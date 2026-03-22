//
//  LLSmallCardView.m
//  LuckyLoan
//
//  Created by hao on 2024/1/24.
//

#import "LLSmallCardView.h"

@interface LLSmallCardView ()

@end

@implementation LLSmallCardView

- (id)initWithFrame:(CGRect)frame data:(NSDictionary *)data {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadUI:data];
    }
    return self;
}

- (void)loadUI:(NSDictionary *)data {
    UIImageView *image = [[UIImageView alloc] initWithFrame:self.bounds];
    image.image = ImageWithName(@"img_small_card_bg");
    [self addSubview:image];
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(LeftMargin, 12, 30*WScale, 30*WScale)];
    [icon sd_setImageWithURL:URLEncode(data[c_productLogo])];
    [icon showRadius:4];
    [self addSubview:icon];
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(icon.right + 10, 12, self.width - icon.right, 30*WScale)];
    name.text = NotNull(data[c_productName]);
    name.textColor = TextWhiteColor;
    name.font = Font(12);
    [self addSubview:name];
    
    UILabel *amountLead = [[UILabel alloc] initWithFrame:CGRectMake(LeftMargin, 58*WScale, 20, 25)];
    amountLead.text = @"₦:";
    amountLead.textColor = UIColor.whiteColor;
    amountLead.font = Font(20);
    amountLead.textAlignment = NSTextAlignmentLeft;
    amountLead.alpha = 0.6;
    [amountLead sizeToFit];
//    [self addSubview:amountLead];
    
    UILabel *amountValue = [[UILabel alloc] initWithFrame:CGRectMake(LeftMargin, 45*WScale, 20, 30)];
    amountValue.text = data[c_amountRange];
    amountValue.textColor = UIColor.whiteColor;
    amountValue.font = FontBold(30);
    amountValue.textAlignment = NSTextAlignmentLeft;
    [amountValue sizeToFit];
    [self addSubview:amountValue];
    
    UILabel *amountTitle = [[UILabel alloc] initWithFrame:CGRectMake(LeftMargin, amountValue.bottom, SafeWidth - 2*LeftMargin, 20)];
    amountTitle.text = NotNull(data[c_amountRangeDes]);
    amountTitle.textColor = UIColor.whiteColor;
    amountTitle.font = Font(12);
    amountTitle.textAlignment = NSTextAlignmentLeft;
    amountTitle.alpha = 0.6;
    [self addSubview:amountTitle];
    
    UIButton *applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    applyBtn.frame = CGRectMake(36, self.height - 44, self.width - 72, 36);
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
