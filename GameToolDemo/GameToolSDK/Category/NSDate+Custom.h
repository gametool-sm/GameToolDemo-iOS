//
//  NSDate+Custom.h
//  GTSDK
//
//  Created by shangmi on 2023/8/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (Custom)

//获取预约或倒计时的时间的总秒数
+ (int)countDownConvertToSeconds:(NSString *)timeString;

+ (int)appointmentTimeConvertToSeconds:(NSString *)timeString;

@end

NS_ASSUME_NONNULL_END
