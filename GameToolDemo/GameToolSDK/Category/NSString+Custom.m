//
//  NSString+Custom.m
//  GTSDK
//
//  Created by shangmi on 2023/7/9.
//

#import "NSString+Custom.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Custom)

+ (NSString *)getSpeedText:(GTMultiplyingModel *)model {
    if (model == nil) {
        return @"";
    }
    
    if (model.isUp) {
        return [NSString stringWithFormat:@"%.0f", model.number];
    }else {
        return [NSString stringWithFormat:@"%.1f", model.number];
    }
}

+ (NSDictionary *)handleDebugToken:(NSString *)string {
    if ([string isEqualToString:@""]) {
        return @{};
    }
    NSArray *array = [[[string componentsSeparatedByString:@"?"] lastObject] componentsSeparatedByString:@"&"];
    if (array.count) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        for (NSString *str in array) {
            NSArray *arr = [str componentsSeparatedByString:@"="];
            [dict setValue:[arr lastObject] forKey:[arr firstObject]];
        }
        return [dict copy];
    }else {
        return @{};
    }
}

+ (NSString *)MD5:(NSString *)source {
    if (source.length == 0) {
        return nil;
    }
    const char *cStr = [source UTF8String];
    if (cStr == NULL) {
        return nil;
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02X", digest[i]];
    }
    return [result lowercaseString];
}

//格式化时间为00:00:00格式（时分秒）
+ (NSString *)secondsConversionTime:(int)time {
    int hours = time / 3600;
    int minutes = (time % 3600) / 60;
    int seconds = time % 60;
    
    // 格式化时间为00:00:00格式
    NSString *formattedTime = [NSString stringWithFormat:@"%02d : %02d : %02d", hours, minutes, seconds];
    return formattedTime;
}

//格式化时间为00:00:000格式（分秒毫秒）
+ (NSString *)millisecondConversionTime:(float)time {
    int timeNum = [[NSString stringWithFormat:@"%.0f", time*1000] intValue];
    
    int minutes = (int)timeNum / 60000;
//    float seconds = fmodf(time, 60);
    int seconds = (int)(timeNum % 60000)/1000;
    int milliseconds = timeNum % 1000;
    
    // 格式化时间为00:00:000格式
    NSString *formattedTime = [NSString stringWithFormat:@"%02d : %02d : %03d", minutes, seconds, milliseconds];
    return formattedTime;
}

@end
