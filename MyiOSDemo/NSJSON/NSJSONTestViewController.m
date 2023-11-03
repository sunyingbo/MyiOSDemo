//
//  NSJSONTestViewController.m
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/7/14.
//

#import "NSJSONTestViewController.h"
#import "Masonry.h"

@interface NSJSONTestViewController ()

@property (nonatomic, strong) UIButton *button;

@end

@implementation NSJSONTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.button];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 50));
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(100);
    }];
    
}

- (UIButton *)button
{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.backgroundColor = [UIColor orangeColor];
        [_button setTitle:@"string to obj" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (void)buttonClick:(UIButton *)button
{
//    NSDictionary *origin = @{};
    NSArray *array = @[@"test", @"\ntest"];
    NSData *data = [NSJSONSerialization dataWithJSONObject:array options:0 error:nil];
    if (data) {
        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"yingbo3 %@", jsonString);
        
        if (jsonString.length <= 0) {
            return;
        }
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        if (jsonData) {
            NSArray *obj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingFragmentsAllowed error:nil];
            NSLog(@"yingbo3");
        }
    }
}

@end
