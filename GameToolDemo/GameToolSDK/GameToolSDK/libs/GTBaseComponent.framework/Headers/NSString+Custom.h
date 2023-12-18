//
//  NSString+Custom.h
//  GTBaseComponent
//
//  Created by shangmi on 2023/7/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Custom)

//处理后台出粘贴的debugToken
+ (NSDictionary *)handleDebugToken:(NSString *)string;

/// MD5加密
/// - Parameter source: 原字符串
+ (NSString *)MD5:(NSString *)source;

@end

NS_ASSUME_NONNULL_END
