//
//  Student.m
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/3/17.
//

#import "Student.h"
#import "PeopleProtocol.h"
#import "PeopleManager.h"

@interface Student ()<PeopleProtocol>

@end

@implementation Student

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
    
}

- (void)eat
{
    NSLog(@"yingbo3 student eat ...");
}

@end
