//
//  LLNormalAlert.m
//  king
//
//  Created by hao on 2023/9/4.
// 
//

#import "LLNormalAlert.h"

@interface LLNormalAlert ()
@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *buttonDesc;
@property (nonatomic, strong) UIView *customView;
@end

@implementation LLNormalAlert

- (id)initWithTitle:(NSString *)title content:(NSString *)content buttonDesc:(NSString *)buttonDesc {
    self = [super init];
    if (self) {
        _title = title;
        _content = content;
        _buttonDesc = buttonDesc;
        self.backgroundColor = ClearColor;
        [self loadUI];
    }
    return self;
}

- (id)initWithCustomView:(UIView *)customView {
    self = [super init];
    if (self) {
        _customView = customView;
        self.backgroundColor = ClearColor;
        [self loadUI];
    }
    return self;
}


- (void)loadUI {
    self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    UIButton *bgGrayView = [UIButton buttonWithType:UIButtonTypeCustom];
    bgGrayView.frame = self.frame;
    bgGrayView.backgroundColor = [UIColor blackColor];
    bgGrayView.alpha = 0.7;
    [bgGrayView addTarget:self action:@selector(bgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bgGrayView];
    
    if (_customView) {
        _customView.center = self.center;
        _alertView = _customView;
        [self addSubview:_alertView];
        return;
    }
    
    CGFloat alertWidth = ScreenWidth - 40*2;
    CGFloat alertHeight = 100;
    _alertView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - alertHeight, alertWidth, alertHeight)];
    _alertView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_alertView];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(55, 0, alertWidth - 110, 55)];
    title.text = _title;
    title.textColor = TextWhiteColor;
    title.font = FontBold(18);
    title.textAlignment = NSTextAlignmentCenter;
    [_alertView addSubview:title];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(alertWidth - 55, 0, 55, 55);
    [closeBtn setImage:ImageWithName(@"ic_alert_close") forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(bgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_alertView addSubview:closeBtn];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(LeftMargin, 10 + title.bottom, alertWidth-2*LeftMargin, 0)];
    [_alertView addSubview:_scrollView];
    
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _scrollView.width, 16)];
    contentLabel.font = Font(13);
    contentLabel.textColor = TextWhiteColor;
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.numberOfLines = 0;
    [contentLabel setLineSpace:5 withText:_content];
    [contentLabel sizeToFit];
    [_scrollView addSubview:contentLabel];
    CGFloat contentHeight = MIN(contentLabel.height, ScreenHeight/2);
    _scrollView.height = contentHeight;
    _scrollView.contentSize = CGSizeMake(_scrollView.width, contentLabel.height);

    
    LLBaseButton *bottomBtn = [[LLBaseButton alloc] initWithFrame:CGRectMake(50, _scrollView.bottom + 40, _alertView.width - 100, 45) title:_buttonDesc];
    bottomBtn.type = BtnTypeNormal;
    [bottomBtn addTarget:self action:@selector(bottomBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_alertView addSubview:bottomBtn];
    
    _alertView.height = bottomBtn.bottom + 20;
    _alertView.centerX = ScreenWidth/2;
    _alertView.centerY = ScreenHeight/2;
    [_alertView showRadius:16];
}

- (void)bottomBtnClick {
    if (self.bottomTapBlock) {
        self.bottomTapBlock();
    }
    [self hide];
}

- (void)show {
    self.alpha = 1;
    [TopWindow addSubview:self];
    [self addAnimation];
}

- (void)addAnimation {
    CAKeyframeAnimation *scale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scale.values = @[@(0.1),@(1.1),@(0.9),@(1.0)];
    scale.calculationMode = kCAAnimationLinear;
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[scale];
    animationGroup.duration = 0.35;
    [_alertView.layer addAnimation:animationGroup forKey:nil];
}

- (void)bgBtnClick:(UIButton *)btn {
    [self hide];
}

- (void)hide {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end

