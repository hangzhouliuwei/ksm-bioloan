//
//  LLRepayCardView.m
//  LuckyLoan
//
//  Created by hao on 2024/1/24.
//

#import "LLRepayCardView.h"

@interface LLRepayCardView ()

@end

@implementation LLRepayCardView

- (id)initWithFrame:(CGRect)frame data:(NSDictionary *)data {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadUI:data];
    }
    return self;
}

- (void)loadUI:(NSDictionary *)data {
    NSArray *bgImgArr = @[@"img_repay_green", @"img_repay_orange", @"img_repay_red"];
    NSArray *titleColorArr = @[UIColor.blackColor, COLOR(255, 105, 50), COLOR(255, 7, 7)];
    NSArray *bgColorArr = @[COLOR(253, 210, 80), UIColor.whiteColor, UIColor.whiteColor];

    UIImageView *image = [[UIImageView alloc] initWithFrame:self.bounds];
    image.image = ImageWithName(bgImgArr[0]);
    [self addSubview:image];
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(65*WScale, 0, self.width - 65*WScale - 86, self.height)];
    name.text = NotNull(data[c_message]);
    name.textColor = TextWhiteColor;
    name.font = Font(12);
    [self addSubview:name];

    UIButton *applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    applyBtn.backgroundColor = bgColorArr[0];
    applyBtn.frame = CGRectMake(self.width - 86, self.height/2 - 16*WScale, 76, 32*WScale);
    applyBtn.titleLabel.font = FontBold(12);
    [applyBtn setTitle:@"Repay" forState:UIControlStateNormal];
    [applyBtn setTitleColor:titleColorArr[0] forState:UIControlStateNormal];
    [applyBtn addTarget:self action:@selector(repayClick) forControlEvents:UIControlEventTouchUpInside];
    [applyBtn showRadius:4];
    [self addSubview:applyBtn];
    
    [self showRadius:8];
}

- (void)repayClick {
    if (self.repayBlock) {
        self.repayBlock();
    }
}

@end
