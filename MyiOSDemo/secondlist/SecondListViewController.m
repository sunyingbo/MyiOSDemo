//
//  SecondListViewController.m
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/2/24.
//

#import "SecondListViewController.h"
#import "FriendGroupModel.h"
#import "FriendTableViewCell.h"
#import "FriendGroupHeaderView.h"

@interface SecondListViewController ()<UITableViewDelegate, UITableViewDataSource, FriendGroupHeaderViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *friendGroup;

@end

@implementation SecondListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTitleAndTableView];
}

- (void)setUpTitleAndTableView
{
    self.title = @"好友列表";
    self.navigationController.navigationBar.barTintColor = [UIColor purpleColor];
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.sectionHeaderHeight = 44;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 30, 0, 80);
    self.tableView.separatorStyle =
    UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor blueColor];
    [self.view addSubview:self.tableView];
}

- (NSArray *)friendGroup {
    if (!_friendGroup) {
        _friendGroup = [FriendGroupModel friendGroupList];
    }
    return _friendGroup;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.friendGroup.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    FriendGroupModel *model = self.friendGroup[section];
    return model.isExpend ? model.friends.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendTableViewCell *cell = [FriendTableViewCell friendCellWithTableView:tableView];
    cell.friendModel = [self.friendGroup[indexPath.section] friends][indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    FriendGroupHeaderView *headerView = [FriendGroupHeaderView friendHeaderViewWithTableView:tableView];
    headerView.delegate = self;
    FriendGroupModel *groupModel = self.friendGroup[section];
    
    headerView.groupModel = groupModel;
    headerView.tag = section;
    return headerView;
}

- (void)headerViewDidClickBtn:(FriendGroupHeaderView *)headerView
{
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:headerView.tag];
    
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}

@end
