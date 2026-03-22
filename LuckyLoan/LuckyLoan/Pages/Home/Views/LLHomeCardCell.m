//
//  LLHomeCardCell.m
//  LuckyLoan
//
//  Created by hao on 2023/12/28.
//

#import "LLHomeCardCell.h"

@interface LLHomeCardCell ()
@property (nonatomic, strong) UIImageView *bgImage;
@property (nonatomic, strong) UIImageView *corner;
@property (nonatomic, strong) UILabel *cornerDesc;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *lead;
@property (nonatomic, strong) UILabel *value;
@property (nonatomic, strong) UILabel *desc;
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UIImageView *rank;
@end

@implementation LLHomeCardCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = BGColor;
        _bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(10*WScale, 0, ScreenWidth - 20*WScale, HomeCardHeight - 5*WScale)];
        _bgImage.userInteractionEnabled = YES;
        [self.contentView addSubview:_bgImage];
        
        _corner = [[UIImageView alloc] initWithFrame:CGRectMake(15*WScale, 3*WScale, 124*WScale, 24*WScale)];
        [self.contentView addSubview:_corner];
        
        _cornerDesc = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, _corner.width - 20, _corner.height)];
        _cornerDesc.textColor = TextWhiteColor;
        _cornerDesc.font = FontBold(10);
        _cornerDesc.textAlignment = NSTextAlignmentLeft;
        [_corner addSubview:_cornerDesc];
        
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(32*WScale, 36*WScale, 30*WScale, 30*WScale)];
        [self.contentView addSubview:_icon];
        
        _name = [[UILabel alloc] initWithFrame:CGRectMake(_icon.right + 10, _icon.y, 120*WScale, _icon.height)];
        _name.textColor = TextGrayColor;
        _name.font = Font(12);
        _name.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_name];
        
        _lead = [[UILabel alloc] initWithFrame:CGRectMake(_icon.x, _icon.bottom + 14*WScale, 24, 24)];
        _lead.textColor = UIColor.blackColor;
        _lead.font = Font(20);
        _lead.alpha = 0.6;
        _lead.textAlignment = NSTextAlignmentLeft;
//        [self.contentView addSubview:_lead];
        
        _value = [[UILabel alloc] initWithFrame:CGRectMake(_icon.x, _icon.bottom + 8*WScale, _name.width + 100, 30)];
        _value.textColor = UIColor.blackColor;
        _value.font = FontBold(30);
        _value.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_value];
        
        _desc = [[UILabel alloc] initWithFrame:CGRectMake(_icon.x, _value.bottom + 8*WScale, ScreenWidth - 64*WScale, 20)];
        _desc.textColor = TextLightGrayColor;
        _desc.font = Font(10);
        _desc.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_desc];
        
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectBtn.titleLabel.font = Font(16);
        _selectBtn.frame = CGRectMake(ScreenWidth - 176*WScale, _value.y - 5*WScale, 152*WScale, 40*WScale);
        [_selectBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_selectBtn addTarget:self action:@selector(selectAction) forControlEvents:UIControlEventTouchUpInside];
        [_selectBtn showRadius:8];
        _selectBtn.clipsToBounds = NO;
        [self.contentView addSubview:_selectBtn];
        
        _rank = [[UIImageView alloc] initWithFrame:CGRectMake(_selectBtn.width - 54*WScale, -25*WScale, 43*WScale, 58*WScale)];
        [_selectBtn addSubview:_rank];
    }
    return self;
}

- (void)loadData:(NSDictionary *)dic index:(NSInteger)index {
    NSString *bgImageStr = StrFormat(@"img_card_bg%@", @(index%7));
    _bgImage.image = ImageWithName(bgImageStr);
    _corner.image = ImageWithName(@"ic_card_corner");
    [_icon sd_setImageWithURL:URLEncode(dic[c_productLogo])];
    _name.text = dic[c_productName];
    _lead.text= @"₦:";
    _value.text = dic[c_amountRange];
    _desc.text = dic[c_amountRangeDes];
    if (index < 3) {
        _rank.image = ImageWithName(StrFormat(@"ic_top%@", @((index+1))));
        _selectBtn.y = _value.y - 5*WScale;
    }else {
        _selectBtn.centerY = HomeCardHeight/2;
    }
    [_selectBtn setTitle:dic[c_buttonText] forState:UIControlStateNormal];
    _selectBtn.backgroundColor = [LLTools colorWithHexString:dic[c_buttoncolor]];
    _cornerDesc.text = dic[c_productDesc];
}

- (void)selectAction {
    if (self.selectBlock) {
        self.selectBlock();
    }
}

@end
