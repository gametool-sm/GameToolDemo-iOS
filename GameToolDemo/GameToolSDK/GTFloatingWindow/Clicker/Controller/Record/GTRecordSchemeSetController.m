//
//  GTRecordSchemeSetController.m
//  GTSDK
//
//  Created by smwl on 2023/11/1.
//

#import "GTRecordSchemeSetController.h"
#import "GTRecordSetViewController.h"
#import "GTRecordWindowManager.h"
#import "GTRecordView.h"
#import "GTRecordManager.h"

static NSString *const GTClickerPointSetTableViewCellID = @"GTClickerPointSetTableViewCellID";
@interface GTRecordSchemeSetController ()<UITableViewDelegate, UITableViewDataSource,GTClickerPointSetTableViewCellDelegate,UITableViewDropDelegate,UITableViewDragDelegate,UITextFieldDelegate>

@property (nonatomic, assign) BOOL isShowingTouchView; // 标记当前显示的是触点视图还是方案视图
@property (nonatomic, assign) BOOL isClickerDelete; //是否点击删除按钮，触发动画，按钮更改
@property (nonatomic, assign) BOOL isMaskAdded;     //是否添加蒙层
@property (nonatomic, strong) GTClickerWindowStartView *clickerWindowStartView;

@end

@implementation GTRecordSchemeSetController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.planButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    [self.planButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.touchButton.mas_right).mas_equalTo(@(-46*WIDTH_RATIO/2));
        make.width.height.equalTo(@(46*WIDTH_RATIO));
    }];

 
    self.touchButton.hidden = YES;
}


-(void)setClicker:(id)sender{
    self.setViewController = [GTRecordSetViewController new];
    [self.navigationController pushViewController:self.setViewController animated:NO];
}

-(GTRecordPointSetPlanView *)planView{
    if(!_planView){
        _planView = [GTRecordPointSetPlanView new];
    }
    return _planView;
}


- (void)changeTheme:(NSNotification *)noti {
    [super changeTheme:noti];
    self.pointSetTableView.backgroundColor = [GTThemeManager share].colorModel.clicker_pointSetView_bg_color;
    [self.deleteButton setImage:[[GTThemeManager share] imageWithName:@"clicker_pointset_delete"] forState:UIControlStateNormal];
    [self.setButton setImage:[[GTThemeManager share] imageWithName:@"clicker_set_icon"] forState:UIControlStateNormal];
    
    
    [self.quitButton setBackgroundColor:[GTThemeManager share].colorModel.clicker_pointSetquitbutton_color];
    [self.quitButton setTitleColor:[GTThemeManager share].colorModel.clicker_savebutton_text_color forState:UIControlStateNormal];
    self.touchView.backgroundColor = [GTThemeManager share].colorModel.bgColor;
    self.clickInterval.textColor = [GTThemeManager share].colorModel.clicker_text_color;
    self.pressDuration.textColor = [GTThemeManager share].colorModel.clicker_text_color;
    self.tapCount.textColor = [GTThemeManager share].colorModel.clicker_text_color;
    [self setButtoncolor];
    self.whiteBackground.backgroundColor = [GTThemeManager share].colorModel.bgColor;
    [self.cancelPointButton setImage:[[GTThemeManager share] imageWithName:@"icon_close_hide_float_ball_window"] forState:UIControlStateNormal];
    self.deletePointLabel.textColor = [GTThemeManager share].colorModel.clicker_title_color;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    self.change = 0;
    [self.view addSubview:self.touchButton];
    [self.view addSubview:self.lineView];
    [self.view addSubview:self.planButton];
    [self.view addSubview:self.deleteButton];
    [self.view addSubview:self.setButton];
    [self.view addSubview:self.quitButton];
    [self.view addSubview:self.saveButton];

    self.isClickerDelete = NO ;
    [self.touchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left).offset(110*WIDTH_RATIO);
        make.width.height.equalTo(@(46*WIDTH_RATIO));
    }];
    [self.planButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.touchButton.mas_right);
        make.width.height.equalTo(@(46*WIDTH_RATIO));
    }];

    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20*WIDTH_RATIO);
        make.centerY.equalTo(self.touchButton.mas_centerY);
        make.width.height.equalTo(@(20*WIDTH_RATIO));
    }];
    [self.setButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-20*WIDTH_RATIO);
        make.centerY.equalTo(self.touchButton.mas_centerY);
        make.width.height.equalTo(@(20*WIDTH_RATIO));
    }];

    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.touchButton.mas_bottom).offset(-5*WIDTH_RATIO);
        make.centerX.equalTo(self.touchButton.mas_centerX);
        make.width.equalTo(@(20*WIDTH_RATIO));
        make.height.equalTo(@(2*WIDTH_RATIO));
    }];
    [self.quitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-20*WIDTH_RATIO);
        make.left.equalTo(self.view.mas_left).offset(20*WIDTH_RATIO);
        make.width.equalTo(@(130*WIDTH_RATIO));
        make.height.equalTo(@(42*WIDTH_RATIO));
    }];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-20*WIDTH_RATIO);
        make.right.equalTo(self.view.mas_right).offset(-20*WIDTH_RATIO);
        make.width.equalTo(@(130*WIDTH_RATIO));
        make.height.equalTo(@(42*WIDTH_RATIO));
    }];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.touchButton.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.quitButton.mas_top).offset(-4 *WIDTH_RATIO);
    }];
    [self setUptouchView];
    [self setUpPlanView];
    
    [self.view addSubview:self.clickerWindowStartView];
    [self.clickerWindowStartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    @WeakObj(self);
    self.clickerWindowStartView.startViewPauseClickBlock = ^{
        [selfWeak.clickerWindowStartView setHidden:YES];
    };
    
    if([GTRecordManager shareInstance].isRecord)  {
        if ([GTRecordWindowManager shareInstance].recordWindowState == RecordWindowStateRecordTime ||
            [GTRecordWindowManager shareInstance].recordWindowState == RecordWindowStateRecordTimeDark) {
            [self.clickerWindowStartView updateDataWithType:SchemeActionPageTypeRecording];
        }else if ([GTRecordWindowManager shareInstance].recordWindowState == RecordWindowStateStartRecord){
            [self.clickerWindowStartView updateDataWithType:SchemeActionPageTypeRecord];
        }
        self.clickerWindowStartView.hidden = NO;
    }else if ([GTRecordManager shareInstance].isPlayback) {
        [self.clickerWindowStartView updateDataWithType:SchemeActionPageTypeRecordPlaying];
        self.clickerWindowStartView.hidden = NO;
    }else {
        self.clickerWindowStartView.hidden = YES;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(QuitSchemeNotification:) name:GTSDKClickerWindowQuitSchemeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tapSetNotification:) name:GTSDKRecordWindowTapSetNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[GTRecordManager shareInstance] addObserver:self forKeyPath:@"isRecord" options:NSKeyValueObservingOptionNew context:nil];
    [[GTRecordManager shareInstance] addObserver:self forKeyPath:@"isPlayback" options:NSKeyValueObservingOptionNew context:nil];
    //监听悬浮窗视图样式
    [[GTRecordWindowManager shareInstance] addObserver:self forKeyPath:@"recordWindowState" options:NSKeyValueObservingOptionNew context:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PauseSetNotification:) name:GTSDKClickerWindowPauseNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(quitRecordSchemeNotification:) name:GTSDKRecordWindowQuitSchemeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recordFinishRecordNotification:) name:GTSDKRecordFinishRecordNotification object:nil];
}

