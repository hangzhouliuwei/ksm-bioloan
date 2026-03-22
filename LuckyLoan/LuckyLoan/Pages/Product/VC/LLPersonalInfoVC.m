//
//  LLPersonalInfoVC.m
//  LuckyLoan
//
//  Created by hao on 2024/1/3.
//

#import "LLPersonalInfoVC.h"
#import "LLApplyStepView.h"
#import "LLGenderAlert.h"
#import "LLDateAlert.h"
#import "LLLeaveAlert.h"
#import "IQKeyboardManager.h"

@interface LLPersonalInfoVC () <UITextFieldDelegate>
@property (nonatomic, strong) LLApplyStepView *stepView;
@property (nonatomic, strong) UIImageView *countownBg;
@property (nonatomic, strong) UILabel *countdown;
@property (nonatomic, assign) NSInteger seconds;
@property (nonatomic, strong) UIView *infoBg;
@property (nonatomic, strong) UITextField *email;
@property (nonatomic, strong) UIView *emailTypeView;
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, copy) NSArray *itemList;
@property (nonatomic, strong) NSMutableDictionary *saveDic;
@property (nonatomic, strong) NSMutableArray *textArr;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, assign) BOOL didAuth;
@end

@implementation LLPersonalInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.canPanBack = NO;
    if (App.status.authItems.count == 4) {
        self.title = App.status.authItems[0][c_title];
    }
    self.seconds = 180;
    self.saveDic = [NSMutableDictionary dictionary];
    self.textArr = [NSMutableArray array];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    [self loadTimer];
    _startTime = [LLTools nowTimeIntervalString];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    _emailTypeView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:130];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:10];
}

- (void)loadView {
    [super loadView];
    [self requestData];
}

