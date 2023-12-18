//
//  GTSDKConfig.h
//  GTSDK
//
//  Created by smwl_dxl on 2023/6/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Notification Name
 */
extern NSString *const GTSDKAbnormalExitNotification;               //异常退出通知

extern NSString *const GTSDKChangeFloatingBallStateNotification;    //更改悬浮球三种状态
extern NSString *const GTSDKChangeSpeedInfo;                        //更改有关加速器的所有消息，如加减速，具体数值，控制开关
extern NSString *const GTSDKChangeTheme;                            //更改整体主题浅色或深色
extern NSString *const GTSDKClickerWindowChangeModelNotification;

extern NSString *const GTSDKClickerWindowQuitSchemeNotification;           //连点器悬浮窗下滑至退出方案区域，并且退出方案
extern NSString *const GTSDKClickerWindowTapSetNotification;               //悬浮窗点击设置跳转悬浮弹窗 
extern NSString *const GTSDKClickerWindowPauseNotification;                //连点器暂停发出通知

extern NSString *const GTSDKRecordWindowQuitSchemeNotification;         //录制悬浮窗下滑至退出方案区域，并且退出方案
extern NSString *const GTSDKRecordWindowTapSetNotification;             ///录制悬浮窗点击设置跳转悬浮弹窗 
extern NSString *const GTSDKRecordFinishRecordNotification;
@interface GTSDKConfig : NSObject

//设置appkey
+(void)setAppkey:(NSString *)appkey;
//获取appkey
+(NSString *)getAppkey;
//设置设备id，在初始化的接口里面返回，设置之后在后续接口的请求头中会用到
+(void)setDeviceId:(NSString *)deviceId;
//获取设备id
+(NSString *)getDeviceId;
//设置用户Id
+(void)setUserId:(NSString *)userID;
//获取用户Id
+(NSString *)getUserID;
//设置后门密码
+(void)setDevVerify:(NSString *)devVerify;
//获取后门密码
+(NSString *)getDevVerify;

//获取功能权限
//获取加速权限
+(void)setIsSpeedUpFeature:(BOOL)isSpeedUpFeature;
+(BOOL)getIsSpeedUpFeature;
//获取连点权限
+(void)setIsLinkerFeature:(BOOL)isLinkerFeature;
+(BOOL)getIsLinkerFeature;

//获取是否是调试模式
+(void)setIsOpenDebugEnvironment:(BOOL)isOpenDebugEnvironment;
+(BOOL)getIsOpenDebugEnvironment;

//加速器配置
+(void)setSpeedUpConfig:(NSDictionary *)speedUpConfigDict;
+(NSDictionary *)getSpeedUpConfig;

@end

NS_ASSUME_NONNULL_END
