//
//  CarouselUIService.m
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/7/3.
//

#import "CarouselUIService.h"
#import "CarouseCollectionViewCell.h"
#import "CarouselViewModel.h"
#import "CarouseModel.h"

@implementation CarouselUIService

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.viewModel.data.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CarouseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CarouseCollectionViewCell" forIndexPath:indexPath];
    CarouseModel *model = self.viewModel.data[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
