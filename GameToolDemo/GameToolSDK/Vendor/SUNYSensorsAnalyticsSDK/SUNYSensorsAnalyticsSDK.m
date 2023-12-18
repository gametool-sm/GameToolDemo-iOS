//  SUNYSensorsAnalyticsSDK.m
//  SUNYSensorsAnalyticsSDK
//
//  Created by 曹犟 on 15/7/1.
//  Copyright © 2015－2018 Sensors Data Inc. All rights reserved.

#import <objc/runtime.h>
#include <sys/sysctl.h>
#include <stdlib.h>

#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <UIKit/UIApplication.h>
#import <UIKit/UIDevice.h>
#import <UIKit/UIScreen.h>

#import "SUNYJSONUtil.h"
#import "SUNYSAGzipUtility.h"
#import "SUNYMessageQueueBySqlite.h"
#import "SUNYSALogger.h"
#import "SUNYReachability.h"
#import "SUNYSensorsAnalyticsSDK.h"
#import "SUNYJSONUtil.h"
#import "NSString+SUNYHashCode.h"
#import "SUNYSensorsAnalyticsExceptionHandler.h"
#import "SUNYSAKeyChainItemWrapper.h"
#import "SUNYSACommonUtility.h"

#define VERSION @"1.10.17"
#define PROPERTY_LENGTH_LIMITATION 8191
/**
 * @abstract
 * TrackTimer 接口的时间单位。调用该接口时，传入时间单位，可以设置 event_duration 属性的时间单位。
 *
 * @discuss
 * 时间单位有以下选项：
 *   SUNYSensorsAnalyticsTimeUnitMilliseconds - 毫秒
 *   SUNYSensorsAnalyticsTimeUnitSeconds - 秒
 *   SUNYSensorsAnalyticsTimeUnitMinutes - 分钟
 *   SUNYSensorsAnalyticsTimeUnitHours - 小时
 */
typedef NS_ENUM(NSInteger, SUNYSensorsAnalyticsTimeUnit) {
    SUNYSensorsAnalyticsTimeUnitMilliseconds,
    SUNYSensorsAnalyticsTimeUnitSeconds,
    SUNYSensorsAnalyticsTimeUnitMinutes,
    SUNYSensorsAnalyticsTimeUnitHours
};

//中国运营商 mcc 标识
static NSString* const CARRIER_CHINA_MCC = @"460";

void *SUNYSensorsAnalyticsQueueTag = &SUNYSensorsAnalyticsQueueTag;

static SUNYSensorsAnalyticsSDK *sharedInstance = nil;

@interface SUNYSensorsAnalyticsSDK()

// 在内部，重新声明成可读写的

@property (atomic, copy) NSString *serverURL;

@property (atomic, copy) NSString *distinctId;
@property (atomic, copy) NSString *originalId;
@property (atomic, copy) NSString *loginId;
@property (atomic, copy) NSString *firstDay;
@property (nonatomic, strong) dispatch_queue_t serialQueue;

@property (atomic, strong) NSDictionary *automaticProperties;
@property (atomic, strong) NSDictionary *superProperties;
@property (nonatomic, strong) NSMutableDictionary *trackTimer;

@property (nonatomic, strong) NSPredicate *regexTestName;

@property (atomic, strong) SUNYMessageQueueBySqlite *messageQueue;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic,copy) NSDictionary<NSString *,id> *(^dynamicSuperProperties)(void);


///是否为被动启动
@property(nonatomic, assign, getter=isLaunchedPassively) BOOL launchedPassively;
@end

@implementation SUNYSensorsAnalyticsSDK {
    SUNYSensorsAnalyticsDebugMode _debugMode;
    UInt64 _flushBulkSize;
    UInt64 _flushInterval;
    UInt64 _maxCacheSize;
    NSDateFormatter *_dateFormatter;
    BOOL _appRelaunched;                // App 从后台恢复
    BOOL _applicationWillResignActive;
    SUNYSensorsAnalyticsNetworkType _networkTypePolicy;
    NSString *_deviceModel;
    NSString *_osVersion;
    NSString *_originServerUrl;
    NSString *_cookie;
}

#pragma mark - Initialization
+ (SUNYSensorsAnalyticsSDK *)sharedInstanceWithServerURL:(NSString *)serverURL
                                        andDebugMode:(SUNYSensorsAnalyticsDebugMode)debugMode {
    return [SUNYSensorsAnalyticsSDK sharedInstanceWithServerURL:serverURL
            andLaunchOptions:nil andDebugMode:debugMode];
}

+ (SUNYSensorsAnalyticsSDK *)sharedInstanceWithServerURL:(NSString *)serverURL
                                        andLaunchOptions:(NSDictionary *)launchOptions
                                        andDebugMode:(SUNYSensorsAnalyticsDebugMode)debugMode {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] initWithServerURL:serverURL
                                         andLaunchOptions:launchOptions
                                             andDebugMode:debugMode];
    });
    return sharedInstance;
}

+ (SUNYSensorsAnalyticsSDK *)sharedInstance {

    return sharedInstance;
}

+ (UInt64)getCurrentTime {
    UInt64 time = [[NSDate date] timeIntervalSince1970] * 1000;
    return time;
}

+ (UInt64)getSystemUpTime {
    UInt64 time = NSProcessInfo.processInfo.systemUptime * 1000;
    return time;
}

+ (NSString *)getUniqueHardwareId {
    NSString *distinctId = NULL;

    Class ASIdentifierManagerClass = NSClassFromString(@"ASIdentifierManager");
    if (ASIdentifierManagerClass) {
        SEL sharedManagerSelector = NSSelectorFromString(@"sharedManager");
        id sharedManager = ((id (*)(id, SEL))[ASIdentifierManagerClass methodForSelector:sharedManagerSelector])(ASIdentifierManagerClass, sharedManagerSelector);
        SEL advertisingIdentifierSelector = NSSelectorFromString(@"advertisingIdentifier");
        NSUUID *uuid = ((NSUUID* (*)(id, SEL))[sharedManager methodForSelector:advertisingIdentifierSelector])(sharedManager, advertisingIdentifierSelector);
        distinctId = [uuid UUIDString];
        // 在 iOS 10.0 以后，当用户开启限制广告跟踪，advertisingIdentifier 的值将是全零
        // 00000000-0000-0000-0000-000000000000
        if (!distinctId || [distinctId hasPrefix:@"00000000"]) {
            distinctId = NULL;
        }
    }
    
    // 没有IDFA，则使用IDFV
    if (!distinctId && NSClassFromString(@"UIDevice")) {
        distinctId = [[UIDevice currentDevice].identifierForVendor UUIDString];
    }
    
    // 没有IDFV，则使用UUID
    if (!distinctId) {
        SUNYSADebug(@"%@ error getting device identifier: falling back to uuid", self);
        distinctId = [[NSUUID UUID] UUIDString];
    }
    return distinctId;
}

