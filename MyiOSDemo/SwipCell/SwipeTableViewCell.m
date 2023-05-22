//
//  SwipeTableViewCell.m
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/5/12.
//

#import "SwipeTableViewCell.h"

static CGFloat const MinTrigerSpeed = 1000.0f;

@interface SwipeTableViewCell ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIPanGestureRecognizer *edgePanGesture;

@property (nonatomic, assign) BOOL buttonHidden;
@property (nonatomic, assign) BOOL buttonMoving;

@property (nonatomic, assign) CGFloat realContainerViewVisibleWidth;
@property (nonatomic, assign) CGFloat leftMarginGesture;

@property (nonatomic, strong) UILabel *uiLabel;

@end

@implementation SwipeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.realContainerViewVisibleWidth = self.contentView.frame.size.width;
        self.leftMarginGesture = self.contentView.frame.size.width / 7 * 2;
        self.buttonHidden = YES;
        
        self.contentView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.button];
        [self.contentView addSubview:self.containerView];
        [self.containerView addSubview:self.uiLabel];
    }
    return self;
}

-(void)updateCell:(NSString *)text
{
    self.uiLabel.text = text;
}

- (UIButton *)button
{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(0, 0, 100, self.contentView.frame.size.height);
        _button.backgroundColor = [UIColor blackColor];
        [_button setTitle:@"Next" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(nextAd:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (void)nextAd:(UIButton *)button
{
    NSLog(@"yingbo3 nextAd");
}

- (UIView *)containerView
{
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.frame = CGRectMake(0, 0, self.contentView.bounds.size.width / 7 * 9.5, self.contentView.bounds.size.height);
        _containerView.backgroundColor = [UIColor whiteColor];
        [_containerView addGestureRecognizer:self.edgePanGesture];
    }
    return _containerView;
}

- (UILabel *)uiLabel
{
    if (!_uiLabel) {
        _uiLabel = [[UILabel alloc] init];
        _uiLabel.frame = CGRectMake(0, 0, 100, 30);
        _uiLabel.font = [UIFont systemFontOfSize:15];
        _uiLabel.textColor = [UIColor blackColor];
    }
    return _uiLabel;
}

- (UIPanGestureRecognizer *)edgePanGesture
{
    if (!_edgePanGesture) {
        _edgePanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
        _edgePanGesture.delegate = self;
    }
    return _edgePanGesture;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view];
    if (self.buttonHidden) {
        return point.x > self.leftMarginGesture;
    } else {
        return YES;
    }
    return NO;
}

- (void)panGestureRecognizer:(UIPanGestureRecognizer *)recognizer
{
    CGPoint point = [recognizer translationInView:self.containerView];
    CGFloat velocityX = [recognizer velocityInView:self.containerView].x;
    // 轻扫
    if (self.buttonHidden && velocityX > MinTrigerSpeed) {
        [self showMenu:YES];
    } else if (!self.buttonHidden && velocityX < -MinTrigerSpeed) {
        [self showMenu:NO];
    }
    // 拖动
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.buttonMoving = YES;
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat buttonVisibleWidth = self.leftMarginGesture;
        CGRect frame = self.containerView.frame;
        CGFloat originX = frame.origin.x + point.x;
        if (originX > buttonVisibleWidth) {
            frame.origin.x = buttonVisibleWidth;
        } else if (originX < 0) {
            frame.origin.x = 0;
        } else {
            frame.origin.x += point.x;
        }
        self.containerView.frame = frame;
        [recognizer setTranslation:CGPointZero inView:self.contentView];
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        [self showMenu:self.containerView.frame.origin.x > self.leftMarginGesture / 2];
        self.buttonMoving = NO;
    } else if (recognizer.state == UIGestureRecognizerStateFailed || recognizer.state == UIGestureRecognizerStateCancelled) {
        [self hideMenu];
        self.buttonMoving = NO;
    }
}

- (void)hideMenu
{
    if (!self.buttonHidden || self.buttonMoving) {
        [self showMenu:NO];
    }
}

- (void)showMenu
{
    if (self.buttonHidden) {
        [self showMenu:YES];
    }
}

- (void)showMenu:(BOOL)show
{
    CGFloat buttonWidth = self.contentView.bounds.size.width - self.realContainerViewVisibleWidth;
    NSTimeInterval duration = (show ? (buttonWidth - self.containerView.frame.origin.x) / buttonWidth : self.containerView.frame.origin.x / buttonWidth) * 0.3;
    [UIView animateWithDuration:duration animations:^{
        CGRect frame = self.containerView.frame;
        frame.origin.x = show ? self.leftMarginGesture : 0;
        self.containerView.frame = frame;
    } completion:^(BOOL finished) {
        self.buttonHidden = !show;
    }];
}

@end
