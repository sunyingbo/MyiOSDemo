//
//  ProductsHeaderView.h
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/3/8.
//

#import <UIKit/UIKit.h>
#import "ProductGroupModel.h"

NS_ASSUME_NONNULL_BEGIN
@class ProductsHeaderView;

// 定义一个 协议
@protocol ProductsHeaderViewDelegate <NSObject>

- (void)headerViewDidClickBtn:(ProductsHeaderView *)headerView;

@end

@interface ProductsHeaderView : UITableViewHeaderFooterView

@property (nonatomic, assign) id<ProductsHeaderViewDelegate>delegate;
@property (nonatomic, strong) ProductGroupModel *groupModel;

+ (instancetype)productsHeaderViewWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