- (instancetype)initWithServerURL:(NSString *)serverURL
                    andLaunchOptions:(NSDictionary *)launchOptions
                     andDebugMode:(SUNYSensorsAnalyticsDebugMode)debugMode {
    @try {
        if (self = [self init]) {
            _networkTypePolicy = SUNYSensorsAnalyticsNetworkType3G | SUNYSensorsAnalyticsNetworkType4G | SUNYSensorsAnalyticsNetworkTypeWIFI;

            if ([[NSThread currentThread] isMainThread]) {
                [self configLaunchedPassivelyWithLaunchOptions:launchOptions];
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self configLaunchedPassivelyWithLaunchOptions:launchOptions];;
                });
            }

            _debugMode = debugMode;
            [self enableLog];
            [self setServerUrl:serverURL];
            
            _flushInterval = 15 * 1000;
            _flushBulkSize = 100;
            _maxCacheSize = 10000;

            _appRelaunched = NO;
            _applicationWillResignActive = NO;
            _dateFormatter = [[NSDateFormatter alloc] init];
            [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];

            self.flushBeforeEnterBackground = YES;

            self.messageQueue = [[SUNYMessageQueueBySqlite alloc] initWithFilePath:[self filePathForData:@"message-v2"]];
            if (self.messageQueue == nil) {
                SUNYSADebug(@"SqliteException: init Message Queue in Sqlite fail");
            }

            // 取上一次进程退出时保存的distinctId、loginId、superProperties
            [self unarchive];

            if (self.firstDay == nil) {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                self.firstDay = [dateFormatter stringFromDate:[NSDate date]];
                [self archiveFirstDay];
            }

            self.automaticProperties = [self collectAutomaticProperties];
            self.trackTimer = [NSMutableDictionary dictionary];

            NSString *namePattern = @"^((?!^distinct_id$|^original_id$|^time$|^event$|^properties$|^id$|^first_id$|^second_id$|^users$|^events$|^event$|^user_id$|^date$|^datetime$)[a-zA-Z_$][a-zA-Z\\d_$]{0,99})$";
            self.regexTestName = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", namePattern];

            NSString *label = [NSString stringWithFormat:@"com.sensorsdata.analytics.mini.SUNYSensorsAnalyticsSDK.%p",self];

            self.serialQueue = dispatch_queue_create([label UTF8String], DISPATCH_QUEUE_SERIAL);
            dispatch_queue_set_specific(self.serialQueue, SUNYSensorsAnalyticsQueueTag, &SUNYSensorsAnalyticsQueueTag, NULL);
            
            [self setUpListeners];

            // XXX: App Active 的时候会启动计时器，此处不需要启动
            //        [self startFlushTimer];
            NSString *logMessage = nil;
            logMessage = [NSString stringWithFormat:@"%@ initialized the instance of Sensors Analytics SDK with server url '%@', debugMode: '%@'",
                              self, serverURL, [self debugModeToString:debugMode]];
            SUNYSALog(@"%@", logMessage);
        }
    } @catch(NSException *exception) {
        SUNYSAError(@"%@ error: %@", self, exception);
    }
    return self;
}

- (void)configLaunchedPassivelyWithLaunchOptions:(NSDictionary *)launchOptions {
    UIApplicationState applicationState = UIApplication.sharedApplication.applicationState;
    //远程通知启动，位置变动启动
    if ([launchOptions.allKeys containsObject:UIApplicationLaunchOptionsRemoteNotificationKey] || [launchOptions.allKeys containsObject:UIApplicationLaunchOptionsLocationKey]) {
        if (applicationState == UIApplicationStateBackground) {
            self.launchedPassively = YES;
        }
    }
}

- (NSDictionary *)getPresetProperties {
    NSMutableDictionary *properties = [[NSMutableDictionary alloc] init];
    @try {
        id app_version = [_automaticProperties objectForKey:@"$app_version"];
        if (app_version) {
            [properties setValue:app_version forKey:@"$app_version"];
        }
        [properties setValue:[_automaticProperties objectForKey:@"$lib"] forKey:@"$lib"];
        [properties setValue:[_automaticProperties objectForKey:@"$lib_version"] forKey:@"$lib_version"];
        [properties setValue:@"Apple" forKey:@"$manufacturer"];
        [properties setValue:_deviceModel forKey:@"$model"];
        [properties setValue:@"iOS" forKey:@"$os"];
        [properties setValue:_osVersion forKey:@"$os_version"];
        [properties setValue:[_automaticProperties objectForKey:@"$screen_height"] forKey:@"$screen_height"];
        [properties setValue:[_automaticProperties objectForKey:@"$screen_width"] forKey:@"$screen_width"];
        NSString *networkType = [SUNYSensorsAnalyticsSDK getNetWorkStates];
        [properties setObject:networkType forKey:@"$network_type"];
        if ([networkType isEqualToString:@"WIFI"]) {
            [properties setObject:@YES forKey:@"$wifi"];
        } else {
            [properties setObject:@NO forKey:@"$wifi"];
        }
        [properties setValue:[_automaticProperties objectForKey:@"$carrier"] forKey:@"$carrier"];
        if ([self isFirstDay]) {
            [properties setObject:@YES forKey:@"$is_first_day"];
        } else {
            [properties setObject:@NO forKey:@"$is_first_day"];
        }
        [properties setValue:[_automaticProperties objectForKey:@"$device_id"] forKey:@"$device_id"];
    } @catch(NSException *exception) {
        SUNYSAError(@"%@ error: %@", self, exception);
    }
    return [properties copy];
}

- (void)setServerUrl:(NSString *)serverUrl {
    _originServerUrl = serverUrl;
    if (serverUrl == nil || [serverUrl length] == 0 || _debugMode == SUNYSensorsAnalyticsDebugOff) {
        _serverURL = serverUrl;
    } else {
        // 将 Server URI Path 替换成 Debug 模式的 '/debug'
        NSURL *tempBaseUrl = [NSURL URLWithString:serverUrl];
        if (tempBaseUrl.lastPathComponent.length > 0) {
            tempBaseUrl = [tempBaseUrl URLByDeletingLastPathComponent];
        }
        NSURL *url = [tempBaseUrl URLByAppendingPathComponent:@"debug"];
        NSString *host = url.host;
        if ([host containsString:@"_"]) { //包含下划线日志提示
            NSString * referenceUrl = @"https://en.wikipedia.org/wiki/Hostname";
            SUNYSALog(@"Server url:%@ contains '_'  is not recommend,see details:%@",serverUrl,referenceUrl);
        }
        _serverURL = [url absoluteString];
    }
}

- (void)disableDebugMode {
    _debugMode = SUNYSensorsAnalyticsDebugOff;
    _serverURL = _originServerUrl;
    [self enableLog:NO];
}

- (NSString *)debugModeToString:(SUNYSensorsAnalyticsDebugMode)debugMode {
    NSString *modeStr = nil;
    switch (debugMode) {
        case SUNYSensorsAnalyticsDebugOff:
            modeStr = @"DebugOff";
            break;
        case SUNYSensorsAnalyticsDebugAndTrack:
            modeStr = @"DebugAndTrack";
            break;
        case SUNYSensorsAnalyticsDebugOnly:
            modeStr = @"DebugOnly";
            break;
        default:
            modeStr = @"Unknown";
            break;
    }
    return modeStr;
}

- (BOOL)isFirstDay {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *current = [dateFormatter stringFromDate:[NSDate date]];

    return [[self firstDay] isEqualToString:current];
}

- (void)setFlushNetworkPolicy:(SUNYSensorsAnalyticsNetworkType)networkType {
    @synchronized (self) {
        _networkTypePolicy = networkType;
    }
}

- (SUNYSensorsAnalyticsNetworkType)toNetworkType:(NSString *)networkType {
    if ([@"NULL" isEqualToString:networkType]) {
        return SUNYSensorsAnalyticsNetworkTypeALL;
    } else if ([@"WIFI" isEqualToString:networkType]) {
        return SUNYSensorsAnalyticsNetworkTypeWIFI;
    } else if ([@"2G" isEqualToString:networkType]) {
        return SUNYSensorsAnalyticsNetworkType2G;
    }   else if ([@"3G" isEqualToString:networkType]) {
        return SUNYSensorsAnalyticsNetworkType3G;
    }   else if ([@"4G" isEqualToString:networkType]) {
        return SUNYSensorsAnalyticsNetworkType4G;
    }
    return SUNYSensorsAnalyticsNetworkTypeNONE;
}

- (void)setMaxCacheSize:(UInt64)maxCacheSize {
    if (maxCacheSize > 0) {
        //防止设置的值太小导致事件丢失
        if (maxCacheSize < 10000) {
            maxCacheSize = 10000;
        }
        _maxCacheSize = maxCacheSize;
    }
}

- (UInt64)getMaxCacheSize {
    return _maxCacheSize;
}

- (void)login:(NSString *)loginId {
    [self login:loginId withProperties:nil];
}

