//
//  GridListCollectionViewCell.m
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/7/3.
//

#import "GridListCollectionViewCell.h"
#import "GridListModel.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width

@interface GridListCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLable;

@end

@implementation GridListCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureUI];
    }
    return self;
}

- (void)configureUI
{
    self.imageV = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.imageV];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [self.contentView addSubview:self.titleLabel];
    
    self.priceLable = [[UILabel alloc] initWithFrame:CGRectZero];
    self.priceLable.textColor = [UIColor redColor];
    self.priceLable.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:self.priceLable];
}

- (void)setIsGrid:(BOOL)isGrid
{
    _isGrid = isGrid;
    if (isGrid) {
        self.imageV.frame = CGRectMake(5, 5, self.bounds.size.width - 60, self.bounds.size.width - 60);
        self.titleLabel.frame = CGRectMake(5, self.bounds.size.width - 45, ScreenWidth / 2, 20);
        self.priceLable.frame = CGRectMake(5, self.bounds.size.width - 20, ScreenWidth / 2, 20);
    } else {
        self.imageV.frame = CGRectMake(5, 5, self.bounds.size.height - 10, self.bounds.size.height - 10);
        self.titleLabel.frame = CGRectMake(self.bounds.size.height + 10, 0, ScreenWidth / 2, self.bounds.size.height - 20);
        self.priceLable.frame = CGRectMake(self.bounds.size.height + 10, self.bounds.size.height - 30, ScreenWidth / 2, 20);
    }
}

- (void)setModel:(GridListModel *)model
{
    _model = model;
    [self.imageV setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.imageUrl]]]];
    self.titleLabel.text = model.wname;
    self.priceLable.text = [NSString stringWithFormat:@"¥%.2f", model.jdPrice];
}

@end
