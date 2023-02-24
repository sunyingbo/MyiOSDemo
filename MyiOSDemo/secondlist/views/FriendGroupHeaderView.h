//
//  FriendGroupHeaderView.h
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/2/24.
//

#import <UIKit/UIKit.h>
#import "FriendGroupModel.h"

NS_ASSUME_NONNULL_BEGIN

@class FriendGroupHeaderView;

// 定义一个 协议
@protocol FriendGroupHeaderViewDelegate <NSObject>

- (void)headerViewDidClickBtn:(FriendGroupHeaderView *)headerView;

@end

@interface FriendGroupHeaderView : UITableViewHeaderFooterView

//代理属性
@property (nonatomic, assign) id<FriendGroupHeaderViewDelegate>delegate;

@property (nonatomic, strong) FriendGroupModel *groupModel;

+ (instancetype)friendHeaderViewWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
