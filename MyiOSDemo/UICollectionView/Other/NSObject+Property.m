//
//  NSObject+Property.m
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/7/3.
//

#import "NSObject+Property.h"
#import <objc/runtime.h>

@implementation NSObject (Property)

+ (instancetype)objectWithDictionary:(NSDictionary *)dictionary
{
    id obj = [[self alloc] init];
    unsigned int count;
    Ivar *ivars = class_copyIvarList(self, &count);
    
    for (unsigned int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        NSString *key = [ivarName substringFromIndex:1];
        
        id value = dictionary[key];
        if (!value) {
            if ([self respondsToSelector:@selector(replacedKeyFromPropertyName)]) {
                NSString *replaceKey = [self replacedKeyFromPropertyName][key];
                value = dictionary[replaceKey];
            }
        }
        
        if ([value isKindOfClass:[NSDictionary class]]) {
            NSString *type = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
            NSRange range = [type rangeOfString:@"\""];
            type = [type substringFromIndex:range.location + range.length];
            range = [type rangeOfString:@"\""];
            type = [type substringToIndex:range.location];
            Class modelClass = NSClassFromString(type);
            
            if (modelClass) {
                value = [modelClass objectWithDictionary:value];
            }
        }
        
        if ([value isKindOfClass:[NSArray class]]) {
            if ([self respondsToSelector:@selector(objectClassInArray)]) {
                NSMutableArray *models = [NSMutableArray array];
                
                NSString *type = [self objectClassInArray][key];
                Class classModel = NSClassFromString(type);
                for (NSDictionary *dict in value) {
                    id model = [classModel objectWithDictionary:dict];
                    [models addObject:model];
                }
                value = models;
            }
        }
        
        if (value) {
            [obj setValue:value forKey:key];
        }
    }
    
    free(ivars);
    return obj;
}

@end
