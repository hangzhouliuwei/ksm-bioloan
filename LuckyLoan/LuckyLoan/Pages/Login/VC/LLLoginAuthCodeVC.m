//
//  LLLoginVC.h
//  LuckyLoan
//
//  Created by hao on 2023/12/21.
//

#import "LLLoginAuthCodeVC.h"
#import "LLAuthcodeInputView.h"
#import "LLAuthCodeView.h"
#import "YYText.h"

@interface LLLoginAuthCodeVC ()

@property (nonatomic, strong) LLAuthcodeInputView *authCodeText;
@property (nonatomic, strong) LLAuthCodeView *authCodeBtn;
@property (nonatomic, strong) LLBaseButton *sureBtn;
@property (nonatomic, strong) YYLabel *agreementLabel;
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
@end

@implementation LLLoginAuthCodeVC

- (void)loadView {
    [super loadView];
    [self looadUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(delayMethod) userInfo:nil repeats:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [_authCodeText toResponder];
}

- (void)delayMethod {
    if (_authCodeBtn.userInteractionEnabled) {
        [self requestAuthCode];
    }
}

- (void)looadUI {
    UIImageView *header = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 260*WScale)];
    header.image = ImageWithName(@"img_login_bg");
    header. clipsToBounds = YES;
    UIView *headerBot = [[UIView alloc] initWithFrame:CGRectMake(0, header.height - 36, ScreenWidth, 72)];
    headerBot.backgroundColor = UIColor.whiteColor;
    headerBot.layer.cornerRadius = 20;
    [header addSubview:headerBot];
    [self.contentView addSubview:header];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(LeftMargin, StatusBarHeight + 20, 24, 24);
    [closeBtn setImage:ImageWithName(@"ic_back") forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:closeBtn];
    
    UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(32, header.bottom, ScreenWidth - 64, 20)];
    desc.text = @"Verification code has been sent to";
    desc.textColor = TextGrayColor;
    desc.font = Font(12);
    [self.contentView addSubview:desc];
    
    UILabel *phone = [[UILabel alloc] initWithFrame:CGRectMake(32, desc.bottom + 24, 200, 20)];
    phone.text = self.phoneNo;
    phone.textColor = TextBlackColor;
    phone.font = FontBold(16);
    [self.contentView addSubview:phone];
    
    kWeakself;
    _authCodeBtn = [[LLAuthCodeView alloc] initWithFrame:CGRectMake(ScreenWidth - 132, desc.bottom + 24, 100, 20) phone:_phoneNo];
    _authCodeBtn.clickBlock = ^{
        [weakSelf.view endEditing:YES];
        [weakSelf requestAuthCode];
    };
    [self.contentView addSubview:_authCodeBtn];
    
    self.authCodeText = [[LLAuthcodeInputView alloc] initWithFrame:CGRectMake(32, phone.bottom + 24, ScreenWidth - 64, 44)];
    self.authCodeText.inputBlock = ^(NSInteger index) {
        [weakSelf inputCount:index];
    };
    [self.contentView addSubview:self.authCodeText];
    
    UIButton *noSmsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    noSmsBtn.frame = CGRectMake(ScreenWidth - 182, self.authCodeText.bottom + 24, 150, 20);
    noSmsBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [noSmsBtn setTitle:@"Not receiving SMS?" forState:UIControlStateNormal];
    [noSmsBtn setTitleColor:TextGrayColor forState:UIControlStateNormal];
    noSmsBtn.titleLabel.font = Font(12);
    [noSmsBtn addTarget:self action:@selector(noSmsAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:noSmsBtn];
    
    self.sureBtn = [[LLBaseButton alloc] initWithFrame:CGRectMake(32, self.contentView.height - 132 - SafeAreaBottomHeight, ScreenWidth - 64, 42) title:@"LOGIN"];
    [self.sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.sureBtn.backgroundColor = MainColor;
    self.sureBtn.type = BtnTypeDisable;
    self.sureBtn.titleLabel.font = FontBold(14);
    [self.sureBtn showRadius:4.0f];
    [self.contentView addSubview:self.sureBtn];
    
    _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectBtn.frame = CGRectMake(32, self.sureBtn.bottom + 20, 30, 30);
    [_selectBtn setImage:ImageWithName(@"ic_unselected") forState:UIControlStateNormal];
    [_selectBtn setImage:ImageWithName(@"ic_selected") forState:UIControlStateSelected];
    [_selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _selectBtn.selected = YES;
    [self.contentView addSubview:_selectBtn];
    
    [self agreement];
}

- (void)selectBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self inputCount:self.authCodeText.text.length];
}

