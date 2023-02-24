//
//  FriendTableViewCell.h
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/2/24.
//

#import <UIKit/UIKit.h>
#import "FriendModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FriendTableViewCell : UITableViewCell

@property (nonatomic, strong) FriendModel *friendModel;

+ (instancetype)friendCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