- (void)login:(NSString *)loginId withProperties:(NSDictionary * _Nullable )properties {
    if (loginId == nil || loginId.length == 0) {
        SUNYSAError(@"%@ cannot login blank login_id: %@", self, loginId);
        return;
    }
    if (loginId.length > 255) {
        SUNYSAError(@"%@ max length of login_id is 255, login_id: %@", self, loginId);
        return;
    }
    dispatch_async(self.serialQueue, ^{
        if (![loginId isEqualToString:[self loginId]]) {
            self.loginId = loginId;
            [self archiveLoginId];
            if (![loginId isEqualToString:[self distinctId]]) {
                self.originalId = [self distinctId];
                [self track:@"$SignUp" withProperties:nil withType:@"track_signup"];
            }
        }
    });
}

- (void)logout {
    self.loginId = nil;
    [self archiveLoginId];
}

- (NSString *)anonymousId {
    return _distinctId;
}

- (void)resetAnonymousId {
    self.distinctId = [[self class] getUniqueHardwareId];
    [self archiveDistinctId];
}

- (void)trackAppCrash {
    // Install uncaught exception handlers first
    [[SUNYSensorsAnalyticsExceptionHandler sharedHandler] addSensorsAnalyticsInstance:self];
}

- (void)flushByType:(NSString *)type withSize:(int)flushSize andFlushMethod:(BOOL (^)(NSArray *, NSString *))flushMethod {
    while (true) {
        NSArray *recordArray = [self.messageQueue getFirstRecords:flushSize withType:type];
        if (recordArray == nil) {
            SUNYSAError(@"Failed to get records from SQLite.");
            break;
        }
        
        if ([recordArray count] == 0 || !flushMethod(recordArray, type)) {
            break;
        }
        
        if (![self.messageQueue removeFirstRecords:flushSize withType:type]) {
            SUNYSAError(@"Failed to remove records from SQLite.");
            break;
        }
    }
}

- (void)_flush:(BOOL) vacuumAfterFlushing {
    if (_serverURL == nil || [_serverURL isEqualToString:@""]) {
        return;
    }
    // 判断当前网络类型是否符合同步数据的网络策略
    NSString *networkType = [SUNYSensorsAnalyticsSDK getNetWorkStates];
    if (!([self toNetworkType:networkType] & _networkTypePolicy)) {
        return;
    }
    // 使用 Post 发送数据
    BOOL (^flushByPost)(NSArray *, NSString *) = ^(NSArray *recordArray, NSString *type) {
        NSString *jsonString;
        NSData *zippedData;
        NSString *b64String;
        NSString *postBody;
        @try {
            // 1. 先完成这一系列Json字符串的拼接
            jsonString = [NSString stringWithFormat:@"[%@]",[recordArray componentsJoinedByString:@","]];
            // 2. 使用gzip进行压缩
            zippedData = [SUNYSAGzipUtility gzipData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
            // 3. base64
            b64String = [zippedData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
            int hashCode = [b64String sensorsdata_hashCode];
            b64String = (id)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                  (CFStringRef)b64String,
                                                                                  NULL,
                                                                                  CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                  kCFStringEncodingUTF8));
        
            postBody = [NSString stringWithFormat:@"crc=%d&gzip=1&data_list=%@", hashCode, b64String];
        } @catch (NSException *exception) {
            SUNYSAError(@"%@ flushByPost format data error: %@", self, exception);
            return YES;
        }
        
        NSURL *URL = [NSURL URLWithString:self.serverURL];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[postBody dataUsingEncoding:NSUTF8StringEncoding]];
        // 普通事件请求，使用标准 UserAgent
        [request setValue:@"SensorsAnalytics iOS SDK" forHTTPHeaderField:@"User-Agent"];
        if (self->_debugMode == SUNYSensorsAnalyticsDebugOnly) {
            [request setValue:@"true" forHTTPHeaderField:@"Dry-Run"];
        }
        
        //Cookie
        [request setValue:[[SUNYSensorsAnalyticsSDK sharedInstance] getCookieWithDecode:NO] forHTTPHeaderField:@"Cookie"];

        dispatch_semaphore_t flushSem = dispatch_semaphore_create(0);
        __block BOOL flushSucc = YES;
        
        void (^block)(NSData*, NSURLResponse*, NSError*) = ^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error || ![response isKindOfClass:[NSHTTPURLResponse class]]) {
                SUNYSAError(@"%@", [NSString stringWithFormat:@"%@ network failure: %@", self, error ? error : @"Unknown error"]);
                flushSucc = NO;
                dispatch_semaphore_signal(flushSem);
                return;
            }
            
            NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse*)response;
            NSString *urlResponseContent = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSString *errMsg = [NSString stringWithFormat:@"%@ flush failure with response '%@'.", self, urlResponseContent];
            NSString *messageDesc = nil;
            NSInteger statusCode = urlResponse.statusCode;
            if(statusCode != 200) {
                messageDesc = @"\n【invalid message】\n";
                SUNYSAError(@"%@",errMsg);
                if (self->_debugMode == SUNYSensorsAnalyticsDebugOff) {

                    if (statusCode >= 300) {
                        flushSucc = NO;
                    }
                }
            } else {
                messageDesc = @"\n【valid message】\n";
            }
            SUNYSAError(@"==========================================================================");
            if ([SUNYSALogger isLoggerEnabled]) {
                @try {
                    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                    NSString *logString=[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
                    SUNYSAError(@"%@ %@: %@", self,messageDesc,logString);
                } @catch (NSException *exception) {
                    SUNYSAError(@"%@: %@", self, exception);
                }
            }
            if (statusCode != 200) {
                SUNYSAError(@"%@ ret_code: %ld", self, statusCode);
                SUNYSAError(@"%@ ret_content: %@", self, urlResponseContent);
            }
            dispatch_semaphore_signal(flushSem);
        };
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:block];
        
        [task resume];
#else
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:
         ^(NSURLResponse *response, NSData* data, NSError *error) {
             return block(data, response, error);
        }];
#endif
        
        dispatch_semaphore_wait(flushSem, DISPATCH_TIME_FOREVER);
        
        return flushSucc;
    };
    
    [self flushByType:@"Post" withSize:(_debugMode == SUNYSensorsAnalyticsDebugOff ? 50 : 1) andFlushMethod:flushByPost];
    
    SUNYSADebug(@"events flushed.");
}

- (void)flush {
    dispatch_async(self.serialQueue, ^{
        [self _flush:NO];
    });
}

- (BOOL) isValidName : (NSString *) name {
    @try {
        if (_deviceModel == nil) {
            _deviceModel = [self deviceModel];
        }

        if (_osVersion == nil) {
            UIDevice *device = [UIDevice currentDevice];
            _osVersion = [device systemVersion];
        }

        //据反馈，该函数在 iPhone 8、iPhone 8 Plus，并且系统版本号为 11.0 上可能会 crash，具体原因暂未查明
        if ([_osVersion isEqualToString:@"11.0"]) {
            if ([_deviceModel isEqualToString:@"iPhone10,1"] ||
                [_deviceModel isEqualToString:@"iPhone10,4"] ||
                [_deviceModel isEqualToString:@"iPhone10,2"] ||
                [_deviceModel isEqualToString:@"iPhone10,5"]) {
                    return YES;
            }
        }
        return [self.regexTestName evaluateWithObject:name];
    } @catch (NSException *exception) {
        SUNYSAError(@"%@: %@", self, exception);
        return NO;
    }
}

- (NSString *)filePathForData:(NSString *)data {
    //此处为了
    NSString *filename = [NSString stringWithFormat:@"com.sensorsdata.analytics.mini.SUNYSensorsAnalyticsSDK.%@.plist", data];
    NSString *filepath = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject]
            stringByAppendingPathComponent:filename];
    SUNYSADebug(@"filepath for %@ is %@", data, filepath);
    return filepath;
}

- (void)enqueueWithType:(NSString *)type andEvent:(NSDictionary *)e {
    NSMutableDictionary *event = [[NSMutableDictionary alloc] initWithDictionary:e];
    [self.messageQueue addObejct:event withType:@"Post"];
}

