//
//  FlowLayout4.m
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/5/29.
//

#import "FlowLayout4.h"

@implementation FlowLayout4

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 创建一个 item 布局属性类
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    // 获取 item 的个数
    int itemCounts = (int)[self.collectionView numberOfItemsInSection:0];
    // 设置每个 item 的大小为 320 * 100
    attributes.size = CGSizeMake(320, 100);
    attributes.center = CGPointMake(self.collectionView.frame.size.width / 2, self.collectionView.frame.size.height / 2 + self.collectionView.contentOffset.y);
    CATransform3D tran3d = CATransform3DIdentity;
    tran3d.m34 = - 1 / 2000.0;
    CGFloat radius = 50 / tanf(M_PI * 2 / itemCounts / 2);
    // 获取当前的偏移量
    float offset = self.collectionView.contentOffset.y;
    // 在角度设置上，添加一个偏移角度
    float angleOffset = offset / self.collectionView.frame.size.height;
    CGFloat angle = (float)(indexPath.row + angleOffset - 1) / itemCounts * M_PI * 2;
    tran3d = CATransform3DRotate(tran3d, angle, 1.0, 0, 0);
    tran3d = CATransform3DTranslate(tran3d, 0, 0, radius);
    // 进行设置
    attributes.transform3D = tran3d;
    return attributes;
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *attributes = [[NSMutableArray alloc] init];
    // 遍历设置每个item的布局属性
    for (int i = 0; i < [self.collectionView numberOfItemsInSection:0]; i++) {
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]]];
    }
    return attributes;
}

- (CGSize)collectionViewContentSize
{
    return CGSizeMake(self.collectionView.frame.size.width, self.collectionView.frame.size.height * ([self.collectionView numberOfItemsInSection:0] + 2));
}

// 返回 yes，则一有变化就会刷新布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

@end
