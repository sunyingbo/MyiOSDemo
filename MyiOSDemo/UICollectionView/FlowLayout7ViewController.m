//
//  FlowLayout7ViewController.m
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/6/21.
//

#import "FlowLayout7ViewController.h"
#import "PopView.h"
#import "Masonry.h"

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
