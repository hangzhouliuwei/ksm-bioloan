//
//  LLAccessAlert.m
//  LuckyLoan
//
//  Created by hao on 2024/1/5.
//

#import "LLAccessAlert.h"

@interface LLAccessAlert ()
@property (nonatomic, strong) UIImageView *alertView;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *icon;
@end

@implementation LLAccessAlert

- (id)initWithIcon:(NSString *)icon content:(NSString *)content {
    self = [super init];
    if (self) {
        _content = content;
        _icon = icon;
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
    
    CGFloat alertWidth = ScreenWidth - 40*2;
    CGFloat alertHeight = 230;
    _alertView = [[UIImageView alloc]initWithFrame:CGRectMake(0, ScreenHeight - alertHeight, alertWidth, alertHeight)];
    _alertView.userInteractionEnabled = YES;
    _alertView.backgroundColor = [UIColor whiteColor];
    _alertView.image = ImageWithName(@"ic_no_access_bg");
    [self addSubview:_alertView];
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(alertWidth/2 - 94/2, 24, 94, 94)];
    icon.image = ImageWithName(_icon);
    [_alertView addSubview:icon];
    
    UILabel *content = [[UILabel alloc]initWithFrame:CGRectMake(16, icon.bottom, alertWidth - 32, 45)];
    content.font = FontBold(16);
    content.textColor = TextBlackColor;
    content.numberOfLines = 0;
    content.textAlignment = NSTextAlignmentCenter;
    [content setLineSpace:5 withText:_content];
    [_alertView addSubview:content];
    
    LLBaseButton *cancel = [[LLBaseButton alloc] initWithFrame:CGRectMake(16, content.bottom + 14, 108, 42) title:@"Cancel"];
    cancel.type = BtnTypeGray;
    [cancel addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [_alertView addSubview:cancel];

    LLBaseButton *confirm = [[LLBaseButton alloc] initWithFrame:CGRectMake(cancel.right + 10, content.bottom + 14, _alertView.width - cancel.right - 26, 42) title:@"Set up"];
    confirm.type = BtnTypeGreen;
    [confirm addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [_alertView addSubview:confirm];
    
    _alertView.height = confirm.bottom + 24;
    _alertView.centerX = ScreenWidth/2;
    _alertView.centerY = ScreenHeight/2;
    [_alertView showRadius:16];
}

- (void)cancelAction {
    [self hide];
}

- (void)confirmAction {
    if (self.confirmBlock) {
        self.confirmBlock();
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