- (void)track:(NSString *)event withProperties:(NSDictionary *)propertieDict withType:(NSString *)type {

    // 对于type是track数据，它们的event名称是有意义的
    if ([type isEqualToString:@"track"]) {
        if (event == nil || [event length] == 0) {
            NSString *errMsg = @"SensorsAnalytics track called with empty event parameter";
            SUNYSAError(@"%@", errMsg);
            return;
        }
        if (![self isValidName:event]) {
            NSString *errMsg = [NSString stringWithFormat:@"Event name[%@] not valid", event];
            SUNYSAError(@"%@", errMsg);
            return;
        }
    }
    
    if (propertieDict) {
        if (![self assertPropertyTypes:&propertieDict withEventType:type]) {
            SUNYSAError(@"%@ failed to track event.", self);
            return;
        }
    }
    
    NSMutableDictionary *libProperties = [[NSMutableDictionary alloc] init];
    
    [libProperties setValue:[_automaticProperties objectForKey:@"$lib"] forKey:@"$lib"];
    [libProperties setValue:[_automaticProperties objectForKey:@"$lib_version"] forKey:@"$lib_version"];
    
    id app_version = [_automaticProperties objectForKey:@"$app_version"];
    if (app_version) {
        [libProperties setValue:app_version forKey:@"$app_version"];
    }
    
    [libProperties setValue:@"code" forKey:@"$lib_method"];


    dispatch_async(self.serialQueue, ^{
        //获取用户自定义的动态公共属性
        NSDictionary *dynamicSuperPropertiesDict = self.dynamicSuperProperties?self.dynamicSuperProperties():nil;
        if (dynamicSuperPropertiesDict && [dynamicSuperPropertiesDict isKindOfClass:NSDictionary.class] == NO) {
            SUNYSALog(@"dynamicSuperProperties  returned: %@  is not an NSDictionary Obj.",dynamicSuperPropertiesDict);
            dynamicSuperPropertiesDict = nil;
        } else {
            if ([self assertPropertyTypes:&dynamicSuperPropertiesDict withEventType:@"register_super_properties"] == NO) {
                dynamicSuperPropertiesDict = nil;
            }
        }
        //去重
        [self unregisterSameLetterSuperProperties:dynamicSuperPropertiesDict];

        NSNumber *currentSystemUpTime = @([[self class] getSystemUpTime]);
        NSNumber *timeStamp = @([[self class] getCurrentTime]);
        NSMutableDictionary *p = [NSMutableDictionary dictionary];
        if ([type isEqualToString:@"track"] || [type isEqualToString:@"track_signup"]) {
            // track / track_signup 类型的请求，还是要加上各种公共property
            // 这里注意下顺序，按照优先级从低到高，依次是automaticProperties, superProperties,dynamicSuperPropertiesDict,propertieDict
            [p addEntriesFromDictionary:self->_automaticProperties];
            [p addEntriesFromDictionary:self->_superProperties];
            [p addEntriesFromDictionary:dynamicSuperPropertiesDict];

            //update lib $app_version from super properties
            id app_version = [self->_superProperties objectForKey:@"$app_version"];
            if (app_version) {
                [libProperties setValue:app_version forKey:@"$app_version"];
            }

            // 每次 track 时手机网络状态
            NSString *networkType = [SUNYSensorsAnalyticsSDK getNetWorkStates];
            [p setObject:networkType forKey:@"$network_type"];
            if ([networkType isEqualToString:@"WIFI"]) {
                [p setObject:@YES forKey:@"$wifi"];
            } else {
                [p setObject:@NO forKey:@"$wifi"];
            }

            NSDictionary *eventTimer = self.trackTimer[event];
            if (eventTimer) {
                [self.trackTimer removeObjectForKey:event];
                NSNumber *eventBegin = [eventTimer valueForKey:@"eventBegin"];
                NSNumber *eventAccumulatedDuration = [eventTimer objectForKey:@"eventAccumulatedDuration"];
                SUNYSensorsAnalyticsTimeUnit timeUnit = [[eventTimer valueForKey:@"timeUnit"] intValue];
                
                float eventDuration;
                if (eventAccumulatedDuration) {
                    eventDuration = [currentSystemUpTime longValue] - [eventBegin longValue] + [eventAccumulatedDuration longValue];
                } else {
                    eventDuration = [currentSystemUpTime longValue] - [eventBegin longValue];
                }

                if (eventDuration < 0) {
                    eventDuration = 0;
                }

                if (eventDuration > 0 && eventDuration < 24 * 60 * 60 * 1000) {
                    switch (timeUnit) {
                        case SUNYSensorsAnalyticsTimeUnitHours:
                            eventDuration = eventDuration / 60.0;
                        case SUNYSensorsAnalyticsTimeUnitMinutes:
                            eventDuration = eventDuration / 60.0;
                        case SUNYSensorsAnalyticsTimeUnitSeconds:
                            eventDuration = eventDuration / 1000.0;
                        case SUNYSensorsAnalyticsTimeUnitMilliseconds:
                            break;
                    }
                    @try {
                        [p setObject:@([[NSString stringWithFormat:@"%.3f", eventDuration] floatValue]) forKey:@"event_duration"];
                    } @catch (NSException *exception) {
                        SUNYSAError(@"%@: %@", self, exception);
                    }
                }
            }
        }
        
        NSString *project = nil;
        NSString *token = nil;
        if (propertieDict) {
            NSArray *keys = propertieDict.allKeys;
            for (id key in keys) {
                NSObject *obj = propertieDict[key];
                if ([@"$project" isEqualToString:key]) {
                    project = (NSString *)obj;
                } else if ([@"$token" isEqualToString:key]) {
                    token = (NSString *)obj;
                } else {
                    if ([obj isKindOfClass:[NSDate class]]) {
                        // 序列化所有 NSDate 类型
                        NSString *dateStr = [self->_dateFormatter stringFromDate:(NSDate *)obj];
                        [p setObject:dateStr forKey:key];
                    } else {
                        [p setObject:obj forKey:key];
                    }
                }
            }
        }

        NSMutableDictionary *e;
        NSString *bestId = self.getBestId;

        if ([type isEqualToString:@"track_signup"]) {
            e = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                 event, @"event",
                 [NSDictionary dictionaryWithDictionary:p], @"properties",
                 bestId, @"distinct_id",
                 self.originalId, @"original_id",
                 timeStamp, @"time",
                 type, @"type",
                 libProperties, @"lib",
                 @(arc4random()), @"_track_id",
                 nil];
        } else if([type isEqualToString:@"track"]){
            //  是否首日访问
            if ([self isFirstDay]) {
                [p setObject:@YES forKey:@"$is_first_day"];
            } else {
                [p setObject:@NO forKey:@"$is_first_day"];
            }

            @try {
                if ([self isLaunchedPassively]) {
                    [p setObject:@"background" forKey:@"$app_state"];
                }
            } @catch (NSException *e) {
                SUNYSAError(@"%@: %@", self, e);
            }

            e = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                 event, @"event",
                 [NSDictionary dictionaryWithDictionary:p], @"properties",
                 bestId, @"distinct_id",
                 timeStamp, @"time",
                 type, @"type",
                 libProperties, @"lib",
                 @(arc4random()), @"_track_id",
                 nil];
        } else {
            // 此时应该都是对Profile的操作
            e = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                 [NSDictionary dictionaryWithDictionary:p], @"properties",
                 bestId, @"distinct_id",
                 timeStamp, @"time",
                 type, @"type",
                 libProperties, @"lib",
                 @(arc4random()), @"_track_id",
                 nil];
        }

        if (project) {
            [e setObject:project forKey:@"project"];
        }
        if (token) {
            [e setObject:token forKey:@"token"];
        }
        
        //修正 $device_id，防止用户修改
        NSDictionary *infoProperties = [e objectForKey:@"properties"];
        if (infoProperties && [infoProperties.allKeys containsObject:@"$device_id"]) {
            NSDictionary *autoProperties = self.automaticProperties;
            if (autoProperties && [autoProperties.allKeys containsObject:@"$device_id"]) {
                NSMutableDictionary *correctInfoProperties = [NSMutableDictionary dictionaryWithDictionary:infoProperties];
                correctInfoProperties[@"$device_id"] = autoProperties[@"$device_id"];
                [e setObject:correctInfoProperties forKey:@"properties"];
            }
        }
        
        //smwl 修改源码，与Android保持统一
        // by xqd 20231115
        if (![e.allKeys containsObject:@"login_id"]) {
            [e setObject:[self loginId] ? : @"" forKey:@"login_id"];
        }
        if (![e.allKeys containsObject:@"anonymous_id"]) {
            [e setObject:[self anonymousId] ? : @"" forKey:@"anonymous_id"];
        }

        SUNYSALog(@"\n【track event】:\n%@", e);
        
        [self enqueueWithType:type andEvent:[e copy]];
        
        if (self->_debugMode != SUNYSensorsAnalyticsDebugOff) {
            // 在DEBUG模式下，直接发送事件
            [self flush];
        } else {
            // 否则，在满足发送条件时，发送事件
            if ([type isEqualToString:@"track_signup"] || [[self messageQueue] count] >= self.flushBulkSize) {
                [self flush];
            }
        }
    });
}

