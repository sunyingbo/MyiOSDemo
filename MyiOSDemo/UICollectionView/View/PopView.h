//
//  PopView.h
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/6/19.
//

#import <UIKit/UIKit.h>
#import "ItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PopViewDelegate <NSObject>

- (void)selectedHero:(ItemModel *)item;
- (void)closePopView;

@end

@interface PopView : UIView

@property (nonatomic, weak) id<PopViewDelegate> delegate;
@property (nonatomic, strong) NSArray *dataSource;

- (void)showInSuperView:(UIView *)superView;

@end

NS_ASSUME_NONNULL_END
