//
//  FlowLayout9ViewController.m
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/7/3.
//

#import "FlowLayout9ViewController.h"
#import "FlowLayout9.h"
#import "CarouselViewModel.h"
#import "CarouselUIService.h"
#import "CarouseCollectionViewCell.h"

@interface FlowLayout9ViewController ()

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *indexLabel;
@property (nonatomic, assign) NSInteger allCount;
@property (nonatomic, strong) CarouselViewModel *viewModel;
@property (nonatomic, strong) CarouselUIService *service;

@end

@implementation FlowLayout9ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.collectionView];
    [self.viewModel getData];
    [self.collectionView reloadData];
    
    self.allCount = self.viewModel.data.count;
    [self.view addSubview:self.indexLabel];
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        FlowLayout9 *layout = [[FlowLayout9 alloc] init];
        __weak typeof (self)weakSelf = self;
        layout.slideIndexBlock = ^(NSInteger index) {
            weakSelf.indexLabel.text = [NSString stringWithFormat:@"浏览足迹（%li / %li）", index + 1, weakSelf.allCount];
        };
        layout.itemSize = CGSizeMake(190, 262);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 270) collectionViewLayout:layout];
        _collectionView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
        _collectionView.dataSource = self.service;
        _collectionView.delegate = self.service;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[CarouseCollectionViewCell class] forCellWithReuseIdentifier:@"CarouseCollectionViewCell"];
    }
    return _collectionView;
}

- (UILabel *)indexLabel
{
    if (!_indexLabel) {
        _indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.collectionView.frame), self.view.frame.size.width, 20)];
        _indexLabel.textAlignment = NSTextAlignmentCenter;
        _indexLabel.font = [UIFont systemFontOfSize:13];
        _indexLabel.text = [NSString stringWithFormat:@"浏览记录（2 / %li）", self.allCount];
    }
    return _indexLabel;
}

- (CarouselViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [[CarouselViewModel alloc] init];
    }
    return _viewModel;
}

- (CarouselUIService *)service
{
    if (!_service) {
        _service = [[CarouselUIService alloc] init];
        _service.viewModel = self.viewModel;
    }
    return _service;
}

@end
