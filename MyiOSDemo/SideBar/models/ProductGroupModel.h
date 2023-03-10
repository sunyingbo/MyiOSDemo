//
//  ProductGroupModel.h
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/3/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProductGroupModel : NSObject

///是否展开 默认NO
@property (nonatomic, assign, getter=isExpend) BOOL expend;

@end

NS_ASSUME_NONNULL_END
