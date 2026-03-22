//
//  LLContactInfoVC.m
//  LuckyLoan
//
//  Created by hao on 2024/1/3.
//

#import "LLContactInfoVC.h"
#import "LLApplyStepView.h"
#import "LLItemAlert.h"
#import "LLLeaveAlert.h"
#import "LLContact.h"

@interface LLContactInfoVC () <UITextFieldDelegate>
@property (nonatomic, strong) UITextField *firstRelationship;
@property (nonatomic, strong) UITextField *firstName;
@property (nonatomic, strong) UITextField *firstPhone;
@property (nonatomic, strong) UITextField *secondRelationship;
@property (nonatomic, strong) UITextField *secondName;
@property (nonatomic, strong) UITextField *secondPhone;
@property (nonatomic, strong) NSMutableArray *textArr;
@property (nonatomic, strong) NSMutableDictionary *saveDic;
@property (nonatomic, copy) NSDictionary *dataDic;
@property (nonatomic, strong) LLContact *contct;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
@end

@implementation LLContactInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.canPanBack = NO;
    if (App.status.authItems.count == 4) {
        self.title = App.status.authItems[2][c_title];
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
    if (App.status.contactInfoAuth) {
        [self back];
        return;
    }
    LLLeaveAlert *alert = [[LLLeaveAlert alloc] initWithIcon:@"ic_leave_contact" content:@"Enhance your loan approval rate by completing emergency contact information now."];
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
    
    LLApplyStepView *stepView = [[LLApplyStepView alloc] initWithFrame:CGRectMake(55, 16, ScreenWidth - 110, 58) step:3];
    [self.contentView addSubview:stepView];
    
    NSString *firstName = _dataDic[c_lineal_name];
    NSString *firstRelation = _dataDic[c_lineal_relation];
    NSString *firstMoblie = _dataDic[c_lineal_mobile];
    NSArray *firstItems = _dataDic[c_lineal_list];
    NSString *otherName = _dataDic[c_other_name];
    NSString *otherRelation = _dataDic[c_other_relation];
    NSString *otherMoblie = _dataDic[c_other_mobile];
    NSArray *otherItems = _dataDic[c_other_list];

    NSArray *dataArr = @[
    @{@"desc":@"First Reference Contact", @"items":firstItems, @"contact":@[@{@"title":@"Relationship", @"value":firstRelation}, @{@"title":@"Emergency contact name", @"value":firstName}, @{@"title":@"Emergency contact phone", @"value":firstMoblie}]},
    @{@"desc":@"Second Reference Contact", @"items":otherItems, @"contact":@[@{@"title":@"Relationship", @"value":otherRelation}, @{@"title":@"Emergency contact name", @"value":otherName}, @{@"title":@"Emergency contact phone", @"value":otherMoblie}]}];

    CGFloat offset = stepView.bottom + 8;
    for (int k = 0; k < dataArr.count; k++) {

        NSDictionary *dic = dataArr[k];
        NSArray *contact = dic[@"contact"];
        NSArray *items = dic[@"items"];
        
        UIView *infoBg = [[UIView alloc] initWithFrame:CGRectMake(LeftMargin, offset, SafeWidth, contact.count*74 + 80)];
        [infoBg setBorderShadow:COLOR(219, 237, 231)];
        [self.contentView addSubview:infoBg];
        offset = infoBg.bottom + 16;
        
        UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(LeftMargin, 0, SafeWidth - 2*LeftMargin, 49)];
        desc.text = dic[@"desc"];
        desc.textColor = TextBlackColor;
        desc.font = FontBold(14);
        [desc addLine:LineTypeBottom color:COLOR(238, 238, 243)];
        [infoBg addSubview:desc];
        
        CGFloat offsetY = desc.bottom + 8;
        for (int i = 0; i < contact.count; i++) {
            NSDictionary *info = contact[i];
            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(LeftMargin, offsetY, SafeWidth - 2*LeftMargin, 30)];
            title.text = info[@"title"];
            title.textColor = TextGrayColor;
            title.font = Font(14);
            [infoBg addSubview:title];
            
            UIView *itemBg = [[UIView alloc] initWithFrame:CGRectMake(LeftMargin, title.bottom, SafeWidth - 2*LeftMargin, 36)];
            itemBg.tag = i + k*3;
            itemBg.backgroundColor = UIColor.whiteColor;
            itemBg.layer.borderColor = COLOR(238, 238, 243).CGColor;
            itemBg.layer.borderWidth = 1;
            itemBg.layer.masksToBounds = NO;
            itemBg.layer.cornerRadius = 4;
            [infoBg addSubview:itemBg];
            
            UITextField *text = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, itemBg.width - 10, itemBg.height)];
            text.tag = i + k*3;
            text.borderStyle = UITextBorderStyleNone;
            text.font = FontBold(14);
            text.textColor = UIColor.blackColor;
            text.textAlignment = NSTextAlignmentLeft;
            text.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            text.clearButtonMode = UITextFieldViewModeWhileEditing;
            text.keyboardType = UIKeyboardTypeDefault;
            text.delegate = self;
            [itemBg addSubview:text];
            NSString *value = info[@"value"];
            text.text = NotNull(value);
            if (i == 0) {
                for (NSDictionary *tmp in items) {
                    NSString *tmpKey = tmp[c_type];
                    if ([value isEqualToString:tmpKey]) {
                        text.text = NotNull(tmp[c_name]);
                    }
                }
            }
            NSString *key = @[c_first_relation, c_first_name, c_first_mobile, c_second_relation, c_second_name, c_second_mobile][text.tag];
            self.saveDic[key] = NotNull(value);
            NSMutableDictionary *infoDic = [NSMutableDictionary dictionaryWithDictionary:@{@"title":NotNull(title.text), @"key":key, @"items":items}];
            text.infoDic = infoDic;
            text.enabled = NO;
            
            NSArray *iconArr = @[@"ic_triangle_gray", @"", @"ic_address_book"];
            UIButton *rightView = [UIButton buttonWithType:UIButtonTypeCustom];
            rightView.frame = CGRectMake(itemBg.width - itemBg.height, 0, itemBg.height, itemBg.height);
            rightView.userInteractionEnabled = NO;
            [rightView setImage:ImageWithName(iconArr[i]) forState:UIControlStateNormal];
            [itemBg addSubview:rightView];
            [itemBg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemTap:)]];
            [_textArr addObject:text];
            
            offsetY = itemBg.bottom + 8;
        }
    }
    
    LLBaseButton *nextBtn = [[LLBaseButton alloc] initWithFrame:CGRectMake(32, offset + 20, ScreenWidth - 64, 42) title:@"NEXT"];
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
        @"couriouage":@"blaalleynk"
    };
    kWeakself;
    [Network postWithPath:path_extInfo params:dic success:^(LLResponseModel *response) {
        if (response.success) {
            weakSelf.dataDic = response.dataDic[c_data][c_emergent];
            [weakSelf createUI];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"======faild!");
    }];
}


