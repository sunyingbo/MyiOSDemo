//
//  UICollectionViewTestViewController.m
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/5/9.
//

#import "UICollectionViewTestViewController.h"
#import "FlowLayoutViewController.h"
#import "FlowLayout2ViewController.h"
#import "FlowLayout3ViewController.h"

@interface UICollectionViewTestViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray * array;

@end

@implementation UICollectionViewTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.array = [[NSMutableArray alloc] initWithObjects:@"FlowLayout", @"FlowLayout2", @"FlowLayout3", nil];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = self.array[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: {
            FlowLayoutViewController *flowLayout = [[FlowLayoutViewController alloc] init];
            [self.navigationController pushViewController:flowLayout animated:YES];
            break;
        }
        case 1: {
            FlowLayout2ViewController *flowLayout2 = [[FlowLayout2ViewController alloc] init];
            [self.navigationController pushViewController:flowLayout2 animated:YES];
            break;
        }
        case 2: {
            FlowLayout3ViewController *flowLayout3 = [[FlowLayout3ViewController alloc] init];
            [self.navigationController pushViewController:flowLayout3 animated:YES];
            break;
        }
    }
}

@end
