//
//  GTDataTimeCounter.h
//  GTSDK
//
//  Created by smwl on 2023/11/15.
//

#import <Foundation/Foundation.h>

#import "GTDataTimeModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 当前counter包含上报神策的逻辑
@interface GTDataTimeCounter : NSObject

+(instancetype)sharedInstance;

/// 开启一个计时任务；
///
/// 等同于下方的方法中externParam传nil
-(GTDataTimeCounterType)start:(NSString *)customUniqueId;

/// 开启一个计时任务；
///
/// 如果customUniqueId重复，会覆盖之前的任务；
/// - Parameter customUniqueId: 唯一标识串
/// - Parameter externParam 扩展参数；字典模式，可传nil；当需要配置倒计时时间的时候，可配置如下：
///             @{
///     @"kPresetCountdownTime" : @(x)；x为预设置的倒计时时长，当有这个字段的时候，在上报时会包含倒计时；
///     @"kProperties": 上报上策的properties,
///     @"kEventName:": 事件名称；
/// } 其中x为具体预设的倒计时数值；
///
/// @return 返回的是GTDataTimeCounterType类型的任务标识串，唯一标识这个任务；
/// 上层通过这个类型进行后续的操作；
-(GTDataTimeCounterType)start:(NSString *)customUniqueId externParam:(NSDictionary * __nullable)externParam;


/// 暂停/继续某个计时任务
///
///  @discussion 当业务上需要临时暂停计时的时候调用，或者是需要恢复暂停计时的任务的时候调用；
///
///  不需要考虑应用切换到后台等特殊暂停情况，内部会自动处理暂停和重启；
///
///  @param type 任务标识串
///  @param isStop 是否是暂停；Yes是暂停，No为继续计时
-(void)stop:(BOOL)isStop type:(GTDataTimeCounterType)type;

/// 结束某个计时任务
///
/// @discussion 结束的时候会注销清理掉所有相关数据；
///
/// @param type 任务标识串
-(void)end:(GTDataTimeCounterType)type;

/// 注册计时触发时的行为
///
/// @discussion 内部统一经过60秒会回调触发一次这个行为；
/// 另外在以下情况，也会回调此行为：
/// 主动调用stop的时候；
/// 主动调用end的时候；
/// 被动stop的时候，比如进入到管理后台
///
/// @discussion timeUpAction 生命周期较长，直到调用end的时候才会销毁；
/// 所以block内不应持有短生命周期的对象，以免造成一定范围的内存泄漏；
///
/// @param timeUpAction 计时触发时的行为，参数有初始化时间和间隔时间
/// @param type 任务标识串
-(void)registerAction:(GTDataTimeUpAction)timeUpAction
                 type:(GTDataTimeCounterType)type
                DEPRECATED_MSG_ATTRIBUTE("改为内部上报，这个回调将不再调用") ;

/// 神策初始化的时候调用
/// 判断本地是否还有没上报的进行上报
+(void)findLocalDataToUploadWhenSensorInit;

///神策用户登出的时候调用
///及时上报数据
-(void)sensorUserLogout;

@end

NS_ASSUME_NONNULL_END
