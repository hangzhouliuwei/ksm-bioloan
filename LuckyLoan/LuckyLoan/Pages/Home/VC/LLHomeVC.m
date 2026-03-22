//
//  LLHomeVC.m
//  LuckyLoan
//
//  Created by hao on 2023/12/21.
//

#import "LLHomeVC.h"
#import "LLHomeCardView.h"
#import "LLAdvantageView.h"
#import "LLNoticeView.h"
#import "LLHomeCardCell.h"
#import "JYBanner.h"
#import "LLSmallCardView.h"
#import "LLRepayCardView.h"
//#import "LLOpenAlert.h"
#import "LLServiceView.h"
#import "LLAccessAlert.h"
#import <Contacts/Contacts.h>

@interface LLHomeVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *cardContent;
@property (nonatomic, strong) UIView *creditContent;
@property (nonatomic, strong) LLHomeCardView *cardView;
@property (nonatomic, strong) LLAdvantageView *advantageView;
@property (nonatomic, strong) JYBanner *banner;
@property (nonatomic, strong) LLNoticeView *noticeView;
@property (nonatomic, strong) LLSmallCardView *smallCardView;
@property (nonatomic, strong) LLRepayCardView *repayCardView;
@property (nonatomic, strong) LLServiceView *serviceView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *productList;
@property (nonatomic, strong) NSMutableArray *bannerList;
@property (nonatomic, strong) NSDictionary *bigCardDic;
@property (nonatomic, strong) NSDictionary *smallCardDic;
@property (nonatomic, strong) NSDictionary *lanternDic;
@property (nonatomic, strong) NSDictionary *repayDic;
@property (nonatomic, strong) NSDictionary *homeDic;
@property (nonatomic, strong) NSDictionary *applyInfo;
@property (nonatomic, assign) BOOL noticeHidden;
@property (nonatomic, assign) BOOL isBlock;
@end

@implementation LLHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestHomeData) name:@"NetworkStatusChanged" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestHomeData) name:@"LoginSuccess" object:nil];
    kWeakself;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestHomeData];
        [weakSelf loadCityList];
    }];
//    [header setTitle:@"refresh" forState:MJRefreshStatePulling];
//    [header setTitle:@"refresh" forState:MJRefreshStateRefreshing];
//    header.lastUpdatedTimeLabel.hidden = YES;
    self.contentView.mj_header = header;
    [self loadCityList];
//    [self loadOpenAlert];
}

- (void)viewWillAppear:(BOOL)animated {
    [self requestHomeData];
}

- (void)requestHomeData {
    kWeakself;
    self.bigCardDic = nil;
    self.smallCardDic = nil;
    self.bannerList = nil;
    self.lanternDic = nil;
    self.productList = nil;
    [Network getWithPath:path_home params:nil success:^(LLResponseModel *response) {
        [weakSelf.contentView.mj_header endRefreshing];
        if (response.success) {
            weakSelf.homeDic = response.dataDic;
            NSArray *list = response.dataDic[c_list];
            for (NSDictionary *dic in list) {
                if ([dic[c_type] isEqualToString:c_LARGE_CARD]) {
                    weakSelf.bigCardDic = dic[c_item];
                }
                if ([dic[c_type] isEqualToString:c_SMALL_CARD]) {
                    weakSelf.smallCardDic = dic[c_item];
                }
                if ([dic[c_type] isEqualToString:c_BANNER]) {
                    weakSelf.bannerList = dic[c_item];
                }
                if ([dic[c_type] isEqualToString:c_RIDING_LANTERN]) {
                    weakSelf.lanternDic = dic[c_item];
                }
                if ([dic[c_type] isEqualToString:c_PRODUCT_LIST]) {
                    weakSelf.productList = dic[c_item];
                }
            }
            if (weakSelf.bigCardDic.allKeys.count > 0) {
                [self createBigCardUI];
            }else {
                [self createCreditUI];
            }
        }else {
            NSLog(@"======%@",response.desc);
        }
        
    } failure:^(NSError *error) {
        [weakSelf.contentView.mj_header endRefreshing];
    }];
}

