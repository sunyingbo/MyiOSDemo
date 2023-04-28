//
//  UIWebViewController.m
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/3/28.
//

#import "UIWebViewController.h"

@interface UIWebViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIButton *button;

@end

@implementation UIWebViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor grayColor];
        [self.view addSubview:self.webView];
        [self.view addSubview:self.button];
    }
    return self;
}

- (void)viewDidLoad
{
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"]; //创建 URL
    NSURLRequest *request = [NSURLRequest requestWithURL:url]; //创建 NSURLRequest
    [self.webView loadRequest:request]; // 加载
}

- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 200)];
        _webView.scalesPageToFit = YES; // 自动对页面进行缩放以适应屏幕
        _webView.delegate = self;
    }
    return _webView;
}

- (UIButton *)button
{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.backgroundColor = [UIColor redColor];
        _button.frame = CGRectMake(100, 100, 200, 50);
        [_button setTitle:@"点我" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (void)buttonClick:(UIButton *)button
{
    NSLog(@"yingbo3 UIWebViewController buttonClick");
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"yingbo3 UIWebViewController shouldStartLoadWithRequest");
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"yingbo3 UIWebViewController webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"yingbo3 UIWebViewController webViewDidFinishLoad");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"yingbo3 UIWebViewController touchesBegan");
}

@end
