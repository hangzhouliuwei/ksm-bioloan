//
//  UILabel+Adds.m
//  king
//
//  Created by hao on 2023/6/6.
// 
//

#import "UILabel+Adds.h"

@implementation UILabel (Adds)

- (void)setLineSpace:(CGFloat)lineSpace withText:(NSString *)text {
    if ([LLTools isBlankString:text] || !self) {
        return;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace;
    paragraphStyle.lineBreakMode = self.lineBreakMode;
    paragraphStyle.alignment = self.textAlignment;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    self.attributedText = attributedString;
}

@end
