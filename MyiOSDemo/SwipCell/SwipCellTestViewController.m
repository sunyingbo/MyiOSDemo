//
//  SwipCellTestViewController.m
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/5/12.
//

#import "SwipCellTestViewController.h"
#import "SwipeTableViewCell.h"

@interface SwipCellTestViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation SwipCellTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.array = [[NSMutableArray alloc] initWithObjects:@"数据一", @"数据二", @"数据三", @"数据四", @"数据五", nil];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    SwipeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[SwipeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell updateCell:self.array[indexPath.row]];
    return cell;
}

@end
