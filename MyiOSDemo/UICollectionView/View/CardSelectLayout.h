//
//  CardSelectLayout.h
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/6/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CardSelectLayout : UICollectionViewLayout

@property (nonatomic, assign) NSIndexPath *selectedIndexPath;
@property (nonatomic, assign) CGFloat contentOffsetY;
@property (nonatomic, assign) CGFloat contentSizeHeight;

- (instancetype)initWithIndexPath:(NSIndexPath *)indexPath offsetY:(CGFloat) offsetY contentSizeHeight:(CGFloat)sizeHeight;

@end

NS_ASSUME_NONNULL_END
