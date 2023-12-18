//
//  GTSDKUtils.m
//  GTSDK
//
//  Created by shangmi on 2023/6/15.
//

#import "GTSDKUtils.h"
#import "GTFloatingBallConfig.h"
#import "GTFloatingWindowConfig.h"

/**
 用户传入该应用是横屏还是竖屏（横屏还需自适应翻转）
 1为竖屏，其余为横屏
 */
static NSString *const GTSDKScreenOrientation = @"GTSDKScreenOrientation";
/**
 用户传入该应用使用哪种风格的SDK

 */
static NSString *const GTSDKStyleString = @"GTSDKStyleString";

//SDK主题
static NSString *const GTSDKThemeTypeString = @"GTSDKThemeTypeString";
//判断是否出现过极简模式蒙版
static NSString *const GTSDKShowMinimalistMask = @"GTSDKShowMinimalistMask";

//debugToken
static NSString *const GTSDKDebugToken = @"GTSDKDebugToken";
//悬浮球每次移动的位置
static NSString *const GTSDKFloatingBallLastPositionString = @"GTSDKFloatingBallLastPositionString";

#pragma mark - speed up

//保存是否看过加速器介绍
static NSString *const GTSDKAgreeSpeedUpDesc = @"GTSDKAgreeSpeedUpDesc";

//判断是否是第一次打开极简模式
static NSString *const isfirstOpenExtremely = @"isfirstOpenExtremely";

//判断是否是第一次打开自动贴边
static NSString *const isfirstOpenAutoHide = @"isfirstOpenAutoHide";

//判断是否是第一次打开倍率
static NSString *const isfirstOpenMultiplying = @"isfirstOpenMultiplying";

//保存加速器是否开始
static NSString *const GTSDKSpeedUpControl = @"GTSDKSpeedUpControl";

//保存当前加速器调节的模式和速度（如加速开始*6，即+6；减速暂停*0.2，即-0.2。）
static NSString *const GTSDKSpeedUpOfSpeed = @"GTSDKSpeedUpOfSpeed";
//保存加速模式和速度
static NSString *const GTSDKSpeedUpOfUp = @"GTSDKSpeedUpOfUp";
//保存减速模式和速度
static NSString *const GTSDKSpeedUpOfDown = @"GTSDKSpeedUpOfDown";

//极简模式弹窗弹出次数，当勾选下次不再提示时直接置为3次
static NSString *const GTSDKExtremelyAustereTipShowTimes = @"GTSDKExtremelyAustereTipShowTimes";
//极简模式开关
static NSString *const GTSDKExtremelyAustereIsOn = @"GTSDKExtremelyAustereIsOn";
//自动贴边开关
static NSString *const GTSDKAutoHideIsOn = @"GTSDKAutoHideIsOn";
//倍率快捷切换开关
static NSString *const GTSDKMultiplyingIsOn = @"GTSDKMultiplyingIsOn";
//倍率切换配置
static NSString *const GTSDKCurrentMultiplying = @"CurrentMultiplying";


#pragma mark - clicker

//保存是否看过连点器介绍
static NSString *const GTSDKAgreeClickerDesc = @"GTSDKAgreeClickerDesc";

//连点器悬浮窗每次移动的位置
static NSString *const GTSDKClickerWindowLastPositionString = @"GTSDKClickerWindowLastPositionString";

//录制悬浮窗每次移动的位置
static NSString *const GTSDKRecordWindowLastPositionString = @"GTSDKRecordWindowLastPositionString";

//隐藏悬浮球弹窗弹出次数，当勾选下次不再提示时直接置为3次
static NSString *const GTSDKFloatBallHideWindowShowTimes = @"GTSDKFloatBallHideWindowShowTimes";
//关闭极简模式弹窗弹出次数，当勾选下次不再提示时直接置为3次
static NSString *const GTSDKCloseSimpleStyleWindowShowTimes = @"GTSDKCloseSimpleStyleWindowShowTimes";

