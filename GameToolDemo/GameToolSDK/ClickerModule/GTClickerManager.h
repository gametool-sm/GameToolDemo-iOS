//
//  GTClickerManager.h
//  GTSDK
//
//  Created by shangmi on 2023/8/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GTClickerManager : NSObject

//连点器是否开启
@property (nonatomic, assign) BOOL isRun;

//一整套方案是否执行结束
@property (nonatomic, assign) BOOL isComplete;

+ (GTClickerManager *)shareInstance;

- (BOOL)startScheme:(NSString *)jsonString;

- (BOOL)pauseScheme;

//- (BOOL)continueScheme;

/// 获取方案id
-(int)getPlanId;


/// 获取连点器状态用于埋点
-(NSDictionary *)getClickFinishEvent;

@end

NS_ASSUME_NONNULL_END
