//
//  FlowLayout_6.m
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/5/30.
//

#import "FlowLayout_6.h"

typedef NS_ENUM(NSInteger, RAScrollDirection) {
    RAScrollDirectionNone,
    RAScrollDirectionUp,
    RAScrollDirectionDown
};

@interface UIImageView (FlowLayout_6)

- (void)setCellCopiedImage:(UICollectionViewCell *)cell;

@end

@implementation UIImageView (FlowLayout_6)

- (void)setCellCopiedImage:(UICollectionViewCell *)cell
{
    UIGraphicsBeginImageContextWithOptions(cell.bounds.size, NO, 4.f);
    [cell.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.image = image;
}

@end

@interface FlowLayout_6 ()

@property (nonatomic, strong) UIView *cellFakeView;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) RAScrollDirection scrollDirection;
@property (nonatomic, strong) NSIndexPath *reorderingCellIndexPath;
@property (nonatomic, assign) CGPoint reorderingCellCenter;
@property (nonatomic, assign) CGPoint cellFakeViewCenter;
@property (nonatomic, assign) CGPoint panTranslation;
@property (nonatomic, assign) UIEdgeInsets scrollTrigerEdgeInsets;
@property (nonatomic, assign) UIEdgeInsets scrollTrigerPadding;
@property (nonatomic, assign) BOOL setUped;

@end

@implementation FlowLayout_6

- (void)setDelegate:(id<CollectionViewResetFlowLayoutDelegate>)delegate
{
    self.collectionView.delegate = delegate;
}

- (id<CollectionViewResetFlowLayoutDelegate>)delegate
{
    return (id<CollectionViewResetFlowLayoutDelegate>)self.collectionView.delegate;
}

- (void)setDataSource:(id<CollectionViewResetFlowLayoutDataSource>)dataSource
{
    self.collectionView.dataSource = dataSource;
}

- (id<CollectionViewResetFlowLayoutDataSource>)dataSource
{
    return (id<CollectionViewResetFlowLayoutDataSource>)self.collectionView.dataSource;
}

