//
//  CalenderManager.h
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/4/24.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, WBCalendarError) {
    WBCalendarErrorUnknow,
    WBCalendarErrorMissingArgu,
    WBCalendarErrorUnauthorized,
    WBCalendarErrorSystemError,
};

typedef NS_ENUM(NSUInteger, WBCalendarOperate) {
    WBCalendarOperateNone   = 0,
    WBCalendarOperateAdd    = 1,
    WBCalendarOperateRemove = 2,
    WBCalendarOperateUpdate = 3,
};

@interface WBAdSdkCalendarEvent : NSObject

@property (nonatomic, copy) NSString *eventIdentifier; // 事件ID(标识符，用于区分日历)
@property (nonatomic, copy) NSString *calendarIdentifier; // 事件源(无，则为默认)
@property (nonatomic, copy) NSString *title; // 事件标题
@property (nonatomic, retain) NSDate *startDate; // 开始时间
@property (nonatomic, retain) NSDate *endDate; // 结束时间
@property (nonatomic, retain) NSArray *alarms; // 闹钟集合(传nil，则没有)
@property (nonatomic, copy) NSString *url; // 事件url(传nil，则没有)

- (BOOL)updateWithJSONDictionary:(NSDictionary *)dict;

@end

@interface CalenderManager : NSObject

+ (instancetype) sharedInstance;

- (BOOL)checkAccessForCalendar;

- (void)checkAccessAndRequestForCalendarWithCompletion:(void(^)(BOOL granted))completion;

- (void)modifyEvent:(WBAdSdkCalendarEvent *)event_ completion:(void(^)(BOOL success, NSError *error))completion;

- (NSArray *)fetchEventsStartDate:(NSDate*)startDate_ EndDate:(NSDate *)endDate_;

- (void)saveCalendarEventNoRepeat:(WBAdSdkCalendarEvent *)event_ completion:(void(^)(BOOL success, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
