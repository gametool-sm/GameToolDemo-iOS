//
//  GTRecordManager.h
//  GTSDK
//
//  Created by shangmi on 2023/10/27.
//

#import <Foundation/Foundation.h>
#import "GTRecordView+GTRecord.h"
#import "GTRecordView+PlayBack.h"

NS_ASSUME_NONNULL_BEGIN

@interface GTRecordManager : NSObject

//录制功能是否开启(即悬浮窗为开始录制和录制计时则为yes，否则为no)
@property (nonatomic, assign) BOOL isRecord;

//该方案是否开始（立即回放点击回放则开始，点击结束则结束，点击暂停和继续都不为结束）
//（定时回放点击回放则开始，点击结束则结束，点击暂停和继续都不为结束，倒计时阶段也为开始）
@property (nonatomic, assign) BOOL isPlayback;

//回放功能是否开启
@property (nonatomic, assign) BOOL isRu;

//一整套方案是否执行结束
@property (nonatomic, assign) BOOL isComplete;

+ (GTRecordManager *)shareInstance;

- (void)startScheme:(NSString *)jsonString;

- (void)pauseScheme;

- (void)continueScheme;

- (NSTimeInterval)timeIntervalBeforeFirstLineSchemeJsonStr:(NSString *)schemeJsonStr;

@end

NS_ASSUME_NONNULL_END
