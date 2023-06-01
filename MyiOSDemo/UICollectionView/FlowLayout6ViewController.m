//
//  FlowLayout6ViewController.m
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/6/1.
//

#import "FlowLayout6ViewController.h"
#import "CollectionViewCell6.h"
#import "FlowLayout_6.h"

@interface FlowLayout6ViewController ()<CollectionViewResetFlowLayoutDelegate, CollectionViewResetFlowLayoutDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *photosArray;

@end

@implementation FlowLayout6ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    FlowLayout_6 *layout = [[FlowLayout_6 alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self setUpPhotosArray];
}

- (void)refreshUI:(UIButton *)button
{
    [self setUpPhotosArray];
    [self.collectionView reloadData];
}

- (void)setUpPhotosArray
{
    [self.photosArray removeAllObjects];
    self.photosArray = nil;
    self.photosArray = [NSMutableArray array];
    for (NSInteger i = 1; i <= 21; i++) {
        NSString *photoName = [NSString stringWithFormat:@"%ld.jpg", i];
        UIImage *photoImg = [UIImage imageNamed:photoName];
        [self.photosArray addObject:photoImg];
    }
}

#pragma mark - UICollectionView Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return self.photosArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellID = @"headerCell";
        UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
        return cell;
    } else {
        static NSString *cellID = @"CellId";
        CollectionViewCell6 *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
        [cell.imageView removeFromSuperview];
        cell.imageView.frame = cell.bounds;
        cell.imageView.image = self.photosArray[indexPath.item];
        [cell.contentView addSubview:cell.imageView];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return;
    }
    if (self.photosArray.count == 1) {
        return;
    }
    [self.collectionView performBatchUpdates:^{
        [self.photosArray removeObjectAtIndex:indexPath.item];
        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [self.collectionView reloadData];
    }];
}

#pragma mark - CollectionViewFlowLayoutDelegate
- (CGFloat)sectionSpacingForCollectionView:(UICollectionView *)collectionView
{
    return 5.f;
}

- (CGFloat)minimumInteritemSpacingForCollectionView:(UICollectionView *)collectionView
{
    return 5.f;
}

- (CGFloat)minimumLineSpacingForCollectionView:(UICollectionView *)collectionView
{
    return 5.f;;
}

- (UIEdgeInsets)insetsForCollectionView:(UICollectionView *)collectionView
{
    return UIEdgeInsetsMake(5.f, 0, 5.f, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView sizeForLargeItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeMake(320, 200);
    }
    return CGSizeZero;
}

#pragma mark - CollectionViewResetFlowLayoutDelegate
- (UIEdgeInsets)autoScrollTrigerEdgeInsets:(UICollectionView *)collectionView
{
    return UIEdgeInsetsMake(50.f, 0, 50.f, 0);
}

- (UIEdgeInsets)autoScrollTrigerPadding:(UICollectionView *)collectionView
{
    return UIEdgeInsetsMake(64.f, 0, 0, 0);
}

- (CGFloat)reorderingItemAlpha:(UICollectionView *)collectionView
{
    return .3f;
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath didMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    UIImage *image = [self.photosArray objectAtIndex:fromIndexPath.item];
    [self.photosArray removeObjectAtIndex:fromIndexPath.item];
    [self.photosArray insertObject:image atIndex:toIndexPath.item];
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    if (toIndexPath.section == 0) {
        return NO;
    }
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return NO;
    }
    return YES;
}

@end
