//
//  GTLineModel.h
//  GTSDK
//
//  Created by smwl on 2023/10/19.
//

#import <Foundation/Foundation.h>
#import "GTClickerSchemeModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, PointType){
    PointType_Start,
    PointType_During,
    PointType_End
};


@interface GTLineModel : NSObject

@property (assign,nonatomic)NSInteger lineNum;//线编号

@property(strong,nonatomic)UIButton *startPointButton;

@property(strong,nonatomic)UIButton *endPointButton;

@property(strong,nonatomic)UIView *startBackGroudView;

@property (assign,nonatomic)BOOL outExtremePoint;

@property(strong,nonatomic)GTRecordLineModel *recordLine;




-(void)removeStartEndButton;

/// 增加点
/// - Parameter pointModel: <#pointModel description#>
-(void)addTouchPointModel:(GTClickerActionModel *)pointModel;

/// 展示线的端点：线的起点或终点按钮
/// - Parameters:
///   - pointType:起点或终点
///   - superView: 起点或终点的父view
///   - backGroundImage: 背景图片
///   - alpha: 透明度
-(void)showExtremePoint:(PointType)pointType superView:(UIView *)superView backGround:(NSString *)backGroundImage alpha:(CGFloat)alpha width:(CGFloat)width;


/// 更新端点按钮背景和透明度
/// - Parameters:
///   - backGroundImage: <#backGroundImage description#>
///   - alpha: <#alpha description#>
-(void)updateExtremePointBackGround:(NSString *)backGroundImage alpha:(CGFloat)alpha;


/// 展示有tap手势产生的单个触点
/// - Parameters:
///   - pointType: 起点或终点
///   - superView: 起点或终点的父view
///   - backGroundImage: 背景图片
///   - alpha: 透明度
-(void)showTapPoint:(PointType)pointType superView:(UIView *)superView backGround:(NSString *)backGroundImage alpha:(CGFloat)alpha width:(CGFloat)width;

@end

NS_ASSUME_NONNULL_END
