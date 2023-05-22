//
//  FlowLayout3ViewController.m
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/5/10.
//

#import "FlowLayout3ViewController.h"
#import "FlowLayout3.h"

@interface FlowLayout3ViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation FlowLayout3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    FlowLayout3 *layout = [[FlowLayout3 alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CellId"];
    [self.view addSubview:collectionView];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 20;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellId" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:arc4random() % 255 / 255.0 green:arc4random() % 255 / 255.0 blue:arc4random() % 255 / 255.0 alpha:1];
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 25;
    return cell;
}

@end
