//
//  SMDurationReport.h
//  GTSDK
//
//  Created by smwl on 2023/11/14.
//


#import <Foundation/Foundation.h>
#import "SMEventReport.h"
NS_ASSUME_NONNULL_BEGIN


@interface SMDurationEventReport : NSObject

+(instancetype)defaultReport;

/// 开始时长上报
/// ⚠️ eventName是记录事件的key,不能为nil,不能重复;开始同名时长事件上报，前一个事件会被覆盖，未完成的上报会被取消
/// - Parameters:
///   - toolType: 工具类型
///   - eventName: 事件名称
///   - params: @{@"countdown_time": ,@"plan_id": }
+(void)startReport:(ToolType)toolType eventName:(NSString *)eventName params:(NSDictionary *)params;


/// 暂停时长上报
/// ⚠️ 暂停只适用于需要扣除暂停到继续上报之间时长的场景
/// - Parameters:
///   - toolType: 工具类型
///   - eventName: 工具类型
+(void)pauseReport:(NSString *)eventName;

/// 继续时长上报
/// ⚠️ 暂停时长上报到继续时长上报之间的时间不会计入总时长
/// - Parameters:
///   - toolType: 工具类型
///   - eventName: 工具类型
+(void)continueReport:(NSString *)eventName;


/// 结束时长上报
///⚠️ 时间结束时需要手动结束时才上报，不然定时上报不会停止
/// - Parameters:
///   - toolType: 工具类型
///   - eventName: 工具类型
+(void)finishReport:(NSString *)eventName;


@end

NS_ASSUME_NONNULL_END
