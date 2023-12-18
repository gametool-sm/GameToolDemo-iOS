//
//  GTSDKUtils.h
//  GTSDK
//
//  Created by shangmi on 2023/6/15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GTFloatingWindowCacheProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface GTSDKUtils : NSObject <GTFloatingWindowCacheProtocol>

+ (BOOL)isPortrait;
//获取SDK是默认状态还是班半自定义等
+ (NSString *)getGTSDKStyle;

//获取SDK主题
+ (int)getSDKThemeType;
//保存SDK主题
+ (void)saveSDKThemeType:(int)type;

//判断是否出现过极简模式蒙版
+ (BOOL)isShowMinimalistGuideMask;
//保存已出现蒙版
+ (void)saveShowMinimalistGuideMask;

//获取后门的debugtoken
+ (NSDictionary *)getDebugToken;
//保存后门的debugtoken
+ (void)saveDebugToken:(NSDictionary *)dict;

#pragma mark - speed up

//判断是否阅读了加速器教程
+ (BOOL)isReadSpeedUpTutorials;
//保存已阅读加速器教程
+ (void)saveReadSpeedUpTutorials;

//判断是否是第一次打开极简模式
+ (BOOL)isfirstOpenExtremely;
//保存已打开过极简模式
+ (void)savefirstOpenExtremely;

//判断是否是第一次打开自动贴边
+ (BOOL)isfirstOpenAutoHide;
//保存已打开过自动贴边
+ (void)savefirstOpenAutoHide;

//判断是否是第一次打开倍率
+ (BOOL)isfirstOpenMultiplying;
//保存已打开过倍率
+ (void)savefirstOpenMultiplying;


//获取上次保存的悬浮球位置
+ (CGPoint)getFloatingBallLastPosition;

//保存悬浮球的移动位置
+ (void)saveFloatingBallPosition:(CGPoint)centerPoint;

//获取加速器是否打开
+ (BOOL)getSpeedUpControl;

//保存加速器是否打开
+ (void)saveSpeedUpControl:(BOOL)isStart;

#pragma mark - clicker

//判断是否阅读了连点器教程
+ (BOOL)isReadClickerTutorials;

//保存已阅读连点器教程
+ (void)saveReadClickTutorials;

//获取上次保存的连点器悬浮窗位置
+ (CGPoint)getClickerWindowLastPosition;

//保存连点器悬浮窗的移动位置
+ (void)saveClickerWindowPosition:(CGPoint)centerPoint;

//是否不是第一次使用录制功能
+(void)saveIsNotFirstTimeRecord;
+(BOOL)getIsNotFirstTimeRecord;

//获取上次保存的录制悬浮窗位置
+ (CGPoint)getRecordWindowLastPosition;

//保存录制悬浮窗的移动位置
+ (void)saveRecordWindowPosition:(CGPoint)centerPoint;

#pragma mark - common

+ (NSBundle *)bundleWithName:(NSString *)name;

+ (UIViewController*)getTopWindow;

//json字符串转换成字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

@end

NS_ASSUME_NONNULL_END
