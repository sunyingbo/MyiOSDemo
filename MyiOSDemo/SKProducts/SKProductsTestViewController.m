//
//  SKProductsTestViewController.m
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/11/3.
//

#import "SKProductsTestViewController.h"
#import "MyiOSDemo-Swift.h"

@import StoreKit;

@interface SKProductsTestViewController ()<SKProductsRequestDelegate>

@end

@implementation SKProductsTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(50, 100, 100, 50);
    [button setBackgroundColor:[UIColor redColor]];
    [button setTitle:@"click" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
}

- (void)buttonClick:(UIButton *)button
{
//    [self sendRequestWithID:@"com.sina.weibo.svipmembership.onemonth.25"];
//    [self sendRequestWithID:@"syb.demo.com"];
    
    if (@available(iOS 15.0, *)) {
        [[MySKProductSwiftTest shared] productsRequest:@"syb.demo.com"];
    } else {
        // Fallback on earlier versions
    }
}

- (SKProductsRequest *)sendRequestWithID:(NSString *)productIdentifier
{
    SKProductsRequest *request = [[SKProductsRequest alloc]initWithProductIdentifiers:[NSSet setWithObject:productIdentifier]];
    request.delegate = self;
    [request start];
    return request;
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray<SKProduct *> *myProducts = response.products;
    for (SKProduct *product in myProducts) {
        NSString *productIdentifier = product.productIdentifier;
        
        NSLocale *locale = product.priceLocale;
        NSString *countryCode;
        NSString *currencyCode = locale.currencyCode;
        if (@available(iOS 17.0, *)) {
            countryCode = locale.regionCode;
        } else {
            countryCode = locale.countryCode;
        }
        NSLog(@"yingbo3 countryCode : %@, currencyCode : %@", countryCode, currencyCode);
    }
}

@end
