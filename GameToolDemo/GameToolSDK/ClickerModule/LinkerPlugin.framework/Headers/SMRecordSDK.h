//
//  SMRecordSDK.h
//  LinkerPlugin
//
//  Created by smwl on 2023/10/24.
//

#import <Foundation/Foundation.h>

@class SMClickSchemeModel;
@class SMClickPointModel;

typedef NS_ENUM(NSInteger,RecordSchemeSatus){
    
    //未初始化状态
    RecordSchemeSatusNotStarted = 0,
    //暂停
    RecordSchemeSatusPaused,
    //运行中
    RecordSchemeSatusRunning,
    //结束
    RecordSchemeSatusCompleted,
    //执行出错
    RecordSchemeSatusFailed,

};

@protocol SMRecordSDKDelegate  <NSObject>

@optional
/// 录制方案状态变化
/// - Parameter recordSchemeSatus: 录制方最新案状态
-(void)recordSchemeSatuschanged:(RecordSchemeSatus)recordSchemeSatus;


/// 将在interval后执行索引为lineIndex这条线
/// - Parameters:
///   - lineIndex: 线的索引
///   - interval: 等待时间
-(void)willRecordLine:(NSInteger)lineIndex interval:(NSTimeInterval)interval;



/// 开始绘制某条线
/// - Parameter lineIndex: 线的索引
-(void)beginRecordLine:(NSInteger)lineIndex;


/// 某条线的录制执行完毕
/// - Parameters:
///   - lineIndex: 这条线的索引
///   - isLastLine:是否为方案中最后一条线
///   - nextLineInterval: 这条线和下条线之间的时间间隔
-(void)didRecordLine:(NSInteger)lineIndex isLastLine:(BOOL)isLastLine interval:(NSTimeInterval)nextLineInterval;


/// 将要触摸某个点
/// - Parameters:
///   - pointIndex: 点的索引
///   - lineIndex: 条线的索引
-(void)didFakeTouchPoint:(NSInteger)pointIndex lineIndex:(NSInteger)lineIndex interval:(NSTimeInterval)nextInterval;


/// 完成某个点的触摸
/// - Parameters:
///   - pointIndex: 点的索引
///   - lineIndex: 条线的索引
///   - nextPointInterval: 当前点和下一点的时间间隔
//-(void)didFakeTouchPoint:(NSInteger)pointIndex lineIndex:(NSInteger)lineIndex interval:(NSTimeInterval)nextPointInterval;


/// 方案执行次数变化
/// - Parameter cycleNum: 当前次数
-(void)recordSchemeCycleNumChanged:(NSInteger)cycleNum;



//触点状态变化

@end

NS_ASSUME_NONNULL_BEGIN

@interface SMRecordSDK : NSObject

//@property(nonatomic,assign)BOOL isRuning;
//
//@property(nonatomic,assign)BOOL isPaused;
//
//@property(nonatomic,assign)BOOL isCompleted;

@property(nonatomic,weak)id<SMRecordSDKDelegate>delegate;

//方案状态
@property(nonatomic,assign)RecordSchemeSatus recordSchemeSatus;


/// 创建单利
+(instancetype)shareSDK;


/// 开始一个录制方案
/// - Parameter schemeModel:  录制方案
/// 启动失败时异常信息在schemeSatusChanged:scheme:error:中，此时schemeSatus为ClickerSchemeSatusUnStarted
/// return YES:方案启动成功;NO:方案启动失败
-(void)startRecordWithScheme:(SMClickSchemeModel *)schemeModel;


/// 开始一个录制方案
/// - Parameter schemeJsonStr:  录制方案
/// 启动失败时异常信息在schemeSatusChanged:scheme:error:中，此时schemeSatus为ClickerSchemeSatusUnStarted
/// return YES:方案启动成功;NO:方案启动失败
-(void)startRecordWithSchemeJsonStr:(NSString *)schemeJsonStr;



/// 暂停执行录制方案
/// 建议调用前检查schemeSatus是否为ClickerSchemeSatusRunning或者isRuning是否为YES
/// return YES:暂停成功; NO:暂停失败
-(void)pauseScheme;


/// 继续执行录制方案
/// 建议调用前检查schemeSatus是否为ClickerSchemeSatusPaused或者isPaused是否为YES
/// return YES:继续成功;NO:继续失败
-(void)continueScheme;


/// 结束方案
-(void)finishScheme;


/// 获取回放第一条线需要等待的时间
-(NSTimeInterval)timeIntervalBeforeFirstLine;
+(NSTimeInterval)timeIntervalBeforeFirstLineSchemeJsonStr:(NSString *)schemeJsonStr;



@end

NS_ASSUME_NONNULL_END
