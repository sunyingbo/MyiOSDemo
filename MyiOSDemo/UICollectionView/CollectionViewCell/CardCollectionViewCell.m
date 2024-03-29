//
//  CardCollectionViewCell.m
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/6/30.
//

#import "CardCollectionViewCell.h"

@interface CardCollectionViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIVisualEffectView *blurView;

@end

static int cellCount;

@implementation CardCollectionViewCell

- (instancetype)init
{
    self = [self initWithFrame:CGRectZero];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
        cellCount++;
    }
    return self;
}

- (void)layoutSubviews
{
    self.contentView.frame = self.bounds;
    self.titleLabel.center = CGPointMake(self.bounds.size.width / 2.0, 2 + self.titleLabel.frame.size.height / 2.0);
    self.imageView.frame = self.bounds;
    self.blurView.frame = self.bounds;
}

- (void)initUI
{
    [self.contentView addSubview:self.titleLabel];
    self.layer.cornerRadius = 6;
    self.layer.masksToBounds = YES;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
    [self.titleLabel sizeToFit];
    [self setNeedsLayout];
}

- (void)setBgColor:(UIColor *)bgColor
{
    self.contentView.backgroundColor = bgColor;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    [self.imageView removeFromSuperview];
    self.imageView = [[UIImageView alloc] initWithImage:image];
    [self.contentView addSubview:self.imageView];
}

- (void)setBlur:(CGFloat)ratio
{
    if (!self.blurView.superview) {
        [self.contentView addSubview:self.blurView];
    }
    [self.contentView bringSubviewToFront:self.blurView];
    self.blurView.alpha = ratio;
}

- (UIVisualEffectView *)blurView
{
    if (!_blurView) {
        _blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        _blurView.frame = self.bounds;
    }
    return _blurView;
}

@end
