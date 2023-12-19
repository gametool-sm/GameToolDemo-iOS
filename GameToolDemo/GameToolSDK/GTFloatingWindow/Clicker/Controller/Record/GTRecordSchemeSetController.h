//
//  GTRecordSchemeSetController.h
//  GTSDK
//
//  Created by smwl on 2023/11/1.
//

#import <UIKit/UIKit.h>
#import "GTBaseViewController.h"
#import "GTClickerActionModel.h"
#import "GTClickerSchemeModel.h"
#import "GTDialogView.h"
#import "GTClickerWindowStartView.h"
#import "GTDialogWindowManager.h"
#import "GTRecordManager.h"
#import "GTClickerWindowAnimation.h"
#import "GTFloatingWindowManager.h"
#import "GTFloatingWindowConfig.h"
#import "UIButton+Extent.h"
#import <AudioToolbox/AudioToolbox.h>
#import "GTRecordPointSetPlanView.h"
#import "GTRecordSetViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface GTRecordSchemeSetController : GTBaseViewController

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *touchButton;
@property (nonatomic, strong) UIButton *planButton;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UIButton *setButton;
@property (nonatomic, strong) UIButton *quitButton;
@property (nonatomic, strong) UIButton *saveButton;

@property (nonatomic, strong) UITableView *pointSetTableView;

@property (nonatomic, strong) GTBaseView *touchView;
@property (nonatomic, strong) GTRecordPointSetPlanView *planView;//要向下滑所以用ScrollView

@property (nonatomic, strong) UILabel *tapCount;
@property (nonatomic, strong) UILabel *pressDuration;
@property (nonatomic, strong) UILabel *clickInterval;
@property (nonatomic, strong) NSMutableArray *touchPoints;
@property (nonatomic, assign) int direction;

//动画
@property (nonatomic, strong) UIView *whiteBackground;  //遮挡作用
@property (nonatomic, strong) UILabel *deletePointLabel;
@property (nonatomic, strong) UIButton *deletePointButton;
@property (nonatomic, strong) UIButton *cancelPointButton;

@property (nonatomic, strong) NSMutableArray *pointDataArray;
@property (nonatomic, strong) NSMutableArray *compareDataArray;
//数据源
@property (nonatomic, strong) NSMutableArray *DataArray;
@property (nonatomic, assign) NSInteger row;

//数据
@property (nonatomic, strong) GTClickerSchemeModel *model;

//定时器自动滚动
@property (nonatomic, strong) CADisplayLink *autoScrollTimer;

//对比修改的配置
@property (nonatomic, assign) int change;

//触点与方案的选择
@property (nonatomic, assign) int pointAndPlan;

//快照
@property (nonatomic, strong, nullable) UIDragPreviewParameters *snapshot;
//方案设置
@property (nonatomic, strong) GTRecordSetViewController *setViewController;
//收起键盘的手势
@property (nonatomic, strong) UITapGestureRecognizer *closeKeyBoard;

//
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;


@end

NS_ASSUME_NONNULL_END
