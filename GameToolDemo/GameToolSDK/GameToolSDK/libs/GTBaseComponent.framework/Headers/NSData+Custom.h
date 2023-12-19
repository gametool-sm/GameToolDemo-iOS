//
//  NSData+Custom.h
//  GTBaseComponent
//
//  Created by shangmi on 2023/7/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (Custom)


/// 获取bundle文件
/// - Parameters:
///   - sourceName: 文件名
///   - type: 文件类型
///   - bundleName: bundle名
+ (NSData *)sourceDataWithSourceName:(NSString *)sourceName type:(NSString *)type bundleName:(NSString *)bundleName;

@end

NS_ASSUME_NONNULL_END
