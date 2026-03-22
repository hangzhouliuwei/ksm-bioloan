//
//  LLTabSelectView.m
//  king
//
//  Created by hao on 2023/9/4.
// 
//

#import "LLTabSelectView.h"

@interface LLTabSelectView ()
//基本属性
@property (nonatomic, copy) NSArray *titleArr;
@property (nonatomic, strong) NSMutableArray *btnArr;
@property (nonatomic, strong) UIView *line;
//可滑动属性
@property (nonatomic, assign) BOOL panFlag;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) CGFloat btnRight;

@end

@implementation LLTabSelectView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        self.btnArr = [NSMutableArray array];
        self.selectColor = ClearColor;
        self.unselectColor = ClearColor;
        self.selectTextColor = TextWhiteColor;
        self.unselectTextColor = TextGrayColor;
        self.fontValue = 14;
        self.showBottomLine = YES;
    }
    return self;
}

- (void)showTitles:(NSArray *)arr selectIndex:(NSInteger)index {
    self.titleArr = arr;
    [self loadUIselectIndex:index];
}

- (void)showTitles:(NSArray *)arr selectIndex:(NSInteger)index panFlag:(BOOL)panFlag {
    self.panFlag = panFlag;
    [self showTitles:arr selectIndex:index];
}

- (void)loadUIselectIndex:(NSInteger)index {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    if (self.showBottomLine) {
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 4, 40, 4)];
        [_line showRadius:2];
        _line.backgroundColor = MainColor;
        [_scrollView addSubview:_line];
    }
    
    if (self.panFlag) {
        CGFloat offsetX = 0;
        for (int i = 0; i < _titleArr.count; i++) {
            NSString *titleStr = _titleArr[i];
            CGSize size = [LLTools getSizeByString:titleStr fontValue:self.fontValue maxSize:CGSizeMake(ScreenWidth, 20)];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = i;
            btn.frame = CGRectMake(offsetX, 0, size.width + 30, self.height);
            btn.titleLabel.font = i==index ? FontBold(self.fontValue):Font(self.fontValue);
            [btn setTitle:_titleArr[i] forState:UIControlStateNormal];
            [btn setTitleColor:i==index ? self.selectTextColor : self.unselectTextColor forState:UIControlStateNormal];
            btn.backgroundColor = i==index ? self.selectColor : self.unselectColor;
            [btn addTarget:self action:@selector(clickClick:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:btn];
            [self.btnArr addObject:btn];
            offsetX = btn.right;
            _scrollView.contentSize = CGSizeMake(offsetX, self.height);
        }
    }else {
        CGFloat itemWidth = self.width/_titleArr.count;
        for (int i = 0; i < _titleArr.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = i;
            btn.frame = CGRectMake(i*itemWidth, 0, ([self.type isEqualToString:@"order"] && i == _titleArr.count - 1) ? itemWidth+12 : itemWidth, self.height);
            btn.titleLabel.font = i==index ? FontBold(self.fontValue):Font(self.fontValue);
            [btn setTitle:_titleArr[i] forState:UIControlStateNormal];
            [btn setTitleColor:i==index ? self.selectTextColor : self.unselectTextColor forState:UIControlStateNormal];
            btn.backgroundColor = i==index ? self.selectColor : self.unselectColor;
            [btn addTarget:self action:@selector(clickClick:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:btn];
            [self.btnArr addObject:btn];
        }
    }
    [self lineFrameTransfer:self.btnArr[index]];

}

- (void)clickClick:(UIButton *)btn {
    if (self.clickBlock) {
        self.clickBlock(btn.tag);
    }
    for (UIButton *tmpBtn in self.btnArr) {
        if (tmpBtn == btn) {
            [tmpBtn setTitleColor:self.selectTextColor forState:UIControlStateNormal];
            tmpBtn.backgroundColor = self.selectColor;
            tmpBtn.titleLabel.font = FontBold(self.fontValue);
            if (self.showBottomLine) {
                [UIView animateWithDuration:0.3 animations:^{
                    [self lineFrameTransfer:tmpBtn];
                }];
            }
        }else {
            [tmpBtn setTitleColor:self.unselectTextColor forState:UIControlStateNormal];
            tmpBtn.backgroundColor = self.unselectColor;
            tmpBtn.titleLabel.font = Font(self.fontValue);
        }
    }
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
    for (UIButton *tmpBtn in self.btnArr) {
        if (tmpBtn.tag == _selectIndex) {
            [tmpBtn setTitleColor:self.selectTextColor forState:UIControlStateNormal];
            tmpBtn.backgroundColor = self.selectColor;
            tmpBtn.titleLabel.font = FontBold(self.fontValue);
//            if (self.showBottomLine) {
//                [UIView animateWithDuration:0.3 animations:^{
//                    if (self.panFlag) {
//                        CGFloat offsetX = self.selectIndex*self.width/self.itemCount;
//                        if (offsetX > self.scrollView.contentSize.width - self.scrollView.width) {
//                            offsetX = self.scrollView.contentSize.width - self.scrollView.width;
//                        }
//                        self.scrollView.contentOffset = CGPointMake(offsetX, 0);
//                    }
//                    [self lineFrameTransfer:tmpBtn];
//                }];
//            }
        }else {
            [tmpBtn setTitleColor:self.unselectTextColor forState:UIControlStateNormal];
            tmpBtn.backgroundColor = self.unselectColor;
            tmpBtn.titleLabel.font = Font(self.fontValue);
        }
    }
}

- (void)lineFrameTransfer:(UIButton *)btn {
    CGSize size = [LLTools getSizeByString:btn.titleLabel.text fontValue:btn.titleLabel.font.pointSize maxSize:CGSizeMake(ScreenWidth, 20)];
    self.line.width = size.width;
    self.line.centerX = btn.centerX;
}

@end
