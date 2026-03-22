//
//  LLSetUpVC.m
//  LuckyLoan
//
//  Created by hao on 2024/1/2.
//

#import "LLSetUpVC.h"
#import "LLNormalAlert.h"
#import "LLDeviceInfo.h"

@interface LLSetUpVC ()
@property (nonatomic, strong) LLNormalAlert *alert;
@end

@implementation LLSetUpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Set Up";
}

- (void)loadView {
    [super loadView];
    [self loadUI];
}

- (void)loadUI {
    [self addHeaderImage:@"img_user_header"];
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/2 - 50, 35, 100, 100)];
    logo.image = ImageWithName(@"AppIcon");
    [logo showRadius:20];
    [self.contentView addSubview:logo];
    
    UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(LeftMargin, logo.bottom + 10, SafeWidth, 30)];
    desc.text = @"CashHop";
    desc.textColor = TextBlackColor;
    desc.font = Font(20);
    desc.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:desc];
    
    NSArray *dataArr = @[@{@"title":@"Websit", @"desc":@"cashhops.com", @"action":@"selectAction1"}, @{@"title":@"Email", @"desc":@"CASHHOP@outlook.com", @"action":@"selectAction2"}, @{@"title":@"Edition", @"desc":NotNull([LLDeviceInfo version]), @"action":@"selectAction3"}];
    
    UIImageView *itemBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, desc.bottom + 40, ScreenWidth - 20, dataArr.count * 50)];
    itemBg.image = ImageWithName(@"img_set_bg");
    itemBg.userInteractionEnabled = YES;
    [self.contentView addSubview:itemBg];
    
    for (int i = 0; i < dataArr.count; i++) {
        NSDictionary *dic = dataArr[i];
        UIButton *item = [[UIButton alloc] initWithFrame:CGRectMake(22, 50*i, itemBg.width - 44, 50)];
        SEL selector = NSSelectorFromString(dic[@"action"]);
        if ([self respondsToSelector:selector]) {
            [item addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
        }
        [itemBg addSubview:item];
        if (i < dataArr.count - 1) {
            [item addLine:LineTypeBottom];
        }
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, item.width, item.height)];
        title.text = dic[@"title"];
        title.textColor = TextBlackColor;
        title.font = Font(14);
        title.textAlignment = NSTextAlignmentLeft;
        [item addSubview:title];
        
        UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, item.width, item.height)];
        desc.text = dic[@"desc"];
        desc.textColor = TextGrayColor;
        desc.font = Font(14);
        desc.textAlignment = NSTextAlignmentRight;
        [item addSubview:desc];
    }
    
    LLBaseButton *logoutBtn = [[LLBaseButton alloc] initWithFrame:CGRectMake(32, itemBg.bottom + 50, ScreenWidth - 64, 42) title:@"Log Out"];
    [logoutBtn addTarget:self action:@selector(logoutBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    logoutBtn.type = BtnTypeNormal;
    [self.contentView addSubview:logoutBtn];
    
    LLBaseButton *calcelBtn = [[LLBaseButton alloc] initWithFrame:CGRectMake(32, logoutBtn.bottom + 16, ScreenWidth - 64, 42) title:@"Cancel Account"];
    [calcelBtn addTarget:self action:@selector(cancelAccountBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    calcelBtn.type = BtnTypeBorder;
    [self.contentView addSubview:calcelBtn];
    
}

- (void)selectAction1 {
    
}

- (void)selectAction2 {
    
}

- (void)selectAction3 {
    
}

- (void)logoutConfirmAction {
    [_alert hide];
    [self requestQuit];
}

- (void)cancelAccountConfirmAction {
    [_alert hide];
    [self requestQuit];
}

- (void)clearAction {
    [Network clearHttpHeaders];
    [Page showRootAnimated:NO];
    [Page switchTabAt:0];
}

- (void)cancelAction {
    [_alert hide];
}

- (void)logoutBtnClick:(UIButton *)sender {
    SEL selector = NSSelectorFromString(@"logoutConfirmAction");
    [self showAlert:@"Are you sure want to leave the software?" selector:selector];
}

- (void)cancelAccountBtnClick:(UIButton *)sender {
    SEL selector = NSSelectorFromString(@"cancelAccountConfirmAction");
    [self showAlert:@"Are you sure want to Cancel Account?" selector:selector];
}

- (void)showAlert:(NSString *)title selector:(SEL)selector {
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(LeftMargin, ScreenHeight/2 - 184/2, SafeWidth, 184)];
    image.userInteractionEnabled = YES;
    image.image = ImageWithName(@"img_alert_bg");
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, image.width, 40)];
    label.text = title;
    label.textColor = TextBlackColor;
    label.font = Font(16);
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    [image addSubview:label];
    
    LLBaseButton *confirmBtn = [[LLBaseButton alloc] initWithFrame:CGRectMake(LeftMargin, image.height - 82, 108, 42) title:@"Confirm"];
    [confirmBtn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    confirmBtn.type = BtnTypeGray;
    [image addSubview:confirmBtn];
    
    LLBaseButton *cancelBtn = [[LLBaseButton alloc] initWithFrame:CGRectMake(confirmBtn.right + 10, image.height - 82, image.width - confirmBtn.right - 26, 42) title:@"Cancel"];
    [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.type = BtnTypeGreen;
    [image addSubview:cancelBtn];
    
    _alert = [[LLNormalAlert alloc] initWithCustomView:image];
    [_alert show];
}

- (void)requestQuit {
    kWeakself;
    [Network postWithPath:path_logout params:nil success:^(LLResponseModel *response) {
        if (response.success) {
            [weakSelf clearAction];
        }
    } failure:^(NSError *error) {
        NSLog(@"======faild!");
    }];
}


@end
