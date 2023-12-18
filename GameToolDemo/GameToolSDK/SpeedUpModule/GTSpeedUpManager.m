//
//  GTSpeedUpManager.m
//  GTSDK
//
//  Created by shangmi on 2023/7/9.
//

#import "GTSpeedUpManager.h"
#include <dlfcn.h>

/**
 是否初始化加速成功；
 默认为否；
 */
static bool __isInitSpeedupSucceed = FALSE;

/**
 加速是否被限制使用；
 */
static bool __isSpeedupDisable = FALSE;

@implementation GTSpeedUpManager

+(void)load {
    /**
     加速优化：
        不再强制要求在load方法里面进行初始化；可以延迟到后面，比如登录成功后再初始化；
        通过判断主二进制中是否存在static_patch_type字段，且值为0来做调整；
        默认情况下还是会走原流程，也就是默认会在load里面加载；
     */
    BOOL isNeedInitSpeedWhenCallLoadMethod = TRUE;
    NSString *infoPlistFile = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSDictionary *infoDict = [NSDictionary dictionaryWithContentsOfFile:infoPlistFile];
    if ([infoDict objectForKey:@"static_patch_type"]) {
        NSString *staticPatchType = [infoDict objectForKey:@"static_patch_type"];
        if ([staticPatchType isEqualToString:@"0"]) {
            isNeedInitSpeedWhenCallLoadMethod = FALSE;
        }
    }
    
    if (isNeedInitSpeedWhenCallLoadMethod) {
        NSLog(@"isNeedInitSpeedWhenCallLoadMethod : true");
        
        // try init while loading
        [self speedupInitWithSuccess:NULL failure:NULL];
    }
}

+ (GTSpeedUpManager *)shareInstance {
   static GTSpeedUpManager *manager = nil;
   static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{
       manager = [[GTSpeedUpManager alloc]init];
   });
   return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        //初始化
        [self setUp];
    }
    return self;
}

- (void)setUp {
    self.isStart = [GTSDKUtils getSpeedUpControl];
}

#pragma mark - Speedup Native 
+(void)speedupInitWithSuccess:(nullable void (^)(void))success failure:(nullable void (^)(NSString * _Nonnull))failure {
    if (__isInitSpeedupSucceed) {
        if (success) {
            success();
        }
        return;
    }
    
    NSString * t = [NSString stringWithFormat:@"./SpeedupPlugin.framework/SpeedupPlugin"];
    void * lib_handle = dlopen([t UTF8String], RTLD_GLOBAL | RTLD_NOW);
    if (!lib_handle) {
        char * error = dlerror();
        NSLog(@"gtsdk: link speedUp Framework error : %s", error);
        if (failure) {
            failure([NSString stringWithFormat:@"gtsdk: link speedUp Framework error : %s", error]);
        }
    } else {
        NSLog(@"gtsdk: link speedUp Framework done! ");
        dispatch_async(dispatch_get_main_queue(), ^{
            bool (* tempFunc)(const char * version, const char * appkey) = dlsym(lib_handle, "_Z4initPKcS0_");
            if (tempFunc != NULL) {
                NSString *version = @"";
                NSString *packageName = @"";
                bool isInitSucceed = tempFunc([version UTF8String], [packageName UTF8String]);
                
                if (isInitSucceed) {
                    __isInitSpeedupSucceed = YES;
                    if (success) {
                        success();
                    }
                } else {
                    if (failure) {
                        failure(@"gtsdk: SpeedUp init return code not succeed.");
                    }
                }
            } else {
                NSLog(@"gtsdk: SpeedUp init error : %s", dlerror());
                if (failure) {
                    failure([NSString stringWithFormat:@"gtsdk: SpeedUp init error : %s", dlerror()]);
                }
            }
        });
    }

    dlclose(lib_handle);
}

+(void)disableSpeed:(BOOL)isDisable {
    __isSpeedupDisable = isDisable;
}

+(void)changeSpeed:(float)speed {
    if (!__isInitSpeedupSucceed) {
        return;
    }
    
    // if disable speed, speed should be 1.0;
    if (__isSpeedupDisable) {
        speed = 1.0;
    }
    
    NSString * t = [NSString stringWithFormat:@"./SpeedupPlugin.framework/SpeedupPlugin"];
    void * lib_handle = dlopen([t UTF8String], RTLD_LAZY);
    if (!lib_handle) {
        //
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            void (* tempFunc)(float time_scale) = dlsym(lib_handle, "_Z7speedupf");
            if (tempFunc) {
                tempFunc(speed);
            }
        });
    }

    dlclose(lib_handle);
}

@end
