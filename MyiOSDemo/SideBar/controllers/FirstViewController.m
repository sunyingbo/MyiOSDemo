//
//  SecondViewController.m
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/3/8.
//

#import "FirstViewController.h"
#import "ProductsHeaderView.h"
#import "ProductGroupModel.h"
#import "ProductModel.h"

@interface FirstViewController ()<UITableViewDelegate, UITableViewDataSource, ProductsHeaderViewDelegate>

@property (nonatomic, strong) UITableView *productsTableView;
@property (nonatomic, strong) NSArray *sectionArr;
@property (nonatomic, strong) NSArray *productsArr;
@property (nonatomic, strong) NSMutableArray *productGroupModelArr;
@property (nonatomic, strong) NSMutableArray *productsModelArr;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configData];
    [self createTableView];
}

- (void)configData
{
    if (!_sectionArr) {
        NSArray *numArr = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十"];
        NSMutableArray *tmpArr = [NSMutableArray array];
        for (int i = 0; i < numArr.count; i++) {
            NSString *tmpStr = [NSString stringWithFormat:@"第%@组", numArr[i]];
            [tmpArr addObject:tmpStr];
        }
        _sectionArr = tmpArr;
    }
    self.productGroupModelArr = [[NSMutableArray alloc] initWithCapacity:self.sectionArr.count];
    for (NSString *pro in self.sectionArr) {
        [self.productGroupModelArr addObject:[[ProductGroupModel alloc] init]];
    }
    if (!_productsArr) {
        _productsArr = @[@"创意一",@"创意二",@"创意三",@"创意四",@"创意五"];
    }
    self.productsModelArr = [[NSMutableArray alloc] initWithCapacity:self.productsArr.count];
    for (NSString *pro in self.productsArr) {
        [self.productsModelArr addObject:[[ProductModel alloc] init]];
    }
}

- (void)createTableView
{
    self.view = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 0.25, 0, self.view.frame.size.width * 0.75, self.view.frame.size.height)];
    
    self.productsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.productsTableView.delegate = self;
    self.productsTableView.dataSource = self;
    self.productsTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.productsTableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ProductGroupModel *groupModel = self.productGroupModelArr[section];
    return groupModel.expend ? self.productsArr.count : 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.sectionArr[section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ProductsHeaderView *headerView = [ProductsHeaderView productsHeaderViewWithTableView:tableView];
    headerView.backgroundColor = [UIColor yellowColor];
    headerView.delegate = self;
    ProductGroupModel *groupModel = self.productGroupModelArr[section];
    headerView.groupModel = groupModel;
    headerView.tag = section;
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"defaultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [self.productsArr objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = @"副标题";
    return cell;
}

- (void)headerViewDidClickBtn:(ProductsHeaderView *)headerView
{
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:headerView.tag];
    [self.productsTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}

@end
