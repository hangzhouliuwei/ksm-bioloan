//
//  LLBaseButton.m
//  king
//
//  Created by hao on 2023/9/4.
// 
//

#import "LLBaseButton.h"

@interface LLBaseButton ()

@end

@implementation LLBaseButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadUI];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame title:(NSString *)title {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadUI];
        self.title = title;
    }
    return self;
}

- (void)loadUI {
    [self showRadius:4];
    self.titleLabel.font = FontBold(14);
    self.type = BtnTypeNormal;
}

- (CAGradientLayer *)gradient {
    if (!_gradient) {
        _gradient = [CAGradientLayer layer];
        _gradient.frame = self.bounds;
        _gradient.colors = @[(id)COLOR(255, 210, 63).CGColor, (id)COLOR(255, 185, 35).CGColor];
        _gradient.startPoint = CGPointMake(0, 0);
        _gradient.endPoint = CGPointMake(1, 0);
    }
    return _gradient;
}

- (void)setTitle:(NSString *)title {
    [self setTitle:title forState:UIControlStateNormal];
    _title = title;
}

- (void)setType:(ButtonType)type {
    self.alpha = 1;
    self.enabled = YES;
    self.layer.borderWidth = 0;
    if (type == BtnTypeNormal) {
        [self setTitleColor:TextWhiteColor forState:UIControlStateNormal];
        [self.layer insertSublayer:self.gradient atIndex:0];
    }else if (type == BtnTypeDisable) {
        self.enabled = NO;
        [self setTitleColor:TextWhiteColor forState:UIControlStateNormal];
        self.backgroundColor = COLOR(207, 216, 227);
        [self.gradient removeFromSuperlayer];
    }else if (type == BtnTypeGray) {
        [self setTitleColor:TextGrayColor forState:UIControlStateNormal];
        self.backgroundColor = LineLightGrayColor;
        [self.gradient removeFromSuperlayer];
    }else if (type == BtnTypeGreen) {
        [self setTitleColor:TextWhiteColor forState:UIControlStateNormal];
        self.backgroundColor = MainColor;
        [self.gradient removeFromSuperlayer];
    }else if (type == BtnTypeBorder) {
        [self setTitleColor:COLOR(255, 185, 35) forState:UIControlStateNormal];
        self.layer.borderColor = COLOR(255, 185, 35).CGColor;
        self.layer.borderWidth = 0.8;
        [self.gradient removeFromSuperlayer];
    }else if (type == BtnTypeSimple) {
        [self.gradient removeFromSuperlayer];
        [self setTitleColor:MainColor forState:UIControlStateNormal];
    }
    _type = type;
}

@end
