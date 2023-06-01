//
//  FlowLayout4ViewController.m
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/5/29.
//

#import "FlowLayout4ViewController.h"
#import "FlowLayout4.h"

@interface FlowLayout4ViewController ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger i;

@end

@implementation FlowLayout4ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.i = 100;
    FlowLayout4 *layout = [[FlowLayout4 alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 400, 400) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CellId"];
    [self.view addSubview:self.collectionView];
    self.collectionView.center = self.view.center;
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(changeContentOffset) userInfo:nil repeats:YES];
}

- (void)changeContentOffset {
    self.i = self.i + 100;
    self.collectionView.contentOffset = CGPointMake(0, self.i);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellId" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:arc4random() % 255 / 255.0 green:arc4random() % 255 / 255.0 blue:arc4random() % 255 / 255.0 alpha:1];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250, 80)];
    label.text = [NSString stringWithFormat:@"我是第 %ld 行", (long)indexPath.row];
    [cell.contentView addSubview:label];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < 200) {
        scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y + 10 * 400);
    } else if (scrollView.contentOffset.y > 11 * 400) {
        scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y - 10 * 400);
    }
}

@end
