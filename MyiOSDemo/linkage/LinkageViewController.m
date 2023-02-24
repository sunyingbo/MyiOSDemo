//
//  LinkageViewController.m
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/2/23.
//

#import "LinkageViewController.h"
#import "ProductsViewController.h"

@interface LinkageViewController ()<UITableViewDelegate, UITableViewDataSource, ProductsDelegate>

@property (nonatomic, strong) NSMutableArray *linkageArray;
@property (nonatomic, strong) UITableView *linkageTabelView;
@property (nonatomic, strong) ProductsViewController *productsVC;

@end

@implementation LinkageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品";
    [self configData];
    [self createTableView];
    [self createProductsVC];
}

- (void)configData
{
    if (!self.linkageArray) {
        NSArray *numArr = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十"];
        NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
        for (int i = 0; i < 20; i++) {
            NSString *tmpStr = [NSString stringWithFormat:@"第%@类", numArr[i]];
            [tmpArr addObject:tmpStr];
        }
        _linkageArray = tmpArr;
    }
}

- (void)createTableView
{
    self.linkageTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.linkageTabelView.delegate = self;
    self.linkageTabelView.dataSource = self;
    self.linkageTabelView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.linkageTabelView];
}

- (void)createProductsVC
{
    self.productsVC = [[ProductsViewController alloc] init];
    self.productsVC.delegate = self;
    [self addChildViewController:self.productsVC];
    [self.view addSubview:self.productsVC.view];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.linkageArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    if (self.productsVC) {
        [self.productsVC scrollToSelectedIndexPath:indexPath];
    }
}

#pragma mark - ProductsDelegate
- (void)willDisplayHeaderView:(NSInteger)section
{
    [self.linkageTabelView selectRowAtIndexPath:[NSIndexPath indexPathForRow:section inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

- (void)didEndDisplayHeaderView:(NSInteger)section
{
    [self.linkageTabelView selectRowAtIndexPath:[NSIndexPath indexPathForRow:section + 1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

@end