- (void)requestSaveData {
    self.saveDic[c_product_id] = NotNull(_productId);
    self.saveDic[c_order_no] = NotNull(_orderNo);
    self.saveDic[@"lucullian_now"] = @"ansmadewer";
    kWeakself;
    [Network postWithPath:path_save_ext_info params:self.saveDic success:^(LLResponseModel *response) {
        if (response.success) {
            [weakSelf nextAuthPage];
        }else {
            [LLTools showToast:response.errorMessage];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"======faild!");
    } showLoading:YES];
}

- (void)nextAuthPage {
    NSDictionary *dic = @{@"productId":NotNull(_productId), @"orderNo":NotNull(_orderNo)};
    [Page popAnimated:NO];
    [Page show:@"LLBankInfoVC" param:dic];
    _endTime = [LLTools nowTimeIntervalString];
    [DataPoint userburiePoint:@{@"seceneType":@"5", @"productId":NotNull(_productId), @"startTime":NotNull(_startTime), @"endTime":NotNull(_endTime)}];
}

- (void)itemTap:(UITapGestureRecognizer*)tap {
    [self.view endEditing:YES];
    NSInteger tag = tap.view.tag;
    __block UITextField *text = _textArr[tag];
    NSArray *items = text.infoDic[@"items"];
    NSString *key = text.infoDic[@"key"];
    NSString *titleStr = text.infoDic[@"title"];
    kWeakself;
    if (tag == 0 || tag == 3) {
        LLItemAlert *alert = [[LLItemAlert alloc] initWithData:items selected:[_saveDic[key] stringValue] title:titleStr];
        alert.selectBlock = ^(NSDictionary *dic) {
            weakSelf.saveDic[key] = NotNull([dic[c_type] stringValue]);
            text.text = dic[c_name];
        };
        [alert show];
    }else if (tag == 1 || tag == 2) {
        _contct = [[LLContact alloc] init];
        _contct.selectBlock = ^(NSDictionary *dic) {
            UITextField *name = weakSelf.textArr[1];
            UITextField *phone = weakSelf.textArr[2];
            name.text = dic[@"name"];
            phone.text = dic[@"phone"];
            
            NSString *nameKey = name.infoDic[@"key"];
            NSString *phoneKey = phone.infoDic[@"key"];
            weakSelf.saveDic[nameKey] = dic[@"name"];
            weakSelf.saveDic[phoneKey] = dic[@"phone"];
        };
        [_contct showContact];
    }else if (tag == 4 || tag == 5) {
        _contct = [[LLContact alloc] init];
        _contct.selectBlock = ^(NSDictionary *dic) {
            UITextField *name = weakSelf.textArr[4];
            UITextField *phone = weakSelf.textArr[5];
            name.text = dic[@"name"];
            phone.text = dic[@"phone"];
            
            NSString *nameKey = name.infoDic[@"key"];
            NSString *phoneKey = phone.infoDic[@"key"];
            weakSelf.saveDic[nameKey] = dic[@"name"];
            weakSelf.saveDic[phoneKey] = dic[@"phone"];
        };
        [_contct showContact];
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    NSString *key = textField.infoDic[@"key"];
    self.saveDic[key] = @"";
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSString *key = textField.infoDic[@"key"];
    if (newString.length >= 100) {
        newString = [newString substringToIndex:100];
        textField.text = newString;
        self.saveDic[key] = newString;
        return NO;
    }else {
        self.saveDic[key] = newString;
    }
    return YES;
}

@end
