//
//  GTNetworkManager.m
//  GTSDK
//
//  Created by shangmi on 2023/7/17.
//

#import "GTNetworkManager.h"
#import <sys/utsname.h>
#import <CommonCrypto/CommonCrypto.h>
#import "GTNetworkManager+DebugMode.h"
#import <GTBaseComponent/GTDeviceInfoUtil.h>

@interface GTNetworkManager ()

@property (nonatomic, strong) AFHTTPSessionManager *session;

@end

@implementation GTNetworkManager

+ (GTNetworkManager *)shareManager {
    static GTNetworkManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[GTNetworkManager alloc]init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configData];
    }
    return self;
}

- (NSURLSessionTask *)POST:(NSString *)url parameters:(NSDictionary *)parameters success:(HttpSuccess)success failure:(HttpFailure)failure {
    [self update];
    return [self.session POST:url parameters:parameters headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString * decodeResponseObject;
        if ([responseObject isKindOfClass:[NSData class]]) {
            NSString * str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            decodeResponseObject = [SMEncryptUtil getDecryptResponseDataWithResponseData:str];
        } else {
            decodeResponseObject = responseObject;
        }
        if (decodeResponseObject) {
            NSDictionary * resultDict = [GTSDKUtils dictionaryWithJsonString:decodeResponseObject];
            if (resultDict && success) {
                success(resultDict);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}
- (NSURLSessionTask *)POST:(NSString *)url parameters:(NSDictionary *)parameters body:(HttpBody)body success:(HttpSuccess)success failure:(HttpFailure)failure {
    [self update];
    return [self.session POST:url parameters:parameters headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (body) {
            body(formData);
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString * decodeResponseObject;
        if ([responseObject isKindOfClass:[NSData class]]) {
            decodeResponseObject = [SMEncryptUtil getDecryptResponseDataWithResponseData:responseObject];
        }
        if (decodeResponseObject) {
            NSDictionary * resultDict = [GTSDKUtils dictionaryWithJsonString:decodeResponseObject];
            if (resultDict && success) {
                success(resultDict);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
//            NSError * javaError = [self parseJavaErrorWithOperation:operation error:error];
            failure(error);
        }
    }];
}
- (void)GET:(NSString *)url parameters:(NSDictionary *)parameters success:(HttpSuccess)success failure:(HttpFailure)failure {
    [self.session GET:url parameters:parameters headers:self.session.requestSerializer.HTTPRequestHeaders progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self update];
        NSString * decodeResponseObject;
        if ([responseObject isKindOfClass:[NSData class]]) {
            decodeResponseObject = [SMEncryptUtil getDecryptResponseDataWithResponseData:responseObject];
        }
        if (decodeResponseObject) {
            NSDictionary * resultDict = [GTSDKUtils dictionaryWithJsonString:decodeResponseObject];
            if (resultDict && success) {
                success(resultDict);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
//            NSError * javaError = [self parseJavaErrorWithOperation:operation error:error];
            failure(error);
        }
    }];
}

- (AFHTTPSessionManager *)session {
    if (!_session) {
        _session = [AFHTTPSessionManager manager];
        _session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"text/plain", nil];
        _session.responseSerializer = [AFHTTPResponseSerializer serializer];
        [_session.requestSerializer setValue:[GTNetworkManager GTSDKgenerateUserAgent] forHTTPHeaderField:@"User-Agent"];
        [_session.requestSerializer setValue:@"1/1/-1/GMT+08:00/-1" forHTTPHeaderField:@"i18n"];
        
        
    }
    return _session;
}

- (void)update {
    NSString * sign = [GTNetworkManager MD5:[NSString stringWithFormat:@"idfa=%@&uuid=%@&temp_idfa=%@&cer_id=%@%@",[GTDeviceInfoUtil getIDFA], [GTDeviceInfoUtil getUUID], [GTDeviceInfoUtil getTempidfa], [GTDeviceInfoUtil getCerid], PROD ? @"97701568d069a91171ca890133737d02" : @"cff39ef21be3f0595a651edcec2b0d25"]];
    sign = [sign lowercaseString];
    NSString * queryString = [NSString stringWithFormat:@"idfa=%@&uuid=%@&temp_idfa=%@&cer_id=%@",[GTDeviceInfoUtil getIDFA], [GTDeviceInfoUtil getUUID], [GTDeviceInfoUtil getTempidfa], [GTDeviceInfoUtil getCerid]];
    [self.session.requestSerializer setValue:[NSString stringWithFormat:@"%@&sign=%@",queryString,sign] forHTTPHeaderField:@"gt-dev"];
    
    if ([GTSDKConfig getDeviceId]) {
        NSString * sign = [GTNetworkManager MD5:[NSString stringWithFormat:@"deviceId=%@&userId=%@%@",[GTSDKConfig getDeviceId],[GTSDKConfig getUserID],PROD ? @"97701568d069a91171ca890133737d02" : @"cff39ef21be3f0595a651edcec2b0d25"]];
        sign = [sign lowercaseString];
        NSString * queryString = [NSString stringWithFormat:@"deviceId=%@&userId=%@",[GTSDKConfig getDeviceId],[GTSDKConfig getUserID]];
        [self.session.requestSerializer setValue:[NSString stringWithFormat:@"%@&sign=%@",queryString,sign] forHTTPHeaderField:@"gt-client-info"];
    } else {
        [self.session.requestSerializer setValue:@"" forHTTPHeaderField:@"gt-client-info"];
    }
    if (![self checkIsExpire]) {//debug模式未到期
        [self.session.requestSerializer setValue:self.debugDict[@"token"] forHTTPHeaderField:self.debugDict[@"tokenName"]];
    }
    if ([GTSDKConfig getIsOpenDebugEnvironment]) {
        [self.session.requestSerializer setValue:@"1" forHTTPHeaderField:@"config_env"];
    }else {
        [self.session.requestSerializer setValue:@"2" forHTTPHeaderField:@"config_env"];
    }
}

//删除，等待base库同步
+ (NSString *)MD5:(NSString *)source {
    if (!source || source.length == 0) {
        return nil;
    }
    
    const char *cStr = [source UTF8String];
    if (cStr == NULL) {
        return nil;
    }
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH
     * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02X", digest[i]];
    }
    return result;
}
+ (NSString *_Nullable)GTSDKgenerateUserAgent {
    NSString *sdkVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    UIDevice *currentDevice = [UIDevice currentDevice];
    NSString * typeSDKString = @"GTSDK";
    NSString *userAgent =  [NSString stringWithFormat:@"%@/%@/iOS/%@/%@/%@",
                            typeSDKString,
                            sdkVersion,
                            currentDevice.systemVersion,
                            currentDevice.model,
                            [self iphoneType]];
    return userAgent;
}
+ (NSString *)iphoneType {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPod1,1"]) return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"]) return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"]) return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"]) return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"]) return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPad1,1"]) return @"iPad 1G";
    if ([platform isEqualToString:@"iPad2,1"]) return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,2"]) return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"]) return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,4"]) return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"]) return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,6"]) return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,7"]) return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad3,1"]) return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,2"]) return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,3"]) return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"]) return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,5"]) return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"]) return @"iPad 4";
    if ([platform isEqualToString:@"iPad4,1"]) return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,2"]) return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,3"]) return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,4"]) return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,5"]) return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,6"]) return @"iPad Mini 2G";
    if ([platform isEqualToString:@"i386"]) return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"]) return @"iPhone Simulator";
    return platform;
}

@end
