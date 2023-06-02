//
//  GZipTools.m
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/6/2.
//

#import "GZipTools.h"
#import "zlib.h"

@implementation GZipTools

+ (NSData *)gzipDeflate:(NSString *)string
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    if ([data length] == 0) {
        return data;
    }
    unsigned full_length = (unsigned)[data length];
    unsigned half_length = (unsigned)([data length] / 2);
    
    z_stream strm;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    strm.opaque = Z_NULL;
    strm.total_out = 0;
    strm.next_in = (Bytef *)[data bytes];
    strm.avail_in = full_length;
    
    if (deflateInit2(&strm, Z_DEFAULT_COMPRESSION, Z_DEFLATED, (15 + 16), 8, Z_DEFAULT_STRATEGY) != Z_OK) {
        return nil;
    }
    
    NSMutableData *compressed = [NSMutableData dataWithLength:full_length + half_length];
    
    int deflateStatus;
    do {
        if (strm.total_out >= [compressed length]) {
            [compressed increaseLengthBy:half_length];
        }
        strm.next_out = [compressed mutableBytes] + strm.total_out;
        strm.avail_out = (uInt)([compressed length] - strm.total_out);
        deflateStatus = deflate(&strm, Z_FINISH);
    } while (deflateStatus == Z_OK);
    
    deflateEnd(&strm);
    
    [compressed setLength:strm.total_out];
    return [NSData dataWithData:compressed];
}

+ (NSData *)gzipInflate:(NSData *)data
{
    if ([data length] == 0) {
        return data;
    }
    
    unsigned full_length = (unsigned)[data length];
    unsigned half_length = (unsigned)([data length] / 2);
    
    NSMutableData *decompressed = [NSMutableData dataWithLength:full_length + half_length];
    BOOL done = NO;
    int status;
    
    z_stream strm;
    strm.next_in = (Bytef *)[data bytes];
    strm.avail_in = full_length;
    strm.total_out = 0;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    
    if (inflateInit2(&strm, (15 + 32)) != Z_OK) {
        return nil;
    }
    
    while (!done) {
        if (strm.total_out >= [decompressed length]) {
            [decompressed increaseLengthBy:half_length];
        }
        strm.next_out = [decompressed mutableBytes] + strm.total_out;
        strm.avail_out = (uInt)([decompressed length] - strm.total_out);
        
        status = inflate(&strm, Z_SYNC_FLUSH);
        if (status == Z_STREAM_END) {
            done = YES;
        } else if (status != Z_OK) {
            break;
        }
    }
    if (inflateEnd(&strm) != Z_OK) {
        return nil;
    }
    
    if (done) {
        [decompressed setLength:strm.total_out];
        return [NSData dataWithData:decompressed];
    } else {
        return nil;
    }
}

@end
