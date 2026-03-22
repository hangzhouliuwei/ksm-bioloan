//
//  LLServiceView.m
//  LuckyLoan
//
//  Created by hao on 2024/2/6.
//

#import "LLServiceView.h"

@interface LLServiceView ()
@property (nonatomic, strong) UIImageView *suspendImage;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, copy) NSString *imageName;
@end

@implementation LLServiceView

- (id)initWithFrame:(CGRect)frame image:(NSString *)imageName {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = ClearColor;
        self.imageName = imageName;
        [self loadUI];
    }
    return self;
}

- (void)loadUI {
    _suspendImage = [[UIImageView alloc] initWithFrame:CGRectMake(16, 10, 24, 24)];
    _suspendImage.image = ImageWithName(self.imageName);
    _suspendImage.userInteractionEnabled = YES;
    [_suspendImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(suspendTap)]];
//    [_suspendImage showShadow:UIColor.whiteColor radius:3];
    [self addSubview:_suspendImage];
    
    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _closeBtn.frame = CGRectMake(self.width - 30, 0, 30, 20);
    [_closeBtn setImage:ImageWithName(@"ic_close") forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(closeTap) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_closeBtn];
}

- (void)suspendTap {
    if (self.clickBlock) {
        self.clickBlock();
    }
}

- (void)closeTap {
    CGFloat offsetX = self.width*2;
    if (self.x > [self superview].width/2.0) {
        offsetX = -offsetX;
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.x = self.x - offsetX;
    }completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    CGPoint point = [[touches anyObject] locationInView:self];
    _startPoint = point;
    [[self superview] bringSubviewToFront:self];
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    CGPoint point = [[touches anyObject] locationInView:self];
    CGPoint newcenter = CGPointMake(self.center.x + point.x - _startPoint.x, self.center.y + point.y - _startPoint.y);
    float halfX = CGRectGetMidX(self.bounds);
    float halfY = CGRectGetMidY(self.bounds);
    newcenter.x = MAX(halfX, newcenter.x);
    newcenter.x = MIN(self.superview.bounds.size.width - halfX, newcenter.x);
    newcenter.y = MAX(halfY, newcenter.y);
    newcenter.y = MIN(self.superview.bounds.size.height - halfY, newcenter.y);
    self.center = newcenter;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint point = self.center;
    if (point.x > [self superview].width/2.0) {
        [UIView animateWithDuration:0.2 animations:^{
            if (self.y <= StatusBarHeight) {
                self.y = StatusBarHeight;
            }else if (self.y > [self superview].height - self.height - TabBarHeight - 20) {
                self.y = [self superview].height - self.height - TabBarHeight - 20;
            }
            self.x = [self superview].width - self.width;
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            if (self.y <= StatusBarHeight) {
                self.y = StatusBarHeight;
            }else if (self.y > [self superview].height - self.height - TabBarHeight - 20) {
                self.y = [self superview].height - self.height - TabBarHeight - 20;
            }
            self.x = 0;
        }];
    }
}

@end
