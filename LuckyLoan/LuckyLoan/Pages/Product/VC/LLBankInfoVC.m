//
//  LLBankInfoVC.m
//  LuckyLoan
//
//  Created by hao on 2024/1/3.
//

#import "LLBankInfoVC.h"
#import "LLApplyStepView.h"
#import "LLLeaveAlert.h"
#import "LLItemAlert.h"

@interface LLBankInfoVC () <UITextFieldDelegate>
@property (nonatomic, strong) LLApplyStepView *stepView;
@property (nonatomic, strong) UITextField *bankName;
@property (nonatomic, strong) UITextField *bankAccount;
@property (nonatomic, strong) NSMutableArray *textArr;
@property (nonatomic, strong) NSMutableDictionary *saveDic;
@property (nonatomic, copy) NSArray *itemList;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
@end

@implementation LLBankInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.canPanBack = NO;
    if (App.status.authItems.count == 4) {
        self.title = App.status.authItems[3][c_title];
    }
    self.saveDic = [NSMutableDictionary dictionary];
    self.textArr = [NSMutableArray array];
    
    _startTime = [LLTools nowTimeIntervalString];
}

- (void)loadView {
    [super loadView];
    [self requestData];
}

- (void)backBtnClick:(UIButton *)btn {
    if (App.status.bankInfoAuth) {
        [self back];
        return;
    }
    LLLeaveAlert *alert = [[LLLeaveAlert alloc] initWithIcon:@"ic_leave_bind" content:@"Take the final step to apply for a loan—submitting now will boost your approval rate."];
    kWeakself;
    alert.confirmBlock = ^{
        [weakSelf back];
    };
    [alert show];
}

- (void)back {
    [Page pop];
}

- (void)createUI {
    [self addHeaderImage:@"img_product_bg"];
    
    _stepView = [[LLApplyStepView alloc] initWithFrame:CGRectMake(55, 16, ScreenWidth - 110, 58) step:4];
    [self.contentView addSubview:_stepView];
    
    UIView *infoBg = [[UIView alloc] initWithFrame:CGRectMake(LeftMargin, _stepView.bottom + 8, SafeWidth, 74*_itemList.count + 164)];
    [infoBg setBorderShadow:COLOR(219, 237, 231)];
    [self.contentView addSubview:infoBg];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(LeftMargin, 24, infoBg.width - 2*LeftMargin, 104)];
    image.image = ImageWithName(@"img_bind_desc_bg");
    [infoBg addSubview:image];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(LeftMargin, 8, image.width - 2*LeftMargin, 32)];
    title.text = @"Please bind a debit card";
    title.textColor = MainColor;
    title.font = FontBold(16);
    [image addSubview:title];
    
    UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(LeftMargin, title.bottom + 4, image.width - 2*LeftMargin, 20)];
    desc.text = @"Please confirm that your bank card information is accuate,we will make payments based on the card informton you have filled in.";
    desc.textColor = MainColor;
    desc.numberOfLines = 0;
    desc.font = Font(12);
    [desc sizeToFit];
    [image addSubview:desc];
    
    CGFloat offsetY = image.bottom + 16;
    for (int i = 0; i < _itemList.count; i++) {
        NSDictionary *dic = _itemList[i];
        NSString *titleStr = dic[c_title];
        NSString *cate = dic[c_cate];
        NSInteger status = [dic[c_status] integerValue];
        NSString *code = dic[c_code];
        NSString *value = dic[c_value];
        self.saveDic[code] = NotNull(value);
        
        if ([cate isEqualToString:@"enum"]) {
            NSArray *noteList = dic[c_note];
            for (NSDictionary *dic in noteList) {
                NSString *name = dic[c_name];
                NSString *type = [dic[c_type] stringValue];
                if ([name isEqualToString:value]) {
                    self.saveDic[code] = NotNull(type);
                }
            }
        }
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(LeftMargin, offsetY, SafeWidth - 2*LeftMargin, 30)];
        title.text = titleStr;
        title.textColor = TextGrayColor;
        title.font = Font(14);
        [infoBg addSubview:title];
        
        UIView *item = [[UIView alloc] initWithFrame:CGRectMake(LeftMargin, title.bottom, SafeWidth - 2*LeftMargin, 36)];
        item.tag = i;
        item.backgroundColor = UIColor.whiteColor;
        item.layer.borderColor = COLOR(238, 238, 243).CGColor;
        item.layer.borderWidth = 1;
        item.layer.masksToBounds = NO;
        item.layer.cornerRadius = 4;
        [infoBg addSubview:item];
        
        UITextField *text = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, item.width - 10, item.height)];
        text.tag = i;
        text.borderStyle = UITextBorderStyleNone;
        text.font = FontBold(14);
        text.textColor = UIColor.blackColor;
        text.textAlignment = NSTextAlignmentLeft;
        text.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        text.clearButtonMode = UITextFieldViewModeWhileEditing;
        text.keyboardType = UIKeyboardTypeDefault;
        text.delegate = self;
        [item addSubview:text];
        [_textArr addObject:text];
        
        if (i == 1) {
            text.placeholder = @"Please ensure your card is available";
            text.keyboardType = UIKeyboardTypeNumberPad;
        }else {
            text.placeholder = @"Select bank";
            text.keyboardType = UIKeyboardTypeDefault;
        }
        if (status == 1) {
            text.text = value;
        }
        
        if ([cate isEqualToString:@"enum"]) {//txt,citySelect,enum,day
            text.enabled = NO;
            UIButton *rightView = [UIButton buttonWithType:UIButtonTypeCustom];
            rightView.frame = CGRectMake(item.width - item.height, 0, item.height, item.height);
            rightView.userInteractionEnabled = NO;
            [rightView setImage:ImageWithName(@"ic_triangle_gray") forState:UIControlStateNormal];
            [item addSubview:rightView];
            [item addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemTap:)]];
        }
        offsetY = item.bottom + 8;
    }
    _bankName = _textArr[0];
    _bankAccount = _textArr[1];
    
    UIImageView *raskBg = [[UIImageView alloc] initWithFrame:CGRectMake(32, infoBg.bottom + 24, ScreenWidth - 64, 80)];
    raskBg.image = ImageWithName(@"img_warning_bg");
    [self.contentView addSubview:raskBg];
    
    UIImageView *raskIcon = [[UIImageView alloc] initWithFrame:CGRectMake(16, 16, 16, 16)];
    raskIcon.image = ImageWithName(@"img_warning");
    [raskBg addSubview:raskIcon];
    
    UILabel *raskDesc = [[UILabel alloc] initWithFrame:CGRectMake(raskIcon.right + 8, 16, raskBg.width - raskIcon.right - 24, 20)];
    raskDesc.text = @"Please do not disclose your bank card information,we will also keep your informatin properly ";
    raskDesc.textColor = COLOR(255, 105, 50);
    raskDesc.numberOfLines = 0;
    raskDesc.font = Font(12);
    [raskDesc sizeToFit];
    [raskBg addSubview:raskDesc];

    LLBaseButton *nextBtn = [[LLBaseButton alloc] initWithFrame:CGRectMake(32, raskBg.bottom + 24, ScreenWidth - 64, 42) title:@"SAVE"];
    [nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.type = BtnTypeNormal;
    [self.contentView addSubview:nextBtn];
    [self.contentView setSizeFit:nextBtn];

}