//是否不是第一次使用录制功能
static NSString *const GTSDKIsNotFirstTimeRecord = @"GTSDKIsNotFirstTimeRecord";

@implementation GTSDKUtils

+ (BOOL)isPortrait {
    NSString * plistPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    if (plistPath && plistPath.length > 0) {
        NSMutableDictionary * gameConfigData = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        if (gameConfigData && [[gameConfigData objectForKey:GTSDKScreenOrientation] isEqualToString:@"1"]) {
            return YES;
        }else{
            return NO;
        }
    }else{
        //没获取到按照竖屏
        return YES;
    }
}

+ (NSString *)getGTSDKStyle {
    //方便测试，从Userdefault中获取
    return [NSString stringWithFormat:@"%d", (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"sdkStyle"]];
    
    
    
    
    
    
    NSString * plistPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    if (plistPath && plistPath.length > 0) {
        NSMutableDictionary * gameConfigData = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        if (gameConfigData && ![[gameConfigData objectForKey:GTSDKStyleString] isEqualToString:@"1"]) {
            return [gameConfigData objectForKey:GTSDKStyleString];
        }else{
            return @"0";
        }
    }else{
        //没获取到按照使用默认
        return @"0";
    }
}

//获取SDK主题
+ (int)getSDKThemeType {
    return  (int)[[NSUserDefaults standardUserDefaults] integerForKey:GTSDKThemeTypeString];
}
//保存SDK主题
+ (void)saveSDKThemeType:(int)type {
    [[NSUserDefaults standardUserDefaults] setInteger:(int)type forKey:GTSDKThemeTypeString];
}

//判断是否出现过极简模式引导蒙版
+ (BOOL)isShowMinimalistGuideMask {
    return [[NSUserDefaults standardUserDefaults] boolForKey:GTSDKShowMinimalistMask];
}
//保存已出现蒙版
+ (void)saveShowMinimalistGuideMask {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:GTSDKShowMinimalistMask];
}

//获取后门的debugtoken
+ (NSDictionary *)getDebugToken {
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:GTSDKDebugToken];
    if (dict.allKeys.count) {
        return dict;
    }else {
        return @{};
    }
}

//保存后门的debugtoken
+ (void)saveDebugToken:(NSDictionary *)dict {
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:GTSDKDebugToken];
}

//获取上次保存的悬浮球位置
+ (CGPoint)getFloatingBallLastPosition {
    NSString *lastPosition = [[NSUserDefaults standardUserDefaults] objectForKey:GTSDKFloatingBallLastPositionString];
    
    CGFloat lastPositionX = 0;
    CGFloat lastPositionY = 0;
    
    if ([GTSDKUtils isPortrait]) {
        lastPositionX = 0;
        lastPositionY = (SCREEN_HEIGHT - floatingWindowAndChange_height)/3*2 - 10 - floatingBall_height/2;
    }else {
        lastPositionX = SAFE_AREA_LEFT;
        lastPositionY = SCREEN_HEIGHT / 2;
    }
    
    if (lastPosition) {
        CGPoint lastPositionPoint = CGPointFromString(lastPosition);
        return lastPositionPoint;
    }
    return CGPointMake(lastPositionX, lastPositionY); //初始位置
}

//保存悬浮球的移动位置
+ (void)saveFloatingBallPosition:(CGPoint)centerPoint {
    NSString *lastPosition = NSStringFromCGPoint(centerPoint);
    if (lastPosition) {
        [[NSUserDefaults standardUserDefaults] setObject:lastPosition forKey:GTSDKFloatingBallLastPositionString];
    }
}

#pragma mark - speed up

//判断是否阅读了加速器教程
+ (BOOL)isReadSpeedUpTutorials {
    return [[NSUserDefaults standardUserDefaults] boolForKey:GTSDKAgreeSpeedUpDesc];
}

//保存已阅读加速器教程
+ (void)saveReadSpeedUpTutorials {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:GTSDKAgreeSpeedUpDesc];
}

