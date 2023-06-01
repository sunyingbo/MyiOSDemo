//
//  FlowLayout6.m
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/5/29.
//

#import "FlowLayout6.h"

@interface FlowLayout6 ()

@property (nonatomic, assign) NSInteger numberOfCells;
@property (nonatomic, assign) CGFloat numberOfLines;
@property (nonatomic, assign) CGFloat itemSpacing;
@property (nonatomic, assign) CGFloat lineSpacing;
@property (nonatomic, assign) CGFloat sectionSpacing;
@property (nonatomic, assign) CGSize collectionViewSize;
@property (nonatomic, assign) UIEdgeInsets insets;
@property (nonatomic, assign) CGRect oldRect;
@property (nonatomic, strong) NSArray *oldArray;
@property (nonatomic, strong) NSMutableArray *largeCellSizeArray;
@property (nonatomic, strong) NSMutableArray *smallCellSizeArray;

@end

@implementation FlowLayout6

- (void)prepareLayout
{
    [super prepareLayout];
    self.collectionViewSize = self.collectionView.bounds.size;
    self.itemSpacing = 0;
    self.lineSpacing = 0;
    self.sectionSpacing = 0;
    self.insets = UIEdgeInsetsMake(0, 0, 0, 0);
    if ([self.delegate respondsToSelector:@selector(minimumInteritemSpacingForCollectionView:)]) {
        self.itemSpacing = [self.delegate minimumInteritemSpacingForCollectionView:self.collectionView];
    }
    if ([self.delegate respondsToSelector:@selector(minimumLineSpacingForCollectionView:)]) {
        self.lineSpacing = [self.delegate minimumLineSpacingForCollectionView:self.collectionView];
    }
    if ([self.delegate respondsToSelector:@selector(sectionSpacingForCollectionView:)]) {
        self.sectionSpacing = [self.delegate sectionSpacingForCollectionView:self.collectionView];
    }
    if ([self.delegate respondsToSelector:@selector(insetsForCollectionView:)]) {
        self.insets = [self.delegate insetsForCollectionView:self.collectionView];
    }
}

- (CGFloat)contentHeight
{
    CGFloat contentHeight = 0;
    NSInteger numberOfSections = self.collectionView.numberOfSections;
    CGSize collectionViewSize = self.collectionView.bounds.size;
    
    UIEdgeInsets insets = UIEdgeInsetsZero;
    if ([self.delegate respondsToSelector:@selector(insetsForCollectionView:)]) {
        insets = [self.delegate insetsForCollectionView:self.collectionView];
    }
    CGFloat sectionSpacing = 0;
    if ([self.delegate respondsToSelector:@selector(sectionSpacingForCollectionView:)]) {
        sectionSpacing = [self.delegate sectionSpacingForCollectionView:self.collectionView];
    }
    CGFloat itemSpacing = 0;
    if ([self.delegate respondsToSelector:@selector(minimumInteritemSpacingForCollectionView:)]) {
        itemSpacing = [self.delegate minimumInteritemSpacingForCollectionView:self.collectionView];
    }
    CGFloat lineSpacing = 0;
    if ([self.delegate respondsToSelector:@selector(minimumLineSpacingForCollectionView:)]) {
        lineSpacing = [self.delegate minimumLineSpacingForCollectionView:self.collectionView];
    }
    
    contentHeight += insets.top + insets.bottom + sectionSpacing * (numberOfSections - 1);
    
    CGFloat lastSmallCellHeight = 0;
    for (NSInteger i = 0; i < numberOfSections; i++) {
        NSInteger numberOfLines = ceil((CGFloat)[self.collectionView numberOfItemsInSection:i] / 3.f);
        
        CGFloat largeCellSideLength = (2.f * (collectionViewSize.width - insets.left - insets.right) - itemSpacing) / 3.f;
        CGFloat smallCellSideLength = (largeCellSideLength - itemSpacing) / 2.f;
        CGSize largeCellSize = CGSizeMake(largeCellSideLength, largeCellSideLength);
        CGSize smallCellSize = CGSizeMake(smallCellSideLength, smallCellSideLength);
        if ([self.delegate respondsToSelector:@selector(collectionView:sizeForLargeItemsInSection:)]) {
            if (!CGSizeEqualToSize([self.delegate collectionView:self.collectionView sizeForLargeItemsInSection:i], CGSizeZero)) {
                largeCellSize = [self.delegate collectionView:self.collectionView sizeForLargeItemsInSection:i];
                smallCellSize = CGSizeMake(collectionViewSize.width - largeCellSize.width - itemSpacing - insets.left - insets.right, (largeCellSize.height / 2.f) - (itemSpacing / 2.f));
            }
        }
        lastSmallCellHeight = smallCellSize.height;
        CGFloat largeCellHeight = largeCellSize.height;
        CGFloat lineHeight = numberOfLines * (largeCellHeight + lineSpacing) - lineSpacing;
        contentHeight += lineHeight;
    }
    
    NSInteger numberOfItemsInLastSection = [self.collectionView numberOfItemsInSection:numberOfSections - 1];
    if ((numberOfItemsInLastSection - 1) % 3 == 0 && (numberOfItemsInLastSection - 1) % 6 != 0) {
        contentHeight -= lastSmallCellHeight + itemSpacing;
    }
    return contentHeight;
}

