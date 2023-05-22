//
//  CalenderTestViewController.m
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/4/24.
//

#import "CalenderTestViewController.h"
#import "CalenderManager.h"
#import "WMEventCalendarTool.h"

@interface CalenderTestViewController ()

@property (nonatomic, strong) UIButton *readButton;
@property (nonatomic, strong) UIButton *writeButton;

@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, retain) NSDate *endDate;

@end

@implementation CalenderTestViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor grayColor];
        [self.view addSubview:self.readButton];
        [self.view addSubview:self.writeButton];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeZone* timeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:timeZone];
    
    self.startDate = [dateFormatter dateFromString:@"2023-04-28 13:28:00"];
    self.endDate = [dateFormatter dateFromString:@"2023-04-28 13:28:00"];
}

- (UIButton *)readButton
{
    if (!_readButton) {
        _readButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _readButton.backgroundColor = [UIColor redColor];
        _readButton.frame = CGRectMake(100, 100, 200, 50);
        [_readButton setTitle:@"读取日历" forState:UIControlStateNormal];
        [_readButton addTarget:self action:@selector(readButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _readButton;
}

- (UIButton *)writeButton
{
    if (!_writeButton) {
        _writeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _writeButton.backgroundColor = [UIColor redColor];
        _writeButton.frame = CGRectMake(100, 200, 200, 50);
        [_writeButton setTitle:@"写入日历" forState:UIControlStateNormal];
        [_writeButton addTarget:self action:@selector(writeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _writeButton;
}

- (void)readButtonClick:(UIButton *)button
{
    NSArray *events = [[CalenderManager sharedInstance] fetchEventsStartDate:self.startDate EndDate:self.endDate];
    [events enumerateObjectsUsingBlock:^(EKEvent *event, NSUInteger idx, BOOL * _Nonnull stop) {
            
    }];
}

- (void)writeButtonClick:(UIButton *)button
{
    WBAdSdkCalendarEvent *event = [[WBAdSdkCalendarEvent alloc] init];
    event.eventIdentifier = @"12345";
    event.title = @"816天猫直播--***---";
    event.startDate = self.startDate;
    event.endDate = self.endDate;
    event.alarms = @[@(-300)];
    event.url = @"sinaweibo://chatroom?container_id=2321324874220831375536&live_id=1022:2321324874220831375536&width=1280&height=720&livetype=wblive&cover=https%3A%2F%2Fwx4.sinaimg.cn%2Flarge%2Fcf58b0b5ly8hbjho69rmwj21hc0u07bl.jpg&mid=4874221110429666";
//    [self writeOne:event];
//    [self writeTwo:event];
    [self writeThree:event];
}

- (void)writeOne:(WBAdSdkCalendarEvent *)event
{
    CalenderManager *calenderManager = [CalenderManager sharedInstance];
    if ([calenderManager checkAccessForCalendar]) {
        [calenderManager saveCalendarEventNoRepeat:event completion:^(BOOL success, NSError * _Nonnull error) {
            if (success) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"写日历" message:@"日历写入成功" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDestructive handler:nil];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }];
    } else {
        [calenderManager checkAccessAndRequestForCalendarWithCompletion:^(BOOL granted) {
            if (granted) {
                [calenderManager saveCalendarEventNoRepeat:event completion:^(BOOL success, NSError * _Nonnull error) {
                    if (success) {
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"想访问您的日历" message:@"日历写入成功" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDestructive handler:nil];
                        [alert addAction:okAction];
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                }];
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"想访问您的日历" message:@"请启用，以便于预约添加至日历提醒" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDestructive handler:nil];
                [alert addAction:cancelAction];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }];
    }
}

- (void)writeTwo:(WBAdSdkCalendarEvent *)event
{
    CalenderManager *calenderManager = [CalenderManager sharedInstance];
    if ([calenderManager checkAccessForCalendar]) {
        [calenderManager modifyEvent:event completion:^(BOOL success, NSError * _Nonnull error) {
            if (success) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"写日历" message:@"日历写入成功" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDestructive handler:nil];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }];
    } else {
        [calenderManager checkAccessAndRequestForCalendarWithCompletion:^(BOOL granted) {
            if (granted) {
                [calenderManager saveCalendarEventNoRepeat:event completion:^(BOOL success, NSError * _Nonnull error) {
                    if (success) {
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"想访问您的日历" message:@"日历写入成功" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDestructive handler:nil];
                        [alert addAction:okAction];
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                }];
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"想访问您的日历" message:@"请启用，以便于预约添加至日历提醒" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDestructive handler:nil];
                [alert addAction:cancelAction];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }];
    }
}

- (void)writeThree:(WBAdSdkCalendarEvent *)event
{
    [[WMEventCalendarTool sharedEventCalendar] checkCalendarCanUsedCompletion:^(BOOL granted, NSError *error) {
        // 添加日历源
        [[WMEventCalendarTool sharedEventCalendar] createCalendarIdentifier:@"EventCalendar_1" addCalendarTitle:@"行程" addCompletion:^(BOOL granted, NSError *error) {
            if (!error) {
                NSLog(@"成功");
            }else{
                NSLog(@"%@",error.description);
            }
        }];
        
        //            [[WMEventCalendarTool sharedEventCalendar] createCalendarIdentifier:@"EventCalendar_2" addCalendarTitle:@"工作" addCompletion:^(BOOL granted, NSError *error) {
        //                if (!error) {
        //                    NSLog(@"成功");
        //                }else{
        //                    NSLog(@"%@",error.description);
        //                }
        //            }];
        // 添加事件1 -4.4 - 1
//    [[WMEventCalendarTool sharedEventCalendar] createEventIdentifier:@"EventIdentifier_01" addCalendarTitle:@"测试日历提醒01" addLocation:@"宇宙" addStartDate:[NSDate dateWithTimeIntervalSince1970:1682672720] addEndDate:[NSDate dateWithTimeIntervalSince1970:1682672720] addAllDay:NO addAlarmArray:@[@"300"] addNotes:@"测试日历提醒01的备注" addURL:[NSURL URLWithString:@"www.baidu.com"] addCalendarIdentifier:@"EventCalendar_1" addCompletion:^(BOOL granted, NSError *error) {
//        if (!error) {
//            NSLog(@"成功");
//        }else{
//            NSLog(@"%@",error.description);
//        }
//    }];
        //             添加事件2 - 4.6 - 1
        //            [[WMEventCalendarTool sharedEventCalendar] createEventIdentifier:@"EventIdentifier_02" addCalendarTitle:@"测试日历提醒02" addLocation:@"世界" addStartDate:[NSDate dateWithTimeIntervalSince1970:1554533536] addEndDate:[NSDate dateWithTimeIntervalSince1970:1554562336] addAllDay:NO addAlarmArray:nil addNotes:nil addURL:nil addCalendarIdentifier:@"EventCalendar_1" addCompletion:^(BOOL granted, NSError *error) {
        //                if (!error) {
        //                    NSLog(@"成功");
        //                }else{
        //                    NSLog(@"%@",error.description);
        //                }
        //            }];
        //            添加事件3 - 4.8 - 1
        //            [[WMEventCalendarTool sharedEventCalendar] createEventIdentifier:@"EventIdentifier_03" addCalendarTitle:@"测试日历提醒03" addLocation:@"亚洲" addStartDate:[NSDate dateWithTimeIntervalSince1970:1554699136] addEndDate:[NSDate dateWithTimeIntervalSince1970:1554735136] addAllDay:NO addAlarmArray:nil addNotes:nil addURL:nil addCalendarIdentifier:@"EventCalendar_1" addCompletion:^(BOOL granted, NSError *error) {
        //                if (!error) {
        //                    NSLog(@"成功");
        //                }else{
        //                    NSLog(@"%@",error.description);
        //                }
        //            }];
        //              添加事件4 - 4.9 - 2
        //            [[WMEventCalendarTool sharedEventCalendar] createEventIdentifier:@"EventIdentifier_04" addCalendarTitle:@"测试日历提醒04" addLocation:@"中国" addStartDate:[NSDate dateWithTimeIntervalSince1970:1554785536] addEndDate:[NSDate dateWithTimeIntervalSince1970:1554807136] addAllDay:NO addAlarmArray:nil addNotes:nil addURL:nil addCalendarIdentifier:@"EventCalendar_2" addCompletion:^(BOOL granted, NSError *error) {
        //                                if (!error) {
        //                                    NSLog(@"成功");
        //                                }else{
        //                                    NSLog(@"%@",error.description);
        //                                }
        //                            }];
        //              添加事件5 - 4.10 - 2
        //            [[WMEventCalendarTool sharedEventCalendar] createEventIdentifier:@"EventIdentifier_05" addCalendarTitle:@"测试日历提醒05" addLocation:@"天安门" addStartDate:[NSDate dateWithTimeIntervalSince1970:1554857536] addEndDate:[NSDate dateWithTimeIntervalSince1970:1554893536] addAllDay:NO addAlarmArray:nil addNotes:nil addURL:nil addCalendarIdentifier:@"EventCalendar_2" addCompletion:^(BOOL granted, NSError *error) {
        //                if (!error) {
        //                    NSLog(@"成功");
        //                }else{
        //                    NSLog(@"%@",error.description);
        //                }
        //            }];
        // 查询
        //            EKEvent *Events = [[WMEventCalendarTool sharedEventCalendar] checkToEventIdentifier:@"EventIdentifier_05"];
        //            NSArray *Events = [[WMEventCalendarTool sharedEventCalendar] checkToStartDate:[NSDate dateWithTimeIntervalSince1970:1554375207] addEndDate:[NSDate dateWithTimeIntervalSince1970:2554375207] addModifytitle:nil addCalendarIdentifier:@"EventCalendar_2"];
        //            for (int i = 0; i < Events.count; i++) {
        //                EKEvent *event = Events[i];
        //                NSLog(@"%@ - %@",event.title,event.eventIdentifier);
        //            }
        // 删除
        //            bool isSuceess = [[WMEventCalendarTool sharedEventCalendar] deleteCalendarEventIdentifier:@"EventIdentifier_04"];
        //            bool isSuceess = [[WMEventCalendarTool sharedEventCalendar] deleteCalendarStartDate:[NSDate dateWithTimeIntervalSince1970:1554375207] addEndDate:[NSDate dateWithTimeIntervalSince1970:2554375207] addModifytitle:nil addCalendarIdentifier:@"EventCalendar_2"];
        // 修改
        //            [[WMEventCalendarTool sharedEventCalendar] modifyEventIdentifier:@"EventIdentifier_04" addTitle:@"修改_测试日历提醒04" addLocation:@"长城" addStartDate:[NSDate dateWithTimeIntervalSince1970:1554955150] addEndDate:[NSDate dateWithTimeIntervalSince1970:1554980350] addAllDay:NO addAlarmArray:nil addNotes:nil addURL:nil addCIdentifier:@"EventCalendar_1" addCompletion:^(BOOL granted, NSError *error) {
        //                if (!error) {
        //                    NSLog(@"成功");
        //                }else{
        //                    NSLog(@"%@",error.description);
        //                }
        //            }];
    }];
}

@end