- (void)nextBtnClick:(UIButton *)sender {
    //必选可选判断 haotodo
    for (int i = 0; i < _textArr.count; i++) {
        UITextField *text = _textArr[i];
        NSString *textStr = text.text;
        if ([LLTools isBlankString:textStr]) {
            [LLTools showToast:@"Please enter complete information"];
            return;
        }
    }
    [self requestSaveData];
}

- (void)requestData {
    
    NSDictionary *dic = @{
        c_product_id: _productId,
        c_mobile: NotNull(App.user.phone),
    };
    kWeakself;
    [Network postWithPath:path_cardInfo params:dic success:^(LLResponseModel *response) {
        if (response.success) {
            weakSelf.itemList = response.dataDic[c_data][c_items];
            [weakSelf createUI];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"======faild!");
    }];
}

- (void)requestSaveData {
    self.saveDic[c_product_id] = NotNull(_productId);
    self.saveDic[c_order_no] = NotNull(_orderNo);
    kWeakself;
    [Network postWithPath:path_saveCardInfo params:self.saveDic success:^(LLResponseModel *response) {
        if (response.success) {
            [weakSelf trackPoint];
            [Page pop];
        }else {
            [LLTools showToast:response.errorMessage];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"======faild!");
    } showLoading:YES];
}

- (void)trackPoint {
    _endTime = [LLTools nowTimeIntervalString];
    [DataPoint userburiePoint:@{@"seceneType":@"6", @"productId":NotNull(_productId), @"startTime":NotNull(_startTime), @"endTime":NotNull(_endTime)}];
}

- (void)itemTap:(UITapGestureRecognizer*)tap {
    [self.view endEditing:YES];
    NSInteger tag = tap.view.tag;
    NSDictionary *dic = _itemList[tag];
    NSString *code = dic[c_code];
    NSArray *noteList = dic[c_note];
    NSString *titleStr = dic[c_title];
    __block UITextField *text = nil;
    for (UIView *view in tap.view.subviews) {
        if ([[view class] isEqual:[UITextField class]]) {
            text = (UITextField *)view;
        }
    }
    kWeakself;
    LLItemAlert *alert = [[LLItemAlert alloc] initWithData:noteList selected:[_saveDic[code] stringValue] title:titleStr];
    alert.selectBlock = ^(NSDictionary *dic) {
        weakSelf.saveDic[code] = [dic[c_type] stringValue];
        text.text = dic[c_name];
    };
    [alert show];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    NSDictionary *dic = _itemList[textField.tag];
    NSString *code = dic[c_code];
    self.saveDic[code] = @"";
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSDictionary *dic = _itemList[textField.tag];
    NSString *code = dic[c_code];
    if (newString.length >= 50) {
        newString = [newString substringToIndex:50];
        textField.text = newString;
        self.saveDic[code] = newString;
        return NO;
    }else {
        self.saveDic[code] = newString;
    }
    return YES;
}

@end
