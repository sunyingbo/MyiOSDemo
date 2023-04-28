//
//  People.m
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/3/17.
//

#import "People.h"
#import "PeopleProtocol.h"
#import "PeopleManager.h"

@interface People ()<PeopleProtocol>

@property (nonatomic, strong) NSRunLoop *lastRunLoop;
@property (nonatomic, strong) void (^block)(void);

@end

@implementation People

- (instancetype)init
{
    self = [super init];
    if (self) {
        [PeopleManager addDelegate:self];
    }
    return self;
}

- (void)run
{
    NSLog(@"yingbo3 people run currentQueue ... %@", dispatch_get_current_queue());
    NSRunLoop *currentRunloop = [NSRunLoop currentRunLoop];
    NSLog(@"yingbo3 people run currentRunLoop ... %@", currentRunloop);
    self.lastRunLoop = currentRunloop;
    
    [PeopleManager removeDelegate:self];
//    [PeopleManager addDelegate:self];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"yingbo3 people thread : %@", [NSThread currentThread]);
        [PeopleManager addDelegate:self];
//        [PeopleManager removeDelegate:self];
    });
    
    
    NSLog(@"yingbo3 ......................................");
}

@end
