//
//  LLWorkInfoVC.m
//  LuckyLoan
//
//  Created by hao on 2024/1/3.
//

#import "LLWorkInfoVC.h"
#import "LLApplyStepView.h"
#import "LLItemAlert.h"
#import "LLCityAlert.h"
#import "LLLeaveAlert.h"
#import "LLAccessAlert.h"
#import "LLContact.h"

@interface LLWorkInfoVC () <UITextFieldDelegate>
@property (nonatomic, strong) UITextField *phoneNumber;
@property (nonatomic, copy) NSArray *itemList;
@property (nonatomic, strong) NSMutableDictionary *saveDic;
@property (nonatomic, strong) NSMutableArray *textArr;
@property (nonatomic, strong) LLContact *contct;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
@end

@implementation LLWorkInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.canPanBack = NO;
    if (App.status.authItems.count == 4) {
        self.title = App.status.authItems[1][c_title];
    }
    self.saveDic = [NSMutableDictionary dictionary];
    self.textArr = [NSMutableArray array];
    
    _startTime = [LLTools nowTimeIntervalString];
}

- (void)loadView {
    [super loadView];
    [self requestData];
    if (App.status.cityList.count == 0) {
        [self loadCityList];
    }
}

- (void)backBtnClick:(UIButton *)btn {
    if (App.status.workInfoAuth) {
        [self back];
        return;
    }
    LLLeaveAlert *alert = [[LLLeaveAlert alloc] initWithIcon:@"ic_leave_work" content:@"Completing your work information now increases your chance of raising your loan limit."];
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

    LLApplyStepView *stepView = [[LLApplyStepView alloc] initWithFrame:CGRectMake(55, 16, ScreenWidth - 110, 58) step:2];
    [self.contentView addSubview:stepView];
    

    UIView *infoBg = [[UIView alloc] initWithFrame:CGRectMake(LeftMargin, stepView.bottom + 8, SafeWidth, 74*_itemList.count + 90)];
    [infoBg setBorderShadow:COLOR(219, 237, 231)];
    [self.contentView addSubview:infoBg];
    [self.contentView setSizeFit:infoBg];
    
    CGFloat offsetY = 16;
    for (int i = 0; i < _itemList.count; i++) {
        NSDictionary *dic = _itemList[i];
        NSString *titleStr = dic[c_title];
        NSString *cate = dic[c_cate];
        NSInteger status = [dic[c_status] integerValue];
        NSString *code = dic[c_code];
        NSString *value = dic[c_value];
        NSString *inputType = dic[c_inputType];//1数字，0，随便输入
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
        [text setInfoDic:[NSMutableDictionary dictionaryWithDictionary:dic]];
        if ([inputType isEqualToString:@"1"]) {
            text.keyboardType = UIKeyboardTypeNumberPad;
        }else {
            text.keyboardType = UIKeyboardTypeDefault;
        }
        if (status == 1) {
            text.text = value;
        }

        [item addSubview:text];
        [_textArr addObject:text];

        if ([cate isEqualToString:@"enum"]) {//txt,citySelect,enum,day
            text.enabled = NO;
            UIButton *rightView = [UIButton buttonWithType:UIButtonTypeCustom];
            rightView.frame = CGRectMake(item.width - item.height, 0, item.height, item.height);
            rightView.userInteractionEnabled = NO;
            [rightView setImage:ImageWithName(@"ic_triangle_gray") forState:UIControlStateNormal];
            [item addSubview:rightView];
            [item addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemTap:)]];
        }
        
        if ([titleStr isEqualToString:@"Personal Number"]) {
            text.enabled = NO;
            UIButton *rightView = [UIButton buttonWithType:UIButtonTypeCustom];
            rightView.frame = CGRectMake(item.width - item.height, 0, item.height, item.height);
            rightView.userInteractionEnabled = NO;
            [rightView setImage:ImageWithName(@"ic_address_book") forState:UIControlStateNormal];
            [item addSubview:rightView];
            [item addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemTap:)]];
            _phoneNumber = text;
        }
        if ([titleStr isEqualToString:@"Address State"]) {
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

    LLBaseButton *nextBtn = [[LLBaseButton alloc] initWithFrame:CGRectMake(LeftMargin, infoBg.height - 58, infoBg.width - 2*LeftMargin, 42) title:@"NEXT"];
    [nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.type = BtnTypeNormal;
    [infoBg addSubview:nextBtn];
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
        @"shovelnose_now":@"peeuijred"
    };
    kWeakself;
    [Network postWithPath:path_jobInfo params:dic success:^(LLResponseModel *response) {
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
    [Network postWithPath:path_save_job_info params:self.saveDic success:^(LLResponseModel *response) {
        if (response.success) {
            [weakSelf nextAuthPage];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"======faild!");
    } showLoading:YES];
}

- (void)nextAuthPage {
    NSDictionary *dic = @{@"productId":NotNull(_productId), @"orderNo":NotNull(_orderNo)};
    [Page popAnimated:NO];
    [Page show:@"LLContactInfoVC" param:dic];
    
    _endTime = [LLTools nowTimeIntervalString];
    [DataPoint userburiePoint:@{@"seceneType":@"4", @"productId":NotNull(_productId), @"startTime":NotNull(_startTime), @"endTime":NotNull(_endTime)}];
}

- (void)itemTap:(UITapGestureRecognizer*)tap {
    for (UIView *view in tap.view.subviews) {
        if ([[view class] isEqual:[UITextField class]]) {
            UITextField *text = (UITextField *)view;
            [self selectItem:text];
        }
    }
}

- (void)selectItem:(UITextField *)text {
    [self.view endEditing:YES];

    NSDictionary *dic = _itemList[text.tag];
    NSString *titleStr = dic[c_title];
    NSString *cate = dic[c_cate];
    NSString *code = dic[c_code];
    NSArray *noteList = dic[c_note];

    kWeakself;
    if ([cate isEqualToString:@"enum"]) {
        LLItemAlert *alert = [[LLItemAlert alloc] initWithData:noteList selected:[_saveDic[code] stringValue] title:titleStr];
        alert.selectBlock = ^(NSDictionary *dic) {
            weakSelf.saveDic[code] = NotNull([dic[c_type] stringValue]);
            text.text = dic[c_name];
            [weakSelf nextItem:text];
        };
        [alert show];
    }
    if ([titleStr isEqualToString:@"Personal Number"]) {
        _contct = [[LLContact alloc] init];
        _contct.selectBlock = ^(NSDictionary *dic) {
            weakSelf.saveDic[code] = dic[@"phone"];
            text.text = dic[@"phone"];
            [weakSelf nextItem:text];
        };
        [_contct showContact];
    }
    if ([titleStr isEqualToString:@"Address State"]) {
        LLCityAlert *alert = [[LLCityAlert alloc] initWithAddress:_saveDic[code]];
        alert.selectBlock = ^(NSDictionary *dic) {
            NSString *address = StrFormat(@"%@-%@", dic[@"state"], dic[@"city"]);
            weakSelf.saveDic[code] = address;
            text.text = address;
            [weakSelf nextItem:text];
        };
        [alert show];
    }
}

- (void)nextItem:(UITextField *)text {
    if (_textArr.count > text.tag + 1) {
        UITextField *textField = _textArr[text.tag + 1];
    
        NSDictionary *dic = _itemList[textField.tag];
        NSString *code = dic[c_code];
        NSString *value = [self.saveDic[code] stringValue];
        NSString *cate = dic[c_cate];
        if (value.length == 0) {
            if ([cate isEqualToString:@"enum"] || [cate isEqualToString:@"citySelect"]) {
                [self selectItem:textField];

            }else if ([cate isEqualToString:@"txt"]) {
                [textField becomeFirstResponder];
            }
        }
    }
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
    NSString *titleStr = dic[c_title];
    NSString *code = dic[c_code];
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

- (void)loadCityList {
    [Network getWithPath:path_cityList params:nil success:^(LLResponseModel *response) {
        if (response.success) {
            App.status.cityList = response.dataArr;
        }
    } failure:^(NSError *error) {
    }];
}

@end
