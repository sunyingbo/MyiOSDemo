//
//  FlowLayout5ViewController.m
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/5/29.
//

#import "FlowLayout5ViewController.h"
#import "FlowLayout5.h"

@interface FlowLayout5ViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation FlowLayout5ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    FlowLayout5 *layout = [[FlowLayout5 alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 300, 300) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CellId"];
    [self.view addSubview:self.collectionView];
    self.collectionView.center = self.view.center;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(changeContentOffset) userInfo:nil repeats:YES];
}

- (void)changeContentOffset
{
    self.collectionView.contentOffset = CGPointMake(arc4random() % (11 * 300), arc4random() % (10 * 300));
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 30;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellId" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:arc4random() % 255 / 255.0 green:arc4random() % 255 / 255.0 blue:arc4random() % 255 / 255.0 alpha:1];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    label.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    [cell.contentView addSubview:label];
    return cell;
}

@end