- (void)setDelegate:(id<CollectionViewFlowLayoutDelegate>)delegate
{
    self.collectionView.delegate = delegate;
}

- (id<CollectionViewFlowLayoutDelegate>)delegate
{
    return (id<CollectionViewFlowLayoutDelegate>) self.collectionView.delegate;
}

- (CGSize)collectionViewContentSize
{
    CGSize contentSize = CGSizeMake(self.collectionViewSize.width, 0);
    for (NSInteger i = 0; i < self.collectionView.numberOfSections; i++) {
        if ([self.collectionView numberOfItemsInSection:i] == 0) {
            break;
        }
        NSInteger numberOfLines = ceil((CGFloat)[self.collectionView numberOfItemsInSection:i] / 3.f);
        CGFloat lineHeight = numberOfLines * ([self.largeCellSizeArray[i] CGSizeValue].height + self.lineSpacing) - self.lineSpacing;
        contentSize.height += lineHeight;
    }
    contentSize.height += self.insets.top + self.insets.bottom + self.sectionSpacing * (self.collectionView.numberOfSections - 1);
    NSInteger numberOfItemsInLastSection = [self.collectionView numberOfItemsInSection:self.collectionView.numberOfSections - 1];
    if ((numberOfItemsInLastSection - 1) % 3 == 0 && (numberOfItemsInLastSection - 1) % 6 != 0) {
        contentSize.height -= [self.smallCellSizeArray[self.collectionView.numberOfSections - 1] CGSizeValue].height + self.itemSpacing;
    }
    return contentSize;
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    self.oldRect = rect;
    NSMutableArray *attributesArray = [NSMutableArray array];
    for (NSInteger i = 0; i < self.collectionView.numberOfSections; i++) {
        NSInteger numberOfCellsInSection = [self.collectionView numberOfItemsInSection:i];
        for (NSInteger j = 0; j < numberOfCellsInSection; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            if (CGRectIntersectsRect(rect, attributes.frame)) {
                [attributesArray addObject:attributes];
            }
        }
    }
    self.oldArray = attributesArray;
    return attributesArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    // cellSize
    CGFloat largeCellSideLength = (2.f * (self.collectionViewSize.width - self.insets.left - self.insets.right) - self.itemSpacing) / 3.f;
    CGFloat smallCellSideLength = (largeCellSideLength - self.itemSpacing) / 2.f;
    _largeCellSize = CGSizeMake(largeCellSideLength, largeCellSideLength);
    _smallCellSize = CGSizeMake(smallCellSideLength, smallCellSideLength);
    if ([self.delegate respondsToSelector:@selector(collectionView:sizeForLargeItemsInSection:)]) {
        if (!CGSizeEqualToSize([self.delegate collectionView:self.collectionView sizeForLargeItemsInSection:indexPath.section], CGSizeZero)) {
            _largeCellSize = [self.delegate collectionView:self.collectionView sizeForLargeItemsInSection:indexPath.section];
            _smallCellSize = CGSizeMake(self.collectionViewSize.width - _largeCellSize.width - self.itemSpacing - self.insets.left - self.insets.right, (_largeCellSize.height / 2.f) - (_itemSpacing / 2.f));
        }
    }
    if (!_largeCellSizeArray) {
        _largeCellSizeArray = [NSMutableArray array];
    }
    if (!_smallCellSizeArray) {
        _smallCellSizeArray = [NSMutableArray array];
    }
    self.largeCellSizeArray[indexPath.section] = [NSValue valueWithCGSize:_largeCellSize];
    self.smallCellSizeArray[indexPath.section] = [NSValue valueWithCGSize:_smallCellSize];
    
    // section height
    CGFloat sectionHeight = 0;
    for (NSInteger i = 0; i <= indexPath.section - 1; i++) {
        NSInteger cellsCount = [self.collectionView numberOfItemsInSection:i];
        CGFloat largeCellHeight = [self.largeCellSizeArray[i] CGSizeValue].height;
        CGFloat smallCellHeight = [self.smallCellSizeArray[i] CGSizeValue].height;
        NSInteger lines = ceil((CGFloat)cellsCount / 3.f);
        sectionHeight += lines * (self.lineSpacing + largeCellHeight) + self.sectionSpacing;
        if ((cellsCount - 1) % 3 == 0 && (cellsCount - 1) % 6 != 0) {
            sectionHeight -= smallCellHeight + self.itemSpacing;
        }
    }
    if (sectionHeight > 0) {
        sectionHeight -= self.lineSpacing;
    }
    
    NSInteger line = indexPath.item / 3;
    CGFloat lineSpaceForIndexPath = self.lineSpacing * line;
    CGFloat lineOriginY = _largeCellSize.height * line + sectionHeight + lineSpaceForIndexPath + self.insets.top;
    CGFloat rightSideLargeCellOriginX = self.collectionViewSize.width - _largeCellSize.width - self.insets.right;
    CGFloat rightSideSmallCellOriginX = self.collectionViewSize.width - _smallCellSize.width - self.insets.right;
    
    if (indexPath.item % 6 == 0) {
        attribute.frame = CGRectMake(self.insets.left, lineOriginY, _largeCellSize.width, _largeCellSize.height);
    } else if ((indexPath.item + 1) % 6 == 0) {
        attribute.frame = CGRectMake(rightSideLargeCellOriginX, lineOriginY, _largeCellSize.width, _largeCellSize.height);
    } else if (line % 2 == 0) {
        if (indexPath.item % 2 != 0) {
            attribute.frame = CGRectMake(rightSideSmallCellOriginX, lineOriginY, _smallCellSize.width, _smallCellSize.height);
        } else {
            attribute.frame = CGRectMake(rightSideSmallCellOriginX, lineOriginY + _smallCellSize.height + self.itemSpacing, _smallCellSize.width, _smallCellSize.height);
        }
    } else {
        if (indexPath.item % 2 != 0) {
            attribute.frame = CGRectMake(self.insets.left, lineOriginY, _smallCellSize.width, _smallCellSize.height);
        } else {
            attribute.frame = CGRectMake(self.insets.left, lineOriginY + _smallCellSize.height + self.itemSpacing, _smallCellSize.width, _smallCellSize.height);
        }
    }
    return attribute;
}

@end
