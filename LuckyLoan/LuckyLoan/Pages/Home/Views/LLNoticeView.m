//
//  LLNoticeView.m
//  LuckyLoan
//
//  Created by hao on 2023/12/28.
//

#import "LLNoticeView.h"

@interface LLNoticeView ()

@property (nonatomic, strong) UILabel *title;

@end

@implementation LLNoticeView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLORA(255, 255, 255, 0.5);
        self.hidden = YES;
        [self loadUI];
    }
    return self;
}

- (void)loadUI {
    UIButton *notice = [UIButton buttonWithType:UIButtonTypeCustom];
    notice.frame = CGRectMake(10, 0, self.height, self.height);
    [notice setImage:ImageWithName(@"ic_notice") forState:UIControlStateNormal];
    [self addSubview:notice];
    
    _title = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, self.width - 90, self.height)];
    _title.textColor = COLOR(255, 105, 50);
    _title.font = Font(12);
    _title.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_title];
    
    UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
    close.frame = CGRectMake(self.width - self.height - 10, 0, self.height, self.height);
    [close setImage:ImageWithName(@"ic_close_orange") forState:UIControlStateNormal];
    [close addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:close];
}

- (void)setNoticeTitle:(NSString *)title {
    _title.text = title;
}

- (void)closeBtnClick:(UIButton *)sender {
    if (self.closeBlock) {
        self.closeBlock();
    }
}

@end
