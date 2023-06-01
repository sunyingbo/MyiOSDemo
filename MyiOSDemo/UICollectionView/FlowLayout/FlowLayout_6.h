//
//  FlowLayout_6.h
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/5/30.
//

#import "FlowLayout6.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CollectionViewResetFlowLayoutDelegate <CollectionViewFlowLayoutDelegate>

@optional
- (CGFloat)reorderingItemAlpha:(UICollectionView *)collectionView; // Default 0
- (UIEdgeInsets)autoScrollTrigerEdgeInsets:(UICollectionView *)collectionView; // not supported horizontal scroll
- (UIEdgeInsets)autoScrollTrigerPadding:(UICollectionView *)collectionView;
- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol CollectionViewResetFlowLayoutDataSource <CollectionViewFlowLayoutDataSource>

@optional
- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath;
- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath didMoveToIndexPath:(NSIndexPath *)toIndexPath;
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath;

@end

@interface FlowLayout_6 : FlowLayout6<UIGestureRecognizerDelegate>

@property (nonatomic, strong, readonly) UILongPressGestureRecognizer *longPressGesture;
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *panGesture;
@property (nonatomic, weak) id<CollectionViewResetFlowLayoutDelegate> delegate;
@property (nonatomic, weak) id<CollectionViewResetFlowLayoutDataSource> dataSource;

@end

NS_ASSUME_NONNULL_END