- (void)setUptouchView{
    [self.scrollView addSubview:self.touchView];
    self.touchView.frame = CGRectMake(0, 0, floatingWindow_width * WIDTH_RATIO, 198 * WIDTH_RATIO);
    [self.touchView addSubview:self.tapCount];
    [self.touchView addSubview:self.pressDuration];
    [self.touchView addSubview:self.clickInterval];
    [self.tapCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.touchView.mas_top).offset(5*WIDTH_RATIO);
        make.left.equalTo(self.touchView.mas_left).offset(43*WIDTH_RATIO);
        make.width.equalTo(@(72*WIDTH_RATIO));
        make.height.equalTo(@(17*WIDTH_RATIO));
    }];
    [self.pressDuration mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.touchView.mas_top).offset(5*WIDTH_RATIO);
        make.centerX.equalTo(self.touchView.mas_centerX);
        make.width.equalTo(@(72*WIDTH_RATIO));
        make.height.equalTo(@(17*WIDTH_RATIO));
    }];
    [self.clickInterval mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.touchView.mas_top).offset(5*WIDTH_RATIO);
        make.right.equalTo(self.touchView.mas_right).offset(-43*WIDTH_RATIO);
        make.width.equalTo(@(72*WIDTH_RATIO));
        make.height.equalTo(@(17*WIDTH_RATIO));
    }];

    [self.touchView addSubview:self.pointSetTableView];
    self.pointSetTableView.showsVerticalScrollIndicator = NO;
    [self.pointSetTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tapCount.mas_bottom).offset(4*WIDTH_RATIO);
        make.left.equalTo(self.touchView.mas_left).offset(12*WIDTH_RATIO);
        make.right.equalTo(self.touchView.mas_right).offset(-12*WIDTH_RATIO);
        make.bottom.equalTo(self.touchView.mas_bottom).offset(-4*WIDTH_RATIO);
    }];
}

- (void)setUpPlanView{
    [self.scrollView addSubview:self.planView];
    self.planView.planDelegate = self;
    self.planView.frame = CGRectMake(floatingWindow_width * WIDTH_RATIO, 0, floatingWindow_width * WIDTH_RATIO, 198 * WIDTH_RATIO);
}

//显示不同的view
- (void)showTouchView {
    self.deleteButton.hidden = NO;
    [self.touchButton setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
    [self.planButton setTitleColor:[GTThemeManager share].colorModel.clicker_text_color forState:UIControlStateNormal];
    self.pointAndPlan = 0;
    [UIView animateWithDuration:0.28 animations:^{
        [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.touchButton.mas_bottom).offset(-5*WIDTH_RATIO);
                make.centerX.equalTo(self.touchButton.mas_centerX);
                make.width.equalTo(@(20*WIDTH_RATIO));
                make.height.equalTo(@(2*WIDTH_RATIO));
        }];
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        [self.view layoutIfNeeded];
    }];

}

- (void)showPlanView {
    self.deleteButton.hidden = YES;
    [self.touchButton setTitleColor:[GTThemeManager share].colorModel.clicker_text_color forState:UIControlStateNormal];
    [self.planButton setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
    self.pointAndPlan = 1;
    [UIView animateWithDuration:0.28 animations:^{
        [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.planButton.mas_bottom).offset(-5*WIDTH_RATIO);
                make.centerX.equalTo(self.planButton.mas_centerX);
                make.width.equalTo(@(20*WIDTH_RATIO));
                make.height.equalTo(@(2*WIDTH_RATIO));
        }];
        [self.scrollView setContentOffset:CGPointMake(floatingWindow_width * WIDTH_RATIO, 0) animated:YES];
        [self.view layoutIfNeeded];
    }];
}

