//
//  LLCityAlert.m
//  LuckyLoan
//
//  Created by hao on 2024/1/22.
//

#import "LLCityAlert.h"

@interface LLCityAlert ()

@property (nonatomic, copy) NSArray *arr;
@property (nonatomic, copy) NSArray *cityArr;
@property (nonatomic, strong) UIImageView *alertView;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIView *statusView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, copy) NSString *selectState;
@property (nonatomic, copy) NSString *selectCity;
@property (nonatomic, assign) BOOL showCity;
@property (nonatomic ,strong) LLBaseButton *confirm;

@end

@implementation LLCityAlert

- (id)initWithAddress:(NSString *)selectAddress {
    self = [super init];
    if (self) {
        self.arr = App.status.cityList;
        NSArray *arr = [selectAddress componentsSeparatedByString:@"-"];
        if (arr.count >= 2) {
            self.selectState = arr[0];
            self.selectCity = [selectAddress substringFromIndex:self.selectState.length + 1];
        }
        if (self.selectCity.length > 0) {
            self.showCity = YES;
        }
        if (self.selectState.length) {
            
        }
        for (NSDictionary *dic in self.arr) {
            NSString *name = dic[c_name];
            if ([self.selectState isEqualToString:name]) {
                _cityArr = dic[c_cityList];
            }
        }
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
    CGFloat alertHeight = 442 + SafeAreaBottomHeight;
    
    _alertView = [[UIImageView alloc] initWithFrame:CGRectMake(0, ScreenHeight - alertHeight, alertWidth, alertHeight)];
    _alertView.userInteractionEnabled = YES;
    _alertView.image = ImageWithName(@"img_alert_gender");
    [_alertView showTopRarius:16];
    [self addSubview:_alertView];
    
    _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 45, 200, 36)];
    [_titleView addGradient:@[COLOR(161, 204, 191), COLOR(255, 255, 255)] start:CGPointMake(0, 0.5) end:CGPointMake(1, 0.5)];
    [_alertView addSubview:_titleView];
    
    LLImageTextBtn *title = [[LLImageTextBtn alloc] initWithFrame:CGRectMake(LeftMargin, 0, _titleView.width, _titleView.height) title:@" Address State" color:UIColor.blackColor font:16 icon:@"ic_alert_lead"];
    title.titleLabel.font = FontBold(16);
    title.type = HaoBtnType2;
    [_titleView addSubview:title];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(alertWidth - 56, 0, 56, 56);
    [closeBtn setImage:ImageWithName(@"ic_alert_close") forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(bgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_alertView addSubview:closeBtn];
    
    _statusView = [[UIView alloc] initWithFrame:CGRectMake(LeftMargin, _titleView.bottom + 15, 26, 26)];
    _statusView.backgroundColor = LightMainColor;
    _statusView.layer.borderColor = MainColor.CGColor;
    _statusView.layer.borderWidth = 1;
    _statusView.hidden = YES;
    [_statusView showRadius:13];
    [_alertView addSubview:_statusView];

    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _titleView.bottom, alertWidth, alertHeight - _titleView.bottom - SafeAreaBottomHeight - 80)];
    [_alertView addSubview:_scrollView];
    
    _confirm = [[LLBaseButton alloc] initWithFrame:CGRectMake(16, _scrollView.bottom + 30, _alertView.width - 32, 42) title:@"CONFIRM"];
    _confirm.type = BtnTypeGreen;
    [_confirm addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [_alertView addSubview:_confirm];
    
    [self refreshUI];
}

- (void)confirmAction {
    if (self.selectBlock) {
        self.selectBlock(@{@"state":NotNull(_selectState), @"city":NotNull(_selectCity)});
        [self hide];
    }
}

- (void)selectBtnClick:(UIButton *)sender {
    NSDictionary *dic = sender.infoDic;
    if (_showCity) {
        _selectCity = dic[c_name];
        [self refreshUI];
    }else {
        _selectState = dic[c_name];
        _cityArr = dic[c_cityList];
        _showCity = YES;
        [self refreshUI];
    }
}

- (void)refreshStatusUI {
    [_statusView removeAllSubviews];
    UILabel *state = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, 26, 26)];
    state.text = _selectState;
    state.textColor = MainColor;
    state.font = FontBold(12);
    [state sizeToFit];
    state.height = _statusView.height;
    
    CGFloat offsetX = state.right;
    
    [_statusView addSubview:state];
    if (_selectCity.length > 0) {
        UILabel *city = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, 0, 26, 26)];
        city.text = StrFormat(@"/%@", _selectCity);
        city.textColor = MainColor;
        city.font = FontBold(12);
        [city sizeToFit];
        city.height = _statusView.height;
        [_statusView addSubview:city];
        offsetX = city.right;
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(offsetX + 10, 0, _statusView.height, _statusView.height);
    [btn setImage:ImageWithName(@"ic_alert_close") forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clearClick:) forControlEvents:UIControlEventTouchUpInside];
    [_statusView addSubview:btn];
    
    _statusView.width = btn.right + 5;
}

- (void)clearClick:(UIButton *)sender {
    if (_selectCity.length > 0) {
        _selectCity = @"";
        [self refreshUI];
    }else {
        _showCity = NO;
        [self refreshUI];
    }
}

- (void)refreshUI {
    
    if (_selectCity.length > 0) {
        _confirm.type = BtnTypeGreen;
        _confirm.enabled = YES;
    }else {
        _confirm.type = BtnTypeDisable;
        _confirm.enabled = NO;
    }

    NSArray *itemList = _arr;
    if (_showCity) {
        itemList = _cityArr;
        _scrollView.frame = CGRectMake(0, _titleView.bottom + 55, _alertView.width, _alertView.height - _titleView.bottom - SafeAreaBottomHeight - 55);
        _statusView.hidden = NO;
        [self refreshStatusUI];
    }else {
        _scrollView.frame = CGRectMake(0, _titleView.bottom, _alertView.width, _alertView.height - _titleView.bottom - SafeAreaBottomHeight);
        _statusView.hidden = YES;
    }
    [_scrollView removeAllSubviews];
    CGFloat itemHeight = 40;
    for (int i = 0; i < itemList.count; i++) {
        NSDictionary *dic = itemList[i];
        NSString *titleString = dic[c_name];
        
        UIButton *item = [[UIButton alloc] initWithFrame:CGRectMake(LeftMargin, LeftMargin + (itemHeight + LeftMargin)*i, _alertView.width - 2*LeftMargin, itemHeight)];
        item.tag = i;
        [item showRadius:8];
        [item addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        item.infoDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [_scrollView addSubview:item];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(LeftMargin, 0, item.width - 2*LeftMargin - item.height, item.height)];
        title.text = titleString;
        [item addSubview:title];
        
        if ( (_showCity && [_selectCity isEqualToString:titleString]) || (!_showCity && [_selectState isEqualToString:titleString])) {
            item.backgroundColor = COLOR(232, 245, 241);
            title.textColor = UIColor.blackColor;
            title.font = FontBold(16);
            UIButton *icon = [[UIButton alloc] initWithFrame:CGRectMake(item.width - item.height - LeftMargin, 0, item.height, item.height)];
            icon.enabled = NO;
            [icon setImage:ImageWithName(@"ic_item_selected") forState:UIControlStateNormal];
            [item addSubview:icon];
        }else {
            item.backgroundColor = ClearColor;
            title.textColor = TextGrayColor;
            title.font = Font(14);
        }
    }
    _scrollView.contentSize = CGSizeMake(_scrollView.width, itemList.count * (itemHeight + LeftMargin));

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
