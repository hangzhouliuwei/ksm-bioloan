//
//  LLBaseContentView.m
//  king
//
//  Created by hao on 2023/9/4.
// 
//

#import "LLBaseContentView.h"

@implementation LLBaseContentView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

- (void)setSizeFit:(UIView *)bottomView {
    self.contentSize = CGSizeMake(self.width, MAX(bottomView.bottom + SafeAreaBottomHeight, self.height + 1));
}

@end
