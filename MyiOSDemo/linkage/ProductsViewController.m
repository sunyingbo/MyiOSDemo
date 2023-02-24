//
//  ProductsViewController.m
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/2/24.
//

#import "ProductsViewController.h"

@interface ProductsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *productsTableView;
@property (nonatomic, strong) NSArray *sectionArr;
@property (nonatomic, strong) NSArray *productsArr;
@property (nonatomic, assign) BOOL isScrollUp; // 是否是向上滚动
@property (nonatomic, assign) CGFloat lastOffsetY; // 滚动即将结束时 scrollView 的偏移量
@property (nonatomic, assign) NSInteger currentSection;

@end

@implementation ProductsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configData];
    [self createTableView];
}

- (void)configData
{
    if (!_sectionArr) {
        NSArray *numArr = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十"];
        NSMutableArray *tmpArr = [NSMutableArray array];
        for (int i = 0; i < 20; i++) {
            NSString *tmpStr = [NSString stringWithFormat:@"第%@类", numArr[i]];
            [tmpArr addObject:tmpStr];
        }
        _sectionArr = tmpArr;
    }
    if (!_productsArr) {
        _productsArr = @[@"鞋子",@"衣服",@"化妆品",@"饮用水",@"副食品",@"小吃",@"鞋子",@"衣服",@"化妆品",@"饮用水"];
    }
}

- (void)createTableView
{
    self.view = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 0.25, 64, self.view.frame.size.width * 0.75, self.view.frame.size.height)];
    
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
    return self.productsArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
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

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(willDisplayHeaderView:)] != self.isScrollUp) {
        [self.delegate willDisplayHeaderView:section];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didEndDisplayHeaderView:)] && _isScrollUp) {
        [self.delegate didEndDisplayHeaderView:section];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"self.lastOffsetY : %f, scrollView.contentOffset.y : %f", _lastOffsetY, scrollView.contentOffset.y);
    self.isScrollUp = self.lastOffsetY < scrollView.contentOffset.y;
    self.lastOffsetY = scrollView.contentOffset.y;
    NSLog(@"self.lastOffsetY: %f", _lastOffsetY);
}

- (void)scrollToSelectedIndexPath:(NSIndexPath *)indexPath
{
    [self.productsTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.row] animated:YES scrollPosition:UITableViewScrollPositionTop];
}

@end