- (void)prepareLayout
{
    [super prepareLayout];
    [self setUpCollectionViewGesture];
    self.scrollTrigerEdgeInsets = UIEdgeInsetsMake(50.f, 50.f, 50.f, 50.f);
    if ([self.delegate respondsToSelector:@selector(autoScrollTrigerEdgeInsets:)]) {
        self.scrollTrigerEdgeInsets = [self.delegate autoScrollTrigerEdgeInsets:self.collectionView];
    }
    self.scrollTrigerPadding = UIEdgeInsetsMake(0, 0, 0, 0);
    if ([self.delegate respondsToSelector:@selector(autoScrollTrigerPadding:)]) {
        self.scrollTrigerPadding = [self.delegate autoScrollTrigerPadding:self.collectionView];
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attribute = [super layoutAttributesForItemAtIndexPath:indexPath];
    if (attribute.representedElementCategory == UICollectionElementCategoryCell) {
        if ([attribute.indexPath isEqual:self.reorderingCellIndexPath]) {
            CGFloat alpha = 0;
            if ([self.delegate respondsToSelector:@selector(reorderingItemAlpha:)]) {
                alpha = [self.delegate reorderingItemAlpha:self.collectionView];
                if (alpha >= 1.f) {
                    alpha = 1.f;
                } else if (alpha <= 0) {
                    alpha = 0;
                }
            }
            attribute.alpha = alpha;
        }
    }
    return attribute;
}

- (void)setUpCollectionViewGesture
{
    if (!_setUped) {
        _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        self.longPressGesture.delegate = self;
        self.panGesture.delegate = self;
        for (UIGestureRecognizer *gestureRecognizer in self.collectionView.gestureRecognizers) {
            if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
                [gestureRecognizer requireGestureRecognizerToFail:self.longPressGesture];
            }
        }
        [self.collectionView addGestureRecognizer:self.longPressGesture];
        [self.collectionView addGestureRecognizer:self.panGesture];
        _setUped = YES;
    }
}

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)longPress
{
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:
            {
                NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[longPress locationInView:self.collectionView]];
                if ([self.dataSource respondsToSelector:@selector(collectionView:canMoveItemAtIndexPath:)]) {
                    if (![self.dataSource collectionView:self.collectionView canMoveItemAtIndexPath:indexPath]) {
                        return;
                    }
                }
                if ([self.delegate respondsToSelector:@selector(collectionView:layout:willBeginDraggingItemAtIndexPath:)]) {
                    [self.delegate collectionView:self.collectionView layout:self willBeginDraggingItemAtIndexPath:indexPath];
                }
                
                self.reorderingCellIndexPath = indexPath;
                self.collectionView.scrollsToTop = NO;
                UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
                self.cellFakeView = [[UIView alloc] initWithFrame:cell.frame];
                self.cellFakeView.layer.shadowColor = [UIColor blackColor].CGColor;
                self.cellFakeView.layer.shadowOffset = CGSizeMake(0, 0);
                self.cellFakeView.layer.shadowOpacity = .5f;
                self.cellFakeView.layer.shadowRadius = 3.f;
                UIImageView *cellFakeImageView = [[UIImageView alloc] initWithFrame:cell.bounds];
                UIImageView *highlightedImageView = [[UIImageView alloc] initWithFrame:cell.bounds];
                cellFakeImageView.contentMode = UIViewContentModeScaleAspectFill;
                highlightedImageView.contentMode = UIViewContentModeScaleAspectFill;
                cellFakeImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
                highlightedImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
                cell.highlighted = YES;
                [highlightedImageView setCellCopiedImage:cell];
                cell.highlighted = NO;
                [cellFakeImageView setCellCopiedImage:cell];
                [self.collectionView addSubview:self.cellFakeView];
                [self.cellFakeView addSubview:cellFakeImageView];
                [self.cellFakeView addSubview:highlightedImageView];
                self.reorderingCellCenter = cell.center;
                self.cellFakeViewCenter = self.cellFakeView.center;
                [self invalidateLayout];
                CGRect fakeViewRect = CGRectMake(cell.center.x - (self.smallCellSize.width / 2.f), cell.center.y - (self.smallCellSize.height / 2.f), self.smallCellSize.width, self.smallCellSize.height);
                [UIView animateWithDuration:.3f delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.cellFakeView.center = cell.center;
                    self.cellFakeView.frame = fakeViewRect;
                    self.cellFakeView.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
                    highlightedImageView.alpha = 0;
                } completion:^(BOOL finished) {
                    [highlightedImageView removeFromSuperview];
                }];
                if ([self.delegate respondsToSelector:@selector(collectionView:layout:didBeginDraggingItemAtIndexPath:)]) {
                    [self.delegate collectionView:self.collectionView layout:self didBeginDraggingItemAtIndexPath:indexPath];
                }
                break;
            }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            {
                NSIndexPath *currentCellIndexPath = self.reorderingCellIndexPath;
                if ([self.delegate respondsToSelector:@selector(collectionView:layout:willEndDraggingItemAtIndexPath:)]) {
                    [self.delegate collectionView:self.collectionView layout:self willEndDraggingItemAtIndexPath:currentCellIndexPath];
                }
                
                self.collectionView.scrollsToTop = YES;
                [self invalidateDisplayLink];
                UICollectionViewLayoutAttributes *attribute = [self layoutAttributesForItemAtIndexPath:currentCellIndexPath];
                [UIView animateWithDuration:.3f delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.cellFakeView.transform = CGAffineTransformIdentity;
                    self.cellFakeView.frame = attribute.frame;
                } completion:^(BOOL finished) {
                    [self.cellFakeView removeFromSuperview];
                    self.cellFakeView = nil;
                    self.reorderingCellIndexPath = nil;
                    self.reorderingCellCenter = CGPointZero;
                    self.cellFakeViewCenter = CGPointZero;
                    [self invalidateLayout];
                    if (finished) {
                        if ([self.delegate respondsToSelector:@selector(collectionView:layout:didEndDraggingItemAtIndexPath:)]) {
                            [self.delegate collectionView:self.collectionView layout:self didEndDraggingItemAtIndexPath:currentCellIndexPath];
                        }
                    }
                }];
                break;
            }
        default:
            break;
    }
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)pan
{
    switch (pan.state) {
        case UIGestureRecognizerStateChanged:
            {
                self.panTranslation = [pan translationInView:self.collectionView];
                self.cellFakeView.center = CGPointMake(self.cellFakeViewCenter.x + self.panTranslation.x, self.cellFakeViewCenter.y + self.panTranslation.y);
                [self moveItemIfNeeded];
                if (CGRectGetMaxY(self.cellFakeView.frame) >= self.collectionView.contentOffset.y + (self.collectionView.bounds.size.height - self.scrollTrigerEdgeInsets.bottom - self.scrollTrigerPadding.bottom)) {
                    if (ceilf(self.collectionView.contentOffset.y) < self.collectionView.contentSize.height - self.collectionView.bounds.size.height) {
                        self.scrollDirection = RAScrollDirectionDown;
                        [self setUpDisplayLink];
                    }
                } else if (CGRectGetMinY(self.cellFakeView.frame) <= self.collectionView.contentOffset.y + self.scrollTrigerEdgeInsets.top + self.scrollTrigerPadding.top) {
                    if (self.collectionView.contentOffset.y >= self.collectionView.contentInset.top) {
                        self.scrollDirection = RAScrollDirectionUp;
                        [self setUpDisplayLink];
                    }
                } else {
                    self.scrollDirection = RAScrollDirectionNone;
                    [self invalidateDisplayLink];
                }
                break;
            }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
            {
                [self invalidateDisplayLink];
                break;
            }
        default:
            break;
    }
}

