//
//  PeopleManager.m
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/3/17.
//

#import "PeopleManager.h"
#import "PeopleProtocol.h"

@interface PeopleManager ()

@end

@implementation PeopleManager

static NSMutableArray * _delegates = nil;
static NSRunLoop *lastRunLoop = nil;

+ (NSMutableArray *)delegates
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CFArrayCallBacks callbacks = {0, NULL, NULL, CFCopyDescription, CFEqual};
        _delegates = CFBridgingRelease(CFArrayCreateMutable(0, 0, &callbacks));
    });
    return _delegates;
}

+ (void)addDelegate:(id<PeopleProtocol>)delegate
{
    NSLog(@"yingbo3 addDelegate1 : %d", [[self delegates]count]);
    NSRunLoop *currentRunloop = [NSRunLoop currentRunLoop];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSRunLoop *currentRunloop = [NSRunLoop currentRunLoop];
        if ([delegate conformsToProtocol:@protocol(PeopleProtocol)])
        {
            [[self delegates] addObject:delegate];
        }
        NSLog(@"yingbo3 addDelegate2 : %d", [[self delegates]count]);
//    });
}

+ (void)removeDelegate:(id<PeopleProtocol>)delegate
{
    NSLog(@"yingbo3 removeDelegate1 : %d", [[self delegates]count]);
    NSRunLoop *currentRunloop = [NSRunLoop currentRunLoop];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSRunLoop *currentRunloop = [NSRunLoop currentRunLoop];
        if ([delegate conformsToProtocol:@protocol(PeopleProtocol)] && [self delegates].count > 0)
        {
            [[self delegates] removeObject:delegate];
        }
        NSLog(@"yingbo3 removeDelegate2 : %d", [[self delegates]count]);
//    });
}

+ (void)start
{
    NSLog(@"yingbo3 peopleManager start began ------------------------------");
    NSRunLoop *currentRunloop = [NSRunLoop currentRunLoop];
    lastRunLoop = currentRunloop;
    
    if (YES) {
        NSArray *delegates = [PeopleManager delegates];
        
        for (id delegate in delegates) {
            if ([delegate respondsToSelector:@selector(eat)]) {
                [delegate eat];
            }
        }
    }
    
    NSArray *delegates = [PeopleManager delegates];
    if (YES) {
        delegates = [[PeopleManager delegates] copy];
    }
    if (delegates.count > 0) {
        [delegates makeObjectsPerformSelector:@selector(run)];
    }
    NSLog(@"yingbo3 peopleManager start end --------------------------------");
}

@end
