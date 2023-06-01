//
//  FlowLayout6.h
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/5/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CollectionViewFlowLayoutDelegate <UICollectionViewDelegateFlowLayout>

@optional
- (CGSize)collectionView:(UICollectionView *)collectionView sizeForLargeItemsInSection:(NSInteger)section;
- (UIEdgeInsets)insetsForCollectionView:(UICollectionView *)collectionView;
- (CGFloat)sectionSpacingForCollectionView:(UICollectionView *)collectionView;
- (CGFloat)minimumInteritemSpacingForCollectionView:(UICollectionView *)collectionView;
- (CGFloat)minimumLineSpacingForCollectionView:(UICollectionView *)collectionView;

@end

@protocol CollectionViewFlowLayoutDataSource <UICollectionViewDataSource>

@end

@interface FlowLayout6 : UICollectionViewFlowLayout

@property (nonatomic, assign, readonly) CGSize largeCellSize;
@property (nonatomic, assign, readonly) CGSize smallCellSize;

@property (nonatomic, weak) id<CollectionViewFlowLayoutDelegate> delegate;
@property (nonatomic, weak) id<CollectionViewFlowLayoutDataSource> datasource;

- (CGFloat)contentHeight;

@end

NS_ASSUME_NONNULL_END