-(NSString *)getBestId{
    NSString *bestId;
    if ([self loginId] != nil) {
        bestId = [self loginId];
    } else{
        bestId = [self distinctId];
    }

    if (bestId == nil) {
        [self resetAnonymousId];
        bestId = [self anonymousId];
    }
    return bestId;
}

- (void)track:(NSString *)event withProperties:(NSDictionary *)propertieDict {
    [self track:event withProperties:propertieDict withType:@"track"];
}

- (void)track:(NSString *)event {
    [self track:event withProperties:nil withType:@"track"];
}

- (void)setCookie:(NSString *)cookie withEncode:(BOOL)encode {
    if (encode) {
        _cookie = (id)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                (CFStringRef)cookie,
                                                                                NULL,
                                                                                CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                kCFStringEncodingUTF8));
    } else {
        _cookie = cookie;
    }
}

- (NSString *)getCookieWithDecode:(BOOL)decode {
    if (decode) {
        return (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,(__bridge CFStringRef)_cookie, CFSTR(""),CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    } else {
        return _cookie;
    }
}
- (void)trackTimerStart:(NSString *)event {
    if (![self isValidName:event]) {
        NSString *errMsg = [NSString stringWithFormat:@"Event name[%@] not valid", event];
        SUNYSAError(@"%@", errMsg);
        return;
    }
    
    NSNumber *eventBegin = @([[self class] getSystemUpTime]);
    dispatch_async(self.serialQueue, ^{
        self.trackTimer[event] = @{@"eventBegin" : eventBegin, @"eventAccumulatedDuration" : [NSNumber numberWithLong:0], @"timeUnit" : [NSNumber numberWithInt:SUNYSensorsAnalyticsTimeUnitSeconds]};
    });
}

- (void)trackTimerEnd:(NSString *)event {
    [self trackTimerEnd:event withProperties:nil];
}

- (void)trackTimerEnd:(NSString *)event withProperties:(NSDictionary *)propertyDict {
    [self track:event withProperties:propertyDict];
}

- (void)clearTrackTimer {
    dispatch_async(self.serialQueue, ^{
        self.trackTimer = [NSMutableDictionary dictionary];
    });
}

- (NSString  *)getIDFA {
    NSString *idfa = nil;
    @try {
        Class ASIdentifierManagerClass = NSClassFromString(@"ASIdentifierManager");
        if (ASIdentifierManagerClass) {
            SEL sharedManagerSelector = NSSelectorFromString(@"sharedManager");
            id sharedManager = ((id (*)(id, SEL))[ASIdentifierManagerClass methodForSelector:sharedManagerSelector])(ASIdentifierManagerClass, sharedManagerSelector);
            SEL advertisingIdentifierSelector = NSSelectorFromString(@"advertisingIdentifier");
            NSUUID *uuid = ((NSUUID* (*)(id, SEL))[sharedManager methodForSelector:advertisingIdentifierSelector])(sharedManager, advertisingIdentifierSelector);
            NSString *temp = [uuid UUIDString];
            // 在 iOS 10.0 以后，当用户开启限制广告跟踪，advertisingIdentifier 的值将是全零
            // 00000000-0000-0000-0000-000000000000
            if (temp && ![temp hasPrefix:@"00000000"]) {
                idfa = temp;
            }
        }
        return idfa;
    } @catch (NSException *exception) {
        SUNYSADebug(@"%@: %@", self, exception);
        return idfa;
    }
}


- (void)identify:(NSString *)distinctId {
    if (distinctId.length == 0) {
        SUNYSAError(@"%@ cannot identify blank distinct id: %@", self, distinctId);
//        @throw [NSException exceptionWithName:@"InvalidDataException" reason:@"SensorsAnalytics distinct_id should not be nil or empty" userInfo:nil];
        return;
    }
    if (distinctId.length > 255) {
        SUNYSAError(@"%@ max length of distinct_id is 255, distinct_id: %@", self, distinctId);
//        @throw [NSException exceptionWithName:@"InvalidDataException" reason:@"SensorsAnalytics max length of distinct_id is 255" userInfo:nil];
    }
    dispatch_async(self.serialQueue, ^{
        // 先把之前的distinctId设为originalId
        self.originalId = self.distinctId;
        // 更新distinctId
        self.distinctId = distinctId;
        [self archiveDistinctId];
    });
}

- (NSString *)deviceModel {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char answer[size];
    sysctlbyname("hw.machine", answer, &size, NULL, 0);
    NSString *results = @(answer);
    return results;
}

- (NSString *)libVersion {
    return VERSION;
}

- (BOOL)assertPropertyTypes:(NSDictionary **)propertiesAddress withEventType:(NSString *)eventType {
    NSDictionary *properties = *propertiesAddress;
    NSMutableDictionary *newProperties = nil;
    for (id __unused k in properties) {
        // key 必须是NSString
        if (![k isKindOfClass: [NSString class]]) {
            NSString *errMsg = @"Property Key should by NSString";
            SUNYSAError(@"%@", errMsg);
            return NO;
        }
        
        // key的名称必须符合要求
        if (![self isValidName: k]) {
            NSString *errMsg = [NSString stringWithFormat:@"property name[%@] is not valid", k];
            SUNYSAError(@"%@", errMsg);
            return NO;
        }
        
        // value的类型检查
        if(![properties[k] isKindOfClass:[NSString class]] &&
           ![properties[k] isKindOfClass:[NSNumber class]] &&
           ![properties[k] isKindOfClass:[NSNull class]] &&
           ![properties[k] isKindOfClass:[NSSet class]] &&
           ![properties[k] isKindOfClass:[NSArray class]] &&
           ![properties[k] isKindOfClass:[NSDate class]]) {
            NSString * errMsg = [NSString stringWithFormat:@"%@ property values must be NSString, NSNumber, NSSet, NSArray or NSDate. got: %@ %@", self, [properties[k] class], properties[k]];
            SUNYSAError(@"%@", errMsg);
            return NO;
        }
        
        // NSSet、NSArray 类型的属性中，每个元素必须是 NSString 类型
        if ([properties[k] isKindOfClass:[NSSet class]] || [properties[k] isKindOfClass:[NSArray class]]) {
            NSEnumerator *enumerator = [(properties[k]) objectEnumerator];
            id object;
            while (object = [enumerator nextObject]) {
                if (![object isKindOfClass:[NSString class]]) {
                    NSString * errMsg = [NSString stringWithFormat:@"%@ value of NSSet、NSArray must be NSString. got: %@ %@", self, [object class], object];
                    SUNYSAError(@"%@", errMsg);
                    return NO;
                }
                NSUInteger objLength = [((NSString *)object) lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
                if (objLength > PROPERTY_LENGTH_LIMITATION) {
                    //截取再拼接 $ 末尾，替换原数据
                    NSMutableString *newObject = [NSMutableString stringWithString:[SUNYSACommonUtility subByteString:(NSString *)object byteLength:PROPERTY_LENGTH_LIMITATION]];
                    [newObject appendString:@"$"];
                    if (!newProperties) {
                        newProperties = [NSMutableDictionary dictionaryWithDictionary:properties];
                    }
                    
                    NSMutableSet *newSetObject = nil;
                    if ([properties[k] isKindOfClass:[NSArray class]]) {
                        newSetObject = [NSMutableSet setWithArray:properties[k]];
                    } else {
                        newSetObject = [NSMutableSet setWithSet:properties[k]];
                    }
                    [newSetObject removeObject:object];
                    [newSetObject addObject:newObject];
                    [newProperties setObject:newSetObject forKey:k];
                }
            }
        }
        
        // NSString 检查长度，但忽略部分属性
        if ([properties[k] isKindOfClass:[NSString class]]) {
            NSUInteger objLength = [((NSString *)properties[k]) lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
            NSUInteger valueMaxLength = PROPERTY_LENGTH_LIMITATION;
            if ([k isEqualToString:@"app_crashed_reason"]) {
                valueMaxLength = PROPERTY_LENGTH_LIMITATION * 2;
            }
            if (objLength > valueMaxLength) {

                //截取再拼接 $ 末尾，替换原数据
                NSMutableString *newObject = [NSMutableString stringWithString:[SUNYSACommonUtility subByteString:properties[k] byteLength:valueMaxLength]];
                [newObject appendString:@"$"];
                if (!newProperties) {
                    newProperties = [NSMutableDictionary dictionaryWithDictionary:properties];
                }
                [newProperties setObject:newObject forKey:k];
            }
        }
        
        // profileIncrement的属性必须是NSNumber
        if ([eventType isEqualToString:@"profile_increment"]) {
            if (![properties[k] isKindOfClass:[NSNumber class]]) {
                NSString *errMsg = [NSString stringWithFormat:@"%@ profile_increment value must be NSNumber. got: %@ %@", self, [properties[k] class], properties[k]];
                SUNYSAError(@"%@", errMsg);
                return NO;
            }
        }
        
        // profileAppend的属性必须是个NSSet、NSArray
        if ([eventType isEqualToString:@"profile_append"]) {
            if (![properties[k] isKindOfClass:[NSSet class]] && ![properties[k] isKindOfClass:[NSArray class]]) {
                NSString *errMsg = [NSString stringWithFormat:@"%@ profile_append value must be NSSet、NSArray. got %@ %@", self, [properties[k] class], properties[k]];
                SUNYSAError(@"%@", errMsg);
                return NO;
            }
        }
    }
    //截取之后，修改原 properties
    if (newProperties) {
        *propertiesAddress = [NSDictionary dictionaryWithDictionary:newProperties];
    }
    return YES;
}

- (NSDictionary *)collectAutomaticProperties {
    NSMutableDictionary *p = [NSMutableDictionary dictionary];
    UIDevice *device = [UIDevice currentDevice];
    _deviceModel = [self deviceModel];
    _osVersion = [device systemVersion];
    struct CGSize size = [UIScreen mainScreen].bounds.size;
    CTCarrier *carrier = [[[CTTelephonyNetworkInfo alloc] init] subscriberCellularProvider];
    // Use setValue semantics to avoid adding keys where value can be nil.
    [p setValue:[[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] forKey:@"$app_version"];
    if (carrier != nil) {
        NSString *networkCode = [carrier mobileNetworkCode];
        NSString *countryCode = [carrier mobileCountryCode];

        NSString *carrierName = nil;
        //中国运营商
        if (countryCode && [countryCode isEqualToString:CARRIER_CHINA_MCC]) {
            if (networkCode) {

                //中国移动
                if ([networkCode isEqualToString:@"00"] || [networkCode isEqualToString:@"02"] || [networkCode isEqualToString:@"07"] || [networkCode isEqualToString:@"08"]) {
                    carrierName= @"中国移动";
                }
                //中国联通
                if ([networkCode isEqualToString:@"01"] || [networkCode isEqualToString:@"06"] || [networkCode isEqualToString:@"09"]) {
                    carrierName= @"中国联通";
                }
                //中国电信
                if ([networkCode isEqualToString:@"03"] || [networkCode isEqualToString:@"05"] || [networkCode isEqualToString:@"11"]) {
                    carrierName= @"中国电信";
                }
                //中国卫通
                if ([networkCode isEqualToString:@"04"]) {
                    carrierName= @"中国卫通";
                }
                //中国铁通
                if ([networkCode isEqualToString:@"20"]) {
                    carrierName= @"中国铁通";
                }
            }
        } else { //国外运营商解析
            //加载当前 bundle
            NSBundle *sensorsBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[SUNYSensorsAnalyticsSDK class]] pathForResource:@"SUNYSensorsAnalyticsSDK" ofType:@"bundle"]];
            //文件路径
            NSString *jsonPath = [sensorsBundle pathForResource:@"sa_mcc_mnc_mini.json" ofType:nil];
            NSData *jsonData = [NSData dataWithContentsOfFile:jsonPath];
            if (jsonData) {
                NSDictionary *dicAllMcc =  [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
                if (dicAllMcc) {
                    NSString *mccMncKey = [NSString stringWithFormat:@"%@%@",countryCode,networkCode];
                    carrierName = dicAllMcc[mccMncKey];
                }
            }
        }

        if (carrierName != nil) {
            [p setValue:carrierName forKey:@"$carrier"];
        } else {
            if (carrier.carrierName) {
                [p setValue:carrier.carrierName forKey:@"$carrier"];
            }
        }
    }

#if !SENSORS_ANALYTICS_DISABLE_AUTOTRACK_DEVICEID
    [p setValue:[[self class] getUniqueHardwareId] forKey:@"$device_id"];
#endif
    [p addEntriesFromDictionary:@{
                                  @"$lib": @"iOS",
                                  @"$lib_version": [self libVersion],
                                  @"$manufacturer": @"Apple",
                                  @"$os": @"iOS",
                                  @"$os_version": _osVersion,
                                  @"$model": _deviceModel,
                                  @"$screen_height": @((NSInteger)size.height),
                                  @"$screen_width": @((NSInteger)size.width),
                                      }];
    return [p copy];
}

- (void)registerSuperProperties:(NSDictionary *)propertyDict {
    propertyDict = [propertyDict copy];
    if (![self assertPropertyTypes:&propertyDict withEventType:@"register_super_properties"]) {
        SUNYSAError(@"%@ failed to register super properties.", self);
        return;
    }
    dispatch_async(self.serialQueue, ^{
        [self unregisterSameLetterSuperProperties:propertyDict];
        // 注意这里的顺序，发生冲突时是以propertyDict为准，所以它是后加入的
        NSMutableDictionary *tmp = [NSMutableDictionary dictionaryWithDictionary:self->_superProperties];
        [tmp addEntriesFromDictionary:propertyDict];
        self->_superProperties = [NSDictionary dictionaryWithDictionary:tmp];
        [self archiveSuperProperties];
    });
}

-(void)registerDynamicSuperProperties:(NSDictionary<NSString *,id> *(^)(void)) dynamicSuperProperties {
    dispatch_async(self.serialQueue, ^{
        self.dynamicSuperProperties = dynamicSuperProperties;
    });
}

///注销仅大小写不同的 SuperProperties
- (void)unregisterSameLetterSuperProperties:(NSDictionary *)propertyDict {
    dispatch_block_t block =^{
        NSArray *allNewKeys = [propertyDict.allKeys mutableCopy];
        //如果包含仅大小写不同的 key ,unregisterSuperProperty
        NSArray *superPropertyAllKeys = [self.superProperties.allKeys mutableCopy];
        NSMutableArray *unregisterPropertyKeys = [NSMutableArray array];
        for (NSString *newKey in allNewKeys) {
            [superPropertyAllKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *usedKey = (NSString *)obj;
                if ([usedKey caseInsensitiveCompare:newKey] == NSOrderedSame) { // 存在不区分大小写相同 key
                    [unregisterPropertyKeys addObject:usedKey];
                }
            }];
        }
        if (unregisterPropertyKeys.count > 0) {
            [self unregisterSuperPropertys:unregisterPropertyKeys];
        }
    };

    if (dispatch_get_specific(SUNYSensorsAnalyticsQueueTag)) {
        block();
    }else {
        dispatch_async(self.serialQueue, block);
    }
}

- (void)unregisterSuperProperty:(NSString *)property {
    dispatch_async(self.serialQueue, ^{
        NSMutableDictionary *tmp = [NSMutableDictionary dictionaryWithDictionary:self->_superProperties];
        if (tmp[property] != nil) {
            [tmp removeObjectForKey:property];
        }
        self->_superProperties = [NSDictionary dictionaryWithDictionary:tmp];
        [self archiveSuperProperties];
    });
}

- (void)unregisterSuperPropertys:(NSArray <NSString *>*)propertys {
    dispatch_block_t block =  ^{
        NSMutableDictionary *tmp = [NSMutableDictionary dictionaryWithDictionary:self->_superProperties];
        [tmp removeObjectsForKeys:propertys];
        self->_superProperties = [NSDictionary dictionaryWithDictionary:tmp];
        [self archiveSuperProperties];
    };
    if (dispatch_get_specific(SUNYSensorsAnalyticsQueueTag)) {
        block();
    }else {
        dispatch_async(self.serialQueue, block);
    }
}

- (void)clearSuperProperties {
    dispatch_async(self.serialQueue, ^{
        self->_superProperties = @{};
        [self archiveSuperProperties];
    });
}

- (NSDictionary *)currentSuperProperties {
    return [_superProperties copy];
}

#pragma mark - Local caches

- (void)unarchive {
    [self unarchiveDistinctId];
    [self unarchiveLoginId];
    [self unarchiveSuperProperties];
    [self unarchiveFirstDay];
}

- (id)unarchiveFromFile:(NSString *)filePath {
    id unarchivedData = nil;
    @try {
        unarchivedData = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    } @catch (NSException *exception) {
        SUNYSAError(@"%@ unable to unarchive data in %@, starting fresh", self, filePath);
        unarchivedData = nil;
    }
    return unarchivedData;
}

- (void)unarchiveDistinctId {
    NSString *filePath = [self filePathForData:@"distinct_id"];
    NSString *archivedDistinctId = (NSString *)[self unarchiveFromFile:filePath];
    NSString *distinctIdInKeychain = [SUNYSAKeyChainItemWrapper saUdid];
    if (distinctIdInKeychain != nil && distinctIdInKeychain.length > 0) {
        self.distinctId = distinctIdInKeychain;
       
        if (![archivedDistinctId isEqualToString:distinctIdInKeychain]) {
            //保存 Archiver
            NSDictionary *protection = [NSDictionary dictionaryWithObject:NSFileProtectionComplete forKey:NSFileProtectionKey];
            [[NSFileManager defaultManager] setAttributes:protection ofItemAtPath:filePath error:nil];
            if (![NSKeyedArchiver archiveRootObject:[[self distinctId] copy] toFile:filePath]) {
                SUNYSAError(@"%@ unable to archive distinctId", self);
            }
        }
    } else {
        if (archivedDistinctId.length == 0) {
            self.distinctId = [[self class] getUniqueHardwareId];
            [self archiveDistinctId];
        } else {
            self.distinctId = archivedDistinctId;
            //保存 KeyChain
            [SUNYSAKeyChainItemWrapper saveUdid:self.distinctId];
        }
    }
}

- (void)unarchiveLoginId {
    NSString *archivedLoginId = (NSString *)[self unarchiveFromFile:[self filePathForData:@"login_id"]];
    self.loginId = archivedLoginId;
}

- (void)unarchiveFirstDay {
    NSString *archivedFirstDay = (NSString *)[self unarchiveFromFile:[self filePathForData:@"first_day"]];
    self.firstDay = archivedFirstDay;
}

- (void)unarchiveSuperProperties {
    NSDictionary *archivedSuperProperties = (NSDictionary *)[self unarchiveFromFile:[self filePathForData:@"super_properties"]];
    if (archivedSuperProperties == nil) {
        _superProperties = [NSDictionary dictionary];
    } else {
        _superProperties = [archivedSuperProperties copy];
    }
}

- (void)archiveDistinctId {
    NSString *filePath = [self filePathForData:@"distinct_id"];
    /* 为filePath文件设置保护等级 */
    NSDictionary *protection = [NSDictionary dictionaryWithObject:NSFileProtectionComplete
                                                           forKey:NSFileProtectionKey];
    [[NSFileManager defaultManager] setAttributes:protection
                                     ofItemAtPath:filePath
                                            error:nil];
    if (![NSKeyedArchiver archiveRootObject:[[self distinctId] copy] toFile:filePath]) {
        SUNYSAError(@"%@ unable to archive distinctId", self);
    }
    [SUNYSAKeyChainItemWrapper saveUdid:self.distinctId];
    SUNYSADebug(@"%@ archived distinctId", self);
}

- (void)archiveLoginId {
    NSString *filePath = [self filePathForData:@"login_id"];
    /* 为filePath文件设置保护等级 */
    NSDictionary *protection = [NSDictionary dictionaryWithObject:NSFileProtectionComplete
                                                           forKey:NSFileProtectionKey];
    [[NSFileManager defaultManager] setAttributes:protection
                                     ofItemAtPath:filePath
                                            error:nil];
    if (![NSKeyedArchiver archiveRootObject:[[self loginId] copy] toFile:filePath]) {
        SUNYSAError(@"%@ unable to archive loginId", self);
    }
    SUNYSADebug(@"%@ archived loginId", self);
}

- (void)archiveFirstDay {
    NSString *filePath = [self filePathForData:@"first_day"];
    /* 为filePath文件设置保护等级 */
    NSDictionary *protection = [NSDictionary dictionaryWithObject:NSFileProtectionComplete
                                                           forKey:NSFileProtectionKey];
    [[NSFileManager defaultManager] setAttributes:protection
                                     ofItemAtPath:filePath
                                            error:nil];
    if (![NSKeyedArchiver archiveRootObject:[[self firstDay] copy] toFile:filePath]) {
        SUNYSAError(@"%@ unable to archive firstDay", self);
    }
    SUNYSADebug(@"%@ archived firstDay", self);
}

- (void)archiveSuperProperties {
    NSString *filePath = [self filePathForData:@"super_properties"];
    /* 为filePath文件设置保护等级 */
    NSDictionary *protection = [NSDictionary dictionaryWithObject:NSFileProtectionComplete
                                                           forKey:NSFileProtectionKey];
    [[NSFileManager defaultManager] setAttributes:protection
                                     ofItemAtPath:filePath
                                            error:nil];
    if (![NSKeyedArchiver archiveRootObject:[self.superProperties copy] toFile:filePath]) {
        SUNYSAError(@"%@ unable to archive super properties", self);
    }
    SUNYSADebug(@"%@ archive super properties data", self);
}

- (void)deleteAll {
    [self.messageQueue deleteAll];
}

#pragma mark - Network control

+ (NSString *)getNetWorkStates {
    NSString* network = @"NULL";
    @try {
        SUNYReachability *reachability = [SUNYReachability reachabilityForInternetConnection];
        SUNYSANetworkStatus status = [reachability currentReachabilityStatus];

        if (status == SUNYSAReachableViaWiFi) {
            network = @"WIFI";
        } else if (status == SUNYSAReachableViaWWAN) {
          static CTTelephonyNetworkInfo *netinfo = nil;
            if (!netinfo) {
                netinfo = [[CTTelephonyNetworkInfo alloc] init];
            }
            if ([netinfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyGPRS]) {
                network = @"2G";
            } else if ([netinfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyEdge]) {
                network = @"2G";
            } else if ([netinfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyWCDMA]) {
                network = @"3G";
            } else if ([netinfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyHSDPA]) {
                network = @"3G";
            } else if ([netinfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyHSUPA]) {
                network = @"3G";
            } else if ([netinfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMA1x]) {
                network = @"3G";
            } else if ([netinfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORev0]) {
                network = @"3G";
            } else if ([netinfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORevA]) {
                network = @"3G";
            } else if ([netinfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORevB]) {
                network = @"3G";
            } else if ([netinfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyeHRPD]) {
                network = @"3G";
            } else if ([netinfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyLTE]) {
                network = @"4G";
            }
        }
    } @catch(NSException *exception) {
        SUNYSADebug(@"%@: %@", self, exception);
    }
    return network;
}

- (UInt64)flushInterval {
    @synchronized(self) {
        return _flushInterval;
    }
}

- (void)setFlushInterval:(UInt64)interval {
    @synchronized(self) {
        if (interval < 5 * 1000) {
            interval = 5 * 1000;
        }
        _flushInterval = interval;
    }
    [self flush];
    [self startFlushTimer];
}

- (void)startFlushTimer {
    SUNYSADebug(@"starting flush timer.");
    [self stopFlushTimer];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self->_flushInterval > 0) {
            double interval = self->_flushInterval > 100 ? (double)self->_flushInterval / 1000.0 : 0.1f;
            self.timer = [NSTimer scheduledTimerWithTimeInterval:interval
                                                          target:self
                                                        selector:@selector(flush)
                                                        userInfo:nil
                                                         repeats:YES];
            [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
        }
    });
}