- (void)setButtoncolor {
    if(self.pointAndPlan){
        [self.touchButton setTitleColor:[GTThemeManager share].colorModel.clicker_text_color forState:UIControlStateNormal];
        [self.planButton setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
    }else{
        [self.touchButton setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
        [self.planButton setTitleColor:[GTThemeManager share].colorModel.clicker_text_color forState:UIControlStateNormal];
    }
   
}

#pragma mark - 通知
- (void)QuitSchemeNotification:(NSNotification *)noti{
    [self.navigationController popViewControllerAnimated:NO];
}
//TapSetNotification

- (void)tapSetNotification:(NSNotification *)noti {
    [self loadData];
    [self.pointSetTableView reloadData];
}

- (void)recordFinishRecordNotification:(NSNotification *)noti{
    [self tapSetNotification:noti];
}
//添加方案正在运行的提示图
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqual:@"isRecord"] || [keyPath isEqual:@"isPlayback"] || [keyPath isEqual:@"recordWindowState"]) {
//        if(([GTRecordManager shareInstance].isRecord
////            ||[GTRecordWindowManager shareInstance].clickerWindowState == ClickerWindowStateFutureStart
////            ||[GTRecordWindowManager shareInstance].clickerWindowState == ClickerWindowStateFutureDark
//            )&&
//            !(self.clickerWindowStartView)){
//            self.clickerWindowStartView = [[GTClickerWindowStartView alloc] initWithFrame:CGRectZero];
//            [self.view addSubview:self.clickerWindowStartView];
//            [self.view bringSubviewToFront:self.clickerWindowStartView];
//            [self.clickerWindowStartView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.edges.equalTo(self.view);
//            }];
//
//            @WeakObj(self);
//            self.clickerWindowStartView.startViewPauseClickBlock = ^{
//                [selfWeak.clickerWindowStartView removeFromSuperview];
//                selfWeak.clickerWindowStartView = nil;
//            };
//        }
        
        if([GTRecordManager shareInstance].isRecord)  {
            if ([GTRecordWindowManager shareInstance].recordWindowState == RecordWindowStateRecordTime ||
                [GTRecordWindowManager shareInstance].recordWindowState == RecordWindowStateRecordTimeDark) {
                [self.clickerWindowStartView updateDataWithType:SchemeActionPageTypeRecording];
            }else if ([GTRecordWindowManager shareInstance].recordWindowState == RecordWindowStateStartRecord){
                [self.clickerWindowStartView updateDataWithType:SchemeActionPageTypeRecord];
            }
            self.clickerWindowStartView.hidden = NO;
        }else if ([GTRecordManager shareInstance].isPlayback) {
            [self.clickerWindowStartView updateDataWithType:SchemeActionPageTypeRecordPlaying];
            self.clickerWindowStartView.hidden = NO;
        }else {
            self.clickerWindowStartView.hidden = YES;
        }
    }
}

/// 退出录制方案页面
/// - Parameter noti: <#noti description#>
-(void)quitRecordSchemeNotification:(NSNotification *)noti {

    [self.navigationController popViewControllerAnimated:NO];

}

//-(void)PauseSetNotification:(NSNotification *)noti {
//    [self.clickerWindowStartView removeFromSuperview];
//    self.clickerWindowStartView = nil;
//}

- (void)keyboardWillShow:(NSNotification *)noti {
    self.closeKeyBoard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyBoard:)];
    [self.pointSetTableView addGestureRecognizer:self.closeKeyBoard];
}

- (void)closeKeyBoard:(UITapGestureRecognizer *)sender {
    [self.pointSetTableView endEditing:YES];
}

- (void)keyboardWillHide:(NSNotification *)noti {
    [self.pointSetTableView removeGestureRecognizer:self.closeKeyBoard];
   
}

