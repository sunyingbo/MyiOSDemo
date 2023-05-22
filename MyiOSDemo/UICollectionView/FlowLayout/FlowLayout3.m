//
//  FlowLayout3.m
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/5/10.
//

#import "FlowLayout3.h"

@interface FlowLayout3 ()

@property (nonatomic, strong) NSMutableArray *attributeArray;

@end

@implementation FlowLayout3

- (void)prepareLayout
{
    [super prepareLayout];
    self.itemCount = (int)[self.collectionView numberOfItemsInSection:0];
    self.attributeArray = [NSMutableArray array];
    CGFloat radius = MIN(self.collectionView.frame.size.width, self.collectionView.frame.size.height) / 2;
    CGPoint center = CGPointMake(self.collectionView.frame.size.width / 2, self.collectionView.frame.size.height / 2);
    for (int i = 0; i < self.itemCount; i++) {
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        attributes.size = CGSizeMake(50, 50);
        CGFloat x = center.x + cosf(2 * M_PI / self.itemCount * i) * (radius - 25);
        CGFloat y = center.y + sinf(2 * M_PI / self.itemCount * i) * (radius - 25);
        attributes.center = CGPointMake(x, y);
        [self.attributeArray addObject:attributes];
    }
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attributeArray;
}

- (CGSize)collectionViewContentSize
{
    return self.collectionView.frame.size;
}

@end