- (void)stopFlushTimer {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.timer) {
            [self.timer invalidate];
        }
        self.timer = nil;
    });
}

- (UInt64)flushBulkSize {
    @synchronized(self) {
        return _flushBulkSize;
    }
}

- (void)setFlushBulkSize:(UInt64)bulkSize {
    @synchronized(self) {
        _flushBulkSize = bulkSize;
    }
}

- (SUNYSensorsAnalyticsDebugMode)debugMode {
    return _debugMode;
}

#pragma mark - UIApplication Events
- (void)setUpListeners {
    // 监听 App 启动或结束事件
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver:self
                           selector:@selector(applicationWillEnterForeground:)
                               name:UIApplicationWillEnterForegroundNotification
                             object:nil];
    
    [notificationCenter addObserver:self
                           selector:@selector(applicationDidBecomeActive:)
                               name:UIApplicationDidBecomeActiveNotification
                             object:nil];
    
    [notificationCenter addObserver:self
                           selector:@selector(applicationWillResignActive:)
                               name:UIApplicationWillResignActiveNotification
                             object:nil];
    
    [notificationCenter addObserver:self
                           selector:@selector(applicationDidEnterBackground:)
                               name:UIApplicationDidEnterBackgroundNotification
                             object:nil];
    
    [notificationCenter addObserver:self
                           selector:@selector(applicationWillTerminateNotification:)
                               name:UIApplicationWillTerminateNotification
                             object:nil];
    
}

