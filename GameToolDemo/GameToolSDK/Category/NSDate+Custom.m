//
//  NSDate+Custom.m
//  GTSDK
//
//  Created by shangmi on 2023/8/22.
//

#import "NSDate+Custom.h"

@implementation NSDate (Custom)

//获取倒计时的时间的总秒数
+ (int)countDownConvertToSeconds:(NSString *)timeString {
    NSArray *array = [timeString componentsSeparatedByString:@":"];
    int hours = [array[0] intValue];
    int mins = [array[1] intValue];
    int secs = [array[2] intValue];
    int totalSecond = hours * 60 * 60 + mins * 60 + secs;
    return totalSecond;
}


//获取预约时间的时间的总秒数
+ (int)appointmentTimeConvertToSeconds:(NSString *)timeString {
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    
    
    NSDate *currentDate = [NSDate date];
    // 创建NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    // 转换为字符串
    NSString *dateStr = [dateFormatter stringFromDate:currentDate];
    NSString *timeStr = [NSString stringWithFormat:@"%@ %@", dateStr, timeString];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startTime = [dateFormatter dateFromString:timeStr];
    
    NSTimeInterval seconds = [startTime timeIntervalSinceDate:currentDate];
    //如果为负数，则说明日期为第二天，则加上24小时
    if (seconds < 0) {
        return seconds + 24 * 60 *60;
    }
    
    return seconds;
}

@end
