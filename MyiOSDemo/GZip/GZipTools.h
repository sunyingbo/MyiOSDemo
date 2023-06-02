//
//  GZipTools.h
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/6/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GZipTools : NSObject

+ (NSData *)gzipDeflate:(NSString *)string;

+ (NSData *)gzipInflate:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
