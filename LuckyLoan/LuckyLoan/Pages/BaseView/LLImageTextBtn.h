//
//  LLImageTextBtn.h
//  king
//
//  Created by hao on 2023/9/4.
// 
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HaoBtnType) {
    HaoBtnType1 = 0,//左图右文（居中）
    HaoBtnType2,//左图右文（居左）
    HaoBtnType3,//左文右图（居中）
    HaoBtnType4,//左文右图（居右）
    HaoBtnType5,//上图下文
    HaoBtnType6,//上图下文(图文间距10)
    HaoBtnType7,//左文右图（居左）
    HaoBtnType8,//左图右文（居右）
    HaoBtnType9,//左文右图（两边对齐）
};

@interface LLImageTextBtn : UIButton

@property (nonatomic, assign) HaoBtnType type;
@property (nonatomic, copy) NSString *title;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title  color:(UIColor *)color  font:(CGFloat)font icon:(NSString *)icon;

@end

NS_ASSUME_NONNULL_END
