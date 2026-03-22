//
//  UIView+Adds.h
//  king
//
//  Created by hao on 2023/9/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LineType) {
    LineTypeTop = 0,
    LineTypeBottom,
    LineTypeLeft,
    LineTypeRight,
    LineTypeMiddle,
};

@interface UIView (Adds)

@property (nonatomic, strong) NSMutableDictionary *infoDic;

- (CGFloat)height;
- (CGFloat)width;
- (CGFloat)x;
- (CGFloat)y;
- (CGSize)size;
- (CGPoint)origin;
- (CGFloat)centerX;
- (CGFloat)centerY;
- (CGFloat)bottom;
- (CGFloat)right;

- (void)setX:(CGFloat)x;
- (void)setY:(CGFloat)y;
- (void)setWidth:(CGFloat)width;
- (void)setHeight:(CGFloat)height;
- (void)setWidthEqualToView:(UIView *)view;
- (void)setHeightEqualToView:(UIView *)view;
- (void)setCenterX:(CGFloat)centerX;
- (void)setCenterY:(CGFloat)centerY;
- (void)setCenterXEqualToView:(UIView *)view;
- (void)setCenterYEqualToView:(UIView *)view;
- (void)setTopEqualToView:(UIView *)view;
- (void)setBottomEqualToView:(UIView *)view;
- (void)setLeftEqualToView:(UIView *)view;
- (void)setRightEqualToView:(UIView *)view;
- (void)setSize:(CGSize)size;
- (void)setSizeEqualToView:(UIView *)view;

- (void)fillSuperView;
- (UIView *)topSuperView;

- (void)addLine:(LineType)type;
- (void)addLine:(LineType)type color:(UIColor *)color;
- (void)addLine:(LineType)type color:(UIColor *)color width:(CGFloat)lineBold;
- (void)showShadow;
- (void)showShadow:(UIColor *)color;
- (void)showBottomShadow:(UIColor *)color;
- (void)showShadow:(UIColor *)color radius:(CGFloat)radius;
- (void)showRadius:(CGFloat)radius;
- (void)showTopRarius:(CGFloat)radius;
- (void)showLeftTopRarius:(CGFloat)radius;
- (void)showLeftRarius:(CGFloat)radius;
- (void)showBottomRarius:(CGFloat)radius;
- (void)addGradient:(NSArray *)colors start:(CGPoint)start end:(CGPoint)end;
- (void)removeAllSubviews;
- (void)setBorderShadow:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
