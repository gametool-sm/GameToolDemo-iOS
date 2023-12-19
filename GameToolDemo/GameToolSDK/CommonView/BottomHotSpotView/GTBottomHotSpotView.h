//
//  GTBottomHotSpotView.h
//  GTSDK
//
//  Created by shangmi on 2023/8/30.
//

#import "GTBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface GTBottomHotSpotView : GTBaseView

//显示隐藏区域(通过显示与隐藏控制，就不需要反复创建了)
- (void)show;
//隐藏隐藏区域
- (void)hide;
//悬浮球进入隐藏热区松手准备隐藏隐藏区域
- (void)willHide;
//悬浮球进入隐藏热区
-(void)enterHideHotView;
//悬浮球移除隐藏热区
-(void)exitOutHideHotView;
/*
 隐藏热区，只是划的一个区域，方便控件进入这个区域进行变化，时间上在界面上是无感的
 */
@property (nonatomic, strong) UIView * hideHotView;

/*
 隐藏悬浮球
 */
@property (nonatomic, copy) void (^hideFloatBall)(void);
/*
 悬浮球是否在隐藏热区
 */
@property (nonatomic, assign) BOOL isInHotView;

@end

NS_ASSUME_NONNULL_END
