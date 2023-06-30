//
//  CardLayout.m
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/6/30.
//

#import "CardLayout.h"

#define GBL_UIKIT_D0 16
#define GBL_UIKIT_D1 12

static CGFloat cellWidth; // 卡片宽度
static CGFloat cellHeight; // 卡片高度

@interface CardLayout ()

@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, assign) CGFloat m0;
@property (nonatomic, assign) CGFloat n0;
@property (nonatomic, assign) CGFloat delteOffsetY;
@property (nonatomic, strong) NSMutableArray *cellLayoutList;

@end

@implementation CardLayout

- (NSMutableArray *)blurList
{
    if (!_blurList) {
        _blurList = [NSMutableArray array];
        NSInteger rowCount = [self.collectionView numberOfItemsInSection:0];
        for (NSInteger row = 0; row < rowCount; row++) {
            [_blurList addObject:@0];
        }
    }
    return _blurList;
}

- (id)init
{
    self = [self initWithOffsetY:0];
    return self;
}

- (instancetype)initWithOffsetY:(CGFloat)offsetY
{
    self = [super init];
    if (self) {
        cellWidth = [UIScreen mainScreen].bounds.size.width - 12 * 2;
        cellHeight = 210;
        self.offsetY = offsetY;
        self.cellLayoutList = [NSMutableArray array];
        
        self.screenHeight = [UIScreen mainScreen].bounds.size.height;
        self.m0 = 1000;
        self.n0 = 250;
        self.delteOffsetY = 140;
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
    [self.cellLayoutList removeAllObjects];
    NSInteger rowCount = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger row = 0; row < rowCount; row++) {
        UICollectionViewLayoutAttributes *attribute = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
        [self.cellLayoutList addObject:attribute];
    }
}

- (CGSize)collectionViewContentSize
{
    return CGSizeMake(self.collectionView.frame.size.width, [self getContentSizeY]);
}

- (CGFloat)getContentSizeY
{
    self.contentSizeHeight = [self getSizeY];
    return self.contentSizeHeight;
}

- (CGFloat)getSizeY
{
    NSInteger rowCount = [self.collectionView numberOfItemsInSection:0];
    if (rowCount <= 2) {
        return self.collectionView.frame.size.height;
    }
    CGFloat scrollY = self.delteOffsetY * (rowCount - 1);
    return scrollY + self.screenHeight;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset
{
    return CGPointMake(0, self.offsetY);
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *array = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *attribute in self.cellLayoutList) {
        if (CGRectIntersectsRect(attribute.frame, rect)) {
            [array addObject:attribute];
        }
    }
    return array;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowCount = [self.collectionView numberOfItemsInSection:0];
    if (rowCount > 2) {
        return [self getAttributesWhen3orMoreRows:indexPath];
    } else {
        return [self getAttributesWhenLessThan2:indexPath];
    }
}

- (UICollectionViewLayoutAttributes *)getAttributesWhen3orMoreRows:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.size = CGSizeMake(cellWidth, cellHeight);
    
    CGFloat originY = [self getOriginYWithOffsetY:self.collectionView.contentOffset.y row:indexPath.row];
    CGFloat centerY = originY + self.collectionView.contentOffset.y + cellHeight / 2.0;
    attributes.center = CGPointMake(CGRectGetWidth(self.collectionView.frame) / 2, centerY);
    
    CGFloat rat = [self transformRatio:originY];
    attributes.transform = CGAffineTransformMakeScale(rat, rat);
    
    CGFloat blur = 0;
    if ((1 - 1.14 * rat) < 0) {
        blur = 0;
    } else {
        blur = powf((1 - 1.4 * rat), 0.4);
    }
    [self.blurList setObject:@(blur) atIndexedSubscript:indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateBlur:forRow:)]) {
        [self.delegate updateBlur:blur forRow:indexPath.row];
    }
    
    attributes.zIndex = originY;
    return attributes;
}

- (UICollectionViewLayoutAttributes *)getAttributesWhenLessThan2:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGFloat originY = GBL_UIKIT_D1 + indexPath.row * (cellHeight + GBL_UIKIT_D0);
    attributes.frame = CGRectMake(GBL_UIKIT_D0, originY, cellWidth, cellHeight);
    return attributes;
}

- (CGFloat)getOriginYWithOffsetY:(CGFloat)offsetY row:(NSInteger)row
{
    CGFloat x = offsetY;
    CGFloat ni = [self defaultYWithRow:row];
    CGFloat mi = self.m0 + row * self.delteOffsetY;
    CGFloat tmp = mi - x;
    CGFloat y = 0;
    if (tmp >= 0) {
        y = powf(tmp / mi, 4) * ni;
    } else {
        y = 0 - (cellHeight - tmp);
    }
    return y;
}

- (CGFloat)transformRatio:(CGFloat)originY
{
    if (originY < 0) {
        return 1;
    }
    CGFloat range = [UIScreen mainScreen].bounds.size.height;
    originY = fminf(originY, range);
    CGFloat ratio = powf(originY / range, 0.04);
    return ratio;
}

- (CGFloat)defaultYWithRow:(NSInteger)row
{
    CGFloat x0 = 0;
    CGFloat xi = x0 - self.delteOffsetY * row;
    CGFloat ni = powf((self.m0 - xi) / self.m0, 4) * self.n0;
    return ni;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return !CGRectEqualToRect(newBounds, self.collectionView.bounds);
}

@end
