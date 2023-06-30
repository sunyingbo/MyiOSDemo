//
//  PopView.m
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/6/19.
//

#import "PopView.h"
#import "FlowLayout7.h"
#import "Masonry.h"
#import "PopCollectionViewCell.h"
#import "UIView+Extension.h"
#import "Constant.h"

@interface PopView()<UICollectionViewDelegate, UICollectionViewDataSource, CollectionViewFlowLayoutDelegate>

@property (nonatomic, strong) UIView *underBackView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, assign) NSInteger selectedIndex;

@end

static NSString *indentify = @"CollectionViewCell";

@implementation PopView

- (void)showInSuperView:(UIView *)superView
{
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.25;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1f, 0.1f, 1.0f)], [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)]];
    popAnimation.keyTimes = @[@0.2f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [superView addSubview:self];
    [self.underBackView.layer addAnimation:popAnimation forKey:nil];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.selectedIndex = 0;
        self.backgroundColor = [UIColor colorWithRed:51 green:51 blue:51 alpha:0.5];
        [self addSubViews];
    }
    return self;
}

- (void)addSubViews
{
    [self addSubview:self.underBackView];
    
    [self.underBackView addSubview:self.collectionView];
    [self.underBackView addSubview:self.nameLabel];
    [self.underBackView addSubview:self.selectedButton];
    [self.underBackView addSubview:self.closeButton];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.underBackView.mas_right).with.offset(-5);
        make.top.equalTo(self.underBackView.mas_top).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.selectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.underBackView);
        make.bottom.equalTo(self.underBackView.mas_bottom).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(200, 30));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.selectedButton);
        make.bottom.equalTo(self.selectedButton.mas_top).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(200, 45));
    }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ItemModel *model = self.dataSource[indexPath.item];
    PopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:indentify forIndexPath:indexPath];
    cell.heroImageView.image = [UIImage imageNamed:model.imageName];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGPoint pInUnderView = [self.underBackView convertPoint:collectionView.center toView:collectionView];
    NSIndexPath *indexPathNew = [collectionView indexPathForItemAtPoint:pInUnderView];
    if (indexPath.row == indexPathNew.row) {
        NSLog(@"点击了同一个");
        return;
    } else {
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}

- (UIView *)underBackView
{
    if (!_underBackView) {
        _underBackView = [[UIView alloc] init];
        _underBackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        _underBackView.originX = 30;
        _underBackView.originY = 60;
        _underBackView.width = SCREEN_WIDTH - 2 * _underBackView.originX;
        _underBackView.height = SCREEN_WIDTH - 2 * _underBackView.originY;
        [_underBackView cornerRadius:5 borderColor:[UIColor redColor].CGColor borderWidth:2.0f];
    }
    return _underBackView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.backgroundColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont boldSystemFontOfSize:20];
        _nameLabel.textColor = [UIColor blueColor];
        [_nameLabel cornerRadius:5.0f borderColor:[UIColor blackColor].CGColor borderWidth:2.0f];
    }
    return _nameLabel;
}

- (UIButton *)selectedButton
{
    if (!_selectedButton) {
        _selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectedButton.backgroundColor = [UIColor blackColor];
        [_selectedButton setTitle:@"选这个" forState:UIControlStateNormal];
        [_selectedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_selectedButton addTarget:self action:@selector(chooseDone:) forControlEvents:UIControlEventTouchUpInside];
        [_selectedButton cornerRadius:20.0f borderColor:[UIColor whiteColor].CGColor borderWidth:2.0f];
    }
    return _selectedButton;
}

- (void)chooseDone:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedHero:)]) {
        [self.delegate selectedHero:self.dataSource[self.selectedIndex]];
    }
}

- (UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.backgroundColor = [UIColor redColor];
        [_closeButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (void)close:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(closePopView)]) {
        [self.delegate closePopView];
    }
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        FlowLayout7 *layout = [[FlowLayout7 alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(self.underBackView.width / 2, self.underBackView.width - 100);
        layout.minimumLineSpacing = 30;
        layout.minimumInteritemSpacing = 30;
        layout.needAlpha = YES;
        layout.delegate = self;
        CGFloat oneX = self.underBackView.width / 4;
        layout.sectionInset = UIEdgeInsetsMake(0, oneX, 0, oneX);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 30, self.underBackView.bounds.size.width, self.underBackView.bounds.size.height * 0.65) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[PopCollectionViewCell class] forCellWithReuseIdentifier:indentify];
    }
    return _collectionView;
}

- (void)collectionViewScrollToIndex:(NSInteger)index
{
    [self labelText:index];
    self.selectedIndex = index;
}

- (void)setDataSource:(NSArray *)dataSource
{
    self.dataSource = dataSource;
    [self labelText:0];
    [self.collectionView reloadData];
}

- (void)labelText:(NSInteger)idx
{
    ItemModel *model = self.dataSource[idx];
    self.nameLabel.text = model.titleName;
}

@end