- (void)loadCityList {
    [Network getWithPath:path_cityList params:nil success:^(LLResponseModel *response) {
        if (response.success) {
//            App.config.cityList = response.dataArr;
        }else {
        }
        
    } failure:^(NSError *error) {
        [LLTools showToast:@"Network error!"];
    }];
}

//- (void)loadOpenAlert {
//    if (!App.user.isLogin) {
//        return;
//    }
//    kWeakself;
//    [Network getWithPath:path_openAlert params:nil success:^(ResponseModel *response) {
//        if (response.success) {
//            NSString *imgUrl = response.dataDic[c_imgUrl];
//            NSString *jumpUrl = response.dataDic[c_url];
//            [weakSelf openAlert:imgUrl jump:jumpUrl];
//        }
//    } failure:^(NSError *error) {
//    }];
//}
//
//- (void)loadRepayData {
//    kWeakself;
//    [Network getWithPath:path_repay params:nil success:^(ResponseModel *response) {
//        if (response.success) {
//            weakSelf.repayDic = response.dataDic[c_item];
//
//        }
//    } failure:^(NSError *error) {
//        
//    }];
//}


//- (void)openAlert:(NSString *)imgUrl jump:(NSString *)jumpUrl {
//    if ([imgUrl containsString:@"http"]) {
//        LLOpenAlert *alert = [[LLOpenAlert alloc] initWithImage:imgUrl];
//        alert.selectBlock = ^{
//            if ([jumpUrl containsString:@"http"]) {
//                [Page show:@"LLWebViewController" param:@{@"url":NotNull(jumpUrl), @"title":@""}];
//            }
//        };
//        [alert show];
//    }
//}

- (void)createBigCardUI {
    _creditContent.hidden = YES;
    _cardContent.hidden = NO;
    [_cardContent removeAllSubviews];
    [_creditContent removeFromSuperview];
    [_cardContent removeFromSuperview];
    _cardContent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.contentView addSubview:_cardContent];
    
    [self addGradient:@[COLOR(229, 243, 239), UIColor.whiteColor] start:CGPointMake(0, 0) end:CGPointMake(0, 1)];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(LeftMargin, StatusBarHeight, SafeWidth, 44)];
    title.text = @"CashHop";
    title.textColor = TextBlackColor;
    title.font = FontBold(20);
    title.textAlignment = NSTextAlignmentLeft;
    [self.cardContent addSubview:title];
    
    kWeakself;
    [_serviceView removeFromSuperview];
    _serviceView = [[LLServiceView alloc] initWithFrame:CGRectMake(ScreenWidth - 56, StatusBarHeight - 6, 56, 56) image:@"ic_tel"];
    _serviceView.clickBlock = ^{
        [weakSelf telAction];
    };
    [self.view addSubview:_serviceView];
    
    
    _banner = [[JYBanner alloc] initWithFrame:CGRectMake(LeftMargin, NavigationBarHeight, SafeWidth, 143*WScale) configBlock:^JYConfiguration *(JYConfiguration *carouselConfig) {
        carouselConfig.pageContollType = NonePageControl;
        carouselConfig.interValTime = 0;
        return carouselConfig;
    } clickBlock:^(NSInteger index) {
        [weakSelf clickBannerAt:index];
    }];
    [_banner showRadius:8];
    [self.cardContent addSubview:_banner];
    NSMutableArray *imageUrlList = [NSMutableArray array];
    for (NSDictionary *dic in self.bannerList) {
        [imageUrlList addObject:NotNull(dic[c_imgUrl])];
    }
    [_banner startCarouselWithArray:imageUrlList];
    
    _cardView = [[LLHomeCardView alloc] initWithFrame:CGRectMake(LeftMargin, _banner.bottom + 16, SafeWidth, 202*WScale) data:self.bigCardDic];
    _cardView.applyBlock = ^{
        weakSelf.applyInfo = weakSelf.bigCardDic;
        [weakSelf applyProduct];
    };
    [self.cardContent addSubview:_cardView];
    
    _advantageView = [[LLAdvantageView alloc] initWithFrame:CGRectMake(LeftMargin, _cardView.bottom + 12, SafeWidth, 0) data:self.bigCardDic];
    [self.cardContent addSubview:_advantageView];
    
    self.cardContent.height = _advantageView.bottom;
    [self.contentView setSizeFit:self.cardContent];
}

