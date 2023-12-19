//
//  GTDeviceInfoUtil.h
//  GTBaseComponent
//
//  Created by smwl_dxl on 2023/6/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GTDeviceInfoUtil : NSObject
/*
 caid（非广协会的完整方案，去掉了设备名称和开机时间，开机时间改成拼接在最后面）和开机时间的毫秒数（如果没有时间戳的毫秒数就拿到时间戳秒数）然后进行md5
 */
+ (NSString *)getUUID;
/*
 是一个32位的随机字符串，对于这个32位随机字符串的建立，需要加入当前时间戳的毫秒数，定位在毫秒级别减少随机字符串的碰撞。
 当前的值是存储到本地存储中。
 */
+ (NSString *)getTempidfa;
/*
 获取idfa
 */
+ (NSString *)getIDFA;
/*
 获取cer_id
 caid信息设置成的md5值但是不会包含开机信息
 当前内容存储到keychain中。
 */
+ (NSString *)getCerid;
@end

NS_ASSUME_NONNULL_END