- (void)backBtnClick:(UIButton *)btn {
    if (App.status.personInfoAuth) {
        [self back];
        return;
    }
    LLLeaveAlert *alert = [[LLLeaveAlert alloc] initWithIcon:@"ic_leave_personal" content:@"Provide basic information to apply for a loan, and we will tailor a loan amount specifically for you."];
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
    
    _stepView = [[LLApplyStepView alloc] initWithFrame:CGRectMake(55, 16, ScreenWidth - 110, 58) step:1];
    [self.contentView addSubview:_stepView];
    
    _countownBg = [[UIImageView alloc] initWithFrame:CGRectMake(LeftMargin, _stepView.bottom + 24, SafeWidth, 114)];
    _countownBg.image = ImageWithName(@"img_countdown_bg");
    [self.contentView addSubview:_countownBg];
    
    UIImageView *clock = [[UIImageView alloc] initWithFrame:CGRectMake(LeftMargin, 25, 68, 61)];
    clock.image = ImageWithName(@"ic_countdown");
    [_countownBg addSubview:clock];
    
    _countdown = [[UILabel alloc] initWithFrame:CGRectMake(0, clock.height - 20, clock.width, 20)];
    _countdown.text = @"3:00";
    _countdown.textColor = UIColor.whiteColor;
    _countdown.font = FontBold(14);
    _countdown.textAlignment = NSTextAlignmentCenter;
    [clock addSubview:_countdown];
    
    
    NSString *string = @"Complete your personal information within 3 minutes to enhance your approval rate";
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    [attrString addAttribute:NSForegroundColorAttributeName value:UIColor.redColor range:[string rangeOfString:@"3"]];
    [attrString addAttribute:NSForegroundColorAttributeName value:UIColor.redColor range:[string rangeOfString:@"enhance your approval rate"]];
    UILabel *countownDesc = [[UILabel alloc] initWithFrame:CGRectMake(clock.right + 14, clock.y, _countownBg.width - clock.right - 30, clock.height)];
    countownDesc.textColor = TextBlackColor;
    countownDesc.font = Font(11);
    countownDesc.attributedText = attrString;
    countownDesc.numberOfLines = 0;
    [_countownBg addSubview:countownDesc];
    
    _infoBg = [[UIView alloc] initWithFrame:CGRectMake(LeftMargin, _countownBg.bottom + 16, SafeWidth, 74*_itemList.count + 120)];
    [_infoBg setBorderShadow:COLOR(219, 237, 231)];
    [self.contentView addSubview:_infoBg];
    [self.contentView setSizeFit:_infoBg];
    
    CGFloat offsetY = 16;
    for (int i = 0; i < _itemList.count; i++) {
        NSDictionary *dic = _itemList[i];
        NSString *titleStr = dic[c_title];
        NSString *cate = dic[c_cate];
        NSInteger status = [dic[c_status] integerValue];
        NSString *code = dic[c_code];
        NSString *value = dic[c_value];
        NSString *inputType = dic[c_inputType];
        NSString *optional = dic[c_inputType];//1 must, 0 not must
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
        [_infoBg addSubview:title];
        
        UIView *item = [[UIView alloc] initWithFrame:CGRectMake(LeftMargin, title.bottom, SafeWidth - 2*LeftMargin, 36)];
        item.tag = i;
        item.backgroundColor = UIColor.whiteColor;
        item.layer.borderColor = COLOR(238, 238, 243).CGColor;
        item.layer.borderWidth = 1;
        item.layer.masksToBounds = NO;
        item.layer.cornerRadius = 4;
        [_infoBg addSubview:item];
        
        UITextField *text = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, item.width - 10, item.height)];
        text.tag = i;
        text.borderStyle = UITextBorderStyleNone;
        text.font = FontBold(14);
        text.textColor = UIColor.blackColor;
        text.textAlignment = NSTextAlignmentLeft;
        text.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        text.clearButtonMode = UITextFieldViewModeWhileEditing;
        [text setInfoDic:[NSMutableDictionary dictionaryWithDictionary:dic]];
        if ([inputType isEqualToString:@"1"]) {
            text.keyboardType = UIKeyboardTypeNumberPad;
        }else {
            text.keyboardType = UIKeyboardTypeDefault;
        }
        if (status == 1) {
            text.text = value;
        }
        text.delegate = self;
        [item addSubview:text];
        [_textArr addObject:text];

        if ([titleStr isEqualToString:@"Email"]) {
            _emailTypeView = [[UIView alloc] initWithFrame:CGRectMake(item.x, item.bottom, item.width, 4*30)];
            _emailTypeView.hidden = YES;
            _emailTypeView.backgroundColor = COLOR(233, 245, 241);
            [_emailTypeView showRadius:8];
            _email = text;
        }

        if ([cate isEqualToString:@"day"] || [cate isEqualToString:@"enum"]) {
            text.enabled = NO;
            UIButton *rightView = [UIButton buttonWithType:UIButtonTypeCustom];
            rightView.frame = CGRectMake(item.width - item.height, 0, item.height, item.height);
            rightView.userInteractionEnabled = NO;
            [rightView setImage:ImageWithName(@"ic_triangle_gray") forState:UIControlStateNormal];
            [item addSubview:rightView];
            [item addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemTap:)]];
        }
        offsetY = item.bottom + 8;
        if ([titleStr isEqualToString:@"Bvn"]) {
            LLImageTextBtn *tips = [[LLImageTextBtn alloc] initWithFrame:CGRectMake(LeftMargin, 6 + item.bottom, 200, 24) title:@" Don't know your BVN？" color:TextGrayColor font:10 icon:@"ic_tips"];
            tips.type = HaoBtnType2;
            [tips addTarget:self action:@selector(tipsAction) forControlEvents:UIControlEventTouchUpInside];
            [_infoBg addSubview:tips];
            
            UILabel *dail = [[UILabel alloc] initWithFrame:CGRectMake(item.x, tips.y, item.width, 24)];
            dail.text = @"Dail*565*0 #";
            dail.textColor = MainColor;
            dail.font = FontBold(10);
            dail.textAlignment = NSTextAlignmentRight;
            [_infoBg addSubview:dail];
            offsetY = tips.bottom + 2;
            
        }
    }
    LLBaseButton *nextBtn = [[LLBaseButton alloc] initWithFrame:CGRectMake(LeftMargin, _infoBg.height - 58, _infoBg.width - 2*LeftMargin, 42) title:@"NEXT"];
    [nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.type = BtnTypeNormal;
    [_infoBg addSubview:nextBtn];
    
    [_infoBg addSubview:_emailTypeView];
}

- (void)loadTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(timerUpdate) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)timerUpdate {
    _seconds--;
    NSString *mid = @"";
    if (_seconds%60 < 10) {
        mid = @"0";
    }
    _countdown.text = [NSString stringWithFormat:@"%@:%@%@", @(_seconds/60), mid, @(_seconds%60)];
    if (_seconds == 0) {
        [self cancelTimer];
        _countownBg.hidden = YES;
        _infoBg.y = _stepView.bottom + 10;
    }
}

- (void)cancelTimer {
    [self.timer invalidate];
    self.timer = nil;
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
        @"dipode_now":@"stauistill"
    };
    kWeakself;
    [Network postWithPath:path_personal_info params:dic success:^(LLResponseModel *response) {
        if (response.success) {
            weakSelf.itemList = response.dataDic[c_data][c_items];
            [weakSelf createUI];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"======faild!");
    }];
}

- (void)requestSaveData {
//    self.saveDic[@"polaroid_now"] = @"consioeration";
    self.saveDic[c_product_id] = NotNull(_productId);
    self.saveDic[c_order_no] = NotNull(_orderNo);

    kWeakself;
    [Network postWithPath:path_save_personal_info params:self.saveDic success:^(LLResponseModel *response) {
        if (response.success) {
            [weakSelf nextAuthPage];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"======faild!");
    } showLoading:YES];
}

