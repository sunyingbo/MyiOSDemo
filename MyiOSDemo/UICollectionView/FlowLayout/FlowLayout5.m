//
//  FlowLayout5.m
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/5/29.
//

#import "FlowLayout5.h"

@implementation FlowLayout5

- (CGSize)collectionViewContentSize{
    return CGSizeMake(self.collectionView.frame.size.width * ([self.collectionView numberOfItemsInSection:0] + 2), self.collectionView.frame.size.height * ([self.collectionView numberOfItemsInSection:0] + 2));
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *attributes= [NSMutableArray array];
    for (int i = 0; i < [self.collectionView numberOfItemsInSection:0]; i++) {
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]]];
    }
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    attributes.center = CGPointMake(self.collectionView.frame.size.width / 2 + self.collectionView.contentOffset.x, self.collectionView.frame.size.height / 2 + self.collectionView.contentOffset.y);
    attributes.size = CGSizeMake(30, 30);
    CATransform3D trans3D = CATransform3DIdentity;
    trans3D.m34 = - 1 / 900.0;
    CGFloat radius = 15 / tanf(M_PI * 2 / itemCount / 2);
    
    // 根据偏移量，改变角度
    // 添加了一个 x 的偏移量
    CGFloat offsetY = self.collectionView.contentOffset.y;
    CGFloat offsetX = self.collectionView.contentOffset.x;
    
    // 分别计算偏移的角度
    CGFloat angleOffsetY = offsetY / self.collectionView.frame.size.height;
    CGFloat angleOffsetX = offsetX / self.collectionView.frame.size.width;
    
    // x，y 的默认方向相反
    CGFloat angleY = (indexPath.item + angleOffsetY - 1) / itemCount * M_PI * 2;
    CGFloat angleX = (indexPath.item + angleOffsetX - 1) / itemCount * M_PI * 2;
    
    // 四个方向的排列
    if (indexPath.item % 4 == 1) {
        trans3D = CATransform3DRotate(trans3D, angleY, 1.0, 0, 0);
    } else if (indexPath.row % 4 == 2) {
        trans3D = CATransform3DRotate(trans3D, angleX, 0, 1.0, 0);
    } else if (indexPath.row % 4 == 3) {
        trans3D = CATransform3DRotate(trans3D, angleY, 0.5, 0.5, 0);
    } else {
        trans3D = CATransform3DRotate(trans3D, angleY, 0.5, -0.5, 0);
    }
    
    trans3D = CATransform3DTranslate(trans3D, 0, 0, radius);
    attributes.transform3D = trans3D;
    return attributes;
}

@end
