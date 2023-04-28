//
//  CalenderManager.m
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/4/24.
//

#import "CalenderManager.h"

#define WBAdSdkCalendarLaiseeCalenderID @"WBCalendarLaiseeCalenderID"

NSString *const WBAdSdkCalendarErrorDomain = @"WBCalendarErrorDomain";

@implementation WBAdSdkCalendarEvent

- (void)dealloc
{
    _title = nil;
    _startDate = nil;
    _endDate = nil;
    _url = nil;
}

- (BOOL)updateWithJSONDictionary:(NSDictionary *)dict
{
    self.title = [dict objectForKey:@"title"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeZone* timeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:timeZone];

    self.startDate = [dateFormatter dateFromString:[dict objectForKey:@"start_time"]];
    self.endDate = [dateFormatter dateFromString:[dict objectForKey:@"end_time"]];
    if (!self.endDate) {
        self.endDate = self.startDate;
    }
    
    self.url = [dict objectForKey:@"live_url"];
    
    return YES;
}

@end

@interface CalenderManager ()

@property (nonatomic, retain) EKEventStore *eventStore;

@property (nonatomic, retain) EKCalendar *laiseeCalendar;

@end

static dispatch_queue_t wb_calendar_manager_queue;

@implementation CalenderManager

- (void)dealloc
{
    _eventStore = nil;
    
    _laiseeCalendar = nil;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static CalenderManager *sharedManager = nil;
    
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
        wb_calendar_manager_queue = dispatch_queue_create("calendar_manager_queue", DISPATCH_QUEUE_SERIAL);
    });
    
    return sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _eventStore = [[EKEventStore alloc] init];
        
        [self refreshLaiseeCalendarIfNeed];
    }
    return self;
}

- (EKCalendar*)defaultCalendar
{
    @synchronized (self) {
        return self.eventStore.defaultCalendarForNewEvents;
    }
}

- (BOOL)checkAccessForCalendar
{
    BOOL authorization = NO;
    
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    if (status == EKAuthorizationStatusAuthorized) {
        authorization = YES;
    }
    return authorization;
}

- (void)checkAccessAndRequestForCalendarWithCompletion:(void(^)(BOOL granted))completion
{
    [self checkAccessAndRequestForCalendarWithCompletion:completion AskUser:YES];
}

- (void)checkAccessAndRequestForCalendarWithCompletion:(void(^)(BOOL granted))completion AskUser:(BOOL)ask
{
    if (!completion) {
        return;
    }

    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    
    if (status == EKAuthorizationStatusAuthorized) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(YES);
        });
    } else if (status == EKAuthorizationStatusDenied || status == EKAuthorizationStatusRestricted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(NO);
        });
    } else if (status == EKAuthorizationStatusNotDetermined && ask) {
        [[EKEventStore new] requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error){
            dispatch_async(wb_calendar_manager_queue, ^{
                self.eventStore = [[EKEventStore alloc] init];
            });
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(granted);
            });
        }];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(NO);
        });
    }
}

/**
 *  查日历事件
 *
 *  @param eventIdentifier    事件ID(标识符)
 */
- (EKEvent *)checkToEventIdentifier:(NSString *)eventIdentifier
{
    NSString *eIdentifier = [[NSUserDefaults standardUserDefaults] objectForKey:eventIdentifier];
    if (eIdentifier && ![eIdentifier isEqualToString:@""]) {
        EKEvent *event = [self.eventStore eventWithIdentifier:eIdentifier];
        return event;
    }
    return nil;
}

/**
 *  删除日历事件(删除单个)
 *
 *  @param eventIdentifier    事件ID(标识符)
 */
- (BOOL)deleteCalendarEventIdentifier:(NSString *)eventIdentifier
{
    NSString *eIdentifier = [[NSUserDefaults standardUserDefaults] objectForKey:eventIdentifier];
    EKEvent *event;
    NSError *error = nil;
    if (eIdentifier && ![eIdentifier isEqualToString:@""]) {
        event = [self.eventStore eventWithIdentifier:eIdentifier];
        return [self.eventStore removeEvent:event span:EKSpanThisEvent error:&error];
    }
    return NO;
}

/**
 *  修改日历
 *
 *  @param event_ 日历事件
 *  @param completion 回调方法
 */
