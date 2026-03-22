//
//  LLPhoneInputView.h
//  LuckyLoan
//
//  Created by hao on 2023/12/21.

#import "LLAuthcodeInputView.h"

@interface LLAuthcodeInputView () <UITextFieldDelegate>
@property (nonatomic, strong) UITextField *textView;
@property (nonatomic, strong) UIView *rectView;
@property (nonatomic, strong) NSDictionary *attrsDic;
@end

@implementation LLAuthcodeInputView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        [self reloadUI];
    }
    return self;
}

- (void)reloadUI {
    _rectView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:_rectView];
    [self addSubview:self.textView];
    UIButton *corverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    corverBtn.frame = self.textView.frame;
    [corverBtn addTarget:self action:@selector(toResponder) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:corverBtn];

    [self addRect:0];
}

- (void)addRect:(NSInteger)count {
    [_rectView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i = 0; i < AuthCodeLength; i++) {
        CGFloat midSpace = (self.width - 6*self.height)/5;
        UIView *rect = [[UIView alloc] initWithFrame:CGRectMake(i*(midSpace + self.height), 0, self.height, self.height)];
        [rect showRadius:8.0f];
        if (i < count) {
            rect.layer.borderColor = MainColor.CGColor;
            rect.backgroundColor = COLOR(191, 223, 215);
        }else {
            rect.layer.borderColor = COLOR(226, 234, 238).CGColor;
            rect.backgroundColor = COLOR(243, 248, 246);
        }
        rect.layer.borderWidth = 1;
        [_rectView addSubview:rect];
    }
}

- (UITextField *)textView {
    if (!_textView) {
        CGFloat letterWidth = 9;
        CGFloat AuthCodeFont = 16;
        CGFloat textWidth = self.width - self.height + letterWidth;
        _textView = [[UITextField alloc] initWithFrame:CGRectMake((self.height - letterWidth)/2, 0, textWidth + 100, self.height)];
        _textView.borderStyle = UITextBorderStyleNone;
        _textView.textColor = TextBlackColor;
        _textView.tintColor = MainColor;
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _textView.clearButtonMode = UITextFieldViewModeNever;
        _textView.keyboardType = UIKeyboardTypeNumberPad;
        _textView.delegate = self;
        CGFloat space = (textWidth - 6*letterWidth)/(AuthCodeLength - 1);
        _attrsDic = @{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:AuthCodeFont], NSKernAttributeName:[NSNumber numberWithFloat:space]};
    }
    return _textView;
}

- (NSString *)text {
    return self.textView.text;
}

- (void)setText:(NSString *)text {
    self.textView.text = text;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (newString.length > AuthCodeLength) {
        newString = [newString substringToIndex:AuthCodeLength];
    }
    textField.attributedText = [[NSAttributedString alloc] initWithString:newString attributes:_attrsDic];
    [self addRect:newString.length];
    if (self.inputBlock) {
        self.inputBlock(newString.length);
    }
    return NO;
}

- (void)toResponder {
    [_textView becomeFirstResponder];
}

@end
