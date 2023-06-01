//
//  CollectionViewCell6.m
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/5/29.
//

#import "CollectionViewCell6.h"

@implementation CollectionViewCell6

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        self.contentMode = UIViewContentModeScaleAspectFill;
    }
    return self;
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    self.imageView.frame = bounds;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    if (highlighted) {
        self.imageView.alpha = 0.7f;
    } else {
        self.imageView.alpha = 1.f;
    }
}

@end