- (void)dealloc {
    [[GTRecordManager shareInstance] removeObserver:self forKeyPath:@"isRecord"];
    [[GTRecordManager shareInstance] removeObserver:self forKeyPath:@"isPlayback"];
    [[GTRecordWindowManager shareInstance] removeObserver:self forKeyPath:@"recordWindowState"];

    [[NSNotificationCenter defaultCenter] removeObserver:self.pointSetTableView];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - method
//监听变量是否改变
- (void)setChange:(int)change {
    if (_change != change) {
        _change = change;
        if (change != 0) {
            self.saveButton.backgroundColor = [UIColor themeColor];
            [self.saveButton setTitleColor:[UIColor hexColor:@"#FFFFFF"] forState:UIControlStateNormal];
        } else {
            self.saveButton.backgroundColor = [UIColor themeColorWithAlpha:0.4];
            [self.saveButton setTitleColor:[GTThemeManager share].colorModel.clicker_savebutton_color forState:UIControlStateNormal];
        }
    }
}

//传递数据
-(void)loadData{
    self.model = [GTClickerSchemeModel new];
    self.model = [GTRecordWindowManager shareInstance].schemeModel;
    NSMutableArray *copyArray = [NSMutableArray array];
//    for (GTClickerActionModel *actionModel in  [GTRecordWindowManager shareInstance].compareArray) {
//        GTClickerActionModel *copyActionModel = [[GTClickerActionModel alloc] init];
//        copyActionModel.tapCount = actionModel.tapCount;
//        copyActionModel.pressDuration = actionModel.pressDuration;
//        copyActionModel.clickInterval = actionModel.clickInterval;
//        copyActionModel.centerX = actionModel.centerX;
//        copyActionModel.centerY = actionModel.centerY;
//        [copyArray addObject:copyActionModel];
//    }
    self.compareDataArray = [NSMutableArray arrayWithArray:copyArray];
    
    NSMutableArray *copyArray2 = [NSMutableArray array];
    for (GTClickerActionModel *actionModel2 in self.model.actionArray) {
        GTClickerActionModel *copyActionModel2 = [[GTClickerActionModel alloc] init];
        copyActionModel2.tapCount = actionModel2.tapCount;
        copyActionModel2.pressDuration = actionModel2.pressDuration;
        copyActionModel2.clickInterval = actionModel2.clickInterval;
        copyActionModel2.centerX = actionModel2.centerX;
        copyActionModel2.centerY = actionModel2.centerY;
        [copyArray2 addObject:copyActionModel2];
    }
    self.pointDataArray = [NSMutableArray arrayWithArray:copyArray2];
    
    if (![[[GTRecordWindowManager shareInstance].schemeModel modelToJSONString] isEqualToString:[GTRecordWindowManager shareInstance].schemeJsonString]){
        self.change = self.change + 1;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [self.pointSetTableView endEditing:YES];
    [self.touchView endEditing:YES];
    [self.planView.pointSetPlanScrollView endEditing:YES];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.pointDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.0;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    GTClickerPointSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GTClickerPointSetTableViewCellID forIndexPath:indexPath];
    if (!cell) {
        cell = [[GTClickerPointSetTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GTClickerPointSetTableViewCellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.DataArray = self.DataArray;
    cell.row = self.row;
    if(self.isClickerDelete)
    {
        [cell enterDeleteMode];
    }else{
        [cell quitDeleteMode];
    }
    
    [cell updateWithData:self.pointDataArray[indexPath.row] compareArray:self.compareDataArray[indexPath.row]];
    return cell;
}

// 返回一个高度为0的UIView作为头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark - UITableViewDropDelegate & UITableViewDragDelegate
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isClickerDelete) {
        return NO;
    } else {
        return YES;
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *dataArray2 = [NSMutableArray arrayWithCapacity:0];
    dataArray = [self.pointDataArray mutableCopy];
    dataArray2 = [self.compareDataArray mutableCopy];
    // 当结束移动时，判断结束时的位置，把移动的元素删除再加到结束的位置
    if (sourceIndexPath.row < self.pointDataArray.count) {
        GTClickerPointSetTableViewCell * userModel = self.pointDataArray[sourceIndexPath.row];
        GTClickerPointSetTableViewCell * userModel2 = self.compareDataArray[sourceIndexPath.row];
        [dataArray removeObjectAtIndex:sourceIndexPath.row];
        [dataArray2 removeObjectAtIndex:sourceIndexPath.row];
        if (destinationIndexPath.row >= dataArray.count) {
            [dataArray addObject:userModel];
            [dataArray2 addObject:userModel2];
        } else {
            [dataArray insertObject:userModel atIndex:destinationIndexPath.row];
            [dataArray2 insertObject:userModel2 atIndex:destinationIndexPath.row];
        }
    }
    
    self.pointDataArray  = [dataArray mutableCopy];
    self.compareDataArray = [dataArray2 mutableCopy];
    
    NSMutableArray *copyArray = [NSMutableArray array];
    for (GTClickerActionModel *actionModel in self.pointDataArray) {
        GTClickerActionModel *copyActionModel = [[GTClickerActionModel alloc] init];
        copyActionModel.tapCount = actionModel.tapCount;
        copyActionModel.pressDuration = actionModel.pressDuration;
        copyActionModel.clickInterval = actionModel.clickInterval;
        copyActionModel.centerX = actionModel.centerX;
        copyActionModel.centerY = actionModel.centerY;
        [copyArray addObject:copyActionModel];
    }
    [GTRecordWindowManager shareInstance].schemeModel.actionArray = [NSMutableArray arrayWithArray:copyArray];
    
    [self.pointSetTableView reloadData];
    
    NSMutableArray *copyArray2 = [NSMutableArray array];
    for (GTClickerActionModel *actionModel2 in self.compareDataArray) {
        GTClickerActionModel *copyActionModel2 = [[GTClickerActionModel alloc] init];
        copyActionModel2.tapCount = actionModel2.tapCount;
        copyActionModel2.pressDuration = actionModel2.pressDuration;
        copyActionModel2.clickInterval = actionModel2.clickInterval;
        copyActionModel2.centerX = actionModel2.centerX;
        copyActionModel2.centerY = actionModel2.centerY;
        [copyArray2 addObject:copyActionModel2];
    }
   
    [GTRecordWindowManager shareInstance].compareArray = [NSMutableArray arrayWithArray:copyArray2] ;
    
    if (![[[GTRecordWindowManager shareInstance].schemeModel modelToJSONString] isEqualToString:[GTRecordWindowManager shareInstance].schemeJsonString]){
        self.change = self.change + 1;
    }
}

- (nonnull NSArray<UIDragItem *>*)tableView:(UITableView *)tableView itemsForBeginningDragSession:(id<UIDragSession>)session atIndexPath:(NSIndexPath *)indexPath{
    if (!self.isClickerDelete) {
        UIImpactFeedbackGenerator *gen = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleHeavy];
        [gen impactOccurred];
    }
    return  nil;
}

- (BOOL)tableView:(UITableView *)tableView dragSessionIsRestrictedToDraggingApplication:(id<UIDragSession>)session{
    return YES;
}

- (nullable UIDragPreviewParameters *)tableView:(UITableView *)tableView dragPreviewParametersForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIDragPreviewParameters *parameters = [[UIDragPreviewParameters alloc]init];
    CGRect rect = CGRectMake(5, 2, 275 * WIDTH_RATIO , 41);
    parameters.visiblePath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:10 * WIDTH_RATIO];
    parameters.backgroundColor = [GTThemeManager share].colorModel.clicker_pointset_cellSnapshot_color;
    self.snapshot = parameters;
    return self.snapshot;
}

