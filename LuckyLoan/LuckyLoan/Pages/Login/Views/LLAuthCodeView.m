//
//  LLPhoneInputView.h
//  LuckyLoan
//
//  Created by hao on 2023/12/21.
//

#import "LLAuthCodeView.h"
#import "LLCountDown.h"

@interface LLAuthCodeView ()

@property (nonatomic, strong) UIButton* sendBtn;

@end

@implementation LLAuthCodeView

- (id)initWithFrame:(CGRect)frame phone:(NSString *)phone {
    self = [super initWithFrame:frame];
    if (self) {
        if (![phone isEqualToString:App.status.didSendSmsPhone]) {
            [CountDown cancelCountDownWithType:CountDownTypeLogin];
        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countDownExecuting:) name:CountDownLoginNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countDownCompleted) name:CountDownLoginOverNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [self loadUI];
    }
    return self;
}

- (void)loadUI {
    _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendBtn.backgroundColor = UIColor.clearColor;
    _sendBtn.frame = self.bounds;
    _sendBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _sendBtn.titleLabel.font = Font(12);
    [_sendBtn setTitle:@"" forState:UIControlStateNormal];
    [_sendBtn setTitleColor:TextGrayColor forState:UIControlStateNormal];
    [_sendBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_sendBtn];
}

- (void)btnClick:(UIButton *)btn {
    if (self.clickBlock) {
        self.clickBlock();
    }
}

- (void)startCountDown {
    self.userInteractionEnabled = NO;
    [CountDown countDownWithType:CountDownTypeLogin];
}

- (void)appEnterBackground{
    UIApplication *app = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier bgTask;
    //申请一个几分钟的后台任务
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid){
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
}

#pragma mark - NSNotification 处理倒计时事件
- (void)countDownExecuting:(NSNotification *)notification {
    self.userInteractionEnabled = NO;
    NSInteger timeOut = [notification.object integerValue];
    [_sendBtn setTitle: [NSString stringWithFormat:@"%lds",(long)timeOut] forState:(UIControlStateNormal)];
    [_sendBtn setTitleColor:TextGrayColor forState:(UIControlStateNormal)];
}

- (void)countDownCompleted {
    self.userInteractionEnabled = YES;
    [_sendBtn setTitle:@"send" forState:(UIControlStateNormal)];
    [_sendBtn setTitleColor:MainColor forState:(UIControlStateNormal)];
}

- (void)dealloc {
    //页面销毁时，停止倒计时
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
