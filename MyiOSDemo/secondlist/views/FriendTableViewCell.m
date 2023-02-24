//
//  FriendTableViewCell.m
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/2/24.
//

#import "FriendTableViewCell.h"

@implementation FriendTableViewCell

+ (instancetype)friendCellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"cell";
    FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

-(void)setFriendModel:(FriendModel *)friendModel
 {
    _friendModel = friendModel;
    self.textLabel.text = friendModel.name;
    self.detailTextLabel.text = friendModel.intro;
    self.textLabel.textColor = friendModel.isVip ? [UIColor orangeColor] : [UIColor blackColor];
}

@end
