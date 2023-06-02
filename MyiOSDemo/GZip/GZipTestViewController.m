//
//  GZipTestViewController.m
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/6/2.
//

#import "GZipTestViewController.h"
#import "GZipTools.h"

@interface GZipTestViewController ()

@property (nonatomic, strong) NSString *str;
@property (nonatomic, strong) NSData *en;

@end

@implementation GZipTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *gzipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    gzipButton.frame = CGRectMake(50, 100, 100, 50);
    [gzipButton setTitle:@"GZIP" forState:UIControlStateNormal];
    [gzipButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    gzipButton.backgroundColor = [UIColor redColor];
    [gzipButton addTarget:self action:@selector(gzip:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:gzipButton];
    
    UIButton *unzip = [UIButton buttonWithType:UIButtonTypeCustom];
    unzip.frame = CGRectMake(50, 200, 100, 50);
    [unzip setTitle:@"UNZIP" forState:UIControlStateNormal];
    [unzip setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    unzip.backgroundColor = [UIColor redColor];
    [unzip addTarget:self action:@selector(unzip:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:unzip];
    
    self.str = @"123456";
}

- (void)gzip:(UIButton *)button
{
    self.en = [GZipTools gzipDeflate:self.str];
    NSLog(@"yingbo3");
}

- (void)unzip:(UIButton *)button
{
    NSData *unzip = [GZipTools gzipInflate:self.en];
    NSString *newStr = [[NSString alloc] initWithData:unzip encoding:NSUTF8StringEncoding];
    NSLog(@"yingbo3 unzip = %@", newStr);
}

@end
