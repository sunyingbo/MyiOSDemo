//
//  FlowLayout7.m
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/6/19.
//

#import "FlowLayout7.h"
#import "Constant.h"

@interface FlowLayout7()

@property (nonatomic, assign) NSInteger index;

@end

@implementation FlowLayout7

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.index = 0;
    }
    return self;
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    CGRect visibleRect = CGRectMake(self.collectionView.contentOffset.x, 0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    NSArray *visibleItemArray = [super layoutAttributesForElementsInRect:visibleRect];
    
    for (UICollectionViewLayoutAttributes *attribures in visibleItemArray) {
        CGFloat leftMargin = attribures.center.x - self.collectionView.contentOffset.x;
        CGFloat halfCenterX = self.collectionView.frame.size.width / 2;
        CGFloat absOffset = fabs(halfCenterX - leftMargin);
        CGFloat scale = 1 - absOffset / halfCenterX;
        attribures.transform3D = CATransform3DMakeScale(1 + scale * MKJMinZoomScale, 1 + scale * MKJMinZoomScale, 1);
        if (self.needAlpha) {
            if (scale < 0.6) {
                attribures.alpha = 0.6;
            } else if (scale > 0.99) {
                attribures.alpha = 1.0;
            } else {
                attribures.alpha = scale;
            }
        }
    }
    NSArray *attributesArr = [[NSArray alloc] initWithArray:visibleItemArray copyItems:YES];
    return attributesArr;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    CGPoint pInView = [self.collectionView.superview convertPoint:self.collectionView.center toView:self.collectionView];
    NSIndexPath *indexPathNow = [self.collectionView indexPathForItemAtPoint:pInView];
    if (indexPathNow.row == 0) {
        if (newBounds.origin.x < SCREEN_WIDTH / 2) {
            if (self.index != indexPathNow.row) {
                self.index = 0;
                if (self.delegate && [self.delegate respondsToSelector:@selector(collectionViewScrollToIndex:)]) {
                    [self.delegate collectionViewScrollToIndex:self.index];
                }
            }
        }
    } else {
        if (self.index != indexPathNow.row) {
            self.index = indexPathNow.row;
            if (self.delegate && [self.delegate respondsToSelector:@selector(collectionViewScrollToIndex:)]) {
                [self.delegate collectionViewScrollToIndex:self.index];
            }
        }
    }
    [super shouldInvalidateLayoutForBoundsChange:newBounds];
    return YES;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGFloat minOffset = CGFLOAT_MAX;
    CGFloat horizontalCenter = proposedContentOffset.x + self.collectionView.bounds.size.width / 2;
    CGRect visibleRec = CGRectMake(proposedContentOffset.x, 0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    NSArray *visibleAttributes = [super layoutAttributesForElementsInRect:visibleRec];
    for (UICollectionViewLayoutAttributes *atts in visibleAttributes) {
        CGFloat itemCenterX = atts.center.x;
        if (fabs(itemCenterX - horizontalCenter) <= fabs(minOffset)) {
            minOffset = itemCenterX - horizontalCenter;
        }
    }
    
    CGFloat centerOffsetX = proposedContentOffset.x + minOffset;
    if (centerOffsetX < 0) {
        centerOffsetX = 0;
    }
    
    if (centerOffsetX > self.collectionView.contentSize.width - (self.sectionInset.left + self.sectionInset.right + self.itemSize.width))  {
        centerOffsetX = floor(centerOffsetX);
    }
    return CGPointMake(centerOffsetX, proposedContentOffset.y);
}

@end
