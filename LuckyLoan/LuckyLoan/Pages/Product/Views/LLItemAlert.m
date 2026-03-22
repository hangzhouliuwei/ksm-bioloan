//
//  LLItemAlert.m
//  LuckyLoan
//
//  Created by hao on 2024/1/4.
//

#import "LLItemAlert.h"

@interface LLItemAlert ()

@property (nonatomic, copy) NSArray *arr;
@property (nonatomic, strong) NSMutableArray *btnArr;
@property (nonatomic ,strong) UIImageView *alertView;
@property (nonatomic ,assign) NSInteger selectType;
@property (nonatomic ,copy) NSString *titleStr;
@property (nonatomic ,copy) NSDictionary *selectDic;
@property (nonatomic ,strong) LLBaseButton *confirm;

@end

@implementation LLItemAlert

- (id)initWithData:(NSArray *)arr selected:(NSString *)selectType title:(NSString *)titleStr {
    self = [super init];
    if (self) {
        self.arr = arr;
        self.selectType = [selectType integerValue];
        self.titleStr = titleStr;
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
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 45, 200, 36)];
    [titleView addGradient:@[COLOR(161, 204, 191), COLOR(255, 255, 255)] start:CGPointMake(0, 0.5) end:CGPointMake(1, 0.5)];
    [_alertView addSubview:titleView];
    
    LLImageTextBtn *title = [[LLImageTextBtn alloc] initWithFrame:CGRectMake(LeftMargin, 0, titleView.width, titleView.height) title:StrFormat(@" %@", _titleStr) color:UIColor.blackColor font:16 icon:@"ic_alert_lead"];
    title.titleLabel.font = FontBold(16);
    title.type = HaoBtnType2;
    [titleView addSubview:title];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(alertWidth - 56, 0, 56, 56);
    [closeBtn setImage:ImageWithName(@"ic_alert_close") forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(bgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_alertView addSubview:closeBtn];
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, titleView.bottom, alertWidth, alertHeight - titleView.bottom - SafeAreaBottomHeight - 80)];
    [_alertView addSubview:scrollView];

    _confirm = [[LLBaseButton alloc] initWithFrame:CGRectMake(16, scrollView.bottom + 30, _alertView.width - 32, 42) title:@"CONFIRM"];
    _confirm.type = BtnTypeGreen;
    [_confirm addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [_alertView addSubview:_confirm];

    CGFloat itemHeight = 40;
    _btnArr = [NSMutableArray array];
    for (int i = 0; i < self.arr.count; i++) {
        UIButton *item = [[UIButton alloc] initWithFrame:CGRectMake(LeftMargin, LeftMargin + (itemHeight + LeftMargin)*i, alertWidth - 2*LeftMargin, itemHeight)];
        item.tag = i;
        [item showRadius:8];
        [item addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:item];
        [_btnArr addObject:item];
    }
    [self refreshUI];
    scrollView.contentSize = CGSizeMake(scrollView.width, self.arr.count * (itemHeight + LeftMargin));
}

- (void)confirmAction {
    if (self.selectBlock) {
        self.selectBlock(_selectDic);
        [self hide];
    }
}

- (void)selectBtnClick:(UIButton *)sender {
    NSDictionary *dic = _arr[sender.tag];
    _selectType = [dic[c_type] integerValue];
    [self refreshUI];
    _selectDic = dic;
}

- (void)refreshUI {
    if (_selectType > 0) {
        _confirm.type = BtnTypeGreen;
        _confirm.enabled = YES;
    }else {
        _confirm.type = BtnTypeDisable;
        _confirm.enabled = NO;
    }
    for (int i = 0; i < _arr.count; i++) {
        NSDictionary *dic = _arr[i];
        NSInteger type = [dic[c_type] integerValue];
        UIButton *item = _btnArr[i];
        NSString *titleString = _arr[i][c_name];
        [item removeAllSubviews];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(LeftMargin, 0, item.width - 2*LeftMargin - item.height, item.height)];
        title.text = titleString;
        [item addSubview:title];
        
        if (_selectType == type) {
            item.backgroundColor = COLOR(232, 245, 241);
            title.textColor = UIColor.blackColor;
            title.font = FontBold(16);
            UIButton *icon = [[UIButton alloc] initWithFrame:CGRectMake(item.width - item.height - LeftMargin, 0, item.height, item.height)];
            icon.enabled = NO;
            [icon setImage:ImageWithName(@"ic_item_selected") forState:UIControlStateNormal];
            [item addSubview:icon];
            _selectDic = dic;
        }else {
            item.backgroundColor = ClearColor;
            title.textColor = TextGrayColor;
            title.font = Font(14);
        }
    }
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