- (void)nextAuthPage {
    _endTime = [LLTools nowTimeIntervalString];
    [DataPoint userburiePoint:@{@"seceneType":@"3", @"productId":NotNull(_productId), @"startTime":NotNull(_startTime), @"endTime":NotNull(_endTime)}];
    NSDictionary *dic = @{@"productId":NotNull(_productId), @"orderNo":NotNull(_orderNo)};
    [Page popAnimated:NO];
    [Page show:@"LLWorkInfoVC" param:dic];
}

- (void)itemTap:(UITapGestureRecognizer*)tap {
    [self.view endEditing:YES];
    NSInteger tag = tap.view.tag;
    NSDictionary *dic = _itemList[tag];
    NSString *cate = dic[c_cate];
    NSString *code = dic[c_code];
    NSArray *noteList = dic[c_note];
    __block UITextField *text = nil;
    for (UIView *view in tap.view.subviews) {
        if ([[view class] isEqual:[UITextField class]]) {
            text = (UITextField *)view;
        }
    }
    kWeakself;
    if ([cate isEqualToString:@"enum"]) {
        LLGenderAlert *alert = [[LLGenderAlert alloc] initWithData:noteList selected:[_saveDic[code] integerValue]];
        alert.selectBlock = ^(NSDictionary *dic) {
            weakSelf.saveDic[code] = NotNull([dic[c_type] stringValue]);
            text.text = dic[c_name];
        };
        [alert show];
    }else if ([cate isEqualToString:@"day"]) {
        NSString *date = @"";
        if (text.text.length > 0) {
            date = text.text;
        }else {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat: @"dd-MM-yyyy"];
            date = [dateFormatter stringFromDate:[NSDate date]];
        }
        LLDateAlert *alert = [[LLDateAlert alloc] initWithData:date];
        alert.selectBlock = ^(NSString *str) {
            weakSelf.saveDic[code] = str;
            text.text = str;
        };
        [alert show];
    }
}

- (void)tipsAction {
    
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    NSDictionary *dic = _itemList[textField.tag];
    NSString *code = dic[c_code];
    self.saveDic[code] = @"";
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField != _email) {
        _emailTypeView.hidden = YES;
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSDictionary *dic = _itemList[textField.tag];
    NSString *titleStr = dic[c_title];
    NSString *code = dic[c_code];
    if ([titleStr isEqualToString:@"Bvn"]) {
        if (![self isAllNumber:string]) {
            return NO;
        }
    }
    if ([titleStr isEqualToString:@"Email"]) {
        if (newString.length > 0) {
            _emailTypeView.hidden = NO;
            [self refreshEmailList:newString];
        }
    }
    
    if (newString.length >= 100) {
        newString = [newString substringToIndex:100];
        textField.text = newString;
        self.saveDic[code] = newString;
        return NO;
    }else {
        self.saveDic[code] = newString;
    }
    return YES;
}

- (BOOL)isAllNumber:(NSString *)string {
    NSString *regex =@"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:string];
}

- (void)refreshEmailList:(NSString *)text {
    [_emailTypeView removeAllSubviews];
    NSArray *partArr = [text componentsSeparatedByString:@"@"];
    NSString *learStr = partArr[0];
    NSArray *emailArr = @[@"gmail.com", @"icloud.com", @"yahoo.com", @"mail.com"];
    NSMutableArray *tmpArr = [NSMutableArray array];
    for (int i = 0; i < emailArr.count; i++) {
        NSString *endStr = emailArr[i];
        NSString *email = StrFormat(@"%@@%@", learStr, endStr);
        if ([email hasPrefix:text]) {
            [tmpArr addObject:email];
        }
    }
    _emailTypeView.height = 30*tmpArr.count;
    for (int i = 0; i < tmpArr.count; i++) {
        NSString *emailStr = tmpArr[i];
        UIButton *emailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        emailBtn.frame = CGRectMake(0, i*30, _emailTypeView.width, 30);
        emailBtn.infoDic = [NSMutableDictionary dictionaryWithDictionary:@{@"email":NotNull(emailStr)}];
        [emailBtn addTarget:self action:@selector(emailClick:) forControlEvents:UIControlEventTouchUpInside];
        [_emailTypeView addSubview:emailBtn];
        
        UILabel *lead = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 100, 30)];
        lead.text = text;
        lead.textColor = MainColor;
        lead.font = Font(12);
        [lead sizeToFit];
        lead.height = 30;
        [emailBtn addSubview:lead];
        
        UILabel *ending = [[UILabel alloc] initWithFrame:CGRectMake(lead.right, 0, 100, 30)];
        ending.text = [emailStr substringFromIndex:text.length];
        ending.textColor = TextGrayColor;
        ending.font = Font(12);
        [ending sizeToFit];
        ending.height = 30;
        [emailBtn addSubview:ending];
    }
}

- (void)emailClick:(UIButton *)sender {
    _email.text = sender.infoDic[@"email"];
    [self.view endEditing:YES];
    
    NSDictionary *dic = _itemList[_email.tag];
    NSString *code = dic[c_code];
    self.saveDic[code] = _email.text;
}

@end