- (void)createCreditUI {
    [_creditContent removeAllSubviews];
    [_cardContent removeFromSuperview];
    [_creditContent removeFromSuperview];
    _creditContent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.contentView addSubview:_creditContent];
    
//    [self addHeaderImage:@"img_home_header"];
    kWeakself;
    _banner = [[JYBanner alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 243*WScale) configBlock:^JYConfiguration *(JYConfiguration *carouselConfig) {
        carouselConfig.pageContollType = NonePageControl;
        carouselConfig.interValTime = 0;
        return carouselConfig;
    } clickBlock:^(NSInteger index) {
        [weakSelf clickBannerAt:index];
    }];
    [_creditContent addSubview:_banner];
    NSMutableArray *imageUrlList = [NSMutableArray array];
    for (NSDictionary *dic in self.bannerList) {
        [imageUrlList addObject:NotNull(dic[c_imgUrl])];
    }
    [_banner startCarouselWithArray:imageUrlList];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(LeftMargin, StatusBarHeight, SafeWidth, 44)];
    title.text = @"CashHop";
    title.textColor = TextBlackColor;
    title.font = FontBold(20);
    title.textAlignment = NSTextAlignmentLeft;
    [self.creditContent addSubview:title];
    
    [_serviceView removeFromSuperview];
    _serviceView = [[LLServiceView alloc] initWithFrame:CGRectMake(ScreenWidth - 56, StatusBarHeight - 6, 56, 56) image:@"ic_tel_white"];
    _serviceView.clickBlock = ^{
        [weakSelf telAction];
    };
    [self.view addSubview:_serviceView];
    
    _noticeView = [[LLNoticeView alloc] initWithFrame:CGRectMake(0, _banner.height - 88*WScale, ScreenWidth, 30)];
    _noticeView.hidden = _noticeHidden;
    _noticeView.closeBlock = ^{
        weakSelf.noticeHidden = YES;
        weakSelf.noticeView.hidden = YES;
    };
    [_noticeView setNoticeTitle:@"unable to determine interface type without an established connection"];
    [self.banner addSubview:_noticeView];
    
    CGFloat offsetY = _banner.height - 42*WScale;
    if (self.smallCardDic.allKeys.count > 0) {
        _smallCardView = [[LLSmallCardView alloc] initWithFrame:CGRectMake(LeftMargin, _banner.height - 42*WScale, SafeWidth, 151*WScale) data:self.smallCardDic];
        _smallCardView.applyBlock = ^{
            weakSelf.applyInfo = weakSelf.smallCardDic;
            [weakSelf applyProduct];
        };
        [self.creditContent addSubview:_smallCardView];
        
        offsetY = _smallCardView.bottom + 16;
    }
    
//    if (self.repayDic.allKeys.count > 0) {
//        _repayCardView = [[LLRepayCardView alloc] initWithFrame:CGRectMake(LeftMargin, offsetY, SafeWidth, 72*WScale) data:self.repayDic];
//        _repayCardView.repayBlock = ^{
//            [weakSelf repayAction];
//        };
//        [self.creditContent addSubview:_repayCardView];
//        offsetY = _repayCardView.bottom + 16;
//    }
    self.tableView.y = offsetY;
    self.tableView.height = HomeCardHeight*self.productList.count;
    [self.tableView reloadData];
    [self.creditContent addSubview:self.tableView];
    
    self.creditContent.height = self.tableView.bottom;
    [self.contentView setSizeFit:self.creditContent];

}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _banner.bottom, ScreenWidth, self.contentView.height - _smallCardView.bottom) style:UITableViewStyleGrouped];
        _tableView.scrollEnabled = NO;
        _tableView.backgroundColor = BGColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = HomeCardHeight;
        _tableView.separatorColor = UIColor.clearColor;
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 0;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.1)];
    }
    return _tableView;
}