- (void)modifyEvent:(WBAdSdkCalendarEvent *)event_ completion:(void(^)(BOOL success, NSError *error))completion
{
    // 获取到此事件
    EKEvent *event = [self checkToEventIdentifier:event_.eventIdentifier];
    if (event) {
        [self deleteCalendarEventIdentifier:event_.eventIdentifier];
    }
    [self createEvent:event_ completion:completion];
}

/**
 *  添加日历提醒事项
 *
 *  @param event_ 日历事件
 *  @param completion 回调方法
 */
- (void)createEvent:(WBAdSdkCalendarEvent *)event_ completion:(void(^)(BOOL success, NSError *error))completion
{
    if (!completion) {
        return;
    }
    if (![self checkAccessForCalendar]) {
        NSError *error = [NSError errorWithDomain:WBAdSdkCalendarErrorDomain code:WBCalendarErrorUnauthorized userInfo:nil];
        completion(NO, error);
        return;
    }
    if (event_.eventIdentifier.length <= 0 || event_ == nil) {
        NSError *error = [NSError errorWithDomain:WBAdSdkCalendarErrorDomain code:WBCalendarErrorMissingArgu userInfo:nil];
        completion(NO, error);
        return;
    }
    if (!event_.startDate || !event_.endDate || !(event_.title.length > 0)) {
        NSError *error = [NSError errorWithDomain:WBAdSdkCalendarErrorDomain code:WBCalendarErrorMissingArgu userInfo:nil];
        completion(NO, error);
        return;
    }
    dispatch_async(wb_calendar_manager_queue, ^{
        EKEvent *event = [EKEvent eventWithEventStore:self.eventStore];
        event.title = event_.title;
        event.startDate = event_.startDate;
        event.endDate = event_.endDate;
        event.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
        if (event_.url) {
            event.URL = [NSURL URLWithString:event_.url];
        }
        
        //添加提醒
        if (event_.alarms.count > 0) {
            [event_.alarms enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [event addAlarm:[EKAlarm alarmWithRelativeOffset:[obj integerValue]]];
            }];
        }
        
        // 存储到源中
        [event setCalendar:[self.eventStore defaultCalendarForNewEvents]];
        
        __block BOOL isGranted = NO;
        // 保存日历
        NSError *error = nil;
        [self.eventStore saveEvent:event span:EKSpanThisEvent commit:YES error:&error];
        if (!error) {
            if (event.eventIdentifier && ![event.eventIdentifier isEqualToString:@""] && event_.eventIdentifier && ![event_.eventIdentifier isEqualToString:@""]) {
                //存储日历ID
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:event.eventIdentifier forKey:event_.eventIdentifier];
                isGranted = [userDefaults synchronize];
                if (!isGranted) {
                    error = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileWriteUnknownError userInfo:@{NSLocalizedDescriptionKey : @"存储失败"}];
                }
            } else {
                error = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileWriteUnknownError userInfo:@{NSLocalizedDescriptionKey : @"eventIdentifier 不存在"}];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(isGranted, error);
            });
        }
    });
}

//日历存储
- (void)saveCalendarEventNoRepeat:(WBAdSdkCalendarEvent *)event_ completion:(void(^)(BOOL success, NSError *error))completion
{
    [self saveCalendarEventNoRepeat:event_ onlyCompareTitle:NO completion:completion];
}

