//
//  LLLoginVC.m
//  LuckyLoan
//
//  Created by hao on 2023/12/21.
//

#import "LLLoginVC.h"
#import "LLPhoneInputView.h"
#import "LLLoginAuthCodeVC.h"
#import "LLLocation.h"
#import "YYText.h"

@interface LLLoginVC ()
@property (nonatomic, strong) LLPhoneInputView *phoneNoView;
@property (nonatomic, strong) LLBaseButton *sureBtn;
@property (nonatomic, strong) LLLocation *location;
@property (nonatomic, strong) YYLabel *agreementLabel;
@property (nonatomic, strong) UIButton *selectBtn;
@end

@implementation LLLoginVC

- (void)viewDidAppear:(BOOL)animated {
    [self.phoneNoView becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
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
    [closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:closeBtn];

    self.phoneNoView = [[LLPhoneInputView alloc] initWithFrame:CGRectMake(32, header.bottom + 14, ScreenWidth - 64, 44)];
    kWeakself;
    self.phoneNoView.inputBlock = ^(NSInteger index) {
        if (index >= 10) {
            weakSelf.sureBtn.type = BtnTypeNormal;
        }else {
            weakSelf.sureBtn.type = BtnTypeDisable;
        }
        weakSelf.sureBtn.enabled = index > 0;
    };
    [self.contentView addSubview:self.phoneNoView];
    
    self.sureBtn = [[LLBaseButton alloc] initWithFrame:CGRectMake(32, self.phoneNoView.bottom + 24, ScreenWidth - 64, 42) title:@"LOGIN"];
    [self.sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.sureBtn.backgroundColor = MainColor;
    self.sureBtn.type = BtnTypeDisable;
    [self.contentView addSubview:self.sureBtn];
    
    _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectBtn.frame = CGRectMake(32, self.contentView.height - NavigationBarHeight - SafeAreaBottomHeight, 30, 30);
    [_selectBtn setImage:ImageWithName(@"ic_unselected") forState:UIControlStateNormal];
    [_selectBtn setImage:ImageWithName(@"ic_selected") forState:UIControlStateSelected];
    [_selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _selectBtn.selected = YES;
    [self.contentView addSubview:_selectBtn];
    
    [self agreement];
}

- (void)selectBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
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

- (void)closeBtnClick:(UIButton *)sender {
    if (self.loginBLock) {
        self.loginBLock(NO);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sureBtnClick:(UIButton *)sender {
    if (!_selectBtn.selected) {
        [LLTools showToast:@"Please agree to the privacy agreement."];
        return;
    }
    [self nextAction];
    _location = [[LLLocation alloc] init];
    _location.resultBlock = ^(BOOL value) {
    };
    [_location requestAuthLocation];
}

- (void)nextAction {
    if (![LLTools isNrlyPhoneNo:self.phoneNoView.text]) {
        [LLTools showToast:@"Please enter a valid phone number"];
        return;
    }
    LLLoginAuthCodeVC *vc = [[LLLoginAuthCodeVC alloc] init];
    vc.loginBLock = self.loginBLock;
    vc.phoneNo = self.phoneNoView.text;
    vc.navigationBarHidden = YES;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

@end