- (void)setUpDisplayLink
{
    if (_displayLink) {
        return;
    }
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(autoScroll)];
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)invalidateDisplayLink
{
    [self.displayLink invalidate];
    self.displayLink = nil;
}

- (void)autoScroll
{
    CGPoint contentOffset = self.collectionView.contentOffset;
    UIEdgeInsets contentInset = self.collectionView.contentInset;
    CGSize contentSize = self.collectionView.contentSize;
    CGSize boundsSize = self.collectionView.bounds.size;
    CGFloat increment = 0;
    
    if (self.scrollDirection == RAScrollDirectionDown) {
        CGFloat percentage = (((CGRectGetMaxY(self.cellFakeView.frame) - contentOffset.y) - (boundsSize.height - self.scrollTrigerEdgeInsets.bottom - self.scrollTrigerPadding.bottom)) / self.scrollTrigerEdgeInsets.bottom);
        increment = 10 * percentage;
        if (increment >= 10.f) {
            increment = 10.f;
        }
    } else if (self.scrollDirection == RAScrollDirectionUp) {
        CGFloat percentage = (1.f - ((CGRectGetMinY(self.cellFakeView.frame) - contentOffset.y - self.scrollTrigerPadding.top) / self.scrollTrigerEdgeInsets.top));
        increment = -10.f * percentage;
        if (increment <= -10.f) {
            increment = -10.f;
        }
    }
    
    if (contentOffset.y + increment <= -contentInset.top) {
        [UIView animateWithDuration:.07f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            CGFloat diff = -contentInset.top - contentOffset.y;
            self.collectionView.contentOffset = CGPointMake(contentOffset.x, -contentInset.top);
            self.cellFakeViewCenter = CGPointMake(self.cellFakeViewCenter.x, self.cellFakeViewCenter.y + diff);
            self.cellFakeView.center = CGPointMake(self.cellFakeViewCenter.x + self.panTranslation.x, self.cellFakeViewCenter.y + self.panTranslation.y);
        } completion:nil];
        [self invalidateDisplayLink];
        return;
    } else if (contentOffset.y + increment >= contentSize.height - boundsSize.height - contentInset.bottom) {
        [UIView animateWithDuration:.07f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            CGFloat diff = contentSize.height - boundsSize.height - contentInset.bottom - contentOffset.y;
            self.collectionView.contentOffset = CGPointMake(contentOffset.x, contentSize.height - boundsSize.height - contentInset.bottom);
            self.cellFakeViewCenter = CGPointMake(self.cellFakeViewCenter.x, self.cellFakeViewCenter.y + diff);
            self.cellFakeView.center = CGPointMake(self.cellFakeViewCenter.x + self.panTranslation.x, self.cellFakeViewCenter.y + self.panTranslation.y);
        } completion:nil];
        [self invalidateDisplayLink];
        return;
    }
    
    [self.collectionView performBatchUpdates:^{
        self.cellFakeViewCenter = CGPointMake(self.cellFakeViewCenter.x, self.cellFakeViewCenter.y + increment);
        self.cellFakeView.center = CGPointMake(self.cellFakeViewCenter.x + self.panTranslation.x, self.cellFakeViewCenter.y + self.panTranslation.y);
        self.collectionView.contentOffset = CGPointMake(contentOffset.x, contentOffset.y + increment);
    } completion:nil];
    [self moveItemIfNeeded];
}

