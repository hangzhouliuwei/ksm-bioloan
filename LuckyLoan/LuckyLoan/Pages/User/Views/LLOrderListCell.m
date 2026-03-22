//
//  LLOrderListCell.m
//  LuckyLoan
//
//  Created by hao on 2023/12/30.
//

#import "LLOrderListCell.h"

@interface LLOrderListCell ()
@property (nonatomic, strong) UIImageView *bgImage;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *status;
@property (nonatomic, strong) UILabel *amount;
@property (nonatomic, strong) UIView *infoBg;
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UIButton *tiedBtn;
@property (nonatomic, copy) NSDictionary *dic;
@end

@implementation LLOrderListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = BGColor;
        _bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth - 20, OrderListHeight)];
        _bgImage.userInteractionEnabled = YES;
        _bgImage.image = ImageWithName(@"img_order_cell_bg");
        [self.contentView addSubview:_bgImage];
        
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(32, 16, 24, 24)];
        [self.contentView addSubview:_icon];
        
        _name = [[UILabel alloc] initWithFrame:CGRectMake(_icon.right + 10, _icon.y, SafeWidth/2, _icon.height)];
        _name.textColor = UIColor.blackColor;
        _name.font = FontBold(14);
        _name.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_name];
        
        _status = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - SafeWidth/2 - 32, _icon.y, SafeWidth/2, _icon.height)];
        _status.textColor = MainColor;
        _status.font = Font(12);
        _status.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_status];

        
        UILabel *amountDesc = [[UILabel alloc] initWithFrame:CGRectMake(32, _icon.bottom + 12, ScreenWidth - 64, 48)];
        amountDesc.textColor = TextGrayColor;
        amountDesc.font = Font(14);
        amountDesc.text = @"Loan amount";
        amountDesc.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:amountDesc];
        [amountDesc addLine:LineTypeTop];
        
        _amount = [[UILabel alloc] initWithFrame:CGRectMake(32, _icon.bottom + 12, ScreenWidth - 64, 48)];
        _amount.textColor = UIColor.blackColor;
        _amount.font = FontBold(18);
        _amount.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_amount];
        
        _infoBg = [[UIView alloc] initWithFrame:CGRectMake(32, _amount.bottom, ScreenWidth - 64, 100)];
        _infoBg.backgroundColor = LineLightGrayColor;
        [self.contentView addSubview:_infoBg];

        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectBtn.frame = CGRectMake(ScreenWidth - 142, _infoBg.bottom + 16, 110, 30);
        _selectBtn.titleLabel.font = FontBold(12);
//        [_selectBtn addTarget:self action:@selector(selectAction) forControlEvents:UIControlEventTouchUpInside];
        [_selectBtn setTitleColor:TextWhiteColor forState:UIControlStateNormal];
        [_selectBtn showRadius:4];
        [self.contentView addSubview:_selectBtn];
        
        _tiedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _tiedBtn.userInteractionEnabled = NO;
        _tiedBtn.frame = CGRectMake(32, _infoBg.bottom + 16, ScreenWidth - 64, 58);
        [_tiedBtn setBackgroundImage:ImageWithName(@"img_repay_bg") forState:UIControlStateNormal];
        _tiedBtn.hidden = YES;
        [self.contentView addSubview:_tiedBtn];
    }
    return self;
}

- (void)loadData:(NSDictionary *)dic {
    _dic = dic;
    [_icon sd_setImageWithURL:URLEncode(dic[c_productLogo])];
    _name.text = dic[c_productName];
    _status.text = dic[c_buttonText];
    _status.textColor = MainColor;
    _amount.text = dic[c_orderAmount];
    NSArray *infoArr = @[@{@"title":@"Loan Duration", @"value":dic[c_term]}, @{@"title":@"Loan Date", @"value":dic[c_loanTime]}, @{@"title":@"Repayment Date", @"value":dic[c_repayTime]}];
    [self refreshInfoView:infoArr];
    _selectBtn.y = _infoBg.bottom + 16;
    _selectBtn.backgroundColor = MainColor;
    [_selectBtn setTitle:@"Borrow Again" forState:UIControlStateNormal];
    _selectBtn.hidden = NO;
    _bgImage.height = OrderListHeight;
    if (YES) {
        _selectBtn.hidden = YES;
        _tiedBtn.hidden = NO;
        _bgImage.height = OrderListHeight + 28;
        [_tiedBtn removeAllSubviews];
        NSDictionary *tiedDic = dic[c_re_bind];
        UILabel *tiedDesc = [[UILabel alloc] initWithFrame:CGRectMake(LeftMargin, 0, _tiedBtn.width - LeftMargin - 115, _tiedBtn.height)];
        tiedDesc.text = tiedDic[c_text];
        tiedDesc.numberOfLines = 2;
        tiedDesc.textColor = COLOR(255, 105, 50);
        tiedDesc.font = Font(12);
        [_tiedBtn addSubview:tiedDesc];
        
        UIButton *tied = [UIButton buttonWithType:UIButtonTypeCustom];
        tied.titleLabel.font = Font(12);
        tied.backgroundColor = COLOR(255, 105, 50);
        tied.frame = CGRectMake(_tiedBtn.width - 98, 14, 82, 30);
        [tied setTitle:tiedDic[c_btn] forState:UIControlStateNormal];
        [tied setTitleColor:TextWhiteColor forState:UIControlStateNormal];
//        [tied addTarget:self action:@selector(tiedAction) forControlEvents:UIControlEventTouchUpInside];
        [tied showRadius:4];
        [_tiedBtn addSubview:tied];
    }
}

- (void)refreshInfoView:(NSArray *)arr {
    [_infoBg removeAllSubviews];
    _infoBg.height = 100;
    for (int i = 0; i < arr.count; i++) {
        NSDictionary *dic = arr[i];
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(16, 11 + 26*i, _infoBg.width - 32, 26)];
        title.text = dic[@"title"];
        title.textColor = TextGrayColor;
        title.font = Font(14);
        title.textAlignment = NSTextAlignmentLeft;
        [_infoBg addSubview:title];
        
        UILabel *value = [[UILabel alloc] initWithFrame:CGRectMake(16, 11 + 26*i, _infoBg.width - 32, 26)];
        value.text = dic[@"value"];
        value.textColor = TextGrayColor;
        value.font = Font(14);
        value.textAlignment = NSTextAlignmentRight;
        [_infoBg addSubview:value];
    }
}

- (void)selectAction {
    if (self.selectBlock) {
        self.selectBlock();
    }
    NSString *url = _dic[c_loanDetailUrl];
    if (url.length >0) {
        [Page show:@"LLWebViewController" param:@{@"url":NotNull(url), @"navigationBarHidden":@(NO), @"title":@""}];
    }
}

- (void)tiedAction {
    NSString *url = _dic[c_loanDetailUrl];
    if (url.length >0) {
        [Page show:@"LLWebViewController" param:@{@"url":NotNull(url), @"navigationBarHidden":@(NO), @"title":@""}];
    }
}

+ (CGFloat)cellHeight:(NSDictionary *)dic {
    if (YES) {
        return OrderListHeight + 28;
    }else {
        return OrderListHeight;
    }
}

@end
