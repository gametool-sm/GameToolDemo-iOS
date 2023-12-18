//
//  GTSDKConfig.m
//  GTSDK
//
//  Created by smwl_dxl on 2023/6/29.
//

#import "GTSDKConfig.h"

NSString *const GTSDKAbnormalExitNotification = @"GTSDKAbnormalExitNotification";

NSString *const GTSDKChangeFloatingBallStateNotification = @"GTSDKChangeFloatingBallStateNotification";
NSString *const GTSDKChangeSpeedInfo = @"GTSDKChangeSpeedInfo";
NSString *const GTSDKChangeTheme = @"GTSDKChangeTheme";
NSString *const GTSDKClickerWindowChangeModelNotification = @"GTSDKClickerWindowChangeModelNotification";

NSString *const GTSDKClickerWindowQuitSchemeNotification = @"GTSDKClickerWindowQuitSchemeNotification";
NSString *const GTSDKClickerWindowTapSetNotification = @"GTSDKClickerWindowTapSetNotification";
NSString *const GTSDKClickerWindowPauseNotification = @"GTSDKClickerWindowPauseNotification";

NSString *const GTSDKRecordWindowQuitSchemeNotification = @"GTSDKRecordWindowQuitSchemeNotification";
NSString *const GTSDKRecordWindowTapSetNotification = @"GTSDKRecordWindowTapSetNotification";

NSString *const GTSDKRecordFinishRecordNotification = @"GTSDKRecordFinishRecordNotification";

/*
 游戏的appkey
 */
static NSString * __appkey = @"";
/*
 当前设备信息Id信息，会在初始化成功的接口返回
 */
static NSString * __deviceId;
/*
 当前C端的用户Id，需要将其覆盖初始化接口中返回的userId
 */
static NSString * __userId = @"";
/*
 当前后门的加密密码，需要将其覆盖初始化接口中返回的
 */
static NSString * __devVerify = @"";
/**
 加速功能是否开启
 */
static BOOL __isSpeedUpFeature;
/**
 加速器配置
 */
static NSDictionary *__speedUpConfig;
/**
 连点功能是否开启
 */
static BOOL __isLinkerFeature;
/**
 调试模式是否开启
 */
static BOOL __isOpenDebugEnvironment;

@implementation GTSDKConfig


+(void)setAppkey:(NSString *)appkey {
    __appkey = appkey ?: @"";
}
+(NSString *)getAppkey {
    return __appkey;
}
+(void)setDeviceId:(NSString *)deviceId {
    __deviceId = deviceId ?: @"";
}
+(NSString *)getDeviceId {
    return __deviceId;
}
//设置用户Id
+(void)setUserId:(NSString *)userID {
    __userId = userID ?: @"";
}
//获取用户Id
+(NSString *)getUserID {
    return __userId;
}
+(void)setDevVerify:(NSString *)devVerify {
    __devVerify = devVerify ?: @"";
}
+(NSString *)getDevVerify {
    return __devVerify;
}
//获取功能权限
+(void)setIsSpeedUpFeature:(BOOL)isSpeedUpFeature {
    __isSpeedUpFeature = isSpeedUpFeature;
}

+(BOOL)getIsSpeedUpFeature {
    return __isSpeedUpFeature;
}

+(void)setIsLinkerFeature:(BOOL)isLinkerFeature {
    __isLinkerFeature = isLinkerFeature;
}

+(BOOL)getIsLinkerFeature {
    return __isLinkerFeature;
}

//获取是否是调试模式
+(void)setIsOpenDebugEnvironment:(BOOL)isOpenDebugEnvironment {
    __isOpenDebugEnvironment = isOpenDebugEnvironment;
}

+(BOOL)getIsOpenDebugEnvironment {
    return __isOpenDebugEnvironment;
}

//加速器配置
+(void)setSpeedUpConfig:(NSDictionary *)speedUpConfigDict {
    __speedUpConfig = speedUpConfigDict;
}

+(NSDictionary *)getSpeedUpConfig {
    return __speedUpConfig;
}

@end
