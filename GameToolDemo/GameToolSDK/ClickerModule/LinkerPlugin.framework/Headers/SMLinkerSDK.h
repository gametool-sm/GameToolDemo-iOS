//
//  LinkerSDK.h
//  GTSDK111111
//
//  Created by smwl on 2023/8/30.
/*
 test git commit 
 */

#import <Foundation/Foundation.h>
@class SMClickSchemeModel;
@class SMClickPointModel;

typedef NS_ENUM(NSInteger,ClickerSchemeSatus){
    
    //未初始化状态
    ClickerSchemeSatusUnStarted = 0,
//    //启动失败
//    ClickerSchemeStartFailed,
    //暂停
    ClickerSchemeSatusPaused,
//    //操作暂停失败
//    ClickerSchemeSatusPausFailed,
//    //操作继续失败
//    ClickerSchemeSatusContinueFailed,
    //运行中
    ClickerSchemeSatusRunning,
    //结束
    ClickerSchemeSatusCompleted,
    //执行出错
    ClickerSchemeSatusFailed,

};

@protocol SMLinkClickerDelegate <NSObject>

@optional

/// 将要点击一次按钮
/// - Parameter pointModel: 按钮model
-(void)willClickPoint:(SMClickPointModel *_Nullable)pointModel scriptCheakPoint:(SMClickPointModel *_Nullable)scriptCheakPointModel;


/// 完成按钮点击(按时间间隔完成所有点击次数)
/// - Parameter pointModel: 按钮model
-(void)pointClickFinished:(SMClickPointModel *_Nullable)pointModel;

//防脚本检测状态变化
-(void)preventScriptCheakSatusChanged:(BOOL)enable;


/// 方案状态变化
/// - Parameters:
///   - satus: 方案状态
///   - pointModel: 方案状态变化时对应的pointModel
///   - error: 异常信息

-(void)schemeSatusChanged:(ClickerSchemeSatus)status scheme:(SMClickSchemeModel *_Nullable)schemeModel error:(NSError *_Nullable)error;


@end

NS_ASSUME_NONNULL_BEGIN

@interface SMLinkerSDK : NSObject

@property(nonatomic,weak)id<SMLinkClickerDelegate>delegate;

/// 是否开启了防脚本检测
@property(nonatomic,assign)BOOL preventScriptCheakEnable;


@property(nonatomic,assign)ClickerSchemeSatus schemeSatus;

@property(nonatomic,assign)BOOL isRuning;

@property(nonatomic,assign)BOOL isPaused;

@property(nonatomic,assign)BOOL isCompleted;

@property(nonatomic,assign)int cycleNum;//连点方案循环次数

/// 创建单利
+(instancetype)shareSDK;


/// 开始一个连点方案
/// - Parameter schemeModel:  连点方案
/// 启动失败时异常信息在schemeSatusChanged:scheme:error:中，此时schemeSatus为ClickerSchemeSatusUnStarted
/// return YES:方案启动成功;NO:方案启动失败
-(BOOL)startClickWithScheme:(SMClickSchemeModel *)schemeModel;


/// 开始一个连点方案
/// - Parameter schemeJsonStr:  连点方案
/// 启动失败时异常信息在schemeSatusChanged:scheme:error:中，此时schemeSatus为ClickerSchemeSatusUnStarted
/// return YES:方案启动成功;NO:方案启动失败
-(BOOL)startClickWithSchemeJsonStr:(NSString *)schemeJsonStr;



/// 暂停执行连点方案
/// 建议调用前检查schemeSatus是否为ClickerSchemeSatusRunning或者isRuning是否为YES
/// return YES:暂停成功; NO:暂停失败
-(BOOL)pauseScheme;


/// 继续执行连点方案
/// 建议调用前检查schemeSatus是否为ClickerSchemeSatusPaused或者isPaused是否为YES
/// return YES:继续成功;NO:继续失败
-(BOOL)continueScheme;


@end

NS_ASSUME_NONNULL_END
