//
//  GTSDK.m
//  GTSDK
//
//  Created by shangmi on 2023/6/15.
//

#import "GTSDK.h"
#import "GTOperationControl.h"
#import "GTFloatingWindowManager.h"
#import "GTNetworkManager.h"
#import "GTRecordView.h"
#import "GTRecordReadyView.h"
#import "GTRecordGuideView.h"
#import "SMDurationEventReport.h"
#import "GTDataConfig.h"
#import "SMEventSensor.h"
#import "GTDialogView.h"
#import "GTDialogWindowManager.h"
@implementation GTSDK

+ (void)initWithAppKey:(NSString *)appkey style:(GTSDKStyles)style openDebugEnvironment:(BOOL)openDebugEnvironment andSuccess:(nonnull void (^)(void))success failure:(nonnull void (^)(NSString * _Nonnull))failure {
    //为了测试方便，将style由参数传入，plist中的字段未变，看之后的讨论是用哪一个
    [[NSUserDefaults standardUserDefaults] setInteger:style forKey:@"sdkStyle"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    //    初始的时候设置当前是gtsdk（因为gtsdk的加密串跟smsdk以及7game-sdk的不一致）
    [SMCommonUtils setIsGtsdk:YES];
    //    设置域名，因为不同域名的加密串也不同（正式站：1，测试站：0，开发站：-1），根据sdk使用的域名配置
    [SMCommonUtils setDomain:PROD ? @"1" : @"0"];
    
    [GTSDKConfig setAppkey:appkey];
    [GTSDKConfig setIsOpenDebugEnvironment:openDebugEnvironment];
    
    NSDictionary * parame = [SMEncryptUtil getEncryptParameWithOriginDic:@{@"appKey" : appkey ?: @"", @"packageName" : [[NSBundle mainBundle] bundleIdentifier]}];
    NSString * urlStr = [SMEncryptUtil getEncryptResquestUrlWithOriginUrl:GTSDKAPI_SDKINIT andApi:@""];
    NSString * url = [NSString stringWithFormat:@"%@/gt.c/%@",GTSDKAPI_DOMMAIN,urlStr];
    [[GTNetworkManager shareManager] POST:url parameters:parame success:^(id  _Nullable responseObject) {
        NSString * errorno = [responseObject objectForKey:@"errorno"] ?: @"";
        if ([errorno integerValue] == 0) {
            NSString * deviceId = [responseObject objectForKey:@"deviceId"] ?: @"";
            NSString * userId = [responseObject objectForKey:@"userId"] ?: @"";
            NSString * devVerify = [responseObject objectForKey:@"devVerify"] ?: @"";
            
            // 数据安全转换, 服务端可能返回的是long类型， 统一转换为String类型；
            if ([deviceId isKindOfClass:[NSNumber class]]) {
                long deviceIdLong = [(NSNumber *)deviceId longValue];
                deviceId = [NSString stringWithFormat:@"%ld", deviceIdLong];
            }
            if ([userId isKindOfClass:[NSNumber class]]) {
                long userIdLong = [(NSNumber *)userId longValue];
                userId = [NSString stringWithFormat:@"%ld", userIdLong];
            }
            
            [GTSDKConfig setDeviceId:deviceId];
            [GTSDKConfig setUserId:userId];
            [GTSDKConfig setDevVerify:devVerify];
            
            //服务权限
            NSArray *array = [responseObject objectForKey:@"servicePermissions"];
            if (array.count) {
                if ([[array firstObject][@"serviceName"] isEqualToString:@"Speedup"]) {
                    BOOL isSpeedUp = ([array[0][@"isEnabled"] intValue] == 0) ? YES : NO;
                    [GTSDKConfig setIsSpeedUpFeature:isSpeedUp];
                }
                if ([[array lastObject][@"serviceName"] isEqualToString:@"Linker"]) {
                    BOOL isLinker = ([array[1][@"isEnabled"] intValue] == 0) ? YES : NO;
                    [GTSDKConfig setIsLinkerFeature:isLinker];
                }
            }
            
            //加速器配置
            NSDictionary *dict = [responseObject objectForKey:@"speedupInfo"];
            [GTSDKConfig setSpeedUpConfig:dict];
            
            [GTSDKConfig setIsSpeedUpFeature:YES];
            [GTSDKConfig setIsLinkerFeature:YES];
        
            //配置神策初始化
            [[GTDataConfig sharedInstance] initConfigWithAppkey:appkey];
            
            //SDK启动成功埋点
            [[GTDataConfig sharedInstance] uploadSensorDataWithEvent:GTSensorEventSDKSuccessStart andProperties:@{} shouldFlush:YES];
            
            [[GTOperationControl shareInstance] setUpWithInfo:[NSDictionary dictionary]];
            
            if (success){
                success();
            }
            GTDialogView *dialogView=[[GTDialogView  alloc] initWithStyle:DialogViewStyleDefault title:@"初始化成功" content:@"初始化成功" leftButtonTitle:@"确认" rightButtonTitle:@"取消" leftButtonBlock:nil rightButtonBlock:nil];
//            [[UIApplication sharedApplication].keyWindow addSubview:dialogView];
            UIView *view = [GTDialogWindowManager shareInstance].dialogVC.view;
            UIViewController *vc = [GTDialogWindowManager shareInstance].dialogVC;
            NSLog(@"%@",view);
            NSLog(@"%@",vc );
            [[GTDialogWindowManager shareInstance].dialogVC.view addSubview:dialogView];
            [[GTDialogWindowManager shareInstance] dialogWindowShow];
        } else {
            if (failure){
                failure([responseObject objectForKey:@"errormsg"] ?: @"");
            }
            
        }
    } failure:^(NSError * _Nullable error) {
        if (failure){
            failure(error.localizedDescription);
        }
        
    }];
}

+ (void)loginWithGameUserID:(NSString *)game_user_id andSuccess:(void (^)(void))success failure:(void (^)(NSString * _Nonnull))failure {
    NSDictionary * param = @{@"appKey" : [GTSDKConfig getAppkey],@"gameUserId" : game_user_id ? : @"", @"packageName" : [[NSBundle mainBundle] bundleIdentifier]};
    NSDictionary * parame = [SMEncryptUtil getEncryptParameWithOriginDic:param];
    NSString * urlStr = [SMEncryptUtil getEncryptResquestUrlWithOriginUrl:GTSDKAPI_SDKLOGIN andApi:@""];
    NSString * url = [NSString stringWithFormat:@"%@/gt.c/%@",GTSDKAPI_DOMMAIN,urlStr];
    [[GTNetworkManager shareManager] POST:url parameters:parame success:^(id  _Nullable responseObject) {
        NSString * errorno = [responseObject objectForKey:@"errorno"] ?: @"";
        if ([errorno integerValue] == 0) {
            NSString * userId = [responseObject objectForKey:@"userId"] ?: @"";
            
            // 数据安全转换, 服务端可能返回的是long类型， 统一转换为String类型；
            if ([userId isKindOfClass:[NSNumber class]]) {
                long userIdLong = [(NSNumber *)userId longValue];
                userId = [NSString stringWithFormat:@"%ld", userIdLong];
            }
            
            [GTSDKConfig setUserId:userId];
            
            //sensor login
            [[GTDataConfig sharedInstance] loginWithUserId:userId];
            
            if (success){
                success();
            }
        } else {
            if (failure){
                failure([responseObject objectForKey:@"errormsg"] ?: @"");
            }
        }
    } failure:^(NSError * _Nullable error) {
        if (failure){
            failure(error.localizedDescription);
        }
    }];
}


+ (void)showFloatingWindow {
    if ([GTFloatingWindowManager shareInstance].windowWindow) {
        [[GTFloatingWindowManager shareInstance] floatingWindowShow];
    }
}

//测试用,上线注释
+ (void)clearShowTimes {
//    [GTSDKUtils saveExtremelyAustereTipShowTimes:0];
//    [GTSDKUtils saveFloatBallHideWindowShowTimes:0];
//    [GTSDKUtils saveCloseSimpleStyleWindowShowTimes:0];
}

+ (int)getTimes {
    return [GTSDKUtils getExtremelyAustereTipShowTimes];
}

+(void)durationEventReportTest{

    
}
@end