- (void)moveItemIfNeeded
{
    NSIndexPath *atIndexPath = self.reorderingCellIndexPath;
    NSIndexPath *toIndexPath = [self.collectionView indexPathForItemAtPoint:self.cellFakeView.center];
    
    if (toIndexPath == nil || [atIndexPath isEqual:toIndexPath]) {
        return;
    }
    
    if ([self.dataSource respondsToSelector:@selector(collectionView:itemAtIndexPath:canMoveToIndexPath:)]) {
        if (![self.dataSource collectionView:self.collectionView itemAtIndexPath:atIndexPath canMoveToIndexPath:toIndexPath]) {
            return;
        }
    }
    
    if ([self.dataSource respondsToSelector:@selector(collectionView:itemAtIndexPath:willMoveToIndexPath:)]) {
        [self.dataSource collectionView:self.collectionView itemAtIndexPath:atIndexPath willMoveToIndexPath:toIndexPath];
    }
    
    [self.collectionView performBatchUpdates:^{
        self.reorderingCellIndexPath = toIndexPath;
        [self.collectionView moveItemAtIndexPath:atIndexPath toIndexPath:toIndexPath];
        if ([self.dataSource respondsToSelector:@selector(collectionView:itemAtIndexPath:didMoveToIndexPath:)]) {
            [self.dataSource collectionView:self.collectionView itemAtIndexPath:atIndexPath didMoveToIndexPath:toIndexPath];
        }
    } completion:nil];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([self.panGesture isEqual:gestureRecognizer]) {
        if (self.longPressGesture.state == 0 || self.longPressGesture.state == 5) {
            return NO;
        }
    } else if ([self.longPressGesture isEqual:gestureRecognizer]) {
        if (self.collectionView.panGestureRecognizer.state != 0 && self.collectionView.panGestureRecognizer.state != 5) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([self.panGesture isEqual:gestureRecognizer]) {
        if (self.longPressGesture.state != 0 && self.longPressGesture.state != 5) {
            if ([self.longPressGesture isEqual:otherGestureRecognizer]) {
                return YES;
            }
            return NO;
        }
    } else if ([self.longPressGesture isEqual:gestureRecognizer]) {
        if ([self.panGesture isEqual:otherGestureRecognizer]) {
            return YES;
        }
    } else if ([self.collectionView.panGestureRecognizer isEqual:gestureRecognizer]) {
        if (self.longPressGesture.state == 0 || self.longPressGesture.state == 5) {
            return NO;
        }
    }
    return YES;
}

@end
