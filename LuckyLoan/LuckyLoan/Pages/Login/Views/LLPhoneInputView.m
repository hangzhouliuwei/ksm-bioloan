//
//  LLPhoneInputView.h
//  LuckyLoan
//
//  Created by hao on 2023/12/21.
//

#import "LLPhoneInputView.h"

@interface LLPhoneInputView () <UITextFieldDelegate>
@property (nonatomic, strong) UILabel *preLabel;
@property (nonatomic, strong) UITextField *textView;
@end

@implementation LLPhoneInputView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = LightMainColor;
        self.layer.borderColor = LineGrayColor.CGColor;
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 8;
        [self reloadUI];
    }
    return self;
}

- (void)reloadUI {
    [self addSubview:self.preLabel];
    [self addSubview:self.textView];
}

- (UILabel *)preLabel {
    if (!_preLabel) {
        _preLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, 60, 20)];
        _preLabel.backgroundColor = UIColor.clearColor;
        _preLabel.text = @"+234 ";
        _preLabel.textColor = MainColor;
        _preLabel.font = FontBold(14);
        _preLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_preLabel];
    }
    return _preLabel;
}

- (UITextField *)textView {
    if (!_textView) {
        _textView = [[UITextField alloc] initWithFrame:CGRectMake(self.preLabel.right, 0, self.width - self.preLabel.right, self.height)];
        _textView.borderStyle = UITextBorderStyleNone;
        _textView.font = FontBold(12);
        _textView.textColor = TextBlackColor;
        _textView.tintColor = MainColor;
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _textView.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textView.placeholder = @"Phone number";
        _textView.keyboardType = UIKeyboardTypeNumberPad;
        _textView.delegate = self;
    }
    return _textView;
}

- (NSString *)text {
    return self.textView.text;
}

- (void)setText:(NSString *)text {
    self.textView.text = text;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (self.inputBlock) {
        self.inputBlock(0);
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (![self isAllNum:string]) {
        return NO;
    }
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (self.inputBlock) {
        self.inputBlock(newString.length);
    }
    if (newString.length >= 15) {
        textField.text = [newString substringToIndex:15];
//        [self.superview.superview endEditing:YES];
        return NO;
    }
    return YES;
}


- (BOOL)isAllNum:(NSString *)string {
    unichar c;
    for (int i = 0; i < string.length; i++) {
        c = [string characterAtIndex:i];
        if (!isdigit(c)) {
            return NO;
        }
    }
    return YES;
}

- (void)becomeFirstResponder {
    [self.textView becomeFirstResponder];
}

@end