- (void)applicationWillEnterForeground:(NSNotification *)notification {
    SUNYSADebug(@"%@ application will enter foreground", self);
    _appRelaunched = YES;
}

- (void)applicationDidBecomeActive:(NSNotification *)notification {
    SUNYSADebug(@"%@ application did become active", self);

    if (_applicationWillResignActive) {
        _applicationWillResignActive = NO;
        return;
    }
    _applicationWillResignActive = NO;

    // 遍历 trackTimer ,修改 eventBegin 为当前 currentSystemUpTime
    dispatch_async(self.serialQueue, ^{
        NSNumber *currentSystemUpTime = @([[self class] getSystemUpTime]);
        NSArray *keys = [self.trackTimer allKeys];
        NSString *key = nil;
        NSMutableDictionary *eventTimer = nil;
        for (key in keys) {
            eventTimer = [[NSMutableDictionary alloc] initWithDictionary:self.trackTimer[key]];
            if (eventTimer) {
                [eventTimer setValue:currentSystemUpTime forKey:@"eventBegin"];
                self.trackTimer[key] = eventTimer;
            }
        }
    });

    [self startFlushTimer];
}

- (void)applicationWillResignActive:(NSNotification *)notification {
    SUNYSADebug(@"%@ application will resign active", self);
    _applicationWillResignActive = YES;
    [self stopFlushTimer];
}

