//
//  GridListCollectionViewCell.h
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/7/3.
//

#import <UIKit/UIKit.h>
#import "GridListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GridListCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) BOOL isGrid;
@property (nonatomic, strong) GridListModel *model;

@end

NS_ASSUME_NONNULL_END
