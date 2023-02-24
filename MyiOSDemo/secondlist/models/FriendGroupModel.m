//
//  FriendGroupModel.m
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/2/24.
//

#import "FriendGroupModel.h"
#import "FriendModel.h"

@implementation FriendGroupModel

- (instancetype)initWithNSDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+ (instancetype)friendGroupModelWithNSDictionary:(NSDictionary *)dic
{
    return [[self alloc] initWithNSDictionary:dic];
}

+ (NSArray *)friendGroupList
{
    NSString *paths = [[NSBundle mainBundle] pathForResource:@"friends.plist" ofType:nil];
    NSArray *array = [NSArray arrayWithContentsOfFile:paths];
    NSMutableArray *tmpArr = [NSMutableArray arrayWithCapacity:array.count];
    for (NSDictionary *tmpDic in array) {
        FriendGroupModel *groupModel = [FriendGroupModel friendGroupModelWithNSDictionary:tmpDic];
        NSMutableArray *friendListArray = [NSMutableArray array];
        for (NSDictionary *friendListDic in groupModel.friends) {
            FriendModel *friendModel = [FriendModel friendModelWithNSDictionart:friendListDic];
            [friendListArray addObject:friendModel];
        }
        groupModel.friends = friendListArray;
        [tmpArr addObject:groupModel];
    }
    return tmpArr;
}

@end
