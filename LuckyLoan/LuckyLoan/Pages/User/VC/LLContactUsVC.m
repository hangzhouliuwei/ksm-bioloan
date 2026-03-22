//
//  LLContactUsVC.m
//  LuckyLoan
//
//  Created by hao on 2024/1/2.
//

#import "LLContactUsVC.h"

@interface LLContactUsVC ()

@end

@implementation LLContactUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Contact Us";
}

- (void)loadView {
    [super loadView];
    [self loadData];
    [self loadUI];
}

- (void)loadData {
    
}

- (void)loadUI {
    [self addHeaderImage:@"img_user_header"];
    
    NSArray *dataArr = @[@{@"icon":@"ic_contact_tel", @"title":@"Telephone", @"desc":@"XXXXXXXX", @"action":@"telephoneAction"}, @{@"icon":@"ic_contact_whatsapp", @"title":@"WhatsApp", @"desc":@"XXXXXXXX", @"action":@"whatsAppAction"}, @{@"icon":@"ic_contact_email", @"title":@"Customer Service Email", @"desc":@"XXXXXXXX", @"action":@"emailAction"}];
    
    for (int i = 0; i < dataArr.count; i++) {
        NSDictionary *dic = dataArr[i];
        UIButton *item = [[UIButton alloc] initWithFrame:CGRectMake(8, 18 + 110*i, ScreenWidth - 16, 110)];
        [item setBackgroundImage:ImageWithName(@"img_contact_us_bg") forState:UIControlStateNormal];
        SEL selector = NSSelectorFromString(dic[@"action"]);
        if ([self respondsToSelector:selector]) {
            [item addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
        }
        [self.contentView addSubview:item];
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(24, 29, 48, 48)];
        image.image = ImageWithName(dic[@"AppIcon"]);
        [item addSubview:image];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(image.right + 16, image.y, 200, 24)];
        title.text = dic[@"title"];
        title.textColor = TextGrayColor;
        title.font = Font(14);
        title.textAlignment = NSTextAlignmentLeft;
        [item addSubview:title];
        
        UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(image.right + 16, title.bottom, 200, 24)];
        desc.text = dic[@"desc"];
        desc.textColor = UIColor.blackColor;
        desc.font = Font(14);
        desc.textAlignment = NSTextAlignmentLeft;
        [item addSubview:desc];
    }
}

- (void)telephoneAction {
    
}

- (void)whatsAppAction {
    
}

- (void)emailAction {
    
}

@end
