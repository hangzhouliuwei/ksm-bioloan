//
//  LLAdvantageView.m
//  LuckyLoan
//
//  Created by hao on 2023/12/27.
//

#import "LLAdvantageView.h"

@implementation LLAdvantageView

- (id)initWithFrame:(CGRect)frame data:(NSDictionary *)data {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        [self loadUI:data];
    }
    return self;
}

- (void)loadUI:(NSDictionary *)data {
    UILabel *advantageDesc = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SafeWidth, 20)];
    advantageDesc.text = @"Application advantages";
    advantageDesc.textColor = TextLightGrayColor;
    advantageDesc.font = Font(12);
    advantageDesc.textAlignment = NSTextAlignmentLeft;
    [self addSubview:advantageDesc];
    
    NSArray *items = @[@{@"title":@"Safe and reliable", @"value":@"Professional institutions", @"image":@"ic_card_safe"}, @{@"title":@"Payment speed", @"value":StrFormat(@"Received within %@", data[c_termInfo]), @"image":@"ic_card_speed"}, @{@"title":@"High pass rate", @"value":StrFormat(@"%@ successful loans", NotNull(data[c_loanRate])), @"image":@"ic_card_rate"}];
    for (int i = 0; i < items.count; i++) {
        NSDictionary *dic = items[i];
        UIView *item = [[UIView alloc] initWithFrame:CGRectMake(0, 32 + 70*i, self.width, 54)];
        item.backgroundColor = COLOR(245, 246, 250);
        [item showRadius:4];
        [self addSubview:item];
        self.height = item.bottom + 40;

        UIButton *leadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leadBtn.frame = CGRectMake(0, 0, 54, 54);
        [leadBtn setImage:ImageWithName(dic[@"image"]) forState:UIControlStateNormal];
        [item addSubview:leadBtn];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(leadBtn.right, 7, self.width - 130, 20)];
        title.text = dic[@"title"];
        title.textColor = UIColor.blackColor;
        title.font = FontBold(12);
        title.textAlignment = NSTextAlignmentLeft;
        [item addSubview:title];
        
        UILabel *value = [[UILabel alloc] initWithFrame:CGRectMake(leadBtn.right, title.bottom, self.width - 130, 20)];
        value.text = dic[@"value"];
        value.textColor = TextGrayColor;
        value.font = Font(12);
        value.textAlignment = NSTextAlignmentLeft;
        [item addSubview:value];
        
        UIButton *trailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        trailBtn.frame = CGRectMake(item.width - 16 - 59, 10, 59, 29);
        [trailBtn setBackgroundImage:ImageWithName(@"ic_card_Logo") forState:UIControlStateNormal];
        [item addSubview:trailBtn];
    }
    
}

@end
