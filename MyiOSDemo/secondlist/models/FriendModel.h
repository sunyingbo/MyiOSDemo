//
//  FriendModel.h
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/2/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  好友列表 模型
 */
@interface FriendModel : NSObject

/**
 *  头像
 */
@property (nonatomic, copy) NSString *icon;
///个性签名
@property (nonatomic, copy) NSString *intro;
///好友名称
@property (nonatomic, copy) NSString *name;
///是不是会员
@property (nonatomic, assign, getter=isVip) BOOL vip;

- (instancetype)initWithNSDictionary:(NSDictionary *)dic;

+ (instancetype)friendModelWithNSDictionart:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
