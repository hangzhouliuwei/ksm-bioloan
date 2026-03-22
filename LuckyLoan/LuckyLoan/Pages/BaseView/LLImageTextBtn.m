//
//  LLImageTextBtn.m
//  king
//
//  Created by hao on 2023/9/4.
// 
//

#import "LLImageTextBtn.h"

@implementation LLImageTextBtn

- (id)initWithFrame:(CGRect)frame title:(NSString *)title  color:(UIColor *)color  font:(CGFloat)font icon:(NSString *)icon {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = Font(font);
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:color forState:UIControlStateNormal];
        [self setImage:ImageWithName(icon) forState:UIControlStateNormal];
        self.type = HaoBtnType1;
    }
    return self;
}

- (void)setType:(HaoBtnType)type {
    if (type == HaoBtnType1) {
        //默认样式
    }else if (type == HaoBtnType2) {
        self.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    }else if (type == HaoBtnType3) {
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.imageView.bounds.size.width, 0, self.imageView.bounds.size.width + 4)];
        [self setImageEdgeInsets:UIEdgeInsetsMake(0, self.titleLabel.bounds.size.width, 0, -self.titleLabel.bounds.size.width)];
    }else if (type == HaoBtnType4) {
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.imageView.bounds.size.width, 0, self.imageView.bounds.size.width + 4)];
        [self setImageEdgeInsets:UIEdgeInsetsMake(0, self.titleLabel.bounds.size.width, 0, -self.titleLabel.bounds.size.width)];
    }else if (type == HaoBtnType5) {
        [self setTitleEdgeInsets:UIEdgeInsetsMake(self.frame.size.height/2, (self.frame.size.width-self.titleLabel.intrinsicContentSize.width)/2-self.imageView.frame.size.width, 0, (self.frame.size.width-self.titleLabel.intrinsicContentSize.width)/2)];
        [self setImageEdgeInsets:UIEdgeInsetsMake(0, (self.frame.size.width-self.imageView.frame.size.width)/2, self.titleLabel.intrinsicContentSize.height, (self.frame.size.width-self.imageView.frame.size.width)/2)];
    }else if (type == HaoBtnType6) {
        [self setTitleEdgeInsets:UIEdgeInsetsMake(self.frame.size.height/2, (self.frame.size.width-self.titleLabel.intrinsicContentSize.width)/2-self.imageView.frame.size.width, -5, (self.frame.size.width-self.titleLabel.intrinsicContentSize.width)/2)];
        [self setImageEdgeInsets:UIEdgeInsetsMake(-5, (self.frame.size.width-self.imageView.frame.size.width)/2, self.titleLabel.intrinsicContentSize.height, (self.frame.size.width-self.imageView.frame.size.width)/2)];
    }else if (type == HaoBtnType7) {
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.imageView.bounds.size.width, 0, self.imageView.bounds.size.width + 4)];
        [self setImageEdgeInsets:UIEdgeInsetsMake(0, self.titleLabel.bounds.size.width, 0, -self.titleLabel.bounds.size.width)];
    }else if (type == HaoBtnType8) {
        self.contentHorizontalAlignment =UIControlContentHorizontalAlignmentRight;
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    }else if (type == HaoBtnType9) {
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [self setImageEdgeInsets:UIEdgeInsetsMake(0, self.width - self.titleLabel.bounds.size.width - self.imageView.bounds.size.width - 8, 0, 0)];
    }
    _type = type;
}

- (void)setTitle:(NSString *)title {
    [self setTitle:title forState:UIControlStateNormal];
    self.type = _type;
    _title = title;
}

@end
