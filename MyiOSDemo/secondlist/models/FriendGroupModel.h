//
//  FriendGroupModel.h
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/2/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  好友列表分组 模型
 */
@interface FriendGroupModel : NSObject

///分组名称
@property (nonatomic, copy) NSString *name;
///在线的人数
@property (nonatomic, assign) NSInteger online;

///好友列表数组
@property (nonatomic, strong) NSArray *friends;

///是否展开 默认NO
@property (nonatomic, assign, getter=isExpend) BOOL expend;

- (instancetype)initWithNSDictionary:(NSDictionary *)dic;

+ (instancetype)friendGroupModelWithNSDictionary:(NSDictionary *)dic;

+ (NSArray *)friendGroupList;

@end

NS_ASSUME_NONNULL_END