+ (NSBundle *)bundleWithName:(NSString *)name {
    NSString *mainBundlePath = [[NSBundle mainBundle] resourcePath];
    NSString *frameworkBundlePath = [mainBundlePath stringByAppendingPathComponent:name];
    if ([[NSFileManager defaultManager] fileExistsAtPath:frameworkBundlePath]) {
        return [NSBundle bundleWithPath:frameworkBundlePath];
    }
    return nil;
}

//判断是否是第一次打开极简模式
+ (BOOL)isfirstOpenExtremely {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:isfirstOpenExtremely]) {
        return NO;
    }else {
        return YES;;
    }
}
//保存已打开过极简模式
+ (void)savefirstOpenExtremely {
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:isfirstOpenExtremely];
}

//判断是否是第一次打开自动贴边
+ (BOOL)isfirstOpenAutoHide {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:isfirstOpenAutoHide]) {
        return NO;
    }else {
        return YES;;
    }
}
//保存已打开过自动贴边
+ (void)savefirstOpenAutoHide {
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:isfirstOpenAutoHide];
}

//判断是否是第一次打开倍率
+ (BOOL)isfirstOpenMultiplying {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:isfirstOpenMultiplying]) {
        return NO;
    }else {
        return YES;;
    }
}
//保存已打开过倍率
+ (void)savefirstOpenMultiplying {
    [[NSUserDefaults standardUserDefaults] setObject:@"0"  forKey:isfirstOpenMultiplying];
}


//获取加速器是否打开
+ (BOOL)getSpeedUpControl {
    return [[NSUserDefaults standardUserDefaults] boolForKey:GTSDKSpeedUpControl];
}
//保存加速器是否打开
+ (void)saveSpeedUpControl:(BOOL)isStart {
    [[NSUserDefaults standardUserDefaults] setBool:isStart forKey:GTSDKSpeedUpControl];
}

#pragma mark - clicker

//判断是否阅读了连点器教程
+ (BOOL)isReadClickerTutorials {
    return [[NSUserDefaults standardUserDefaults] boolForKey:GTSDKAgreeClickerDesc];
}

//保存已阅读连点器教程
+ (void)saveReadClickTutorials {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:GTSDKAgreeClickerDesc];
}

//获取上次保存的连点器悬浮窗位置
+ (CGPoint)getClickerWindowLastPosition {
    NSString *lastPosition = [[NSUserDefaults standardUserDefaults] objectForKey:GTSDKClickerWindowLastPositionString];
    
    CGFloat lastPositionX = 0;
    CGFloat lastPositionY = 0;
    
    if ([GTSDKUtils isPortrait]) {
        lastPositionX = clickerWindow_distance;
        lastPositionY = 257 * WIDTH_RATIO;
    }else {
        lastPositionX = SAFE_AREA_LEFT;
        lastPositionY = 160;
    }
    
    if (lastPosition) {
        CGPoint lastPositionPoint = CGPointFromString(lastPosition);
        return lastPositionPoint;
    }
    return CGPointMake(lastPositionX, lastPositionY); //初始位置
}

//保存连点器悬浮窗的移动位置
//连点器悬浮窗保存的坐标为origin，不为center
+ (void)saveClickerWindowPosition:(CGPoint)centerPoint {
    NSString *lastPosition = NSStringFromCGPoint(centerPoint);
    if (lastPosition) {
        [[NSUserDefaults standardUserDefaults] setObject:lastPosition forKey:GTSDKClickerWindowLastPositionString];
    }
}

//获取上次保存的录制悬浮窗位置
+ (CGPoint)getRecordWindowLastPosition {
    NSString *lastPosition = [[NSUserDefaults standardUserDefaults] objectForKey:GTSDKRecordWindowLastPositionString];
    
    CGFloat lastPositionX = 0;
    CGFloat lastPositionY = 0;
    
    if ([GTSDKUtils isPortrait]) {
        lastPositionX = clickerWindow_distance;
        lastPositionY = 257 * WIDTH_RATIO;
    }else {
        lastPositionX = SAFE_AREA_LEFT;
        lastPositionY = 160;
    }
    
    if (lastPosition) {
        CGPoint lastPositionPoint = CGPointFromString(lastPosition);
        return lastPositionPoint;
    }
    return CGPointMake(lastPositionX, lastPositionY); //初始位置
}

