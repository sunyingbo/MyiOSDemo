//
//  FlowLayout7ViewController.m
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/6/21.
//

#import "FlowLayout7ViewController.h"
#import "PopView.h"
#import "Masonry.h"
#import "Constant.h"
#import "ItemModel.h"

@interface FlowLayout7ViewController ()<PopViewDelegate>

@property (nonatomic, strong) PopView *popView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIButton *showButton;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation FlowLayout7ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.showButton.backgroundColor = [UIColor blueColor];
    [self.showButton setTitle:@"showPhoto" forState:UIControlStateNormal];
    [self.showButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.showButton.titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    [self.showButton addTarget:self action:@selector(showPhotoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.showButton];
    
    [self.showButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(100);
        make.size.mas_equalTo(CGSizeMake(200, 80));
    }];
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.image = [UIImage imageNamed:@"0"];
    self.imageView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.showButton.mas_bottom).offset(50);
        make.size.mas_equalTo(CGSizeMake(200, 200));
    }];
}

- (void)showPhotoButtonClicked:(UIButton *)button
{
    [self.popView showInSuperView:self.view];
}

- (void)closePopView
{
    [self.popView removeFromSuperview];
}

- (void)selectedHero:(ItemModel *)item
{
    [self closePopView];
    self.imageView.image = [UIImage imageNamed:item.imageName];
}

- (PopView *)popView
{
    if (!_popView) {
        _popView = [[PopView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _popView.dataSource = self.dataSource;
        _popView.delegate = self;
    }
    return _popView;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < 11; i++) {
            ItemModel *model = [[ItemModel alloc] init];
            model.imageName = [NSString stringWithFormat:@"%zd", i];
            model.titleName = [NSString stringWithFormat:@"第%zd张", i];
            [_dataSource addObject:model];
        }
    }
    return _dataSource;
}

@end