- (void)applicationDidEnterBackground:(NSNotification *)notification {
    SUNYSADebug(@"%@ application did enter background", self);
    _applicationWillResignActive = NO;

    self.launchedPassively = NO;

    // 遍历 trackTimer
    // eventAccumulatedDuration = eventAccumulatedDuration + currentSystemUpTime - eventBegin
    dispatch_async(self.serialQueue, ^{
        NSNumber *currentSystemUpTime = @([[self class] getSystemUpTime]);
        NSArray *keys = [self.trackTimer allKeys];
        NSString *key = nil;
        NSMutableDictionary *eventTimer = nil;
        for (key in keys) {
            if (key != nil) {
                if ([key isEqualToString:@"$AppEnd"]) {
                    continue;
                }
            }
            eventTimer = [[NSMutableDictionary alloc] initWithDictionary:self.trackTimer[key]];
            if (eventTimer) {
                NSNumber *eventBegin = [eventTimer valueForKey:@"eventBegin"];
                NSNumber *eventAccumulatedDuration = [eventTimer objectForKey:@"eventAccumulatedDuration"];
                long eventDuration;
                if (eventAccumulatedDuration) {
                    eventDuration = [currentSystemUpTime longValue] - [eventBegin longValue] + [eventAccumulatedDuration longValue];
                } else {
                    eventDuration = [currentSystemUpTime longValue] - [eventBegin longValue];
                }
                [eventTimer setObject:[NSNumber numberWithLong:eventDuration] forKey:@"eventAccumulatedDuration"];
                [eventTimer setObject:currentSystemUpTime forKey:@"eventBegin"];
                self.trackTimer[key] = eventTimer;
            }
        }
    });

    
    if (self.flushBeforeEnterBackground) {
        dispatch_async(self.serialQueue, ^{
            [self _flush:YES];
        });
    }
}

-(void)applicationWillTerminateNotification:(NSNotification *)notification {
    SUNYSALog(@"applicationWillTerminateNotification");
    dispatch_sync(self.serialQueue, ^{
    });
}

#pragma mark - SensorsData  Analytics

- (void)set:(NSDictionary *)profileDict {
    if (profileDict) {
        [self track:nil withProperties:profileDict withType:@"profile_set"];
    }
}

- (void)setOnce:(NSDictionary *)profileDict {
    if (profileDict) {
        [self track:nil withProperties:profileDict withType:@"profile_set_once"];
    }
}

- (void)set:(NSString *) profile to:(id)content {
    if (profile && content) {
        [self track:nil withProperties:@{profile: content} withType:@"profile_set"];
    }
}

- (void)setOnce:(NSString *) profile to:(id)content {
    if (profile && content) {
        [self track:nil withProperties:@{profile: content} withType:@"profile_set_once"];
    }
}

- (void)unset:(NSString *) profile {
    if (profile) {
        [self track:nil withProperties:@{profile: @""} withType:@"profile_unset"];
    }
}

- (void)increment:(NSString *)profile by:(NSNumber *)amount {
    if (profile && amount) {
        [self track:nil withProperties:@{profile: amount} withType:@"profile_increment"];
    }
}

- (void)increment:(NSDictionary *)profileDict {
    if (profileDict) {
        [self track:nil withProperties:profileDict withType:@"profile_increment"];
    }
}

- (void)append:(NSString *)profile by:(NSObject<NSFastEnumeration> *)content {
    if (profile && content) {
        [self track:nil withProperties:@{profile: content} withType:@"profile_append"];
    }
}

- (void)deleteUser {
    [self track:nil withProperties:@{} withType:@"profile_delete"];
}

- (void)enableLog:(BOOL)enabelLog{
    [SUNYSALogger enableLog:enabelLog];
}

- (void)enableLog {
    BOOL printLog = NO;
    if ( [self debugMode] != SUNYSensorsAnalyticsDebugOff) {
        printLog = YES;
    }
    [SUNYSALogger enableLog:printLog];
}

- (void)clearKeychainData {
    [SUNYSAKeyChainItemWrapper deletePasswordWithAccount:kSUNYSAUdidAccount service:kSUNYSAService];
}

@end
