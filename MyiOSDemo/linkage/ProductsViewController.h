//
//  ProductsViewController.h
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/2/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ProductsDelegate <NSObject>

- (void)willDisplayHeaderView:(NSInteger)section;
- (void)didEndDisplayHeaderView:(NSInteger)section;

@end

@interface ProductsViewController : UIViewController

@property (nonatomic, strong) id<ProductsDelegate> delegate;

/// 当 linkageTableView 滚动时，ProductsTableView 跟随滚动至指定 section
/// - Parameter indexPath: 指定 section
- (void) scrollToSelectedIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
