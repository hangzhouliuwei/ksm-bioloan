//
//  LLUserVC.m
//  LuckyLoan
//
//  Created by hao on 2023/12/21.
//

#import "LLUserVC.h"

@interface LLUserVC ()
@property (nonatomic, strong) UIView *userContent;
@property (nonatomic, copy) NSArray *itemList;
@property (nonatomic, assign) BOOL loginCancel;
@end

@implementation LLUserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestUserCenter) name:@"LoginSuccess" object:nil];
    kWeakself;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestUserCenter];
    }];
    self.contentView.mj_header = header;
    [self addHeaderImage:@"img_user_header"];
}

- (void)viewWillAppear:(BOOL)animated {
    if (!_loginCancel) {
        [self requestUserCenter];
    }
}

- (void)loadView {
    [super loadView];
    [self createUI];
}

- (NSString *)secretText:(NSString *)string {
    if (string.length >= 10) {
        NSString *lead = [string substringToIndex:3];
        NSString *end = [string substringFromIndex:string.length - 3];
        return StrFormat(@"%@*****%@", lead, end);
    }else {
        return NotNull(string);
    }
}

- (void)createUI {
    
    [_userContent removeAllSubviews];
    [_userContent removeFromSuperview];
    _userContent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.contentView addSubview:_userContent];
    
    UIButton *headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    headerBtn.frame = CGRectMake(24*WScale, StatusBarHeight + 20*WScale, 78*WScale, 78*WScale);
    [headerBtn setBackgroundImage:ImageWithName(@"ic_header_default") forState:UIControlStateNormal];
    [headerBtn addTarget:self action:@selector(headerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.userContent addSubview:headerBtn];
    
    UILabel *tel = [[UILabel alloc] initWithFrame:CGRectMake(headerBtn.right + 8, headerBtn.y, 200, headerBtn.height)];
    tel.text = [self secretText:App.user.userName];
    tel.textColor = TextBlackColor;
    tel.font = FontBold(18);
    [self.userContent addSubview:tel];
    
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(LeftMargin, headerBtn.bottom + 10, SafeWidth, 173*WScale + 56*_itemList.count)];
    bg.userInteractionEnabled = YES;
    [bg setBorderShadow:COLOR(219, 237, 231)];
    [self.userContent addSubview:bg];
    
    self.userContent.height = bg.bottom;
    [self.contentView setSizeFit:self.userContent];

    
    UIButton *borrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    borrowBtn.tag = 0;
    borrowBtn.frame = CGRectMake(16*WScale, 34*WScale, 153*WScale, 76*WScale);
    [borrowBtn setBackgroundImage:ImageWithName(@"ic_borrow") forState:UIControlStateNormal];
    [borrowBtn addTarget:self action:@selector(orderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:borrowBtn];
    
    UIButton *corner = [UIButton buttonWithType:UIButtonTypeCustom];
    corner.frame = CGRectMake(39*WScale, 0, borrowBtn.width - 39*WScale, 16*WScale);
    corner.titleLabel.font = Font(8);
    [corner setTitle:@"Interest ≧0.70%/day" forState:UIControlStateNormal];
    [corner setTitleColor:TextWhiteColor forState:UIControlStateNormal];
    [corner setBackgroundImage:ImageWithName(@"ic_borrow_corner") forState:UIControlStateNormal];
    [borrowBtn addSubview:corner];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(63*WScale, 44*WScale, borrowBtn.width - 63*WScale, 32*WScale)];
    title.text = @"To be repaid";
    title.textColor = TextGrayColor;
    title.font = Font(12);
    title.textAlignment = NSTextAlignmentCenter;
    [borrowBtn addSubview:title];
    
    UIButton *notFinishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    notFinishBtn.tag = 1;
    notFinishBtn.frame = CGRectMake(borrowBtn.right + 5*WScale, 34*WScale, 74*WScale, 76*WScale);
    [notFinishBtn setBackgroundImage:ImageWithName(@"ic_not_finished") forState:UIControlStateNormal];
    [notFinishBtn addTarget:self action:@selector(orderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:notFinishBtn];
    
    title = [[UILabel alloc] initWithFrame:CGRectMake(0, 44*WScale, notFinishBtn.width, 32*WScale)];
    title.text = @"Not finished";
    title.textColor = TextGrayColor;
    title.font = Font(12);
    title.textAlignment = NSTextAlignmentCenter;
    [notFinishBtn addSubview:title];
    
    UIButton *repaidBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    repaidBtn.tag = 2;
    repaidBtn.frame = CGRectMake(notFinishBtn.right + 5*WScale, 34*WScale, 74*WScale, 76*WScale);
    [repaidBtn setBackgroundImage:ImageWithName(@"ic_repaid") forState:UIControlStateNormal];
    [repaidBtn addTarget:self action:@selector(orderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:repaidBtn];
    
    title = [[UILabel alloc] initWithFrame:CGRectMake(0, 44*WScale, notFinishBtn.width, 32*WScale)];
    title.text = @"Repaid";
    title.textColor = TextGrayColor;
    title.font = Font(12);
    title.textAlignment = NSTextAlignmentCenter;
    [repaidBtn addSubview:title];
    
    NSDictionary *descDic = @{@"customer_service_center":@"You can contact us anytime", @"contac_us":@"Working hours:9:00am-6:00pm", @"privacy_agreement":@"", @"set_up":@""};
    NSDictionary *iconDic = @{@"customer_service_center":@"ic_question", @"contac_us":@"ic_contact_us", @"privacy_agreement":@"ic_private", @"set_up":@"ic_setting"};

    NSMutableArray *itemArr = [NSMutableArray array];
    for (int i = 0; i < _itemList.count; i++) {
        NSDictionary *tmp = _itemList[i];
        NSString *title = tmp[c_title];
        NSString *link = tmp[c_linkUrl];
        NSString *key = tmp[c_key];
        NSString *desc = descDic[key];
        NSString *icon = iconDic[key];
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"title":NotNull(title), @"desc":NotNull(desc), @"image":NotNull(icon), @"link":NotNull(link), @"key": NotNull(key)}];
        [itemArr addObject:dic];
    }
    _itemList = itemArr;
    for (int i = 0; i < _itemList.count; i++) {
        NSDictionary *dic = _itemList[i];
        UIButton *item = [[UIButton alloc] initWithFrame:CGRectMake(0, repaidBtn.bottom + 36*WScale + 56*WScale*i, bg.width, 56*WScale)];
        item.tag = i;
        [item addTarget:self action:@selector(itemAction:) forControlEvents:UIControlEventTouchUpInside];
        [bg addSubview:item];
        
        UIButton *leadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leadBtn.frame = CGRectMake(16, 13, 30, 30);
        [leadBtn setImage:ImageWithName(dic[@"image"]) forState:UIControlStateNormal];
        [item addSubview:leadBtn];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(leadBtn.right + 10*WScale, 20*WScale, bg.width - 72*WScale, 16*WScale)];
        title.text = dic[@"title"];
        title.textColor = TextGrayColor;
        title.font = Font(14);
        title.textAlignment = NSTextAlignmentLeft;
        [item addSubview:title];
        
        NSString *desc = dic[@"desc"];
        if (![LLTools isBlankString:desc]) {
            title.y = 11*WScale;
            UILabel *value = [[UILabel alloc] initWithFrame:CGRectMake(title.x, title.bottom + 0, bg.width - 72*WScale, 24*WScale)];
            value.text = desc;
            value.textColor = TextLightGrayColor;
            value.font = Font(12);
            value.textAlignment = NSTextAlignmentLeft;
            [item addSubview:value];
        }
    }
}