//保存录制悬浮窗的移动位置
+ (void)saveRecordWindowPosition:(CGPoint)centerPoint {
    NSString *lastPosition = NSStringFromCGPoint(centerPoint);
    if (lastPosition) {
        [[NSUserDefaults standardUserDefaults] setObject:lastPosition forKey:GTSDKRecordWindowLastPositionString];
    }
}

#pragma mark - GTFloatingWindowCacheProtocol

//获取上次保存的加速记录
+ (int)getSpeedUpOfUp {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:GTSDKSpeedUpOfUp]) {
        return [[[NSUserDefaults standardUserDefaults] objectForKey:GTSDKSpeedUpOfUp] intValue];
    }else {
        return 1;
    }
}
//保存设置的加速记录
+ (void)saveSpeedUpOfUp:(int)speed {
    if (speed) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",speed] forKey:GTSDKSpeedUpOfUp];
    }
}
//获取上次保存的减速记录
+ (float)getSpeedUpOfDown {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:GTSDKSpeedUpOfDown]) {
        return [[[NSUserDefaults standardUserDefaults] objectForKey:GTSDKSpeedUpOfDown] floatValue];
    }else {
        return 1.0;
    }
}
//保存设置的减速记录
+ (void)saveSpeedUpOfDown:(float)speed {
    if (speed) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",speed] forKey:GTSDKSpeedUpOfDown];
    }
}

//获取上次保存的加速器速度记录
+ (NSArray *)getLastSpeedUpOfSpeed {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:GTSDKSpeedUpOfSpeed]) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:GTSDKSpeedUpOfSpeed];
        NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return array;
    }else {
        GTMultiplyingModel *newModel = [GTMultiplyingModel new];
        newModel.number = 1;
        newModel.isSelected = NO;
        newModel.isUp = YES;
        
        return @[newModel];
    }
}

//保存设置的加速器速度记录
+ (void)saveSpeedUpOfSpeed:(NSArray *)array {
    if (array) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:GTSDKSpeedUpOfSpeed];
    }
}

//获取弹出极简模式提示次数
+ (int)getExtremelyAustereTipShowTimes {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:GTSDKExtremelyAustereTipShowTimes]) {
        return  [[[NSUserDefaults standardUserDefaults] objectForKey:GTSDKExtremelyAustereTipShowTimes] intValue];
    }else {
        return 0;
    }
}

//保存极简模式提示弹窗出现次数
+ (void)saveExtremelyAustereTipShowTimes:(int)times {
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",times] forKey:GTSDKExtremelyAustereTipShowTimes];
}
+ (void)saveFloatBallHideWindowShowTimes:(int)times {
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",times] forKey:GTSDKFloatBallHideWindowShowTimes];
}
+ (int)getFloatBallHideWindowShowTimes {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:GTSDKFloatBallHideWindowShowTimes]) {
        return  [[[NSUserDefaults standardUserDefaults] objectForKey:GTSDKFloatBallHideWindowShowTimes] intValue];
    }else {
        return 0;
    }
}
+ (void)saveCloseSimpleStyleWindowShowTimes:(int)times {
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",times] forKey:GTSDKCloseSimpleStyleWindowShowTimes];
}
+(int)getCloseSimpleStyleWindowShowTimes {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:GTSDKCloseSimpleStyleWindowShowTimes]) {
        return  [[[NSUserDefaults standardUserDefaults] objectForKey:GTSDKCloseSimpleStyleWindowShowTimes] intValue];
    }else {
        return 0;
    }
}
//获取极简模式开关
+ (BOOL)getExtremelyAustereIsOn {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:GTSDKExtremelyAustereIsOn]) {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:GTSDKExtremelyAustereIsOn] intValue] == 1) {
            return YES;
        }else {
            return NO;
        }
    }else {
        return NO;
    }
}

