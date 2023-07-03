//
//  CarouselUIService.h
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/7/3.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class CarouselViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface CarouselUIService : NSObject<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) CarouselViewModel *viewModel;

@end

NS_ASSUME_NONNULL_END
