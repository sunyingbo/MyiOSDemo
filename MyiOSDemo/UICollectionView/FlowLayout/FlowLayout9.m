//
//  FlowLayout9.m
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/6/30.
//

#import "FlowLayout9.h"

@interface FlowLayout9 ()

@property (nonatomic, assign) CGFloat viewHeight;
@property (nonatomic, assign) CGFloat itemHeight;
@property (nonatomic, assign) CGFloat defaultInsetLeft;

@end

@implementation FlowLayout9

- (void)prepareLayout
{
    [super prepareLayout];
    self.visibleCount = self.visibleCount < 1 ? 5 : self.visibleCount;
    self.viewHeight = CGRectGetWidth(self.collectionView.frame);
    self.itemHeight = self.itemSize.width;
    self.defaultInsetLeft = self.defaultInsetLeft == 0 ? -(self.viewHeight - self.itemHeight) / 2 : self.defaultInsetLeft;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, self.defaultInsetLeft, 0, (self.viewHeight - self.itemHeight) / 2);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.size = self.itemSize;
    CGFloat cY = self.collectionView.contentOffset.x + self.viewHeight / 2;
    CGFloat attributesY = self.itemHeight * indexPath.row + self.itemHeight / 2;
    attributes.zIndex = -ABS(attributesY - cY);
    
    CGFloat delta = cY - attributesY;
    CGFloat ratio = -delta / (self.itemHeight * 2);
    CGFloat scale = 1 - ABS(delta) / (self.itemHeight * 6.0) * cos(ratio * M_PI_4);
    
    attributes.alpha = scale;
    attributes.transform = CGAffineTransformMakeScale(scale, scale);
    CGFloat centerY = attributesY;
    attributes.center = CGPointMake(centerY, CGRectGetHeight(self.collectionView.frame) / 2);
    return attributes;
}

- (CGSize)collectionViewContentSize
{
    NSInteger cellCount = [self.collectionView numberOfItemsInSection:0];
    return CGSizeMake(cellCount * self.itemHeight, CGRectGetHeight(self.collectionView.frame));
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSInteger cellCount = [self.collectionView numberOfItemsInSection:0];
    CGFloat centerY = self.collectionView.contentOffset.x + self.viewHeight / 2;
    NSInteger index = centerY / self.itemHeight;
    NSInteger count = (self.visibleCount - 1) / 2;
    NSInteger minIndex = MAX(0, (index - count));
    NSInteger maxIndex = MIN((cellCount - 1), (index + count));
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = minIndex; i <= maxIndex; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [array addObject:attributes];
    }
    return array;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset
{
    CGFloat index = roundf((proposedContentOffset.x + self.viewHeight / 2 - self.itemHeight / 2) / self.itemHeight);
    proposedContentOffset.x = self.itemHeight * index + self.itemHeight / 2 - self.viewHeight / 2;
    if (self.slideIndexBlock) {
        self.slideIndexBlock((NSInteger)index);
    }
    self.defaultInsetLeft = (self.viewHeight - self.itemHeight) / 2;
    return proposedContentOffset;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return !CGRectEqualToRect(newBounds, self.collectionView.bounds);
}

@end
