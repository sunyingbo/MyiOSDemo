//
//  FlowLayout7.h
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/6/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CollectionViewFlowLayoutDelegate <NSObject>

- (void)collectionViewScrollToIndex:(NSInteger)index;

@end

@interface FlowLayout7 : UICollectionViewFlowLayout

@property (nonatomic, assign) id<CollectionViewFlowLayoutDelegate> delegate;
@property (nonatomic, assign) BOOL needAlpha;

@end

NS_ASSUME_NONNULL_END
