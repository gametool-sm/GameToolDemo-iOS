//
//  GTLineDrawer.h
//  GTSDK
//
//  Created by smwl on 2023/10/19.
//

#import <UIKit/UIKit.h>
#import "GTLineModel.h"

#define kRGBA(r,g,b,a) [UIColor colorWithRed:(r)/225.0 green:(g)/225.0 blue:(b)/225.0 alpha:(a)/1.0]

typedef NS_ENUM(NSInteger, GTRecordLineType){
    LineType_Current_UNRunning,//当前未运行
    LineType_Current_Running,//当前运行中
    LineType_Before_STEP_One,//前1步
    LineType_Before_STEP_Two,//前2步和前2步以前
 
};

typedef NS_ENUM(NSInteger,LineDrawMode){
    LineDrawMode_SingleLine,//一次只绘制一条线
    LineDrawMode_MutiLines,//一次绘制多条线
};


NS_ASSUME_NONNULL_BEGIN

@interface GTLineDrawer : NSObject

@property(assign,nonatomic)LineDrawMode draweModel;

@property(assign,nonatomic)GTRecordLineType lineType;

@property(strong,nonatomic)GTLineModel *lineModel;

/// 初始化方法
/// - Parameter recorView: “画板"View
-(instancetype)initWithRecorView:(UIView *)recorView;


/// setLineSource
/// - Parameter lineSource: GTLineSource
-(void)setLineSource:(GTLineSource)lineSource;


/// 获取当前线的所有触点
-(NSArray <GTClickerActionModel *>*)touchPoints;

/// 绘制一条线
-(void)drawLine;


/// 增加并展示一个点
/// - Parameters:
///   - pointModel: 触点model
///   - pointType: 触点类型
-(void)addPoint:(GTClickerActionModel *)pointModel pointType:(PointType)pointType;


/// 仅仅增加一个点 但不展示
/// - Parameter pointModel: pointModel
-(void)addPoint:(GTClickerActionModel *)pointModel;


/// 更新线的编号
/// - Parameter lineNum: 线的编号
-(void)updateLineNum:(NSInteger)lineNum;


/// 隐藏线
-(void)hideLine;


/// 展示线
-(void)showLine;


/// 移除线
-(void)removeLine;

/// 重置线
/// 1、bezierPath removeAllPoints
/// 2、tartPointButton&endPointButton removeFromSuperview
-(void)resetLine;

@end

NS_ASSUME_NONNULL_END
