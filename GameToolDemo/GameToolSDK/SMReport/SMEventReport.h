//
//  SMReport.h
//  GTSDK
//
//  Created by smwl on 2023/11/14.
//

#import <Foundation/Foundation.h>
#import "SMEventReportConfig.h"
typedef NS_ENUM(NSInteger,CPEventStatus){
    CPEventStatusNone,//默认值
    CPEventStatusRuning,//正在运行
    CPEventStatusPaused,//暂停
    CPEventStatuseEnded,//结束
};

typedef NS_ENUM(NSInteger,ToolType){
    ToolTypeSpeedup=1,//加速器
    ToolTypeClicker,//连点器
};

NS_ASSUME_NONNULL_BEGIN

@interface SMEventReport : NSObject

@property(nonatomic,copy)NSString *eventName;

/// 工具启动上报(统计启动次数)
/// - Parameters:
///   - toolType: 工具类型
+(void)toolStartupReport:(ToolType)toolType;

/// 开始时长上报
/// - Parameters:
///   - toolType: 工具类型
///   - params: 倒计时时长请用@{@"countdown_time": }
-(void)startReport:(ToolType)toolType params:(NSDictionary *)params;

/// 暂停时长上报
/// ⚠️ 暂停只适用于需要扣除暂停到继续上报之间时长的场景
-(void)pauseReport;

/// 继续时长上报
/// ⚠️ 暂停时长上报到继续时长上报之间的时间不会计入总时长
-(void)continueReport;


/// 结束时长上报
///⚠️ 时间结束时需要手动结束时才上报，不然定时上报不会停止
-(void)finishReport;


/// 手动更新上报
-(void)durationUpdateReport;


/// 仅用与管理本地数据上报
/// - Parameter eventName: 事件名称
-(instancetype)initWithEventName:(NSString *)eventName;

/// 保存到本地
-(void)localSave;

/// 上报本地数据
-(void)localReport;

/// 清除本地数据
-(void)localRemove;

@end

NS_ASSUME_NONNULL_END
