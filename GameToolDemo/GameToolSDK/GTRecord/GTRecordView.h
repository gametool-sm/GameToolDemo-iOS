//
//  GTRecordView.h
//  GTSDK
//
//  Created by smwl on 2023/10/17.
//

#import <UIKit/UIKit.h>
#import "GTLineModel.h"
#import "GTClickerSchemeModel.h"
#import <LinkerPlugin/LinkerPlugin.h>
#import <LinkerPlugin/SMRecordSDK.h>
#import "GTLineDrawer.h"

typedef NS_ENUM(NSInteger,RecordViewMode){
    RecordViewModeNone,//默认模式
    RecordViewModeRecord,//录制模式
    RecordViewModePlayback,//回放模式
};

@protocol GTRecordViewDelegate <NSObject>

/// 录制方案状态变化
/// - Parameter recordSchemeSatus: 录制方最新案状态
-(void)recordSchemeSatuschanged:(RecordSchemeSatus)recordSchemeSatus;


/// 将在interval后执行索引为lineIndex这条线
/// - Parameters:
///   - lineIndex: 线的索引
///   - interval: 等待时间
-(void)willRecordLine:(NSInteger)lineIndex interval:(NSTimeInterval)interval;


/// 方案执行次数变化
/// - Parameter cycleNum: 当前次数
-(void)recordSchemeCycleNumChanged:(NSInteger)cycleNum;


@end

NS_ASSUME_NONNULL_BEGIN

@interface GTRecordView : UIView<SMRecordSDKDelegate>

@property(nonatomic,weak)id<GTRecordViewDelegate>delegate;

@property (strong,nonatomic)GTLineDrawer *currentLineDrawer;

@property (strong,nonatomic,nullable)GTLineDrawer *beforelineDrawer;

@property (strong,nonatomic) NSMutableArray<GTLineDrawer *>*lineDrawers;

@property(nonatomic,strong)GTClickerSchemeModel *schemeModel;

@property(nonatomic,assign)RecordViewMode recordViewMode;

@property(nonatomic,assign)ClickerWindowPointShowType pointShowType;

@property(nonatomic,assign)NSInteger currentLineIndex;//正在回放的线编号

@property(nonatomic,assign)RecordSchemeSatus schemeSatus;//方案状态


/// 展示录制页面
/// 初始化方法：添加一个view到AppDelete.window，用于响应touch事件，记录触点坐标，展示录制轨迹。
/// 注意：调用了-(void)remove才会被移除，若需要使用新的recordView，请先移除上一个
/// 
+(instancetype)recordView;

/// 移除&销毁GTRecordView
/// GTRecordView 生命周期到此为止
-(void)remove;

/// 读取触点显示模式
-(ClickerWindowPointShowType)loadPointShowType;

@end

NS_ASSUME_NONNULL_END
