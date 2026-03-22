//
//  UIView+Broken.m
//  king
//
//  Created by hao on 2021/11/20.
// 
//

#import "UIView+Broken.h"

const static NSInteger cellCount = 17;

static NSMutableArray<CALayer *> *booms;

@implementation UIView (Broken)

+ (void)load {
    booms = [NSMutableArray<CALayer *> array];
}

- (void)broken{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0), dispatch_get_main_queue(), ^{
        [self boom];
    });
}

- (void)boom {
    [booms removeAllObjects];
    for(int i = 0 ; i < cellCount ; i++){
        for(int j = 0 ; j < cellCount ; j++){
            CGFloat pWidth = MIN(self.frame.size.width, self.frame.size.height)/cellCount;
            CALayer *boomCell = [CALayer layer];
            boomCell.backgroundColor = [self getPixelColorAtLocation:CGPointMake(i*2, j*2)].CGColor;
            boomCell.cornerRadius = pWidth/2;
            boomCell.frame = CGRectMake(i*pWidth, j*pWidth, pWidth, pWidth);
            [self.layer.superlayer addSublayer:boomCell];
            [booms addObject:boomCell];
        }
    }
    //粉碎动画
    [self cellAnimation];
    //缩放
    [self scaleAnimations];
}

- (void)cellAnimation {
    for(CALayer *cell in booms){
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        CAKeyframeAnimation *keyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        keyframeAnimation.path = [self makeRandomPath:cell].CGPath;
        keyframeAnimation.fillMode = kCAFillModeForwards;
        keyframeAnimation.timingFunction =  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut];
        keyframeAnimation.duration = (random()%10) * 0.05 + 0.3;
        CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scale.toValue = @([self makeScaleValue]);
        scale.duration = keyframeAnimation.duration;
        scale.removedOnCompletion = NO;
        scale.fillMode = kCAFillModeForwards;
        CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacity.fromValue = @1;
        opacity.toValue = @0;
        opacity.duration = keyframeAnimation.duration;
        opacity.removedOnCompletion = NO;
        opacity.fillMode = kCAFillModeForwards;
        opacity.timingFunction =  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut];
        animationGroup.duration = keyframeAnimation.duration;
        animationGroup.removedOnCompletion = NO;
        animationGroup.fillMode = kCAFillModeForwards;
        animationGroup.animations = @[keyframeAnimation,scale,opacity];
        animationGroup.delegate = self;
        [cell addAnimation:animationGroup forKey: @"moveAnimation"];
    }
}

- (UIBezierPath *) makeRandomPath: (CALayer *) alayer {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:self.layer.position];
    CGFloat left = -self.layer.frame.size.width * 1.3;
    CGFloat maxOffset = 2 * fabs(left);
    CGFloat randomNumber = random()%101;
    CGFloat endPointX = self.layer.position.x + left + (randomNumber/100) * maxOffset;
    CGFloat controlPointOffSetX = self.layer.position.x + (endPointX-self.layer.position.x)/2;
    CGFloat controlPointOffSetY = self.layer.position.y - 0.2 * self.layer.frame.size.height - random()%(int)(1.2 * self.layer.frame.size.height);
    CGFloat endPointY = self.layer.position.y + self.layer.frame.size.height/2 +random()%(int)(self.layer.frame.size.height/2);
    [path addQuadCurveToPoint:CGPointMake(endPointX, endPointY) controlPoint:CGPointMake(controlPointOffSetX, controlPointOffSetY)];
    return path;
}

- (void)scaleAnimations {
    CAKeyframeAnimation *scale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scale.values = @[@(0.1),@(1.3),@(0.8),@(1.1),@(1.0)];
    scale.calculationMode = kCAAnimationLinear;
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[scale];
    animationGroup.duration = 0.5;
    [self.layer addAnimation:animationGroup forKey:nil];
    [LLTools shake];
}

- (CGFloat)makeScaleValue {
    return 1 - 0.7 * (random()%101 - 50)/50;
}

- (UIImage *)snapShot {
    UIGraphicsBeginImageContext(self.frame.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef) inImage {
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    void *bitmapData;
    unsigned long bitmapByteCount;
    unsigned long bitmapBytePerRow;
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHeight = CGImageGetHeight(inImage);
    bitmapBytePerRow = pixelsWide * 4;
    bitmapByteCount = bitmapBytePerRow * pixelsHeight;
    colorSpace = CGColorSpaceCreateDeviceRGB();
    bitmapData = malloc(bitmapByteCount);
    context = CGBitmapContextCreate(bitmapData, pixelsWide, pixelsHeight, 8, bitmapBytePerRow, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
    return context;
}

- (UIColor *)getPixelColorAtLocation:(CGPoint)point {
    CGImageRef inImage = [self scaleImageToSize:CGSizeMake(cellCount*2, cellCount*2)].CGImage;
    CGContextRef cgctx = [self createARGBBitmapContextFromImage:inImage];
    size_t w = CGImageGetWidth(inImage);
    size_t h = CGImageGetHeight(inImage);
    CGRect rect = CGRectMake(0, 0, w, h);
    CGContextDrawImage(cgctx, rect, inImage);
    unsigned char *bitmapData = CGBitmapContextGetData(cgctx);
    int pixelInfo = 4*((w*round(point.y))+round(point.x));
    CGFloat a = bitmapData[pixelInfo]/255.0;
    CGFloat r = bitmapData[pixelInfo+1]/255.0;
    CGFloat g = bitmapData[pixelInfo+2]/255.0;
    CGFloat b = bitmapData[pixelInfo+3]/255.0;
    CGContextRelease(cgctx);
    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

- (UIImage *)scaleImageToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [[self snapShot] drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *res = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return res;
}

@end