#pragma mark - GTClickerPointSetTableViewCellDelegate
static bool changeOnce;
- (void)textFieldDidChangeInCell:(BOOL)textChange {
    if (![[[GTRecordWindowManager shareInstance].schemeModel modelToJSONString] isEqualToString:[GTRecordWindowManager shareInstance].schemeJsonString]){
        self.saveButton.backgroundColor = [UIColor themeColor];
        [self.saveButton setTitleColor:[UIColor hexColor:@"#FFFFFF"] forState:UIControlStateNormal];
    }else{
        self.saveButton.backgroundColor = [UIColor themeColorWithAlpha:0.4];
        [self.saveButton setTitleColor:[GTThemeManager share].colorModel.clicker_savebutton_color forState:UIControlStateNormal];
    }
}

- (void)deleteButtonClickedInCell:(NSIndexPath *)indexPath {
    if(self.pointDataArray.count == 1){
        [[GTSDKUtils getTopWindow].view makeToast:localString(@"不可删除所有触点") duration:0.5 position:CSToastPositionCenter];
        return;
    }else{
        __block GTDialogView *dialogView;
        dialogView = [[GTDialogView alloc] initWithStyle:DialogViewStyleDefault
                                               title:@"温馨提示"
                                             content:[NSString stringWithFormat: @"确定要删除序号为%ld的触点吗？",(long)indexPath.row+1]
                                     leftButtonTitle:@"取消"
                                    rightButtonTitle:@"删除"
                                     leftButtonBlock:^{
            [[GTDialogWindowManager shareInstance] dialogWindowHide];
        }
                                    rightButtonBlock:^{
            NSLog(@"%ld",indexPath.row);
            [self.pointDataArray removeObjectAtIndex:indexPath.row];
            [self.compareDataArray removeObjectAtIndex:indexPath.row];
            [[GTDialogWindowManager shareInstance] dialogWindowHide];
            //删除此触点model
            [[GTRecordWindowManager shareInstance].schemeModel.actionArray removeObjectAtIndex:indexPath.row];
            [[GTRecordWindowManager shareInstance].compareArray removeObjectAtIndex:indexPath.row];
//            //删除此触点window
//            [[GTRecordWindowManager shareInstance].pointWindowArray removeObjectAtIndex:indexPath.row];
//
//            [[GTRecordWindowManager shareInstance] setUp];
            
            //对比源数据
            if ([[[GTRecordWindowManager shareInstance].schemeModel modelToJSONString] isEqualToString:[GTRecordWindowManager shareInstance].schemeJsonString]){
                [self.saveButton setBackgroundColor:[UIColor themeColorWithAlpha:0.4]];
                [self.saveButton setTitleColor:[UIColor hexColor:@"FFFFFF" withAlpha:0.5] forState:UIControlStateNormal];
            }else {
                [self.saveButton setBackgroundColor:[UIColor themeColor]];
                [self.saveButton setTitleColor:[UIColor hexColor:@"FFFFFF"] forState:UIControlStateNormal];
            }
            [self.pointSetTableView reloadData];

        }];

        [[GTDialogWindowManager shareInstance].dialogVC.view addSubview:dialogView];
        [[GTDialogWindowManager shareInstance] dialogWindowShow];
    }
}

//数据回传更新
- (void)cellDidFinishEditingWithData:(GTClickerActionModel *)data indexPath:(NSIndexPath *)indexPath {
    [self.pointDataArray replaceObjectAtIndex:indexPath.row withObject:data];
    
    NSMutableArray *copyArray2 = [NSMutableArray array];
    for (GTClickerActionModel *actionModel2 in self.pointDataArray) {
        GTClickerActionModel *copyActionModel2 = [[GTClickerActionModel alloc] init];
        copyActionModel2.tapCount = actionModel2.tapCount;
        copyActionModel2.pressDuration = actionModel2.pressDuration;
        copyActionModel2.clickInterval = actionModel2.clickInterval;
        copyActionModel2.centerX = actionModel2.centerX;
        copyActionModel2.centerY = actionModel2.centerY;
        [copyArray2 addObject:copyActionModel2];
    }
    [GTRecordWindowManager shareInstance].schemeModel.actionArray = [NSMutableArray arrayWithArray:copyArray2];
    
}

#pragma mark -response
//删除的入场动画
-(void)deleteClicker:(id)sender{
    self.isClickerDelete = YES;
    [self.view addSubview:self.whiteBackground];
    [self.whiteBackground mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.touchView.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    [self.whiteBackground addSubview:self.deletePointLabel];
    [self.deletePointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.whiteBackground.mas_top).offset(15);
        make.centerX.equalTo(self.whiteBackground.mas_centerX);
        make.width.equalTo(@(190));
        make.height.equalTo(@(21));
    }];
    
    [self.whiteBackground addSubview:self.cancelPointButton];
    [self.cancelPointButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.whiteBackground.mas_top).offset(16);
        make.left.equalTo(self.whiteBackground.mas_left).offset(20);
        make.width.height.equalTo(@(20));
    }];
    [self.view layoutIfNeeded];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.quitButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).offset(55*WIDTH_RATIO); // 向下滑出界面
        }];
        [self.saveButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).offset(55*WIDTH_RATIO);
        }];
        self.touchView.frame = CGRectMake(0, 0, floatingWindow_width * WIDTH_RATIO, 250 * WIDTH_RATIO);
        [self.view layoutIfNeeded];
    }];
    
    [self.pointSetTableView reloadData];

}

