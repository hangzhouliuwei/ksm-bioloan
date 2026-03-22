//
//  UIView+Adds.m
//  king
//
//  Created by hao on 2023/9/4.
//

#import "UIView+Adds.h"
#import "objc/runtime.h"

static const void *infoDicBy = &infoDicBy;

@implementation UIView (Adds)

@dynamic infoDic;

- (void)setInfoDic:(NSMutableDictionary *)infoDic {
    objc_setAssociatedObject(self, infoDicBy, infoDic, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSMutableDictionary *)infoDic {
  return objc_getAssociatedObject(self, infoDicBy);
}

- (CGFloat)height{
    return self.frame.size.height;
}

- (CGFloat)width{
    return self.frame.size.width;
}

- (CGFloat)x{
    return self.frame.origin.x;
}

- (CGFloat)y{
    return self.frame.origin.y;
}

- (CGSize)size{
    return self.frame.size;
}

- (CGPoint)origin{
    return self.frame.origin;
}

- (CGFloat)centerX{
    return self.center.x;
}

- (CGFloat)centerY{
    return self.center.y;
}

- (CGFloat)bottom{
    return self.frame.size.height + self.frame.origin.y;
}

- (CGFloat)right{
    return self.frame.size.width + self.frame.origin.x;
}

- (void)setX:(CGFloat)x{
    self.frame = CGRectMake(x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (void)setY:(CGFloat)y{
    self.frame = CGRectMake(self.frame.origin.x, y, self.frame.size.width, self.frame.size.height);
}

- (void)setWidth:(CGFloat)width{
    CGRect newFrame = CGRectMake(self.x, self.y, width, self.height);
    self.frame = newFrame;
}

- (void)setHeight:(CGFloat)height{
    CGRect newFrame = CGRectMake(self.x, self.y, self.width, height);
    self.frame = newFrame;
}


- (void)setWidthEqualToView:(UIView *)view{
    self.width = view.width;
}
- (void)setHeightEqualToView:(UIView *)view{
    self.height = view.height;
}

- (void)setCenterX:(CGFloat)centerX{
    CGPoint center = CGPointMake(self.centerX, self.centerY);
    center.x = centerX;
    self.center = center;
}

- (void)setCenterY:(CGFloat)centerY{
    CGPoint center = CGPointMake(self.centerX, self.centerY);
    center.y = centerY;
    self.center = center;
}

- (void)setCenterXEqualToView:(UIView *)view{
    UIView *superView = view.superview ? view.superview : view;
    CGPoint viewCenterPoint = [superView convertPoint:view.center toView:self.topSuperView];
    CGPoint centerPoint = [self.topSuperView convertPoint:viewCenterPoint toView:self.superview];
    self.centerX = centerPoint.x;
}

- (void)setCenterYEqualToView:(UIView *)view{
    UIView *superView = view.superview ? view.superview : view;
    CGPoint viewCenterPoint = [superView convertPoint:view.center toView:self.topSuperView];
    CGPoint centerPoint = [self.topSuperView convertPoint:viewCenterPoint toView:self.superview];
    self.centerY = centerPoint.y;
}

- (void)setTopEqualToView:(UIView *)view{
    UIView *superView = view.superview ? view.superview : view;
    CGPoint viewOrigin = [superView convertPoint:view.origin toView:self.topSuperView];
    CGPoint newOrigin = [self.topSuperView convertPoint:viewOrigin toView:self.superview];
    
    self.y = newOrigin.y;
}

- (void)setBottomEqualToView:(UIView *)view{
    UIView *superView = view.superview ? view.superview : view;
    CGPoint viewOrigin = [superView convertPoint:view.origin toView:self.topSuperView];
    CGPoint newOrigin = [self.topSuperView convertPoint:viewOrigin toView:self.superview];
    
    self.y = newOrigin.y + view.height - self.height;
}

- (void)setLeftEqualToView:(UIView *)view{
    UIView *superView = view.superview ? view.superview : view;
    CGPoint viewOrigin = [superView convertPoint:view.origin toView:self.topSuperView];
    CGPoint newOrigin = [self.topSuperView convertPoint:viewOrigin toView:self.superview];
    
    self.x = newOrigin.x;
}

- (void)setRightEqualToView:(UIView *)view{
    UIView *superView = view.superview ? view.superview : view;
    CGPoint viewOrigin = [superView convertPoint:view.origin toView:self.topSuperView];
    CGPoint newOrigin = [self.topSuperView convertPoint:viewOrigin toView:self.superview];
    
    self.x = newOrigin.x + view.width - self.width;
}

- (void)setSize:(CGSize)size{
    self.frame = CGRectMake(self.x, self.y, size.width, size.height);
}

- (void)setSizeEqualToView:(UIView *)view{
    self.frame = CGRectMake(self.x, self.y, view.width, view.height);
}

- (void)fillSuperView{
    self.frame = CGRectMake(0, 0, self.superview.width, self.superview.height);
}

- (UIView *)topSuperView{
    UIView *topSuperView = self.superview;
    
    if (topSuperView == nil) {
        topSuperView = self;
    } else {
        while (topSuperView.superview) {
            topSuperView = topSuperView.superview;
        }
    }
    
    return topSuperView;
}

- (void)addLine:(LineType)type {
    [self addLine:type color:LineLightGrayColor];
}

- (void)addLine:(LineType)type color:(UIColor *)color {
    [self addLine:type color:color width:0.8];
}

- (void)addLine:(LineType)type color:(UIColor *)color width:(CGFloat)lineBold {
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = color;
    [self addSubview:line];
    switch (type) {
        case LineTypeTop:
            line.frame = CGRectMake(0, 0, self.width, lineBold);
            break;
        case LineTypeBottom:
            line.frame = CGRectMake(0, self.height - lineBold - 0.5, self.width, lineBold);
            break;
        case LineTypeLeft:
            line.frame = CGRectMake(0, 0, lineBold, self.height);
            break;
        case LineTypeRight:
            line.frame = CGRectMake(self.width - lineBold, 0, lineBold, self.height);
            break;
        case LineTypeMiddle:
            line.frame = CGRectMake(0, self.height/2, self.width, lineBold);
            break;
            
        default:
            break;
    }
}

- (void)showShadow {
    [self showShadow:ShadowColor];
}

- (void)showShadow:(UIColor *)color {
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = CGSizeMake(0,0);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 4;
}

- (void)showBottomShadow:(UIColor *)color {
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = CGSizeMake(0,4);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 4;
}

- (void)showShadow:(UIColor *)color radius:(CGFloat)radius {
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = 0.000001; // 只要不为0就行
    self.layer.cornerRadius = radius;
    [self showShadow:color];
}

- (void)showRadius:(CGFloat)radius {
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}

- (void)showTopRarius:(CGFloat)radius {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.width, self.height) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(radius,radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)showLeftTopRarius:(CGFloat)radius {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.width, self.height) byRoundingCorners:UIRectCornerTopLeft cornerRadii:CGSizeMake(radius,radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)showLeftRarius:(CGFloat)radius {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.width, self.height) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(radius,radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)showBottomRarius:(CGFloat)radius {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.width, self.height) byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(radius,radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)addGradient:(NSArray *)colors start:(CGPoint)start end:(CGPoint)end {
    NSMutableArray *colorArr = [NSMutableArray array];
    for (UIColor *color in colors) {
        [colorArr addObject:(id)color.CGColor];
    }
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    gradient.colors = [colorArr copy];
    gradient.startPoint = start;
    gradient.endPoint = end;
    [self.layer insertSublayer:gradient atIndex:0];
}

- (void)removeAllSubviews {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)setBorderShadow:(UIColor *)color {
    self.backgroundColor = UIColor.whiteColor;
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = 1;
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = CGSizeMake(0,0);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 8;
    self.layer.cornerRadius = 8;
}

@end
