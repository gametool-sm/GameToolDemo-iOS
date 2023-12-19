//
//  GTDataTimeModel.h
//  GTSDK
//
//  Created by smwl on 2023/11/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 计时任务回调行为；
///
/// @param initTime 初始时间，毫秒
/// @param useTime 使用时长，用于上报，毫秒；
/// @param countdownTime 倒计时时长，毫秒；
typedef void(^GTDataTimeUpAction)(long initTime,
                                  long useTime,
                                  long countdownTime);

/// 计时任务类型
typedef NSString* GTDataTimeCounterType;

typedef NS_ENUM(NSInteger, GTDataTimeModelStopMode) {
    GTDataTimeModelStopModeRunning, // 正常运行状态（默认一开始就进入这个状态）
    GTDataTimeModelStopModeStopByUser,  // 被用户暂停
    GTDataTimeModelStopModeStopBySystemAuto, //被系统暂停，比如退出到后台
    GTDataTimeModelStopModeEnd //已经结束
};

@interface GTDataTimeModel : NSObject
/// 当前名称
@property (nonatomic, strong, nonnull) GTDataTimeCounterType type;

/// 预设倒计时时间；
@property (nonatomic, assign) long presetCountdownTime;

/// 是否需要上报倒计时
@property (nonatomic, assign) bool shouldUploadCountdown;

/// 初始化时间，最开始创建的时间，单位为毫秒
@property (nonatomic, assign) long initTime;

/// 使用时长，用于上报，毫秒；
@property (nonatomic, assign) long useTime;

/// 倒计时时长，毫秒；
@property (nonatomic, assign) long countdownTime;

/// 暂停模式
@property (nonatomic, assign) GTDataTimeModelStopMode StopMode;

/// 记录上次的暂停模式
@property (nonatomic, assign) GTDataTimeModelStopMode lastStopMode;

/// sensor upload event name
@property (nonatomic, strong, nonnull) NSString *eventName;

/// sensor upload data properties
@property (nonatomic, strong, nullable) NSDictionary *properties;


/// 初始化
/// - Parameters:
///   - type: 类型，字符串
///   - externParam: 扩展参数；
-(instancetype)initWithType:(GTDataTimeCounterType)type externParam:(NSDictionary * __nullable)externParam;

/**
 改变模型的状态：
 以下的情况下需要调用此方法改变模型的状态；
 
 用户暂停/恢复
 系统暂停/恢复（比如退到后台是一种系统暂停，回到前台属于系统恢复）
 用户结束
 
 */
-(void)changeStopModeWithIsStop:(BOOL)isStop isFromUser:(BOOL)isFromUser isEnd:(BOOL)isEnd;

// 倒计时结束的时候调用
// 检测是否适合上报；
-(void)timeUpCheckUpload;

/// 用户登出
/// 需要主动上报
-(void)userLogoutCheckUpload;

#pragma mark - convert
+(NSDictionary * __nullable)modelToDict:(GTDataTimeModel *)model;

+(GTDataTimeModel * __nullable)dictToModel:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
