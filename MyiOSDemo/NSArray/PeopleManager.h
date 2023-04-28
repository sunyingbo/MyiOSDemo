//
//  PeopleManager.h
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/3/17.
//

#import <Foundation/Foundation.h>
#import "PeopleProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface PeopleManager : NSObject

+ (void)addDelegate:(id<PeopleProtocol>)delegate;
+ (void)removeDelegate:(id<PeopleProtocol>)delegate;

+ (void)start;

@end

NS_ASSUME_NONNULL_END
