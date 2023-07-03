//
//  NSObject+Property.h
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/7/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol KeyValue <NSObject>

@optional
+ (NSDictionary *)objectClassInArray;

+ (NSDictionary *)replacedKeyFromPropertyName;

@end

@interface NSObject (Property)<KeyValue>

+ (instancetype)objectWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
