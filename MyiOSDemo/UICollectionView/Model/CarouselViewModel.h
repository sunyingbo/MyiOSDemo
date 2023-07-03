//
//  CarouselViewModel.h
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/7/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CarouselViewModel : NSObject

@property (nonatomic, strong) NSMutableArray *data;

- (void)getData;

@end

NS_ASSUME_NONNULL_END
