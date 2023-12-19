//
//  GTDataConfig.m
//  GTSDK
//
//  Created by smwl on 2023/11/13.
//

#import "GTDataConfig.h"
#import "SUNYSensorsAnalyticsSDK.h"
#import <sys/utsname.h>
#import "GTDataTimeTester.h"
#import "GTDataTimeCounter.h"

@implementation GTDataConfig

+(instancetype)sharedInstance {
    static GTDataConfig * __sharedInstance;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        __sharedInstance = [[GTDataConfig alloc] init];
    });
    return __sharedInstance;
}

-(void)initConfigWithAppkey:(NSString *)appkey {
    [SUNYSensorsAnalyticsSDK sharedInstanceWithServerURL:GTSDKAPI_SENSOR_URL
                                            andDebugMode:SUNYSensorsAnalyticsDebugOff];
    [[SUNYSensorsAnalyticsSDK sharedInstance] enableLog:YES];
    [[SUNYSensorsAnalyticsSDK sharedInstance] setFlushBeforeEnterBackground:YES];
    [[SUNYSensorsAnalyticsSDK sharedInstance] identify:[self deviceIdWhileInit]];
    
    // 设置公共属性；
    [self setGTSuperPropertiesWithAppkey:appkey];
    
    [GTDataTimeCounter findLocalDataToUploadWhenSensorInit];
    
    //test
    [[GTDataTimeTester new] show];
}

-(void)loginWithUserId:(NSString *)userId {
    if (!userId || userId.length < 0) {
        NSLog(@"userId not valid!");
        return;
    }
    
    [[SUNYSensorsAnalyticsSDK sharedInstance] login:userId];
}

-(void)logout {
    [[SUNYSensorsAnalyticsSDK sharedInstance] logout];
    
    // 登出的时候需要触发一次计时的全上报；
    [[GTDataTimeCounter sharedInstance] sensorUserLogout];
}

-(void)uploadSensorDataWithEvent:(kGTSensorEvent)event
                   andProperties:(NSDictionary *)properties
                     shouldFlush:(BOOL)shouldFlush {
    [[SUNYSensorsAnalyticsSDK sharedInstance] track:event withProperties:properties];
    
    if (shouldFlush) {
        [[SUNYSensorsAnalyticsSDK sharedInstance] flush];
    }
}

#pragma Private
-(NSString *)deviceIdWhileInit {
    // 需要拼接D；
    return [NSString stringWithFormat:@"D%@", [GTSDKConfig getDeviceId]];
}

// 设置公共属性 - 静态公共属性
-(void)setGTSuperPropertiesWithAppkey:(NSString *)appkey {
    NSString *sdkInfoPlistFile = [[NSBundle mainBundle] pathForResource:@"Frameworks/GTSDK.framework/Info" ofType:@"plist"];
    NSDictionary *sdkInfoDict = [NSDictionary dictionaryWithContentsOfFile:sdkInfoPlistFile];
    NSString *sdkVersion = [sdkInfoDict objectForKey:@"CFBundleShortVersionString"];
    
    NSString *deviceId = [self deviceIdWhileInit];
    NSString *customOs = @"iOS";
    NSString *customOsVersion = [UIDevice currentDevice].systemVersion;
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    bool isSimulatorBool = [platform isEqualToString:@"i386"] || [platform isEqualToString:@"x86_64"];
    NSNumber *isSimulator = [NSNumber numberWithBool:isSimulatorBool];
    
    NSDictionary *tmpDict = @{
        @"app_key" : appkey ? : @"",
        @"sdk_version" : sdkVersion ? : @"",
        @"device_id" : deviceId ? : @"",
        @"custom_os" : customOs ? : @"",
        @"custom_os_version": customOsVersion ? : @"",
        @"is_simulator": isSimulator
    };
    
    [[SUNYSensorsAnalyticsSDK sharedInstance] registerSuperProperties:tmpDict];
}

-(void)debugInfo {
    NSString *distinctId = [SUNYSensorsAnalyticsSDK sharedInstance].distinctId;
    NSString *loginId = [SUNYSensorsAnalyticsSDK sharedInstance].loginId;
    NSString *anonymousId = [SUNYSensorsAnalyticsSDK sharedInstance].anonymousId;
    NSDictionary *presetProperties = [[SUNYSensorsAnalyticsSDK sharedInstance] getPresetProperties];
    NSDictionary *superProperties = [[SUNYSensorsAnalyticsSDK sharedInstance] currentSuperProperties];
    
    NSLog(@"=============GTSensorInfo=============");
    NSLog(@"[GTSensorInfo]: distinctId: %@", distinctId);
    NSLog(@"[GTSensorInfo]: loginId: %@", loginId);
    NSLog(@"[GTSensorInfo]: anonymousId: %@", anonymousId);
    NSLog(@"[GTSensorInfo]: presetProperties: %@", presetProperties);
    NSLog(@"[GTSensorInfo]: superProperties: %@", superProperties);
}
@end
