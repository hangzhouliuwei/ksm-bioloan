//
//  LLTools.m
//  Hao
//
//  Created by hao on 2023/9/4.
// 
//

#import "LLTools.h"
#import "MBProgressHUD.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation LLTools

+ (UIColor *)colorWithHexString: (NSString *)color {
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return COLOR(r, g, b);
}

+ (BOOL)isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([string caseInsensitiveCompare:@"null"] == NSOrderedSame) {
        return YES;
    }
    if (string.length == 0) {
        return YES;
    }
    return NO;
}

+ (BOOL)isNrlyPhoneNo:(NSString *)phoneNo {
    NSString *emailRegex = @"^(9[0-9])\\d{8}$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:phoneNo];
}

+ (CGSize)getSizeByString:(NSString*)str fontValue:(CGFloat)fontValue maxSize:(CGSize)size {
    NSDictionary *attrs = @{NSFontAttributeName : Font(fontValue)};
    CGSize sizeaa = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    return sizeaa;
}

+ (void)showToast:(NSString *)str {
    [LLTools showToast:str time:1.0];
}

+ (void)showToast:(NSString *)str time:(NSTimeInterval)time {
    if (str.length == 0) {
        return;
    }
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:TopWindow.bounds];
    bgView.userInteractionEnabled = YES;
    
    float viewWith = ScreenWidth / 2;
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 10.f, viewWith - 20, 0)];
    [label setText:str];
    [label setNumberOfLines:0];
    [label setFont:Font(15)];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor whiteColor]];
    [label sizeToFit];

    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, label.width + 20, label.height + 20)];
    grayView.layer.cornerRadius = 15;
    grayView.backgroundColor = MainColor;
    grayView.alpha = 0.6;
    [grayView addSubview:label];
    [bgView addSubview:grayView];
    grayView.center = bgView.center;
    
    [TopWindow addSubview:bgView];
    
    [UIView animateWithDuration:0.2f
                     animations:^{
                         grayView.alpha = 1;
                     }
                     completion:^(BOOL finished){
                         [NSTimer scheduledTimerWithTimeInterval:time-0.4f
                                                          target:self
                                                        selector:@selector(hideTip:)
                                                        userInfo:bgView
                                                         repeats:NO];
                     }];
}

+ (void)hideTip:(NSTimer *)timer {
    UIView* flashTipView = (UIView *)[timer userInfo];
    [UIView animateWithDuration:0.2f
                     animations:^{
                         flashTipView.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         [flashTipView removeFromSuperview];
                     }];
}

+ (NSString *)urlZhEncode:(NSString *)urlStr {
    if ([LLTools isBlankString:urlStr]) {
        return @"";
    }
    NSString *encodedString = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return encodedString;
}

+ (void)callWithPhoneNo:(NSString *)str {
    if ([LLTools isBlankString:str]) {
        return;
    }
    NSString *temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    if (temp.length == 0) {
        return;
    }
    NSMutableString *callStr=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",temp];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callStr] options:@{} completionHandler:nil];
}

+ (void)addAttentionAnimation:(UIView *)view {
    //大小缩放
    CAKeyframeAnimation *scale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scale.values = @[@(0.1),@(2),@(0.7),@(1.3),@(1.0)];
//        scale.duration = 0.5;
    scale.calculationMode = kCAAnimationLinear;
    //透明度
    CAKeyframeAnimation *opacity = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacity.values = @[@(1),@(0.3),@(1),@(0.8),@(1.0)];
    opacity.calculationMode = kCAAnimationLinear;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[scale, opacity];
    animationGroup.duration = 0.5;
    [view.layer addAnimation:animationGroup forKey:nil];
    [self shake];
}

+ (void)shake {
    if (@available(iOS 10.0, *)) {
        UIImpactFeedbackGenerator *impactLight = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
        [impactLight impactOccurred];
    }
}

+ (void)showHud {
    [self showHud:@""];
}

+ (void)showHud:(NSString *)tipsString {
    if ([UIApplication sharedApplication].keyWindow) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        hud.contentColor = MainColor;
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.backgroundColor = BGColor;
        if (tipsString.length > 0) {
            UILabel *tips = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
            tips.text = tipsString;
            tips.textColor = TextWhiteColor;
            tips.font = Font(12);
            tips.textAlignment = NSTextAlignmentCenter;
            tips.centerY = hud.height/2 + 50;
            [hud addSubview:tips];
        }
    }
    
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
//    NSURL *fileUrl = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]]URLForResource:@"fun_escape_loading" withExtension:@"gif"];
//    CGImageSourceRef gifSource = CGImageSourceCreateWithURL((CFURLRef)fileUrl, NULL);//将GIF图片转换成对应的图片源
//    size_t frameCout = CGImageSourceGetCount(gifSource);//获取其中图片源个数，即由多少帧图片组成
//    NSMutableArray *frames = [[NSMutableArray alloc] init];
//    for (size_t i = 0; i < frameCout; i++){
//        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(gifSource, i, NULL);//从GIF图片中取出源图片
//        UIImage *image = [UIImage imageWithCGImage:imageRef];
//        CGFloat scale = [[UIScreen mainScreen] scale];
//        UIGraphicsBeginImageContextWithOptions(CGSizeMake(30, 60), NO, scale);
//        [image drawInRect:CGRectMake(0, 0, 30, 60)];
//        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        [frames addObject:newImage];
//        CGImageRelease(imageRef);
//    }
//    UIImageView *imageview = [[UIImageView alloc] init];
//    imageview.frame = CGRectMake(0, 0, 50, 50);
//    imageview.animationImages = frames;
//    imageview.animationDuration = 0.7;
//    [imageview startAnimating];
//
//    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
//    hud.bezelView.backgroundColor = ClearColor;
//    hud.mode = MBProgressHUDModeCustomView;
//    hud.backgroundColor = ClearColor;
//    hud.customView = imageview;
}

+ (void)hideHud {
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
}

+ (NSString *)nowTimeIntervalString {
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970]*1000;
    NSString *timeStr = StrValue(time, 0);
    return NotNull(timeStr);
}

+ (NSInteger)timeWithString:(NSString *)dateStr formatter:(NSString *)formatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    NSInteger time = (long)[date timeIntervalSince1970];
    return time;
}

+ (NSString *)stringWithTime:(NSInteger)time formatter:(NSString *)formatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    NSDate *date = [NSDate  dateWithTimeIntervalSince1970:time];;
    return [dateFormatter stringFromDate:date];
}

+ (void)jumpSystemSetting {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success) {
    }];
}

@end
