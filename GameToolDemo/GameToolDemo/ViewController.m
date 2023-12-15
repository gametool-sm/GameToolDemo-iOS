//
//  ViewController.m
//  GameToolDemo
//
//  Created by smwl on 2023/12/1.
//

#import "ViewController.h"

#import <GameToolSDK/GameToolSDK.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *appKey = @"Your appKey";
    BOOL openDebug = YES;
    [self initSDK:appKey style:GTSDKStylesDefault openDebug:openDebug];
    
    
}


/// 初始化SDK
/// - Parameters:
///   - appKey: 登录gametool官方网站创建应用获取
///
///   - style:SDK初始化模式，决定初始化后悬浮球是否立即显示
///     GTSDKStylesDefault 默认模式：初始化后显示小兔子悬浮球
///     GTSDKStylesCustom 自定义模式：初始化后不显示小兔子悬浮球，需调用[GTSDK showFloatingWindow];唤起悬浮球
///
///   - openDebug: 是否开启调试环境
///     YES:开启,可在管理后台调整加速器倍率
///     NO:不开启,加速器倍率不可调整，由加速配置文件决定
-(void)initSDK:(NSString *)appKey style:(GTSDKStyles)style openDebug:(BOOL)openDebug{
    __weak typeof(self)weakSelf = self;
    [GTSDK initWithAppKey:appKey style:GTSDKStylesDefault openDebugEnvironment:YES andSuccess:^{
        //初始化成功回调
        NSString *userID = @"Your userID";
        [weakSelf loginWithUserID:userID];
        
    } failure:^(NSString * _Nonnull errormsg) {
        //初始化失败回调
        
    }];

}


/// 登录SDK
/// - Parameter userID: 您的用户ID,登录gametool官方网站创建应用获取
-(void)loginWithUserID:(NSString *)userID{
    [GTSDK loginWithGameUserID:userID andSuccess:^{
        //登录成功回调
        
    } failure:^(NSString * _Nonnull errormsg) {
        //登录失败回调
        
    }];
}

@end
