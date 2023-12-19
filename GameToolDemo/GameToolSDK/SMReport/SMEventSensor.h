//
//  SMEventSensor.h
//  GTSDK
//
//  Created by smwl on 2023/11/17.
//
/**
 *
 *CP和神策上报, 同一事件，上报时机相同时在这里统一分发
 *
 */
#import "SMDurationEventReport.h"
#import "GTDataTimeCounter.h"
#import "GTDataConfig.h"
#import "GTDataTimeModel.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMEventSensor : NSObject

/// 工具启动上报(CP端统计启动次数)
/// - Parameters:
///   - toolType: 工具类型
+(void)toolStartup:(ToolType)toolType;

/// 工具关闭上报(神策端统计连点器启动次数)
/// - Parameters:
///   - toolType: 工具类型
///   - event: 事件参数，给神策用
+(void)toolShutdown:(ToolType)toolType event:(NSDictionary *)event;

/// 开始时长上报
/// - Parameters:
///   - toolType: 工具类型
///   - eventName: 工具类型
+(void)startReport:(ToolType)toolType event:(NSString *)eventName params:(NSDictionary *)params;

/// 暂停时长上报
/// - Parameters:
///   - eventName: 工具类型
+(void)pauseReport:(NSString *)eventName;

/// 继续时长上报
/// - Parameters:
///   - eventName: 工具类型
+(void)continueReport:(NSString *)eventName;

/// 结束时长上报
/// - Parameters:
///   - eventName: 工具类型
+(void)finishReport:(NSString *)eventName;


@end

NS_ASSUME_NONNULL_END
