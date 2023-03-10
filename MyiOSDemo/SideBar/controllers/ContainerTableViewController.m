//
//  ContainerTableViewController.m
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/3/8.
//

#import "ContainerTableViewController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"

@interface ContainerTableViewController ()

@property (nonatomic, strong) NSMutableArray *linkageArray;
@property (nonatomic, strong) UITableView *linkageTabelView;

@property (nonatomic, strong) FirstViewController *firstVC;
@property (nonatomic, strong) SecondViewController *secondVC;

@end

@implementation ContainerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"可用广告";
    [self configData];
    [self addFirstVC];
    [self addSecondVC];
}

- (void)configData
{
    if (!self.linkageArray) {
        NSArray *numArr = @[@"开机",@"前后台",@"三",@"四",@"五"];
        _linkageArray = [numArr mutableCopy];
    }
}

- (void)addFirstVC
{
    self.firstVC = [[FirstViewController alloc] init];
    [self addChildViewController:self.firstVC];
    [self.view addSubview:self.firstVC.view];
    self.firstVC.view.hidden = NO;
}

- (void)addSecondVC
{
    self.secondVC = [[SecondViewController alloc] init];
    [self addChildViewController:self.secondVC];
    [self.view addSubview:self.secondVC.view];
    self.secondVC.view.hidden = YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.linkageArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentify = @"cellIdentify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
    }
    cell.textLabel.text = [self.linkageArray objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            self.firstVC.view.hidden = NO;
            self.secondVC.view.hidden = YES;
            break;
        case 1:
            self.firstVC.view.hidden = YES;
            self.secondVC.view.hidden = NO;
            break;
            
        default:
            break;
    }
}

@end