//保存极简模式开关
+ (void)saveExtremelyAustereIsOn:(BOOL)isOn {
    if (![[NSUserDefaults standardUserDefaults] objectForKey:GTSDKAutoHideIsOn]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:GTSDKAutoHideIsOn];
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",isOn] forKey:GTSDKExtremelyAustereIsOn];
}

//获取自动贴边开关
+ (BOOL)getAutoHideIsOn {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:GTSDKAutoHideIsOn]) {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:GTSDKAutoHideIsOn] intValue] == 1) {
            return YES;
        }else {
            return NO;
        }
    }else {
        return NO;
    }
}

//保存自动贴边开关
+ (void)saveAutoHideIsOn:(BOOL)isOn {
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",isOn] forKey:GTSDKAutoHideIsOn];
}

//获取倍率切换开关
+ (BOOL)getMultiplyingIsOn {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:GTSDKMultiplyingIsOn]) {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:GTSDKMultiplyingIsOn] intValue] == 1) {
            return YES;
        }else {
            return NO;
        }
    }else {
        return NO;
    }
}
//是否不是第一次使用录制功能
+(void)saveIsNotFirstTimeRecord{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:GTSDKIsNotFirstTimeRecord];
}
+(BOOL)getIsNotFirstTimeRecord{
    return [[NSUserDefaults standardUserDefaults] boolForKey:GTSDKIsNotFirstTimeRecord];
}
//保存倍率切换开关
+ (void)saveMultiplyingIsOn:(BOOL)isOn {
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",isOn] forKey:GTSDKMultiplyingIsOn];
}

//获取倍率切换的当前配置
+ (NSArray *)getCurrentMultiplying {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:GTSDKCurrentMultiplying]) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:GTSDKCurrentMultiplying];
        NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return array;
    }else {
        
        GTMultiplyingModel *model = [[GTSDKUtils getLastSpeedUpOfSpeed] firstObject];
        
        GTMultiplyingModel *newModel = [GTMultiplyingModel new];
        newModel.number = 1;
        newModel.isSelected = NO;
        newModel.isUp = YES;
        return @[model, newModel];
    }
}

//保存倍率切换的当前配置
+ (void)saveCurrentMultiplying:(NSArray *)config {
    if (config) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:config];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:GTSDKCurrentMultiplying];
    }
}

+ (UIViewController*)getTopWindow {
    UIWindow *window = [self getSuitableGameWindow];
    UIViewController * vc = [self topViewControllerWithRootViewController:window.rootViewController];
    return vc;
}

+ (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}

//获取的是当前显示在最外层并且大小等于设备窗口大小的窗口
//检测顺序：keywindows , delegate window, windows列表
+ (UIWindow *)getSuitableGameWindow {
    
    if ([self pIsGameWindowSizeSuitable:[UIApplication sharedApplication].keyWindow]) {
        return [UIApplication sharedApplication].keyWindow;
    }
    
    if ([[UIApplication sharedApplication].delegate respondsToSelector:@selector(drawView)]) {
        UIWindow * delegateWindow = [UIApplication sharedApplication].delegate.window;
        if ([self pIsGameWindowSizeSuitable:delegateWindow]) {
            return delegateWindow;
        }
    }
    
    for (UIWindow * window in [UIApplication sharedApplication].windows) {
        if ([self pIsGameWindowSizeSuitable:window]) {
            return window;
        }
    }
    
    return [UIApplication sharedApplication].keyWindow ? : [UIWindow new];
}

+ (BOOL)pIsGameWindowSizeSuitable:(UIWindow * _Nullable)window {
    if (!window || window.hidden) return NO;
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    float screenSmallest = screenSize.height > screenSize.width ? screenSize.width : screenSize.height;
    float tempWindowSmallest = window.width > window.height ? window.height : window.width;
    
    return tempWindowSmallest > 0.8 * screenSmallest;
}
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