- (void)applyProduct {
    if (!App.user.isLogin) {
        [Login login:^(BOOL value) {
        }];
        return;
    }
    if (_isBlock) {
        return;
    }
    if ([App.user.appstoreAccount isEqualToString:@"1"]) {
        [self checkLoanStatus];
        return;
    }
    [self updateBlockState];
    [self checkContactsAuth];
}

- (void)checkContactsAuth {
    CNContactStore *store = [[CNContactStore alloc] init];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (error) {
            [self showContactAlert];
            return;
        }
        
        if (granted) {
            [self checkLoctionAuth];
        } else {
            [self showContactAlert];
        }
    }];
}

- (void)showContactAlert {
    LLAccessAlert *alert = [[LLAccessAlert alloc] initWithIcon:@"ic_no_access" content:@"Please provide manual access CashHop"];
    alert.confirmBlock = ^{
        [LLTools jumpSystemSetting];
    };
    [alert show];
}

- (void)checkLoctionAuth {
    [DataPoint updateUserInfo:^(BOOL value) {
        if (value) {
            [self checkLoanStatus];
        }
    }];
}

- (void)updateBlockState {
    _isBlock = YES;
    [self performSelector:@selector(endBlock) withObject:nil afterDelay:1];
}

- (void)endBlock {
    _isBlock = NO;
}

- (void)checkLoanStatus {
    NSString *produtId = [_applyInfo[c_id] stringValue];
    NSDictionary *dic = @{
        c_product_id: NotNull(produtId),//产品id
        @"whapper_now": @"cakestand",//干扰字段 (cakestand)
    };
    kWeakself;
    [Network postWithPath:path_productApply params:dic success:^(LLResponseModel *response) {
        if (response.success) {
            [weakSelf checkStatus:response.dataDic produtId:produtId];
        }
    } failure:^(NSError *error) {
    } showLoading:YES];
}


- (void)checkStatus:(NSDictionary *)dic produtId:(NSString *)produtId {
    
    NSString *url = dic[c_url];
    if ([url containsString:@"http"]) {
        NSString *urlStr = StrFormat(@"%@", url);
        [Page show:@"LLWebViewController" param:@{@"url":urlStr, @"navigationBarHidden":@(NO), @"title":@""}];
        return;
    }
    [Page show:@"LLApplyInfoVC" param:@{@"productId":NotNull(produtId)}];

}

- (void)clickBannerAt:(NSInteger)index {
    if (!App.user.isLogin) {
        [Login login:^(BOOL value) {
        }];
        return;
    }
    NSDictionary *dic = self.bannerList[index];
    NSString *url = dic[c_url];
    if (url.length > 0) {
        [Page show:@"LLWebViewController" param:@{@"url":NotNull(dic[c_url]), @"navigationBarHidden":@(NO), @"title":@""}];
    }
}

- (void)telAction {
    [LLTools showHud];
    if (!App.user.isLogin) {
        [Login login:^(BOOL value) {
        }];
        return;
    }
    NSString *url = self.homeDic[c_icon][c_linkUrl];
    [Page show:@"LLWebViewController" param:@{@"url":url, @"title":@""}];
    [LLTools hideHud];
}

//- (void)repayAction {
//    if (!App.user.isLogin) {
//        [Login login:^(BOOL value) {
//        }];
//        return;
//    }
//    NSString *url = self.repayDic[c_url];
//    [Page show:@"LLWebViewController" param:@{@"url":NotNull(url), @"navigationBarHidden":@(NO), @"title":@""}];
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.productList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"HomeCardCell";
    LLHomeCardCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[LLHomeCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = UIColor.clearColor;
    }
    NSDictionary *dic = self.productList[indexPath.row];
    kWeakself;
    cell.selectBlock = ^{
        weakSelf.applyInfo = dic;
        [weakSelf applyProduct];
    };
    [cell loadData:dic index:indexPath.row];
    return cell;
}

@end
