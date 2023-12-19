//
//  GTClickerPointWindow.m
//  GTSDK
//
//  Created by shangmi on 2023/8/28.
//

#import "GTClickerPointWindow.h"
#import "GTClickerWindowManager.h"
#import "GTClickerWindowBehave.h"
#import "GTClickerManager.h"
#import "GTDialogPointSetView.h"
#import "GTDialogWindowManager.h"

@interface GTClickerPointWindow ()

@property (nonatomic, strong) UILabel *numLabel;
//触点序号
@property (nonatomic, assign) int index;

@end

@implementation GTClickerPointWindow

- (void)changeTheme:(NSNotification *)noti {

}

- (instancetype)initWithFrame:(CGRect)frame withIndex:(int)index actionModel:(nonnull GTClickerActionModel *)actionModel{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        //样式大小
        switch ([GTClickerWindowManager shareInstance].pointSetModel.pointSize) {
            case ClickerWindowPointSizeOfSmall: {
                self.frame = CGRectMake(0, 0, clickerWindow_point_small_width , clickerWindow_point_small_width );
                self.bgImg.image = [[GTThemeManager share] imageWithName:@"clicker_point_small_bg_img"];
            }
                break;
            case ClickerWindowPointSizeOfMedium: {
                self.frame = CGRectMake(0, 0, clickerWindow_point_medium_width , clickerWindow_point_medium_width );
                self.bgImg.image = [[GTThemeManager share] imageWithName:@"clicker_point_medium_bg_img"];
            }
                break;
            case ClickerWindowPointSizeOfLarge: {
                self.frame = CGRectMake(0, 0, clickerWindow_point_large_width , clickerWindow_point_large_width );
                self.bgImg.image = [[GTThemeManager share] imageWithName:@"clicker_point_large_bg_img"];
            }
                break;
            default:
                break;
        }
        //显示方式
        switch ([GTClickerWindowManager shareInstance].pointSetModel.pointShowType) {
            case ClickerWindowPointShowNo: {
                self.hidden = YES;
            }
                break;
            case ClickerWindowPointShowExecute: {
                self.hidden = NO;
            }
                break;
            case ClickerWindowPointShowAll: {
                self.hidden = NO;
            }
                break;
            default:
                break;
        }
        self.index = index;
//        self.actionModel = actionModel;
        self.center = CGPointMake(actionModel.centerX, actionModel.centerY);
        self.numLabel.text = [NSString stringWithFormat:@"%d", index];
        
        [self setUp];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[GTClickerWindowManager shareInstance].pointSetModel removeObserver:self forKeyPath:@"pointShowType"];
    [[GTClickerWindowManager shareInstance].pointSetModel removeObserver:self forKeyPath:@"pointSize"];
    [[GTClickerWindowManager shareInstance] removeObserver:self forKeyPath:@"isAllPointShow"];
    [[GTClickerManager shareInstance] removeObserver:self forKeyPath:@"isRun"];
}

