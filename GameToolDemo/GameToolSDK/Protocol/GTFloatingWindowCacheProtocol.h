//
//  GTFloatingWindowCacheProtocol.h
//  GTSDK
//
//  Created by shangmi on 2023/6/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GTFloatingWindowCacheProtocol <NSObject>

//获取上次保存的加速器速度记录
+ (NSArray *)getLastSpeedUpOfSpeed;
//保存设置的加速器速度记录
+ (void)saveSpeedUpOfSpeed:(NSArray *)array;
//获取上次保存的加速记录
+ (int)getSpeedUpOfUp;
//保存设置的加速记录
+ (void)saveSpeedUpOfUp:(int)speed;
//获取上次保存的减速记录
+ (float)getSpeedUpOfDown;
//保存设置的减速记录
+ (void)saveSpeedUpOfDown:(float)speed;


//获取弹出极简模式提示次数
+ (int)getExtremelyAustereTipShowTimes;
//保存极简模式提示弹窗出现次数
+ (void)saveExtremelyAustereTipShowTimes:(int)times;
//获取极简模式开关
+ (BOOL)getExtremelyAustereIsOn;
//保存极简模式开关
+ (void)saveExtremelyAustereIsOn:(BOOL)isOn;
//获取自动贴边开关
+ (BOOL)getAutoHideIsOn;
//保存自动贴边开关
+ (void)saveAutoHideIsOn:(BOOL)isOn;
//获取倍率切换开关
+ (BOOL)getMultiplyingIsOn;
//保存倍率切换开关
+ (void)saveMultiplyingIsOn:(BOOL)isOn;
//获取倍率切换的当前配置
+ (NSArray *)getCurrentMultiplying;
//保存倍率切换的当前配置
+ (void)saveCurrentMultiplying:(NSArray *)config;
//保存隐藏悬浮球提示弹窗出现次数
+ (void)saveFloatBallHideWindowShowTimes:(int)times;
//获取隐藏悬浮球弹窗次数
+ (int)getFloatBallHideWindowShowTimes;
//保存关闭极简模式弹窗出现次数
+ (void)saveCloseSimpleStyleWindowShowTimes:(int)times;
//获取关闭极简模式弹窗次数
+ (int)getCloseSimpleStyleWindowShowTimes;
@end

NS_ASSUME_NONNULL_END
