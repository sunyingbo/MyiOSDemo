//
//  FlowLayout8ViewController.m
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/6/30.
//

#import "FlowLayout8ViewController.h"
#import "CardLayout.h"
#import "CardSelectLayout.h"
#import "CardCollectionViewCell.h"

#define RGBAColor(r, g, b, a) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a]
#define RGBColor(r, g, b) RGBAColor(r, g, b, 1.0)
#define RGBColorC(c) RGBColor((((int)c) >> 16), ((((int)c) >> 8) & 0xff), (((int)c) & 0xff))

static CGFloat collectionHeight;

@interface FlowLayout8ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, CardLayoutDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) CardLayout *cardLayout;
@property (nonatomic, strong) CardSelectLayout *cardSelectLayout;
@property (nonatomic, strong) UICollectionViewLayout *layout;

@end

@implementation FlowLayout8ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    collectionHeight = self.view.bounds.size.height;
    self.cardLayout = [[CardLayout alloc] initWithOffsetY:400];
    self.layout = self.cardLayout;
    self.cardLayout.delegate = self;
    [self.view addSubview:self.collectionView];
}

- (__kindof UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, collectionHeight) collectionViewLayout:self.layout];
        [_collectionView registerClass:[CardCollectionViewCell class] forCellWithReuseIdentifier:@"cardCell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView setContentOffset:CGPointMake(0, 400)];
        _collectionView.backgroundColor = RGBColorC(0x2D3142);
    }
    return _collectionView;
}

- (UITapGestureRecognizer *)tapGesCollectionView
{
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnBackground)];
    }
    return _tapGesture;
}

- (void)tapOnBackground
{
    CGFloat offsetY = self.collectionView.contentOffset.y;
    if ([self.layout isKindOfClass:[CardLayout class]]) {
        
    } else {
        if (!self.cardLayout) {
            self.cardLayout = [[CardLayout alloc] initWithOffsetY:offsetY];
            self.layout = self.cardLayout;
            self.cardLayout.delegate = self;
        } else {
            self.cardLayout.offsetY = offsetY;
            self.layout = self.cardLayout;
        }
        self.collectionView.scrollEnabled = YES;
        [self.collectionView removeGestureRecognizer:self.tapGesCollectionView];
    }
    [self.collectionView setCollectionViewLayout:self.layout animated:YES];
    [self updateBlur];
}

- (void)updateBlur
{
    if ([self.layout isKindOfClass:[CardLayout class]]) {
        for (NSInteger row = 0; row < [self.collectionView numberOfItemsInSection:0]; row++) {
            CardCollectionViewCell *cell = (CardCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
            CGFloat blur = ((NSNumber *)[((CardLayout *)self.layout).blurList objectAtIndex:row]).floatValue;
            [cell setBlur:blur];
        }
    } else {
        for (NSInteger row = 0; row < [self.collectionView numberOfItemsInSection:0]; row++) {
            CardCollectionViewCell *cell = (CardCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
            [cell setBlur:0];
        }
    }
}

- (void)updateBlur:(CGFloat)blur forRow:(NSInteger)row
{
    if (![self.layout isKindOfClass:[CardLayout class]]) {
        return;
    }
    CardCollectionViewCell *cell = (CardCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
    [cell setBlur:blur];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 39;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cardCell" forIndexPath:indexPath];
    cell.bgColor = [self getGameColor:indexPath.row];
    cell.title = [NSString stringWithFormat:@"Item %d", (int)indexPath.row];
    return cell;
}

- (UIColor *)getGameColor:(NSInteger)index
{
    NSArray *colorList = @[RGBColorC(0xfb742a), RGBColorC(0xfcc42d), RGBColorC(0x29c26d), RGBColorC(0xfaa20a), RGBColorC(0x5e64d9), RGBColorC(0x6d7482), RGBColorC(0x54b1ff), RGBColorC(0xe2c179), RGBColorC(0x9973e5), RGBColorC(0x61d4ff)];
    UIColor *color = [colorList objectAtIndex:(index % 10)];
    return color;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat offsetY = self.collectionView.contentOffset.y;
    if ([self.layout isKindOfClass:[CardLayout class]]) {
        if (!self.cardSelectLayout) {
            self.cardSelectLayout = [[CardSelectLayout alloc] initWithIndexPath:indexPath offsetY:offsetY contentSizeHeight:((CardLayout *)self.layout).contentSizeHeight];
            self.layout = self.cardSelectLayout;
        } else {
            self.cardSelectLayout.contentOffsetY = offsetY;
            self.cardSelectLayout.contentSizeHeight = ((CardLayout *)self.layout).contentSizeHeight;
            self.cardSelectLayout.selectedIndexPath = indexPath;
            self.layout = self.cardSelectLayout;
        }
        self.collectionView.scrollEnabled = NO;
        [self showMaskView];
        [(CardCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath] setBlur:0];
    } else {
        if (!self.cardLayout) {
            self.cardLayout = [[CardLayout alloc] initWithOffsetY:offsetY];
            self.layout = self.cardLayout;
            self.cardLayout.delegate = self;
        } else {
            self.cardLayout.offsetY = offsetY;
            self.layout = self.cardLayout;
            self.cardLayout.delegate = self;
        }
        self.collectionView.scrollEnabled = YES;
        [self hideMaskView];
    }
    [self.collectionView setCollectionViewLayout:self.layout animated:YES];
}

- (void)showMaskView
{
    self.collectionView.backgroundColor = RGBColorC(0x161821);
    [self.collectionView addGestureRecognizer:self.tapGesCollectionView];
}

- (void)hideMaskView
{
    self.collectionView.backgroundColor = RGBColorC(0x2D3142);
    [self.collectionView removeGestureRecognizer:self.tapGesCollectionView];
}

@end
