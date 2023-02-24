//
//  FriendModel.m
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/2/24.
//

#import "FriendModel.h"

@implementation FriendModel

- (instancetype)initWithNSDictionary:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+ (instancetype)friendModelWithNSDictionart:(NSDictionary *)dic {
    return [[self alloc] initWithNSDictionary:dic];
}

@end
