//
//  LLOrderListVC.m
//  LuckyLoan
//
//  Created by hao on 2023/12/29.
//

#import "LLOrderListVC.h"
#import "LLTabSelectView.h"
#import "LLOrderListCell.h"

@interface LLOrderListVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) LLTabSelectView *orderTab;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) BOOL isLoadMore;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *emptyView;
@property (nonatomic, strong) NSMutableArray *dataList;

@end

@implementation LLOrderListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Order";
}

- (void)loadView {
    [super loadView];
    [self addHeaderImage:@"img_user_header"];
    [self refreshList];
    [self loadUI];
}

- (void)loadUI {
    [self.view addSubview:self.orderTab];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.emptyView];
    self.emptyView.hidden = YES;
}

- (void)refreshUI {
    [self.tableView reloadData];
    if (self.dataList.count > 0) {
        self.emptyView.hidden = YES;
    }else {
        self.emptyView.hidden = NO;
    }
}

- (LLTabSelectView *)orderTab {
    if (!_orderTab) {
        _orderTab = [[LLTabSelectView alloc] initWithFrame:CGRectMake(0, NavigationBarHeight, ScreenWidth, 40)];
        _orderTab.selectTextColor = UIColor.blackColor;
        _orderTab.unselectTextColor = COLORA(0, 0, 0, 0.5);
        [_orderTab showTitles:@[@"To be repaid", @"All", @"No finished", @"Repaid"] selectIndex:_selectTabIndex panFlag:YES];
        kWeakself;
        _orderTab.clickBlock = ^(NSInteger index) {
            weakSelf.selectTabIndex = index;
            [weakSelf refreshList];
        };
    }
    return _orderTab;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _orderTab.bottom, ScreenWidth, self.view.height - _orderTab.bottom) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = ClearColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = OrderListHeight;
        _tableView.separatorColor = UIColor.clearColor;
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 0;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.1)];
        kWeakself;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf refreshList];
        }];
//        _tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
//            [self loadMoreList];
//        }];
    }
    return _tableView;
}

- (UIView*)emptyView {
    if(!_emptyView) {
        _emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, (ScreenHeight - ScreenWidth)/2, ScreenWidth, ScreenWidth)];
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(75*WScale, 0, 225*WScale, 144*WScale)];
        image.image = ImageWithName(@"img_empty");
        [_emptyView addSubview:image];
        
        LLBaseButton *applyBtn = [[LLBaseButton alloc] initWithFrame:CGRectMake(32, _emptyView.height - 42, ScreenWidth - 64, 42) title:@"APPLY NOW"];
        [applyBtn addTarget:self action:@selector(applyBtnClick) forControlEvents:UIControlEventTouchUpInside];
        applyBtn.type = BtnTypeNormal;
        [_emptyView addSubview:applyBtn];
    }
    return _emptyView;
}

- (void)applyBtnClick {
    [Page switchTabAt:0];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataList[indexPath.row];
    NSString *url = dic[c_loanDetailUrl];
    if (url.length >0) {
        [Page show:@"LLWebViewController" param:@{@"url":NotNull(url), @"navigationBarHidden":@(NO), @"title":@""}];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [LLOrderListCell cellHeight:self.dataList[indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"OrderListCell";
    LLOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[LLOrderListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = UIColor.clearColor;
    }
    NSDictionary *dic = self.dataList[indexPath.row];
    [cell loadData:dic];
    return cell;
}


- (void)refreshList {
    self.pageIndex = 1;
    self.isLoadMore = NO;
    [self requestOrderList];
}

//- (void)loadMoreList {
//    self.pageIndex = self.pageIndex + 1;
//    self.isLoadMore = YES;
//    [self loadRequest];
//}

- (void)requestOrderList {
    _orderType = @"4";// 状态 4全部 7进行中 6待还款 5已结清
    if (_selectTabIndex == 0) {
        _orderType = @"6";
    }else if (_selectTabIndex == 1) {
        _orderType = @"4";
    }else if (_selectTabIndex == 2) {
        _orderType = @"7";
    }else if (_selectTabIndex == 3) {
        _orderType = @"5";
    }
    
    NSDictionary *dic = @{
        c_orderType: _orderType,
        c_pageNum: @"1",
        c_pageSize: @"1000"
    };
    kWeakself;
    [Network postWithPath:path_orderList params:dic success:^(LLResponseModel *response) {
        if (response.success) {
            weakSelf.dataList = response.dataDic[c_list];
            [weakSelf refreshUI];
        }
        [weakSelf.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        NSLog(@"======faild!");
    }];
}


@end
