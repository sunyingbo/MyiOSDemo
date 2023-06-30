//
//  NSArrayTestViewController.m
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/3/17.
//

#import "NSArrayTestViewController.h"
#import "People.h"
#import "Student.h"
#import "PeopleProtocol.h"
#import "PeopleManager.h"

@interface NSArrayTestViewController ()

@property (nonatomic, strong) NSMutableArray *peopleArray;
@property (nonatomic, strong) NSMutableArray *commonArray;
@property (nonatomic, strong) void (^block)(void);

@end

@implementation NSArrayTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    startButton.backgroundColor = [UIColor lightGrayColor];
    startButton.frame = CGRectMake(10, 100, 300, 100);
    [startButton setTitle:@"开始" forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(start:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startButton];
    
    UIButton *eatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    eatButton.backgroundColor = [UIColor lightGrayColor];
    eatButton.frame = CGRectMake(10, 210, 300, 100);
    [eatButton setTitle:@"吃" forState:UIControlStateNormal];
    [eatButton addTarget:self action:@selector(eat:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:eatButton];
    
    UIButton *copyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    copyButton.backgroundColor = [UIColor lightGrayColor];
    copyButton.frame = CGRectMake(10, 320, 300, 100);
    [copyButton setTitle:@"copy" forState:UIControlStateNormal];
    [copyButton addTarget:self action:@selector(copyArray:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:copyButton];
    
    UIButton *copyButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    copyButton2.backgroundColor = [UIColor lightGrayColor];
    copyButton2.frame = CGRectMake(10, 430, 300, 100);
    [copyButton2 setTitle:@"copy2" forState:UIControlStateNormal];
    [copyButton2 addTarget:self action:@selector(copyArray2:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:copyButton2];
    
    UIButton *removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    removeButton.backgroundColor = [UIColor lightGrayColor];
    removeButton.frame = CGRectMake(10, 540, 300, 100);
    [removeButton setTitle:@"remove" forState:UIControlStateNormal];
    [removeButton addTarget:self action:@selector(remove:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:removeButton];
    
    for (int i = 0; i < 65; i++) {
        [self.peopleArray addObject:[[People alloc] init]];
        [self.peopleArray addObject:[[Student alloc] init]];
    }
    
    self.commonArray = [[NSMutableArray alloc] initWithArray:@[@"A", @"B", @"B", @"C", @"B", @"D"]];
    
    __weak typeof(self) weakSelf = self;
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        switch (activity) {
            case kCFRunLoopEntry:
                NSLog(@"yingbo3 即将进入runloop");
                break;
            case kCFRunLoopBeforeTimers:
                NSLog(@"yingbo3 即将处理timer事件");
                break;
            case kCFRunLoopBeforeSources:
                NSLog(@"yingbo3 即将处理source事件");
                break;
            case kCFRunLoopBeforeWaiting:
                NSLog(@"yingbo3 即将进入睡眠");
                break;
            case kCFRunLoopAfterWaiting:
                NSLog(@"yingbo3 被唤醒");
                break;
            case kCFRunLoopExit:
                NSLog(@"yingbo3 runloop退出");
                break;

            default:
                break;
        }
    });
//    CFRunLoopAddObserver(runLoop, observer, kCFRunLoopDefaultMode);
//    CFRelease(observer);
}

- (NSArray *)peopleArray
{
    if (!_peopleArray) {
        _peopleArray = [[NSMutableArray alloc] init];
    }
    return _peopleArray;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"yingbo3 touchesBegan ******************************");
//    [PeopleManager start];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"yingbo3 touchesEnded ******************************");
//    [PeopleManager start];
}

- (void)start:(UIButton *)startButton
{
//    for (int i = 0; i < 2000; i++) {
//        [PeopleManager start];
//    }
}

- (void)eat:(UIButton *)eatButton
{
    
}

- (void)copyArray:(UIButton *)copyButton
{
    NSDate *start_date = [NSDate date];
    
    NSArray *newArray = [self.peopleArray copy];
    
    NSDate *end_api = [NSDate date];
    NSTimeInterval duration = [end_api timeIntervalSinceDate:start_date];
    NSString *durationString = [NSString stringWithFormat:@"%lf", duration];
    NSLog(@"yingbo3 copyArray : %@", durationString);
}

- (void)copyArray2:(UIButton *)copyButton
{
    NSDate *start_date = [NSDate date];
    
    NSArray *newArray = [[NSArray alloc] initWithArray:self.peopleArray copyItems:YES];
    
    NSDate *end_api = [NSDate date];
    NSTimeInterval duration = [end_api timeIntervalSinceDate:start_date];
    NSString *durationString = [NSString stringWithFormat:@"%lf", duration];
    NSLog(@"yingbo3 copyArray2 : %@", durationString);
}

- (void)remove:(UIButton *)removeButton
{
//    for (NSString *str in self.commonArray) {
//        if ([str isEqualToString:@"B"]) {
//            [self.commonArray removeObject:str];
//        }
//    }
    
//    for (int i = 0; i < self.commonArray.count; i++) {
//        NSString *str = self.commonArray[i];
//        if ([str isEqualToString:@"B"]) {
//            [self.commonArray removeObject:str];
//        }
//    }
    
//    [self.commonArray enumerateObjectsUsingBlock:^(NSString *str, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ([str isEqualToString:@"B"]) {
//            [self.commonArray removeObject:str];
//        }
//    }];
    
    NSArray *array = [self.commonArray copy];
    [array enumerateObjectsUsingBlock:^(NSString *str, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([str isEqualToString:@"B"]) {
            [self.commonArray removeObject:str];
//            [self.commonArray removeObjectAtIndex:idx];
            NSLog(@"yingbo3 array = %@", self.commonArray);
        }
    }];
    NSLog(@"yingbo3 array = %@", self.commonArray);
}

@end
