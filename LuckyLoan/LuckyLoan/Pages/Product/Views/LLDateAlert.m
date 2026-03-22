//
//  LLDateAlert.m
//  LuckyLoan
//
//  Created by hao on 2024/1/4.
//

#import "LLDateAlert.h"

@interface LLDateAlert ()

@property (nonatomic, copy) NSString *dateStr;
@property (nonatomic ,strong) UIImageView *alertView;
@property (nonatomic, strong) UIDatePicker *datePicker;
@end

@implementation LLDateAlert

- (id)initWithData:(nullable NSString *)dateStr {
    self = [super init];
    if (self) {
        self.dateStr = dateStr;
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
    CGFloat alertHeight = 372 + SafeAreaBottomHeight;
    
    _alertView = [[UIImageView alloc] initWithFrame:CGRectMake(0, ScreenHeight - alertHeight, alertWidth, alertHeight)];
    _alertView.userInteractionEnabled = YES;
    _alertView.image = ImageWithName(@"img_alert_date");
    [_alertView showTopRarius:16];
    [self addSubview:_alertView];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 45, 200, 36)];
    [titleView addGradient:@[COLOR(161, 204, 191), COLOR(255, 255, 255)] start:CGPointMake(0, 0.5) end:CGPointMake(1, 0.5)];
    [_alertView addSubview:titleView];
    
    LLImageTextBtn *title = [[LLImageTextBtn alloc] initWithFrame:CGRectMake(LeftMargin, 0, titleView.width, titleView.height) title:@" Birthday" color:UIColor.blackColor font:16 icon:@"ic_alert_lead"];
    title.titleLabel.font = FontBold(16);
    title.type = HaoBtnType2;
    [titleView addSubview:title];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(alertWidth - 56, 0, 56, 56);
    [closeBtn setImage:ImageWithName(@"ic_alert_close") forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(bgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_alertView addSubview:closeBtn];
    
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, titleView.bottom + 16, alertWidth, 155)];
    if (@available(iOS 13.4, *)) {
        _datePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
    }
    _datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-AU"];
    _datePicker.frame = CGRectMake(0, titleView.bottom + 16, alertWidth, 155);
    _datePicker.datePickerMode = UIDatePickerModeDate;
    NSInteger min = [LLTools timeWithString:@"01-01-1960" formatter:@"dd-MM-yyyy"];
    NSInteger max = [LLTools timeWithString:@"31-12-2040" formatter:@"dd-MM-yyyy"];
    NSDate *minDate = [NSDate  dateWithTimeIntervalSince1970:min];
    NSDate *maxDate = [NSDate  dateWithTimeIntervalSince1970:max];
    _datePicker.maximumDate = maxDate;
    _datePicker.minimumDate = minDate;
    [_datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    
    if (_dateStr.length > 0) {
        NSInteger times = [LLTools timeWithString:_dateStr formatter:@"dd-MM-yyyy"];
        _dateStr = [LLTools stringWithTime:times formatter:@"dd-MM-yyyy"];
        NSDate *date = [NSDate  dateWithTimeIntervalSince1970:times];
        [_datePicker setDate:date animated:YES];
    }else {
        [_datePicker setDate:[NSDate date] animated:YES];
    }
    [_alertView addSubview:_datePicker];
    
    LLBaseButton *confirm = [[LLBaseButton alloc] initWithFrame:CGRectMake(16, _datePicker.bottom + 30, _alertView.width - 32, 42) title:@"CONFIRM"];
    confirm.type = BtnTypeGreen;
    [confirm addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [_alertView addSubview:confirm];

}

- (void)confirmAction {
    if (self.selectBlock) {
        self.selectBlock(_dateStr);
    }
    [self hide];
}

- (void)dateChange:(UIDatePicker *)datePicker {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"dd-MM-yyyy";
    _dateStr = [formatter stringFromDate:datePicker.date];
    NSLog(@"===%@",_dateStr);
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
