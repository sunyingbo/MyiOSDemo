//
//  CardLayout.h
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/6/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CardLayoutDelegate <NSObject>

- (void)updateBlur:(CGFloat)blur forRow:(NSInteger)row;

@end

@interface CardLayout : UICollectionViewLayout

@property (nonatomic, assign) CGFloat offsetY;
@property (nonatomic, assign) CGFloat contentSizeHeight;
@property (nonatomic, strong) NSMutableArray *blurList;
@property (nonatomic, weak) id<CardLayoutDelegate> delegate;

- (instancetype)initWithOffsetY:(CGFloat)offsetY;

@end

NS_ASSUME_NONNULL_END
