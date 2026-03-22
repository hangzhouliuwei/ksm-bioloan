//
//  LLApplyStepView.m
//  LuckyLoan
//
//  Created by hao on 2024/1/3.
//

#import "LLApplyStepView.h"

@implementation LLApplyStepView

- (id)initWithFrame:(CGRect)frame step:(NSInteger)step {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = ClearColor;
        [self loadUIStep:step];
    }
    return self;
}

- (void)loadUIStep:(NSInteger)step {
    
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 34)];
    bg.backgroundColor = COLORA(255, 255, 255, 0.26);
    [bg showRadius:bg.height/2];
    [self addSubview:bg];
    
    CGFloat space = (self.width - 8 - 4*26)/3;
    for (int i = 0; i < 4; i++) {
        UILabel *number = [[UILabel alloc] initWithFrame:CGRectMake(4 + (26 + space)*i, 4, 26, 26)];
        number.backgroundColor = UIColor.whiteColor;
        number.text = StrValue(i + 1, 0);
        number.textColor = MainColor;
        number.font = FontBold(16);
        number.textAlignment = NSTextAlignmentCenter;
        [number showRadius:number.height/2];
        [bg addSubview:number];
        if (i >= step) {
            number.alpha = 0.3;
        }
        if (i < 3) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(number.right + 6, 16, space - 12, 2)];
            line.backgroundColor = UIColor.whiteColor;
            [line showRadius:1];
            [bg addSubview:line];
            if (i >= step) {
                line.alpha = 0.3;
            }
        }
        if (i == step - 1) {
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.height - 17, 17, 17)];
            image.image = ImageWithName(@"ic_coin");
            image.centerX = number.centerX;
            [self addSubview:image];
        }
    }
}

@end
