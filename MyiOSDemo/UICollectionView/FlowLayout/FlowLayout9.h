//
//  FlowLayout9.h
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/6/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SlideIndexBlock)(NSInteger index);

@interface FlowLayout9 : UICollectionViewLayout

@property (nonatomic, copy) SlideIndexBlock slideIndexBlock;
@property (nonatomic) NSInteger visibleCount;
@property (nonatomic) CGSize itemSize;

@end

NS_ASSUME_NONNULL_END
