//
//  PeopleProtocol.h
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/3/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PeopleProtocol <NSObject>

- (void)run;

@optional
- (void)eat;

@end

NS_ASSUME_NONNULL_END
