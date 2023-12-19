//
//  GTSpeedUpManager.h
//  GTSDK
//
//  Created by shangmi on 2023/7/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GTSpeedUpManager : NSObject

//加速器是否开启
@property (nonatomic, assign) BOOL isStart;

+ (GTSpeedUpManager *)shareInstance;

/**
 加速初始化统一调用；
 
 @param success 初始化成功的回调；
 @param failure 初始化失败的回调
 */
+(void)speedupInitWithSuccess:(nullable void (^)(void))success
                      failure:(nullable void (^)(NSString * _Nonnull))failure;


/**
 是否限制加速的使用；当请求接口初始化后游戏厂商没有加速的使用权限，需要调用这里，将isDisable设置为Yes;
 
 @param isDisable 是否限制使用；默认为否；当为Yes的时候，加速恒定倍率为1；即无加速效果
 */
+(void)disableSpeed:(BOOL)isDisable;

/**
 调用底层加速的方法；
 
 @param speed 加速速率；
 */
+(void)changeSpeed:(float)speed;

@end

NS_ASSUME_NONNULL_END
