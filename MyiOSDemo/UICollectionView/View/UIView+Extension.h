//
//  UIView+Extension.h
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/6/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Extension)

@property (nonatomic, assign) CGFloat originX;
@property (nonatomic, assign) CGFloat originY;
@property (nonatomic, assign) CGFloat endX;
@property (nonatomic, assign) CGFloat endY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGPoint centerOfCurrentView;
@property (nonatomic, assign) CGFloat centerXOfCurrentView;
@property (nonatomic, assign) CGFloat centerYOfCurrentView;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

- (void)cornerRadius:(CGFloat)cornerRadius borderColor:(CGColorRef)borderColor borderWidth:(CGFloat)borderWidth;

@end

NS_ASSUME_NONNULL_END