//复原
-(void)cancelPointClick:(id)sender{
    self.isClickerDelete = NO;
    [self.whiteBackground removeFromSuperview];
    [self.view layoutIfNeeded];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.quitButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).offset(-20*WIDTH_RATIO);// 使按钮返回到初始位置
        }];
        [self.saveButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).offset(-20*WIDTH_RATIO);
        }];
        self.touchView.frame = CGRectMake(0, 0, floatingWindow_width * WIDTH_RATIO, 198 * WIDTH_RATIO);
        [self.view layoutIfNeeded];
        [self.pointSetTableView reloadData];
    }];

}


-(void)quitClick:(id)sender{
    if ([self.saveButton.backgroundColor isEqual:[UIColor themeColor]]) {
        __block GTDialogView *dialogView;
        dialogView = [[GTDialogView alloc] initWithStyle:DialogViewStyleDefault
                                                   title:@"温馨提示"
                                                 content:@"当前方案未保存，是否确定退出？"
                                         leftButtonTitle:@"取消"
                                        rightButtonTitle:@"退出"
                                         leftButtonBlock:^{
            [[GTDialogWindowManager shareInstance] dialogWindowHide];
        }
                                        rightButtonBlock:^{
            [[GTRecordWindowManager shareInstance] recordWindowHide];
            [GTRecordWindowManager shareInstance].isAllPointShow = NO;
            [GTRecordWindowManager shareInstance].schemeModel = nil;
            [GTRecordWindowManager shareInstance].lastClickJsonString = @"";
            [self.navigationController popViewControllerAnimated:NO];
            changeOnce = NO;
            [[GTDialogWindowManager shareInstance] dialogWindowHide];
        }];
        [GTDialogWindowManager shareInstance].dialogWindow.windowLevel = 30010;
        [[GTDialogWindowManager shareInstance].dialogVC.view addSubview:dialogView];
        [[GTDialogWindowManager shareInstance] dialogWindowShow];
        [[GTRecordView recordView] remove];
        
        //连点器启动时长埋点（结束计时）
        //神策开始计时
        [[GTDataTimeCounter sharedInstance] end:GTSensorEventAutoClickerStartDuration];
        //cp开始计时
//        [SMDurationEventReport finishReport:GTSensorEventAutoClickerStartDuration];
    }else{
        [[GTRecordWindowManager shareInstance] recordWindowHide];
        [GTRecordWindowManager shareInstance].schemeModel = nil;
        [GTRecordWindowManager shareInstance].isAllPointShow = NO;
        [GTRecordWindowManager shareInstance].lastClickJsonString = @"";
        [self.navigationController popViewControllerAnimated:NO];
        [[GTRecordView recordView] remove];
        
        //连点器启动时长埋点（结束计时）
        //神策开始计时
        [[GTDataTimeCounter sharedInstance] end:GTSensorEventAutoClickerStartDuration];
        //cp开始计时
//        [SMDurationEventReport finishReport:GTSensorEventAutoClickerStartDuration];
    }
    
    if ([[GTRecordWindowManager shareInstance].schemeJsonString isEqualToString:@""]) {
        //工具箱元素点击埋点
        [[GTDataConfig sharedInstance] uploadSensorDataWithEvent:GTSensorEventToolBoxElementClick andProperties:@{@"tool_name" : @"连点器", @"plan_id" : [NSNumber numberWithInt:0],  @"toolbox_click_type" : [NSNumber numberWithInt:7]} shouldFlush:YES];
    }else {
        //工具箱元素点击埋点
        [[GTDataConfig sharedInstance] uploadSensorDataWithEvent:GTSensorEventToolBoxElementClick andProperties:@{@"tool_name" : @"连点器", @"plan_id" : [NSNumber numberWithInt:-3],  @"toolbox_click_type" : [NSNumber numberWithInt:7]} shouldFlush:YES];
    }
    
    
}

