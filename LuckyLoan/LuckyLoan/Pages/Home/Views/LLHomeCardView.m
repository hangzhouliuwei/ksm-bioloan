//
//  LLHomeCardView.m
//  LuckyLoan
//
//  Created by hao on 2023/12/27.
//

#import "LLHomeCardView.h"

@interface LLHomeCardView ()

@end

@implementation LLHomeCardView

- (id)initWithFrame:(CGRect)frame data:(NSDictionary *)data {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadUI:data];
    }
    return self;
}

- (void)loadUI:(NSDictionary *)data {
    UIImageView *image = [[UIImageView alloc] initWithFrame:self.bounds];
    image.image = ImageWithName(@"img_card");
    [self addSubview:image];
    
    UILabel *amountTitle = [[UILabel alloc] initWithFrame:CGRectMake(LeftMargin, 12*WScale, SafeWidth - 2*LeftMargin, 20)];
    amountTitle.text = NotNull(data[c_amountRangeDes]);
    amountTitle.textColor = UIColor.whiteColor;
    amountTitle.font = Font(12);
    amountTitle.textAlignment = NSTextAlignmentLeft;
    amountTitle.alpha = 0.6;
    [self addSubview:amountTitle];
    
    UILabel *amountLead = [[UILabel alloc] initWithFrame:CGRectMake(LeftMargin, 58*WScale, 20, 25)];
    amountLead.text = @"₦:";
    amountLead.textColor = UIColor.whiteColor;
    amountLead.font = Font(20);
    amountLead.textAlignment = NSTextAlignmentLeft;
    amountLead.alpha = 0.6;
    [amountLead sizeToFit];
//    [self addSubview:amountLead];
    
    UILabel *amountValue = [[UILabel alloc] initWithFrame:CGRectMake(LeftMargin, 52*WScale, 20, 30)];
    amountValue.text = data[c_amountRange];
    amountValue.textColor = UIColor.whiteColor;
    amountValue.font = FontBold(30);
    amountValue.textAlignment = NSTextAlignmentLeft;
    [amountValue sizeToFit];
    [self addSubview:amountValue];
    
    UILabel *period = [[UILabel alloc] initWithFrame:CGRectMake(LeftMargin, 98*WScale, 20, 20)];
    period.text = data[c_termInfoDes];
    period.textColor = COLOR(0, 94, 68);
    period.font = FontBold(12);
    period.textAlignment = NSTextAlignmentLeft;
    [period sizeToFit];
    [self addSubview:period];
    
    UILabel *interest = [[UILabel alloc] initWithFrame:CGRectMake(LeftMargin, period.y, SafeWidth - 2*LeftMargin, 20)];
    interest.text = data[c_loanRateDes];
    interest.textColor = COLOR(0, 94, 68);
    interest.font = FontBold(12);
    interest.textAlignment = NSTextAlignmentRight;
    [self addSubview:interest];
    
    UILabel *days = [[UILabel alloc] initWithFrame:CGRectMake(LeftMargin, 118*WScale, 20, 20)];
    days.text = data[c_termInfo];
    days.textColor = UIColor.whiteColor;
    days.font = Font(16);
    days.textAlignment = NSTextAlignmentLeft;
    [days sizeToFit];
    [self addSubview:days];
    
    UILabel *interestValue = [[UILabel alloc] initWithFrame:CGRectMake(LeftMargin, days.y, SafeWidth - 2*LeftMargin, 20)];
    interestValue.text = StrFormat(@"%@", NotNull(data[c_loanRate]));
    interestValue.textColor = UIColor.whiteColor;
    interestValue.font = Font(16);
    interestValue.textAlignment = NSTextAlignmentRight;
    [self addSubview:interestValue];
    
    UIButton *applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    applyBtn.frame = CGRectMake(36, 150*WScale, self.width - 72, 36);
    [applyBtn setBackgroundImage:ImageWithName(@"ic_apply_bg") forState:UIControlStateNormal];
    applyBtn.titleLabel.font = FontBold(12);
    [applyBtn setTitle:data[c_buttonText] forState:UIControlStateNormal];
    [applyBtn setTitleColor:TextBlackColor forState:UIControlStateNormal];
    [applyBtn addTarget:self action:@selector(applyClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:applyBtn];
}

- (void)applyClick {
    if (self.applyBlock) {
        self.applyBlock();
    }
}

@end
