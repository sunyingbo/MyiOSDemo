//
//  CarouselViewModel.m
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/7/3.
//

#import "CarouselViewModel.h"
#import "CarouseModel.h"

@implementation CarouselViewModel

- (void)getData
{
    NSInteger count = 20;
    NSMutableArray *data = [[NSMutableArray alloc] initWithCapacity:count];
    int frakeIndex = 0;
    for (int i = 0; i < count; i++) {
        CarouseModel *model = [[CarouseModel alloc] init];
        model.p_price = 10.0 + i;
        model.p_name = [NSString stringWithFormat:@"%@这是一款商品这是一款商品这是一款商品", @(i)];
        model.p_imageURL = [NSString stringWithFormat:@"pic_%d.jpg", frakeIndex];
        frakeIndex++;
        frakeIndex = frakeIndex > 3 ? 0 : frakeIndex;
        [data addObject:model];
    }
    self.data = data;
}

@end
