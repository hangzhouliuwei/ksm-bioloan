//
//  LLNavigationBar.m
//  king
//
//  Created by hao on 2023/9/4.
// 
//

#import "LLNavigationBar.h"

@implementation LLNavigationBar

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = ClearColor;
        [self loadUI];
    }
    return self;
}

- (void)loadUI {
    self.leftBtn.hidden = NO;
}

- (UIButton *)leftBtn {
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.frame = CGRectMake(0, StatusBarHeight, 48, 44);
        _leftBtn.titleLabel.font = Font(14);
        [_leftBtn setTitle:@"" forState:UIControlStateNormal];
        [_leftBtn setTitleColor:TextWhiteColor forState:UIControlStateNormal];
        [_leftBtn setImage:ImageWithName(@"ic_back") forState:UIControlStateNormal];
        [_leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_leftBtn];
    }
    return _leftBtn;
}

- (UILabel *)midView {
    if (!_midView) {
        _midView = [[UILabel alloc] initWithFrame:CGRectMake(LeftMargin + 44, StatusBarHeight, SafeWidth - 44*2, 44)];
        _midView.textColor = TextBlackColor;
        _midView.font = FontBold(20);
        _midView.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_midView];
    }
    return _midView;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _rightBtn.frame = CGRectMake(ScreenWidth - LeftMargin - 80, StatusBarHeight, 80, 44);
        _rightBtn.titleLabel.font = Font(15);
        [_rightBtn setTitleColor:TextWhiteColor forState:UIControlStateNormal];
        [_rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 80 - 44, 0, 0)];
        [_rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rightBtn];
    }
    return _rightBtn;
}

- (void)leftBtnClick:(UIButton *)btn {
    if (self.leftBtnClick) {
        self.leftBtnClick();
    }
}

- (void)rightBtnClick:(UIButton *)btn {
    if (self.rightBtnClick) {
        self.rightBtnClick();
    }
}

- (void)hideLeftBtn {
    _leftBtn.hidden = YES;
}

- (void)showLeftBtn {
    _leftBtn.hidden = NO;
}

- (void)hideRightBtn {
    _rightBtn.hidden = YES;
}

- (void)showRightBtn {
    _rightBtn.hidden = NO;
}

@end
