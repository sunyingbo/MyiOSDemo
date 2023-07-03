//
//  CarouseCollectionViewCell.h
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/7/3.
//

#import <UIKit/UIKit.h>
@class CarouseModel;

NS_ASSUME_NONNULL_BEGIN

@interface CarouseCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) CarouseModel *model;

@end

NS_ASSUME_NONNULL_END
