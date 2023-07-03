//
//  CarouseCollectionViewCell.m
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/7/3.
//

#import "CarouseCollectionViewCell.h"
#import "CarouseModel.h"

@interface CarouseCollectionViewCell ()

@property (nonatomic, strong) UIImageView *goodImageView;
@property (nonatomic, strong) UILabel *goodNameLabel;
@property (nonatomic, strong) UILabel *goodPriceLabel;

@end

@implementation CarouseCollectionViewCell

- (void)setModel:(CarouseModel *)model
{
    _model = model;
    self.goodImageView.image = [UIImage imageNamed:model.p_imageURL];
    self.goodNameLabel.text = model.p_name;
    self.goodPriceLabel.text = [NSString stringWithFormat:@"¥%0.2f", model.p_price];
}

- (UIImageView *)goodImageView
{
    if (!_goodImageView) {
        _goodImageView = [[UIImageView alloc] init];
    }
    return _goodImageView;
}

- (UILabel *)goodNameLabel
{
    if (!_goodNameLabel) {
        _goodNameLabel = [[UILabel alloc] init];
        _goodNameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _goodNameLabel;
}

- (UILabel *)goodPriceLabel
{
    if (!_goodPriceLabel) {
        _goodPriceLabel = [[UILabel alloc] init];
        _goodPriceLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _goodPriceLabel;
}

@end
