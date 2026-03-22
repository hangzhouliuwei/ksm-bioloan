//
//  LLOpenAlert.m
//  LuckyLoan
//
//  Created by hao on 2024/1/30.
//

#import "LLOpenAlert.h"

@interface LLOpenAlert ()
@property (nonatomic, strong) SDAnimatedImageView *alertView;
@property (nonatomic, copy) NSString *content;
@end

@implementation LLOpenAlert

- (id)initWithImage:(NSString *)imageUrl {
    self = [super init];
    if (self) {
        _content = imageUrl;
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
    
    CGFloat alertWidth = ScreenWidth - 32*2;
    CGFloat alertHeight = alertWidth;
    
    
    _alertView = [[SDAnimatedImageView alloc] initWithFrame:CGRectMake(0, ScreenHeight - alertHeight, alertWidth, alertHeight)];
    _alertView.userInteractionEnabled = YES;
    [_alertView sd_setImageWithURL:[NSURL URLWithString:_content]];
    [self addSubview:_alertView];

    UIButton *topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    topBtn.frame = _alertView.frame;
    [topBtn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:topBtn];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(alertWidth - 55, 0, 55, 55);
    [closeBtn setImage:ImageWithName(@"ic_alert_close") forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(bgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_alertView addSubview:closeBtn];
    
    _alertView.centerX = ScreenWidth/2;
    _alertView.centerY = ScreenHeight/2;
    [_alertView showRadius:16];
}

- (void)click {
    [self hide];
    if (self.selectBlock) {
        self.selectBlock();
    }
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