- (void)agreement {
    self.agreementLabel = [[YYLabel alloc]initWithFrame:CGRectMake(63, self.selectBtn.y + 8, ScreenWidth - 95, 20)];
    self.agreementLabel.numberOfLines = 0;
    self.agreementLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    self.agreementLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.agreementLabel];
    NSDictionary *attributes = @{NSFontAttributeName:Font(12), NSForegroundColorAttributeName: TextGrayColor};
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"Login means you have read and agreed with Privacy Agreement" attributes:attributes];

    [text yy_setTextHighlightRange:[[text string] rangeOfString:@"Privacy Agreement"] color:MainColor backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        LLWebViewController *vc = [[LLWebViewController alloc] init];
        vc.url = PrivacyUrl;
        vc.isPresent = YES;
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        vc.title = @"Privacy Agreement";
        [self presentViewController:vc animated:YES completion:nil];
    }];
    self.agreementLabel.attributedText = text;
    self.agreementLabel.textAlignment = NSTextAlignmentLeft;
    [self.agreementLabel sizeToFit];
}

- (void)noSmsAction {
    
}

- (void)closeBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sureBtnClick {
    if (!_selectBtn.selected) {
        [LLTools showToast:@"Please agree to the privacy agreement."];
        return;
    }
    [self requestFastLogin];
}

- (void)inputCount:(NSInteger)count {
    if (count == AuthCodeLength && _selectBtn.selected) {
        [self.view endEditing:YES];
        self.sureBtn.type = BtnTypeNormal;
    }else {
        self.sureBtn.type = BtnTypeDisable;
    }
}

- (void)requestFastLogin {
    NSDictionary *dic = @{
        c_username: self.phoneNo,
        c_smsCode: self.authCodeText.text,
        @"moosewood_now":@"duiuyiton"
    };
    kWeakself;
    [Network postWithPath:path_login_sms params:dic success:^(LLResponseModel *response) {
        if (response.success) {
            [weakSelf loginSucessed];
        }else {
            [LLTools showToast:response.errorMessage];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestAuthCode {
    [self.authCodeBtn startCountDown];
    self.authCodeBtn.userInteractionEnabled = NO;
    
    NSDictionary *dic = @{
        c_phone: self.phoneNo,
        c_jhudhygs: @"juyttrr"
    };
    kWeakself;
    [Network postWithPath:path_send_sms params:dic success:^(LLResponseModel *response) {
        if (response.success) {
            [weakSelf.authCodeText toResponder];
        }
        if (response.desc.length > 0) {
            [LLTools showToast:response.desc];
        }
        App.status.didSendSmsPhone = weakSelf.phoneNo;
    } failure:^(NSError *error) {
        
    } showLoading:YES];

    _startTime = [LLTools nowTimeIntervalString];
}

- (void)loginSucessed {
    App.user.isLogin = YES;
    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    if (self.loginBLock) {
        self.loginBLock(YES);
    }
    _endTime = [LLTools nowTimeIntervalString];
    [DataPoint userburiePoint:@{@"seceneType":@"1", @"productId":@"", @"startTime":NotNull(_startTime), @"endTime":NotNull(_endTime)}];
}

@end
