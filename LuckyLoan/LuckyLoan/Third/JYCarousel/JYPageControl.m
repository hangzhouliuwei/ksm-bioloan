//
//  JYPageControl.m
//  JYBanner
//
//  Created by Dely on 16/11/16.
//  Copyright © 2016年 Dely. All rights reserved.
//

#import "JYPageControl.h"

//pageControl边距
static CGFloat pageControlMagin = 20.0;

@interface JYPageControl ()

@property (nonatomic, strong) JYConfiguration *config;
@property (nonatomic, assign) CGRect superViewFrame;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UILabel *pageLabel;
@property (nonatomic, assign) NSInteger numberOfPages;

@end


@implementation JYPageControl

- (void)initViewWithNumberOfPages:(NSInteger)numberOfPages configuration:(JYConfiguration *)config addInView:(UIView *)superView{
    
    self.numberOfPages = numberOfPages;
    self.config = config;
    self.superViewFrame = superView.frame;
    [self removePageControl];
    
    if (self.config.pageContollType == LabelPageControl){
        if (!self.pageLabel && (self.numberOfPages > 1)) {
            self.pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.superViewFrame) - 45, CGRectGetHeight(self.superViewFrame) - 30, 30, 15)];
            self.pageLabel.textAlignment = NSTextAlignmentCenter;
            self.pageLabel.font = Font(10);
            self.pageLabel.textColor = [UIColor whiteColor];
            self.pageLabel.layer.cornerRadius = 8;
            self.pageLabel.layer.masksToBounds = YES;
            self.pageLabel.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
            self.pageLabel.text = [NSString stringWithFormat:@"%d/%@",1,@(self.numberOfPages)];
            self.pageLabel.layer.zPosition = 1.0;
            [superView addSubview:self.pageLabel];
            
        }else if (self.pageLabel && (self.numberOfPages == 1)){
            //数量为1隐藏label
            [self.pageLabel removeFromSuperview];
            self.pageLabel = nil;
        }
    }else if (self.config.pageContollType != NonePageControl){
        
        if (!self.pageControl && (self.numberOfPages > 0)) {
            self.pageControl = [[UIPageControl alloc] init];
            self.pageControl.hidesForSinglePage = YES;
            self.pageControl.userInteractionEnabled = NO;
            self.pageControl.layer.zPosition = 1.0;
            if (self.config.currentPageTintColor) {
                self.pageControl.currentPageIndicatorTintColor = self.config.currentPageTintColor;
            }
            if (self.config.pageTintColor) {
                self.pageControl.pageIndicatorTintColor = self.config.pageTintColor;
            }
            [superView addSubview:self.pageControl];
        }
        self.pageControl.numberOfPages = _numberOfPages;
        self.pageControl.frame = CGRectMake(0, CGRectGetHeight(self.superViewFrame) - 20, numberOfPages*pageControlMagin + 100, 20);
        [self.pageControl setTransform:CGAffineTransformMakeScale(0.75, 0.75)];
        
        //设置pageControl的位置
        if (self.config.pageContollType == LeftPageControl){
            self.pageControl.x = 0;
            self.pageControl.y = self.pageControl.y - 25;
        }else if (self.config.pageContollType == MiddlePageControl){
            self.pageControl.x = CGRectGetWidth(self.superViewFrame)/2 - self.pageControl.width/2;
        }else if (self.config.pageContollType == HomePageControl){
            self.pageControl.x = CGRectGetWidth(self.superViewFrame) - self.pageControl.width;
            self.pageControl.y = self.pageControl.y - 25;
        }else if (self.config.pageContollType == RightPageControl){
            self.pageControl.x = CGRectGetWidth(self.superViewFrame) - self.pageControl.width;
            self.pageControl.y = self.pageControl.y;
        }
    }
}

- (void)removePageControl{
    if (self.pageControl) {
        [self.pageControl removeFromSuperview];
        self.pageControl = nil;
    }
    
    if (self.pageLabel) {
        [self.pageLabel removeFromSuperview];
        self.pageLabel = nil;
    }
    
}

- (void)updateCurrentPageWithIndex:(NSInteger)index{
    self.pageControl.currentPage = index;
    self.pageLabel.text = [NSString stringWithFormat:@"%ld/%@",(index+1),@(self.numberOfPages)];
}


@end
