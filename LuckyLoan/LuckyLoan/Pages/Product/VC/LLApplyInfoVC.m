//
//  LLApplyInfoVC.m
//  LuckyLoan
//
//  Created by hao on 2024/1/2.
//

#import "LLApplyInfoVC.h"
#import "LLAuthItemView.h"
#import "YYText.h"

@interface LLApplyInfoVC ()
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) YYLabel *agreementLabel;
@property (nonatomic, copy) NSDictionary *detailDic;
@property (nonatomic, assign) NSInteger step;
@property (nonatomic, copy) NSString *orderNo;
@end

@implementation LLApplyInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"CashHop";
    self.step = 0;

    NSString *startTime = [LLTools nowTimeIntervalString];
    [DataPoint userburiePoint:@{@"seceneType":@"2", @"productId":NotNull(_productId), @"startTime":NotNull(startTime), @"endTime":NotNull(startTime)}];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)loadData {
    App.status.personInfoAuth = NO;
    App.status.workInfoAuth = NO;
    App.status.contactInfoAuth = NO;
    App.status.bankInfoAuth = NO;
    [self requestProductDetail];
}

- (void)createUI {
    [self addHeaderImage:@"img_product_bg"];
    [self.contentView removeAllSubviews];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(LeftMargin, 20, SafeWidth, 20)];
    title.text = @"Test how much your quota";
    title.textColor = COLOR(2, 81, 68);
    title.font = FontBold(16);
    [self.contentView addSubview:title];
    
    UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(LeftMargin, title.bottom + 16, 258, 40)];
    desc.text = @"Complete the following certification items to konw";
    desc.textColor = TextGrayColor;
    desc.font = Font(14);
    desc.numberOfLines = 2;
    [self.contentView addSubview:desc];
    
    UIView *infoBg = [[UIView alloc] initWithFrame:CGRectMake(LeftMargin, desc.bottom + 16, SafeWidth, 460)];
    [infoBg setBorderShadow:COLOR(219, 237, 231)];
    [self.contentView addSubview:infoBg];
    [self.contentView setSizeFit:infoBg];
    
    NSArray *iconArr = @[@"ic_personal_info", @"ic_job_info", @"ic_emergency_info", @"ic_bank_info"];
    NSArray *itemList = _detailDic[c_data][c_verify];
    App.status.authItems = itemList;
    App.status.authJumpUrl = _detailDic[c_data][c_productDetail][c_url];
    _orderNo = _detailDic[c_data][c_productDetail][c_orderNo];
    kWeakself;
    for (int i = 0; i < itemList.count; i++) {
        NSDictionary *dic = itemList[i];
        NSString *titleStr = dic[c_title];
        NSString *statusStr = [dic[c_status] stringValue];
        LLAuthItemView *item = [[LLAuthItemView alloc] initWithFrame:CGRectMake(LeftMargin, 22 + 80*i, SafeWidth - 2*LeftMargin, 72)];
        [item loadIcon:iconArr[i] title:titleStr status:statusStr];
        item.selectBlock = ^{
            [weakSelf selectItem:i status:statusStr];
        };
        [infoBg addSubview:item];
        if ([statusStr isEqualToString:@"1"]) {
            self.step = i + 1;
            if (i == 0) {
                App.status.personInfoAuth = YES;
            }else if (i == 1) {
                App.status.workInfoAuth = YES;
            }else if (i == 2)  {
                App.status.contactInfoAuth = YES;
            }else if (i == 3)  {
                App.status.bankInfoAuth = YES;
            }
        }
    }

    _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectBtn.frame = CGRectMake(LeftMargin, iconArr.count*80 + 30, 30, 30);
    [_selectBtn setImage:ImageWithName(@"ic_unselected") forState:UIControlStateNormal];
    [_selectBtn setImage:ImageWithName(@"ic_selected") forState:UIControlStateSelected];
    [_selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _selectBtn.selected = YES;
    [infoBg addSubview:_selectBtn];
    
    self.agreementLabel = [[YYLabel alloc]initWithFrame:CGRectMake(_selectBtn.right, self.selectBtn.y + 8, ScreenWidth - _selectBtn.width - 4*LeftMargin, 20)];
    [infoBg addSubview:self.agreementLabel];
    [self congigAgreement];
    
    LLBaseButton *applyBtn = [[LLBaseButton alloc] initWithFrame:CGRectMake(LeftMargin, _selectBtn.bottom + 20, infoBg.width - 2*LeftMargin, 42) title:@"APPLY NOW"];
    [applyBtn addTarget:self action:@selector(applyAction) forControlEvents:UIControlEventTouchUpInside];
    applyBtn.type = BtnTypeNormal;
    [infoBg addSubview:applyBtn];
}