- (void)setUp {
    [self addSubview:self.bgImg];
    [self addSubview:self.numLabel];
    
//    [self.bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.right.bottom.left.equalTo(self);
//    }];
//
//    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.mas_centerX);
//        make.centerY.equalTo(self.mas_centerY);
//    }];
    //拖拽手势
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragAction:)];
    [self addGestureRecognizer:panGesture];
    //长按手势
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [self addGestureRecognizer:longPressGesture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTheme:) name:GTSDKChangeTheme object:nil];
    //监听触点显示
    [[GTClickerWindowManager shareInstance].pointSetModel addObserver:self forKeyPath:@"pointShowType" options:NSKeyValueObservingOptionNew context:nil];
    //监听触点大小
    [[GTClickerWindowManager shareInstance].pointSetModel addObserver:self forKeyPath:@"pointSize" options:NSKeyValueObservingOptionNew context:nil];
    //监听触点显示
    [[GTClickerWindowManager shareInstance] addObserver:self forKeyPath:@"isAllPointShow" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    //监听连点器功能是否开始，判断触点是否隐藏
    [[GTClickerManager shareInstance] addObserver:self forKeyPath:@"isRun" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    //触点显示
    if ([keyPath isEqualToString:@"pointShowType"] || [keyPath isEqualToString:@"isRun"]) {
        switch ([GTClickerWindowManager shareInstance].pointSetModel.pointShowType) {
            case ClickerWindowPointShowNo: {
                //触点不显示
                self.hidden = YES;
            }
                break;
            case ClickerWindowPointShowExecute: {
                //运行触点显示
                if ([GTClickerManager shareInstance].isRun) {
                    self.hidden = YES;
                }else {
                    self.hidden = NO;
                }
            }
                break;
            case ClickerWindowPointShowAll: {
                //所有触点显示
                self.hidden = NO;
            }
                break;
            default:
                break;
        }
    }
    //触点大小
    if ([keyPath isEqualToString:@"pointSize"]) {
        switch ([GTClickerWindowManager shareInstance].pointSetModel.pointSize) {
            case ClickerWindowPointSizeOfSmall: {
                [UIView animateWithDuration:0.12 animations:^{
//                    self.frame = CGRectMake(self.center.x - clickerWindow_point_small_width * WIDTH_RATIO/2,
//                                                         self.center.y - clickerWindow_point_small_width * WIDTH_RATIO/2,
//                                                         clickerWindow_point_small_width * WIDTH_RATIO,
//                                                         clickerWindow_point_small_width * WIDTH_RATIO);
                
                    self.frame = CGRectMake(0,
                                            0,
                                            clickerWindow_point_small_width ,
                                            clickerWindow_point_small_width );
                    self.center = CGPointMake([GTClickerWindowManager shareInstance].schemeModel.actionArray[self.index-1].centerX, [GTClickerWindowManager shareInstance].schemeModel.actionArray[self.index-1].centerY);
                    self.bgImg.frame = CGRectMake(0, 0, clickerWindow_point_small_width, clickerWindow_point_small_width);
                    self.numLabel.center = CGPointMake(clickerWindow_point_small_width/2, clickerWindow_point_small_width/2);
                }];
                
    
            }
                break;
            case ClickerWindowPointSizeOfMedium: {
                [UIView animateWithDuration:0.12 animations:^{
//                    self.frame = CGRectMake(self.center.x - clickerWindow_point_medium_width * WIDTH_RATIO/2,
//                                                         self.center.y - clickerWindow_point_medium_width * WIDTH_RATIO/2,
//                                                         clickerWindow_point_medium_width * WIDTH_RATIO,
//                                                         clickerWindow_point_medium_width * WIDTH_RATIO);
                    self.frame = CGRectMake(0,
                                            0,
                                            clickerWindow_point_medium_width ,
                                            clickerWindow_point_medium_width );
                    self.center = CGPointMake([GTClickerWindowManager shareInstance].schemeModel.actionArray[self.index-1].centerX, [GTClickerWindowManager shareInstance].schemeModel.actionArray[self.index-1].centerY);
                    self.bgImg.frame = CGRectMake(0, 0, clickerWindow_point_medium_width, clickerWindow_point_medium_width);
                    self.numLabel.center = CGPointMake(clickerWindow_point_medium_width/2, clickerWindow_point_medium_width/2);
                }];
       
            }
                break;
            case ClickerWindowPointSizeOfLarge: {
                [UIView animateWithDuration:0.12 animations:^{
//                    self.frame = self.frame = CGRectMake(self.center.x - clickerWindow_point_large_width * WIDTH_RATIO/2,
//                                                         self.center.y - clickerWindow_point_large_width * WIDTH_RATIO/2,
//                                                         clickerWindow_point_large_width * WIDTH_RATIO,
//                                                         clickerWindow_point_large_width * WIDTH_RATIO);
                    self.frame = CGRectMake(0,
                                            0,
                                            clickerWindow_point_large_width ,
                                            clickerWindow_point_large_width );
                    self.center = CGPointMake([GTClickerWindowManager shareInstance].schemeModel.actionArray[self.index-1].centerX, [GTClickerWindowManager shareInstance].schemeModel.actionArray[self.index-1].centerY);
                    self.bgImg.frame = CGRectMake(0, 0, clickerWindow_point_large_width, clickerWindow_point_large_width);
                    self.numLabel.center = CGPointMake(clickerWindow_point_large_width/2, clickerWindow_point_large_width/2);
                }];
            }
                break;
            default:
                break;
        }
        
        
    }
    
    //触点是否隐藏
    if ([keyPath isEqualToString:@"isAllPointShow"]) {
        self.hidden = ![GTClickerWindowManager shareInstance].isAllPointShow;
    }

}

//拖动悬浮球手势动作
- (void)dragAction:(UIPanGestureRecognizer *)gesture {
    UIGestureRecognizerState moveState = gesture.state;
    switch (moveState) {
        case UIGestureRecognizerStateBegan: {
            if (self.dragTipDisappearBlock) {
                self.dragTipDisappearBlock();
            }
        }
            break;
        case UIGestureRecognizerStateChanged: {
            CGPoint point = [gesture translationInView:self];
            if (![GTClickerManager shareInstance].isRun && !([GTClickerWindowManager shareInstance].clickerWindowState == ClickerWindowStateFutureStart ||
                                                            [GTClickerWindowManager shareInstance].clickerWindowState == ClickerWindowStateFutureDark)) {
                //连点器启动时，包括开始功能和倒计时，不能移动触点
                //中心将要移动的点 （进行判断移动范围）
                CGPoint movePoint = CGPointMake(point.x + CENTERX(self),
                                          point.y + CENTERY(self));
                self.center = [GTClickerWindowBehave clickerPointMoveArea:movePoint];
            }
        }
            break;
        case UIGestureRecognizerStateEnded: {
            //触点停止时，记录中心点坐标
            [GTClickerWindowManager shareInstance].schemeModel.actionArray[self.index-1].centerX = self.center.x;
            [GTClickerWindowManager shareInstance].schemeModel.actionArray[self.index-1].centerY = self.center.y;
        }
        default:
            break;
    }
    [gesture setTranslation:CGPointZero inView:self];
}

//长按弹出触点设置
- (void)longPressAction:(UILongPressGestureRecognizer *)gesture {
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            if (!([GTClickerManager shareInstance].isRun ||
                [GTClickerWindowManager shareInstance].clickerWindowState == ClickerWindowStateFutureStart ||
                [GTClickerWindowManager shareInstance].clickerWindowState == ClickerWindowStateFutureDark)) {
                
                GTDialogPointSetView *view = [[GTDialogPointSetView alloc] initWithTitle:[NSString stringWithFormat:@"触点%d的设置",self.index] model:[GTClickerWindowManager shareInstance].schemeModel.actionArray[self.index-1] index:self.index];
                view.longPressPointShowPointSetBlock = ^(GTClickerActionModel * _Nonnull model) {
                    [[GTClickerWindowManager shareInstance].schemeModel.actionArray replaceObjectAtIndex:self.index-1 withObject:model];
                };
                [[GTDialogWindowManager shareInstance].dialogVC.view addSubview:view];
                [[GTDialogWindowManager shareInstance] dialogWindowShow];
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - setter & getter

- (UIImageView *)bgImg {
    if (!_bgImg) {
        _bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.size.width, self.size.height)];
        _bgImg.userInteractionEnabled = YES;
    }
    return _bgImg;
}

- (UILabel *)numLabel {
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.size.width, self.size.height)];
        _numLabel.textColor = [UIColor hexColor:@"#FFFFFF"];
        _numLabel.font = [UIFont systemFontOfSize:13 * WIDTH_RATIO];
        _numLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _numLabel;
}

@end
