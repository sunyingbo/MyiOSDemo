//
//  ViewController.m
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/2/13.
//

#import "ViewController.h"
#import "MoveViewController.h"
#import "DeleteViewController.h"
#import "InsertViewController.h"
#import "LinkageViewController.h"
#import "SecondListViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray * array;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.array = [[NSMutableArray alloc] initWithObjects:@"cell 的移动", @"cell 的删除", @"cell 的添加", @"TableView 的联动", @"二级列表", nil];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
}

// 多少分区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// 多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

// 每行显示内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // cell 重用机制
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = self.array[indexPath.row];
    return cell;
}

// 每行点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: {
            MoveViewController *moveVC = [[MoveViewController alloc] init];
            [self.navigationController pushViewController:moveVC animated:YES];
            break;
        }
        case 1: {
            DeleteViewController *deleteVC = [[DeleteViewController alloc] init];
            [self.navigationController pushViewController:deleteVC animated:YES];
            break;
        }
        case 2: {
            InsertViewController *insertVC = [[InsertViewController alloc] init];
            [self.navigationController pushViewController:insertVC animated:YES];
            break;
        }
        case 3: {
            LinkageViewController *linkageVC = [[LinkageViewController alloc] init];
            [self.navigationController pushViewController:linkageVC animated:YES];
            break;
        }
        case 4: {
            SecondListViewController *secondListVC = [[SecondListViewController alloc] init];
            [self.navigationController pushViewController:secondListVC animated:YES];
            break;
        }
        default:
            break;
    }
}

@end
