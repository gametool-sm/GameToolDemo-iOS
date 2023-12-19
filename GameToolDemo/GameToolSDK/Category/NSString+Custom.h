//
//  NSString+Custom.h
//  GTSDK
//
//  Created by shangmi on 2023/7/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Custom)

+ (NSString *)getSpeedText:(GTMultiplyingModel *)model;
//处理后台出粘贴的debugToken
+ (NSDictionary *)handleDebugToken:(NSString *)string;

/// MD5加密
/// - Parameter source: 原字符串
+ (NSString *)MD5:(NSString *)source;

//格式化时间为00:00:00格式（时分秒）
+ (NSString *)secondsConversionTime:(int)time;
//格式化时间为00:00:000格式（分秒毫秒）
+ (NSString *)millisecondConversionTime:(float)time;

@end

NS_ASSUME_NONNULL_END