-(void)saveClick:(id)sender{
    if ([[GTRecordWindowManager shareInstance].schemeJsonString isEqualToString:@""]) {
        //工具箱元素点击埋点
        [[GTDataConfig sharedInstance] uploadSensorDataWithEvent:GTSensorEventToolBoxElementClick andProperties:@{@"tool_name" : @"连点器", @"plan_id" : [NSNumber numberWithInt:0],  @"toolbox_click_type" : [NSNumber numberWithInt:8]} shouldFlush:YES];
    }else {
        //工具箱元素点击埋点
        [[GTDataConfig sharedInstance] uploadSensorDataWithEvent:GTSensorEventToolBoxElementClick andProperties:@{@"tool_name" : @"连点器", @"plan_id" : [NSNumber numberWithInt:-3],  @"toolbox_click_type" : [NSNumber numberWithInt:8]} shouldFlush:YES];
    }
    
    if ([self.saveButton.backgroundColor isEqual:[UIColor themeColor]]) {
       if(self.planView.planNameTextField.text.length == 0){
            [[GTSDKUtils getTopWindow].view makeToast:localString(@"名称不能为空") duration:0.5 position:CSToastPositionCenter];
        }else if(self.planView.loopNumberTextField.text.length == 0 && self.planView.fincycleIndex == 1 ){
            [[GTSDKUtils getTopWindow].view makeToast:localString(@"有限循环次数不能为空") duration:0.5 position:CSToastPositionCenter];
        }else{
            __block GTDialogView *dialogView;
            
            dialogView = [[GTDialogView alloc] initWithStyle:DialogViewStyleDefault
                                                       title:@"温馨提示"
                                                     content:@"确定要保存当前方案吗？"
                                             leftButtonTitle:@"取消"
                                            rightButtonTitle:@"保存"
                                             leftButtonBlock:^{
                [[GTDialogWindowManager shareInstance] dialogWindowHide];
            }
                                            rightButtonBlock:^{
               
                //保存
                //启用方案保存
                if(self.DataArray.count > self.row){
                    NSMutableArray<GTClickerSchemeModel *> *dataArray = self.DataArray;
                    [dataArray replaceObjectAtIndex:self.row withObject:[GTRecordWindowManager shareInstance].schemeModel];
                    self.DataArray = dataArray;
                    [NSData saveSchemeList:self.DataArray];
                    [GTRecordWindowManager shareInstance].schemeJsonString = [[GTRecordWindowManager shareInstance].schemeModel modelToJSONString];
                    
                    self.planView.startTimeCompare = self.planView.startTime;
                    self.planView.oldSelected = self.planView.selectedButtonIndex;
                    self.planView.cycleIndex = [GTRecordWindowManager shareInstance].schemeModel.cycleIndex;
                    self.planView.cycleInterval = [GTRecordWindowManager shareInstance].schemeModel.cycleInterval;
                }else{
                    //创建
                    NSMutableArray<GTClickerSchemeModel *> *dataArray = self.DataArray;
                    if(!dataArray){
                        dataArray = [NSMutableArray array];
                    }
                    [dataArray addObject:[GTRecordWindowManager shareInstance].schemeModel];
                    self.DataArray = dataArray;
                    [NSData saveSchemeList:self.DataArray];
                    [GTRecordWindowManager shareInstance].schemeJsonString = [[GTRecordWindowManager shareInstance].schemeModel modelToJSONString];
                    
                    self.planView.startTimeCompare = self.planView.startTime;
                    self.planView.oldSelected = self.planView.selectedButtonIndex;
                    self.planView.cycleIndex = [GTRecordWindowManager shareInstance].schemeModel.cycleIndex;
                    self.planView.cycleInterval = [GTRecordWindowManager shareInstance].schemeModel.cycleInterval;
                }
                
                self.change = 0;
                changeOnce = NO;
                [self.saveButton setBackgroundColor:[UIColor themeColorWithAlpha:0.4]];
                [self.saveButton setTitleColor:[UIColor hexColor:@"FFFFFF" withAlpha:0.5] forState:UIControlStateNormal];
                
                NSMutableArray *copyArray = [NSMutableArray array];
                for (GTClickerActionModel *actionModel in [GTRecordWindowManager shareInstance].schemeModel.actionArray) {
                    GTClickerActionModel *copyActionModel = [[GTClickerActionModel alloc] init];
                    copyActionModel.tapCount = actionModel.tapCount;
                    copyActionModel.pressDuration = actionModel.pressDuration;
                    copyActionModel.clickInterval = actionModel.clickInterval;
                    copyActionModel.centerX = actionModel.centerX;
                    copyActionModel.centerY = actionModel.centerY;
                    [copyArray addObject:copyActionModel];
                }
                self.compareDataArray = [NSMutableArray arrayWithArray:copyArray];
                [GTRecordWindowManager shareInstance].compareArray = [copyArray mutableCopy];
                [self.pointSetTableView reloadData];
                [[GTDialogWindowManager shareInstance] dialogWindowHide];
            }];
            [GTDialogWindowManager shareInstance].dialogWindow.windowLevel = 30100;
            [[GTDialogWindowManager shareInstance].dialogVC.view addSubview:dialogView];
            [[GTDialogWindowManager shareInstance] dialogWindowShow];
        }
    }
}


#pragma mark -setter & getter

- (GTClickerWindowStartView *)clickerWindowStartView {
    if (!_clickerWindowStartView) {
        _clickerWindowStartView = [[GTClickerWindowStartView alloc] initWithFrame:CGRectZero];
        _clickerWindowStartView.hidden = YES;
        [self.view bringSubviewToFront:_clickerWindowStartView];
    }
    return _clickerWindowStartView;
}

- (UITableView *)pointSetTableView {
    if (!_pointSetTableView) {
        _pointSetTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _pointSetTableView.backgroundColor = [GTThemeManager share].colorModel.clicker_pointSetView_bg_color;
        _pointSetTableView.delegate = self;
        _pointSetTableView.dataSource = self;
        _pointSetTableView.dragDelegate = self;
        _pointSetTableView.dropDelegate = self;
        _pointSetTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _pointSetTableView.contentInset = UIEdgeInsetsZero;
        [_pointSetTableView registerClass:[GTClickerPointSetTableViewCell class] forCellReuseIdentifier:GTClickerPointSetTableViewCellID];
        _pointSetTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    }
    return _pointSetTableView;
}

-(UIButton *)deleteButton{
    if(!_deleteButton){
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:[[GTThemeManager share] imageWithName:@"clicker_pointset_delete"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteClicker:) forControlEvents:UIControlEventTouchUpInside];
        [_deleteButton setEnlargeEdgeWithTop:8 right:8 bottom:8 left:8];
    }
    return  _deleteButton;
}

-(UIButton *)setButton{
    if(!_setButton){
        _setButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_setButton setImage:[[GTThemeManager share] imageWithName:@"clicker_set_icon"] forState:UIControlStateNormal];
        [_setButton addTarget:self action:@selector(setClicker:) forControlEvents:UIControlEventTouchUpInside];
        [_setButton setEnlargeEdgeWithTop:8 right:8 bottom:8 left:8];
    }
    return  _setButton;
}

-(UIButton *)touchButton{
    if(!_touchButton){
        _touchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_touchButton setTitle:@"触点" forState:UIControlStateNormal];
        [_touchButton setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
        _touchButton.titleLabel.font = [UIFont systemFontOfSize:15*WIDTH_RATIO];
        [_touchButton addTarget:self action:@selector(showTouchView) forControlEvents:UIControlEventTouchUpInside];

    }
    return  _touchButton;
}

