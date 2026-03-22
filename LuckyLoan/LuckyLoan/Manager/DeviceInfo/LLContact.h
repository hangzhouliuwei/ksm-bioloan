//
//  LLContact.h
//  LuckyLoan
//
//  Created by hao on 2024/1/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLContact : NSObject
@property (nonatomic, copy) ReturnDicBlock selectBlock;
- (void)showContact;
@end

NS_ASSUME_NONNULL_END
