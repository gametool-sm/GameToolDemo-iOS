//
//  GTClickerPointSetPlanView.h
//  GTSDK
//
//  Created by shangminet on 2023/8/23.
//

#import <UIKit/UIKit.h>
#import "GTClickerSchemeModel.h"
#import "GTClickerPointSetTableViewCell.h"
#import "GTBaseView.h"
#import "GTClickerWindowManager.h"
#import "UIButton+Extent.h"
#import "GTFloatingWindowManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface GTClickerPointSetPlanView : GTBaseView<UITextFieldDelegate>

@property (nonatomic, weak) id<UITextFieldDelegate> delegate;


@property (nonatomic, strong) UIScrollView *pointSetPlanScrollView;
@property (nonatomic, strong) UIView *contentView;
//方案名称
@property (nonatomic, assign) int noChinese;
@property (nonatomic, assign) int Chinese;
@property (nonatomic, strong) UILabel *planNameLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UITextField *planNameTextField;
@property (nonatomic, strong) UIView *planTextBackGround;

//总循环次数
@property (nonatomic, strong) UILabel *loopNumberLabel;
@property (nonatomic, strong) UIView *loopTextBackGround;
@property (nonatomic, strong) UIView *loopButtonBackGround;
@property (nonatomic, strong) UIButton *unlimitedNumberButton;
@property (nonatomic, strong) UIButton *limitedNumberButton;
@property (nonatomic, strong) UITextField *loopNumberTextField;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, assign) BOOL isLimitedNumberSelected;
//循环间隔
@property (nonatomic, strong) UILabel *loopIntervalLabel;
@property (nonatomic, strong) UIView *loopIntervalBackGround;
@property (nonatomic, strong) UITextField *loopIntervalTextField;
@property (nonatomic, strong) UILabel *millSecondLabel;
//循环间隔的提示框
@property (nonatomic, strong) UIButton *loopTipButton;
@property (nonatomic, strong) UILabel *loopTipLabel;
@property (nonatomic, strong) UIImageView *loopTipAngle;
@property (nonatomic, strong) UIView *loopTipView;
@property (nonatomic, strong) UIView *loopTipBackGround;


//启动方式
@property (nonatomic, strong) UILabel *startTypeLabel;
@property (nonatomic, strong) UIView *typeBackGround;
@property (nonatomic, strong) UIButton *nowTimeButton;
@property (nonatomic, strong) UIButton *setTimeButton;
@property (nonatomic, strong) UIButton *countDownButton;

//对比
@property (nonatomic, assign) int selectedButtonIndex;
@property (nonatomic, assign) int cycleIndex;
@property (nonatomic, assign) int cycleInterval;
@property (nonatomic, assign) int fincycleIndex;

@property (nonatomic, assign) int isSelectedType;
@property (nonatomic, assign) int startTypeCompare;
@property (nonatomic, assign) int oldSelected;
//定时
@property (nonatomic, strong) UIView *setTimeBackGround;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *startTimeCompare;
@property (nonatomic, strong) UITextField *timeHour;
@property (nonatomic, strong) UITextField *timeMinute;
@property (nonatomic, strong) UITextField *timeSecond;
@property (nonatomic, strong) UILabel *colonLabel;
@property (nonatomic, strong) UILabel *colonLabel2;

//数据
@property (nonatomic, strong) GTClickerSchemeModel *model;
@property (weak, nonatomic) id<GTClickerPointSetTableViewCellDelegate> planDelegate;

//删除按钮
@property (nonatomic, strong) UIButton *planClearButton;
@property (nonatomic, strong) UIButton *loopNumberClearButton;
@property (nonatomic, strong) UIButton *loopIntervalClearButton;

//键盘移动量
@property (nonatomic, assign) CGFloat offsetY;
//收起键盘的手势
@property (nonatomic, strong) UITapGestureRecognizer *closeKeyBoard;

//能否加删除图标
@property (nonatomic, assign) BOOL isAddDeleted;

//蓝色图层
@property (nonatomic, strong) UIView *blueButtonView;
- (void)setPlanKeyBoardWillShow:(NSNotification *)notification;
- (void)setPlanKeyBoardWillHide:(NSNotification *)notification;
@end

NS_ASSUME_NONNULL_END