-(UIButton *)planButton{
    if(!_planButton){
        _planButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_planButton setTitle:@"方案" forState:UIControlStateNormal];
        [_planButton setTitleColor:[GTThemeManager share].colorModel.clicker_text_color forState:UIControlStateNormal];
        _planButton.titleLabel.font = [UIFont systemFontOfSize:15*WIDTH_RATIO];
        [_planButton addTarget:self action:@selector(showPlanView) forControlEvents:UIControlEventTouchUpInside];
    }
    return  _planButton;
}

-(GTBaseView *)touchView{
    if(!_touchView){
        _touchView = [GTBaseView new];
        _touchView.backgroundColor = [GTThemeManager share].colorModel.bgColor;
    }
    return _touchView;
}


-(UIView *)lineView{
    if(!_lineView){
        _lineView = [UIView new];
        _lineView.backgroundColor = [GTThemeManager share].colorModel.gtswitch_is_on_bg_color;
        _lineView.layer.cornerRadius = 1.7 * WIDTH_RATIO;
        _lineView.layer.masksToBounds = YES;
    }
    return _lineView;
}

- (UIButton *)quitButton {
    if (!_quitButton) {
        _quitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _quitButton.layer.cornerRadius = 12*WIDTH_RATIO;
        _quitButton.layer.masksToBounds = YES;
        [_quitButton setBackgroundColor:[GTThemeManager share].colorModel.clicker_pointSetquitbutton_color];
        [_quitButton setTitle:localString(@"退出方案") forState:UIControlStateNormal];
        [_quitButton setTitleColor:[GTThemeManager share].colorModel.clicker_savebutton_text_color forState:UIControlStateNormal];
        _quitButton.titleLabel.font = [UIFont systemFontOfSize:14*WIDTH_RATIO];
        [_quitButton addTarget:self action:@selector(quitClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _quitButton;
}

- (UIButton *)saveButton {
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveButton.layer.cornerRadius = 12*WIDTH_RATIO;
        _saveButton.layer.masksToBounds = YES;
        if(self.row>self.DataArray.count){
            [_saveButton setBackgroundColor:[UIColor themeColor]];
            [_saveButton setTitleColor:[UIColor hexColor:@"FFFFFF"] forState:UIControlStateNormal];
            self.change = self.change + 1;
        }else{
            [_saveButton setBackgroundColor:[UIColor themeColorWithAlpha:0.4]];
            [_saveButton setTitleColor:[UIColor hexColor:@"FFFFFF" withAlpha:0.5] forState:UIControlStateNormal];
        }
        
        [_saveButton setTitle:localString(@"保存方案") forState:UIControlStateNormal];
        _saveButton.titleLabel.font = [UIFont systemFontOfSize:14*WIDTH_RATIO];
        [_saveButton addTarget:self action:@selector(saveClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}

- (UILabel *)tapCount {
    if (!_tapCount) {
        _tapCount = [UILabel new];
        _tapCount.text = localString(@"点击次数");
        _tapCount.textAlignment = NSTextAlignmentCenter;
        _tapCount.textColor = [GTThemeManager share].colorModel.clicker_text_color;
        _tapCount.font = [UIFont systemFontOfSize:12*WIDTH_RATIO];
    }
    return _tapCount;
}

- (UILabel *)pressDuration {
    if (!_pressDuration) {
        _pressDuration = [UILabel new];
        _pressDuration.text = localString(@"按压时长");
        _pressDuration.textAlignment = NSTextAlignmentCenter;
        _pressDuration.textColor = [GTThemeManager share].colorModel.clicker_text_color;
        _pressDuration.font = [UIFont systemFontOfSize:12*WIDTH_RATIO];
    }
    return _pressDuration;
}

- (UILabel *)clickInterval {
    if (!_clickInterval) {
        _clickInterval = [UILabel new];
        _clickInterval.text = localString(@"点击间隔");
        _clickInterval.textAlignment = NSTextAlignmentCenter;
        _clickInterval.textColor = [GTThemeManager share].colorModel.clicker_text_color;
        _clickInterval.font = [UIFont systemFontOfSize:12*WIDTH_RATIO];
    }
    return _clickInterval;
}

-(UIView *)whiteBackground{
    if(!_whiteBackground){
        _whiteBackground = [UIView new];
        _whiteBackground.backgroundColor = [GTThemeManager share].colorModel.bgColor;
    }
    return _whiteBackground;
}

- (UILabel *)deletePointLabel {
    if (!_deletePointLabel) {
        _deletePointLabel = [UILabel new];
        _deletePointLabel.text = localString(@"删除触点");
        _deletePointLabel.textAlignment = NSTextAlignmentCenter;
        _deletePointLabel.textColor = [GTThemeManager share].colorModel.clicker_title_color;
        _deletePointLabel.font = [UIFont systemFontOfSize:15*WIDTH_RATIO];
    }
    return _deletePointLabel;
}

- (UIButton *)cancelPointButton {
    if (!_cancelPointButton) {
        _cancelPointButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelPointButton setImage:[[GTThemeManager share] imageWithName:@"icon_close_hide_float_ball_window"] forState:UIControlStateNormal];
        [_cancelPointButton addTarget:self action:@selector(cancelPointClick:) forControlEvents:UIControlEventTouchUpInside];
        [_cancelPointButton setEnlargeEdgeWithTop:8 right:8 bottom:8 left:8];
    }
    return _cancelPointButton;
}
- (UIScrollView *)scrollView{
    if(!_scrollView){
        _scrollView = [UIScrollView new];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(floatingWindow_width * WIDTH_RATIO * 2,0);
        _scrollView.scrollEnabled = NO;
    }
    return _scrollView;
}

@end
