//
//  LLTabSelectView.h
//  king
//
//  Created by hao on 2023/9/4.
// 
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLTabSelectView : UIView
@property (nonatomic, strong) UIColor *selectColor;
@property (nonatomic, strong) UIColor *unselectColor;
@property (nonatomic, strong) UIColor *selectTextColor;
@property (nonatomic, strong) UIColor *unselectTextColor;
@property (nonatomic, assign) BOOL showBottomLine;
@property (nonatomic, assign) NSInteger fontValue;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) ReturnIntBlock clickBlock;
@property (nonatomic, assign) NSInteger selectIndex;

- (id)initWithFrame:(CGRect)frame;
- (void)showTitles:(NSArray *)arr selectIndex:(NSInteger)index;
- (void)showTitles:(NSArray *)arr selectIndex:(NSInteger)index panFlag:(BOOL)panFlag;

@end

NS_ASSUME_NONNULL_END