- (void)selectBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (void)selectItem:(NSInteger)index status:(NSString *)status {
    if ([status isEqualToString:@"1"]) {
        NSDictionary *dic = @{@"productId":NotNull(_productId), @"orderNo":NotNull(_orderNo)};
        if (index == 0) {
            [Page show:@"LLPersonalInfoVC" param:dic];
        }else if (index == 1) {
            [Page show:@"LLWorkInfoVC" param:dic];
        }else if (index == 2) {
            [Page show:@"LLContactInfoVC" param:dic];
        }else if (index == 3) {
            [Page show:@"LLBankInfoVC" param:dic];
        }
    }else {
        [self applyAction];
    }
}

- (void)applyAction {
    if (!_selectBtn.selected) {
        [LLTools showToast:@"Please agree to the privacy agreement."];
        return;
    }
    NSDictionary *dic = @{@"productId":_productId, @"orderNo":NotNull(_orderNo)};
    
    if (_step == 0) {
        [Page show:@"LLPersonalInfoVC" param:dic];
    }else if (_step == 1) {
        [Page show:@"LLWorkInfoVC" param:dic];
    }else if (_step == 2) {
        [Page show:@"LLContactInfoVC" param:dic];
    }else if (_step == 3) {
        [Page show:@"LLBankInfoVC" param:dic];
    }else if (_step == 4) {
        [self requestAuthUrl];
    }
}

- (void)H5AuthPage:(NSString *)url {
    if (url.length > 0) {
        url = StrFormat(@"%@&%@", url, Network.headerString);
    }
    [Page popAnimated:NO];
    [Page show:@"LLWebViewController" param:@{@"url":url, @"navigationBarHidden":@(NO), @"title":@""}];
    NSString *startTime = [LLTools nowTimeIntervalString];
    [DataPoint userburiePoint:@{@"seceneType":@"7", @"productId":NotNull(_productId), @"startTime":NotNull(startTime), @"endTime":NotNull(startTime)}];
}

- (void)requestAuthUrl {
    NSDictionary *dic = @{c_order_no:NotNull(_orderNo), @"ikebana_now":@"houijhyus"};
    kWeakself;
    [Network postWithPath:path_orderPageUrl params:dic success:^(LLResponseModel *response) {
        if (response.success) {
            [weakSelf H5AuthPage:response.dataDic[c_data][c_url]];
        }else {
            [LLTools showToast:response.errorMessage];
        }
    } failure:^(NSError *error) {
        NSLog(@"======faild!");
    } showLoading:YES];
}

- (void)congigAgreement {
    self.agreementLabel.numberOfLines = 0;
    self.agreementLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    self.agreementLabel.textAlignment = NSTextAlignmentLeft;
    NSDictionary *attributes = @{NSFontAttributeName:Font(12), NSForegroundColorAttributeName: TextGrayColor};
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"I have read and agree with the 〈Loan Agreement〉" attributes:attributes];
    kWeakself;
    [text yy_setTextHighlightRange:[[text string] rangeOfString:@"〈Loan Agreement〉"] color:MainColor backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        [weakSelf openContract];
    }];
    self.agreementLabel.attributedText = text;
    self.agreementLabel.textAlignment = NSTextAlignmentLeft;
    [self.agreementLabel sizeToFit];
}

- (void)requestProductDetail {
    NSDictionary *dic = @{
        c_product_id: self.productId,//产品id
    };
    kWeakself;
    [Network postWithPath:path_productDetail params:dic success:^(LLResponseModel *response) {
        if (response.success) {
            weakSelf.detailDic = response.dataDic;
            [weakSelf createUI];
            NSLog(@"======success!");
        }
        
    } failure:^(NSError *error) {
        NSLog(@"======faild!");
    } showLoading:YES];
}

- (void)openContract {
    LLWebViewController *vc = [[LLWebViewController alloc] init];
    vc.url = ContractUrl;
    vc.isPresent = YES;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    vc.title = @"Loan Agreement";
    [self presentViewController:vc animated:YES completion:nil];
}

@end