- (void)headerBtnClick {
    if (!App.user.isLogin) {
        [Login login:^(BOOL value) {
        }];
    }
}

- (void)orderBtnClick:(UIButton *)sedner {
    if (!App.user.isLogin) {
        [Login login:^(BOOL value) {
        }];
        return;
    }
    NSInteger tabIndex = 0;
    NSString *orderType = @"4";// 状态 4全部 7进行中 6待还款 5已结清
    if (sedner.tag == 0) {
        tabIndex = 0;
        orderType = @"6";
    }else if (sedner.tag == 1) {
        tabIndex = 2;
        orderType = @"7";
    }else if (sedner.tag == 2) {
        tabIndex = 3;
        orderType = @"6";
    }
    [Page show:@"LLOrderListVC" param:@{@"selectTabIndex":@(tabIndex), @"orderType":orderType}];
}

- (void)itemAction:(UIButton *)sender {
    [LLTools showHud];
    if (!App.user.isLogin) {
        [Login login:^(BOOL value) {
        }];
        return;
    }
    NSDictionary *dic = _itemList[sender.tag];
    NSString *link = dic[@"link"];
    NSString *key = dic[@"key"];
    NSString *title = dic[@"title"];
    if ([key isEqualToString:@"set_up"]) {
        [Page show:@"LLSetUpVC"];
    }else {
        [Page show:@"LLWebViewController" param:@{@"url":NotNull(link), @"navigationBarHidden":@(NO), @"title":NotNull(title)}];
    }
    [LLTools hideHud];
}

- (void)requestUserCenter {
    kWeakself;
    [Network getWithPath:path_userCenter params:nil success:^(LLResponseModel *response) {
        if (response.success) {
            weakSelf.itemList = response.dataDic[c_extendLists];
            [weakSelf createUI];
        }else {
            if ([response.code isEqualToString:@"-2"]) {
                if (!App.user.isLogin) {
                    [Login login:^(BOOL value) {
                        weakSelf.loginCancel = YES;
                    }];
                }
            }
        }
        [weakSelf.contentView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [weakSelf.contentView.mj_header endRefreshing];
    }];
}

@end
