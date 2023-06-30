//
//  CardCollectionViewCell.h
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/6/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CardCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIColor *bgColor;
@property (nonatomic, strong) UIImage *image;

- (void)setBlur:(CGFloat)ratio;

@end

NS_ASSUME_NONNULL_END