// 日历存储
- (void)saveCalendarEventNoRepeat:(WBAdSdkCalendarEvent *)event_
                 onlyCompareTitle:(BOOL)onlyCompareTitle
                       completion:(void(^)(BOOL success, NSError *error))completion
{
    if (!completion) {
        return;
    }

    NSArray *events = [self fetchEventsStartDate:event_.startDate EndDate:event_.endDate];
    __block BOOL exist = NO;
    [events enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            EKEvent *event = (EKEvent *)obj;
            if ([self isEqualToEvent:event withEvent:event_ onlyCompareTitle:onlyCompareTitle]) {
                // 已有
                completion(YES, nil);
                exist = YES;
                *stop = YES;
            }
    }];
    
    if (!exist) {
        if (![self checkAccessForCalendar]) {
            NSError *error = [NSError errorWithDomain:WBAdSdkCalendarErrorDomain code:WBCalendarErrorUnauthorized userInfo:nil];
            completion(NO, error);
            return;
        }
        
        if (event_ == nil) {
            NSError *error = [NSError errorWithDomain:WBAdSdkCalendarErrorDomain code:WBCalendarErrorMissingArgu userInfo:nil];
            completion(NO, error);
            return;
        }
        
        if (!event_.startDate || !event_.endDate || !(event_.title.length > 0)) {
            NSError *error = [NSError errorWithDomain:WBAdSdkCalendarErrorDomain code:WBCalendarErrorMissingArgu userInfo:nil];
            completion(NO, error);
            return;
        }
        dispatch_async(wb_calendar_manager_queue, ^{
            [self refreshLaiseeCalendarIfNeed];
            EKEvent *event = [EKEvent eventWithEventStore:self.eventStore];
            event.title = event_.title;
            event.startDate = event_.startDate;
            event.endDate = event_.endDate;
            event.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
            
            if (event_.alarms.count > 0) {
                [event_.alarms enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [event addAlarm:[EKAlarm alarmWithRelativeOffset:[obj integerValue]]];
                }];
            }
            
            event.availability = EKEventAvailabilityFree;
            [event setCalendar:self.laiseeCalendar];
            if (event_.url) {
                event.URL = [NSURL URLWithString:event_.url];
            }
            NSError *error = nil;
            [self.eventStore saveEvent:event span:EKSpanThisEvent commit:YES error:&error];
            if (error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(NO, error);
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(YES, nil);
                });
            }
        });
    }
}

//读取日历
- (NSArray *)fetchEventsStartDate:(NSDate*)startDate_ EndDate:(NSDate *)endDate_
{
    if (!startDate_ || !endDate_) {
        return nil;
    }
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *oneDayAgoComponents = [[NSDateComponents alloc] init];
    oneDayAgoComponents.minute = -1;
    NSDate *oneMinAgo = [calendar dateByAddingComponents:oneDayAgoComponents
                                                  toDate:startDate_
                                                 options:0];
    
    // 创建结束日期组件（Create the end date components）
    NSDateComponents *oneYearFromNowComponents = [[NSDateComponents alloc] init];
    oneYearFromNowComponents.minute = 1;
    NSDate *oneMinAfter = [calendar dateByAddingComponents:oneYearFromNowComponents
                                                       toDate:endDate_
                                                      options:0];
    //
    // We will only search the default calendar for our events

    
    NSArray *calendarArray = nil;
    EKCalendar *defaultCalendar_ = self.defaultCalendar;
    if (defaultCalendar_) {
        calendarArray = @[defaultCalendar_];
    }
    // Create the predicate
    NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:oneMinAgo
                                                                      endDate:oneMinAfter
                                                                    calendars:calendarArray];
    NSArray *events = [self.eventStore  eventsMatchingPredicate:predicate];
    
    return events;
}

- (void)refreshLaiseeCalendarIfNeed
{
    if ([self checkAccessForCalendar]) {
        NSUserDefaults *userDefaults = [[NSUserDefaults alloc] init];
        NSString *laiseeCalendarID = [userDefaults stringForKey:WBAdSdkCalendarLaiseeCalenderID];
        
        if (self.laiseeCalendar) {
            if (self.laiseeCalendar.calendarIdentifier) {
                EKCalendar *laiseeCalendar = [_eventStore calendarWithIdentifier:self.laiseeCalendar.calendarIdentifier];
                if (!laiseeCalendar) {
                    self.laiseeCalendar = nil;
                }
            }
        } else {
            EKCalendar *laiseeCalendar = [_eventStore calendarWithIdentifier:laiseeCalendarID];
            if (laiseeCalendar) {
                self.laiseeCalendar = laiseeCalendar;
            }
        }
        
        if (!self.laiseeCalendar) {
            self.laiseeCalendar = _eventStore.defaultCalendarForNewEvents;
        }
        
        if (![laiseeCalendarID isEqualToString:self.laiseeCalendar.calendarIdentifier]) {
            [userDefaults setObject:self.laiseeCalendar.calendarIdentifier forKey:WBAdSdkCalendarLaiseeCalenderID];
        }
    }
}

- (BOOL)isEqualToEvent:(EKEvent *)event withEvent:(WBAdSdkCalendarEvent *)event_ onlyCompareTitle:(BOOL)onlyCompareTitle
{
    if (onlyCompareTitle) {
        return [event.title isEqualToString:event_.title];
    } else {
        return [event.title isEqualToString:event_.title] && [event.startDate isEqualToDate:event_.startDate];
    }
}

@end
