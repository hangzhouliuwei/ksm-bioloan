//
//  LLGenderAlert.m
//  LuckyLoan
//
//  Created by hao on 2024/1/4.
//

#import "LLGenderAlert.h"

@interface LLGenderAlert ()

@property (nonatomic, strong) NSArray *arr;
@property (nonatomic ,strong) UIImageView *alertView;
@property (nonatomic ,assign) NSInteger selectType;
@property (nonatomic ,assign) NSInteger selectIndex;
@property (nonatomic ,strong) LLBaseButton *male;
@property (nonatomic ,strong) LLBaseButton *female;
@property (nonatomic ,strong) LLBaseButton *confirm;
@property (nonatomic, copy) NSArray *btnArr;
@end

@implementation LLGenderAlert

- (id)initWithData:(NSArray *)arr selected:(NSInteger)selectType {
    self = [super init];
    if (self) {
        self.arr = arr;
        self.selectType = selectType;
        [self loadUI];
    }
    return self;
}

- (void)loadUI {
    self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    UIButton* bgGrayView = [UIButton buttonWithType:UIButtonTypeCustom];
    bgGrayView.frame = self.frame;
    bgGrayView.backgroundColor = [UIColor blackColor];
    bgGrayView.alpha = 0.3;
    [bgGrayView addTarget:self action:@selector(bgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bgGrayView];
    
    CGFloat alertWidth = ScreenWidth;
    CGFloat alertHeight = 332 + SafeAreaBottomHeight;
    
    _alertView = [[UIImageView alloc] initWithFrame:CGRectMake(0, ScreenHeight - alertHeight, alertWidth, alertHeight)];
    _alertView.userInteractionEnabled = YES;
    _alertView.image = ImageWithName(@"img_alert_gender");
    [_alertView showTopRarius:16];
    [self addSubview:_alertView];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 45, 200, 36)];
    [titleView addGradient:@[COLOR(161, 204, 191), COLOR(255, 255, 255)] start:CGPointMake(0, 0.5) end:CGPointMake(1, 0.5)];
    [_alertView addSubview:titleView];
    
    LLImageTextBtn *title = [[LLImageTextBtn alloc] initWithFrame:CGRectMake(LeftMargin, 0, titleView.width, titleView.height) title:@" Gender" color:UIColor.blackColor font:16 icon:@"ic_alert_lead"];
    title.titleLabel.font = FontBold(16);
    title.type = HaoBtnType2;
    [titleView addSubview:title];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(alertWidth - 56, 0, 56, 56);
    [closeBtn setImage:ImageWithName(@"ic_alert_close") forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(bgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_alertView addSubview:closeBtn];
    
    if (_arr.count < 2) {
        return;
    }
    _male = [[LLBaseButton alloc] initWithFrame:CGRectMake(38, titleView.bottom + 16, alertWidth - 76, 50) title:_arr[0][c_name]];
    _male.type = BtnTypeBorder;
    _male.tag = 0;
    _male.layer.borderColor = MainColor.CGColor;
    [_male setTitleColor:MainColor forState:UIControlStateNormal];
    [_male addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_alertView addSubview:_male];
    
    _female = [[LLBaseButton alloc] initWithFrame:CGRectMake(38, _male.bottom + 16, alertWidth - 76, 50) title:_arr[1][c_name]];
    _female.type = BtnTypeBorder;
    _female.tag = 1;
    _female.layer.borderColor = MainColor.CGColor;
    [_female setTitleColor:MainColor forState:UIControlStateNormal];
    [_female addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_alertView addSubview:_female];
    
    _confirm = [[LLBaseButton alloc] initWithFrame:CGRectMake(16, _female.bottom + 30, _alertView.width - 32, 42) title:@"CONFIRM"];
    _confirm.type = BtnTypeGreen;
    [_confirm addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [_alertView addSubview:_confirm];

    
    _btnArr = @[_male, _female];
    [self refreshUI];
}

- (void)refreshUI {
    if (_selectType > 0) {
        _confirm.type = BtnTypeGreen;
        _confirm.enabled = YES;
    }else {
        _confirm.type = BtnTypeDisable;
        _confirm.enabled = NO;
    }
    for (int i = 0; i < _btnArr.count; i++) {
        UIButton *btn = _btnArr[i];
        NSInteger type = [_arr[i][c_type] integerValue];
        if (type == _selectType) {
            btn.alpha = 0.5;
            btn.backgroundColor = COLOR(200, 229, 222);
            _selectIndex = i;
        }else {
            btn.alpha = 1;
            btn.backgroundColor = UIColor.whiteColor;
        }
    }
}

- (void)confirmAction {
    if (self.selectBlock) {
        self.selectBlock(_arr[_selectIndex]);
    }
    [self hide];
}

- (void)selectBtnClick:(UIButton *)sender {
    _selectIndex = sender.tag;
    _selectType = [_arr[_selectIndex][c_type] integerValue];
    [self refreshUI];
}

- (void)show {
    CGFloat y = _alertView.y;
    _alertView.y = ScreenHeight;
    kWeakself;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.alertView.y = y;
    } completion:^(BOOL finished) {
        
    }];
    [TopWindow addSubview:self];
}

- (void)bgBtnClick:(UIButton *)btn {
    [self hide];
}

- (void)hide {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
