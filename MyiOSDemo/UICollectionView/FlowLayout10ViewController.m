//
//  FlowLayout10ViewController.m
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/7/3.
//

#import "FlowLayout10ViewController.h"
#import "GridListCollectionViewCell.h"
#import "GridListModel.h"
#import "NSObject+Property.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width

@interface FlowLayout10ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) UIButton *switchBtn;

@property (nonatomic, assign) BOOL isGrid;

@end

@implementation FlowLayout10ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isGrid = NO;
    [self.view addSubview:self.collectionView];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"product" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSArray *products = dict[@"wareInfo"];
    for (id obj in products) {
        [self.dataSource addObject:[GridListModel objectWithDictionary:obj]];
    }
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumInteritemSpacing = 2;
        layout.minimumLineSpacing = 2;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(2, 2, self.view.bounds.size.width - 4, self.view.bounds.size.height - 4) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[GridListCollectionViewCell class] forCellWithReuseIdentifier:@"CellIndentifier"];
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GridListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    cell.isGrid = self.isGrid;
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isGrid) {
        return CGSizeMake((ScreenWidth - 6) / 2, (ScreenWidth - 6) / 2 + 40);
    } else {
        return CGSizeMake(ScreenWidth - 4, (ScreenWidth - 6) / 4 + 20);
    }
}

- (void)onBtnClick:(UIButton *)sender
{
    self.isGrid = !self.isGrid;
    [self.collectionView reloadData];
    
    if (self.isGrid) {
        [self.switchBtn setImage:[UIImage imageNamed:@"product_list_grid_btn"] forState:UIControlStateNormal];
    } else {
        [self.switchBtn setImage:[UIImage imageNamed:@"product_list_list_btn"] forState:UIControlStateNormal];
    }
}

@end
