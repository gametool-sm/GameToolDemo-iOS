//
//  GTClickerMainViewController.m
//  GTSDK
//
//  Created by shangmi on 2023/8/13.
//

#import "GTClickerMainViewController.h"
#import "GTClickerMainTableViewCell.h"
#import "UITableView+Custom.h"
#import "GTClickercreateViewController.h"
#import "GTClickerSetViewController.h"
#import "GTClickerPointSetViewController.h"
#import "GTClickerWindowManager.h"
#import "GTClickerSchemeModel.h"
#import "NSData+Custom.h"
#import "GTClickerManager.h"
#import "GTUnauthorizedCoverView.h"
#import "GTRecordSetViewController.h"
#import "GTRecordWindowManager.h"
#import "GTRecordSchemeSetController.h"
#import "SMEventSensor.h"
static NSString *const GTClickerMainTableViewCellID = @"GTClickerMainTableViewCellID";

@interface GTClickerMainViewController () <UITableViewDelegate, UITableViewDataSource,GTClickerMainTableViewCellDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *rightButton;

//数据源
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *dataArray2;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *createSchemeButton;

//连点器设置与创建方案
@property (nonatomic, strong) GTClickercreateViewController *createViewController;
@property (nonatomic, strong) GTClickerSetViewController *setViewController;

//屏幕第一行cell
@property (nonatomic, assign) NSInteger firstPath;
@property (nonatomic, assign) NSInteger finalPath;

//选取了第几行
@property (nonatomic, assign) NSInteger row;
@end

@implementation GTClickerMainViewController

- (void)changeTheme:(NSNotification *)noti {
    [super changeTheme:noti];

    self.titleLabel.textColor = [GTThemeManager share].colorModel.clicker_title_color;
    [self.rightButton setImage:[[GTThemeManager share] imageWithName:@"clicker_set_icon"] forState:UIControlStateNormal];
    self.tableView.backgroundColor = [GTThemeManager share].colorModel.bgColor;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}

- (void)setUp {
    self.view.backgroundColor = [GTThemeManager share].colorModel.bgColor;
    
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.rightButton];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.createSchemeButton];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(16 * WIDTH_RATIO);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(190 * WIDTH_RATIO);
        make.height.mas_equalTo(20 * WIDTH_RATIO);
        
        make.top.equalTo(self.view.mas_top).offset(16 * WIDTH_RATIO);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(190 * WIDTH_RATIO);
        make.height.mas_equalTo(20 * WIDTH_RATIO);
    }];
    
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-20 * WIDTH_RATIO);
        make.width.mas_equalTo(20 * WIDTH_RATIO);
        make.height.mas_equalTo(20 * WIDTH_RATIO);
    }];
    
    [self.createSchemeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(248 * WIDTH_RATIO);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(200 * WIDTH_RATIO);
        make.height.mas_equalTo(42 * WIDTH_RATIO);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(12 * WIDTH_RATIO);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(270 * WIDTH_RATIO);
        make.bottom.equalTo(self.createSchemeButton.mas_top).offset(-12 * WIDTH_RATIO);
    }];
    
    if (![GTSDKConfig getIsSpeedUpFeature]) {
        GTUnauthorizedCoverView *coverView = [GTUnauthorizedCoverView new];
        [self.view addSubview:coverView];
        [self.view bringSubviewToFront:coverView];
        
        [coverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.equalTo(self.view);
        }];
    }
}

//获取方案列表，并根据是否有方案判断显示内容
- (void)loadData {
    [self.dataArray removeAllObjects];
    NSArray *array = [NSData getSchemeList][@"data"];
    for (NSDictionary *dict in array) {
        GTClickerSchemeModel *model = [GTClickerSchemeModel modelWithDictionary:dict];
        //存储连点触点
        NSMutableArray <GTClickerActionModel *>* arr = [NSMutableArray array];
        //存储录制
        NSMutableArray *recordArr = [NSMutableArray array];
        
//        for (NSDictionary *actionDict in model.actionArray) {
            for (GTClickerActionModel *actionModel in model.actionArray) {
//            GTClickerActionModel *actionModel = [GTClickerActionModel new];
//            actionModel.tapCount = [actionDict[@"tap_count"] intValue];
//            actionModel.pressDuration = [actionDict[@"press_duration"] intValue];
//            actionModel.clickInterval = [actionDict[@"click_interval"] intValue];
//            actionModel.centerX = [actionDict[@"center_x"] floatValue];
//            actionModel.centerY = [actionDict[@"center_y"] floatValue];
//            actionModel.timestamp = [actionDict[@"timestamp"] floatValue];
//            [arr addObject:actionModel];
            [arr addObject:actionModel];
        }
        
//        for (NSArray *recordArray in model.recordLines) {
//            //存储一条轨迹
//            NSMutableArray *lineArr = [NSMutableArray array];
//            for (NSDictionary *recordDict in recordArray) {
//                GTClickerActionModel *actionModel = [GTClickerActionModel new];
//                actionModel.tapCount = [recordDict[@"tap_count"] intValue];
//                actionModel.pressDuration = [recordDict[@"press_duration"] intValue];
//                actionModel.clickInterval = [recordDict[@"click_interval"] intValue];
//                actionModel.centerX = [recordDict[@"center_x"] floatValue];
//                actionModel.centerY = [recordDict[@"center_y"] floatValue];
//                actionModel.timestamp = [recordDict[@"timestamp"] floatValue];
//                [lineArr addObject:actionModel];
//            }
//
//            [recordArr addObject:lineArr];
//        }
        
        model.actionArray = arr;
//        model.recordLines = recordArr;
        [self.dataArray addObject:model];
    }
    if (self.dataArray.count == 0) {
        [self.tableView showEmptyView];
    }else {
        self.tableView.backgroundView = nil;
        [self.tableView reloadData];
    }
}

#pragma mark - response
- (void)setClick {
    self.setViewController = [GTClickerSetViewController new];
    [self.navigationController pushViewController:self.setViewController animated:NO];
}

- (void)createSchemeClick {
    self.createViewController = [GTClickercreateViewController new];
    [self.navigationController pushViewController:self.createViewController animated:NO];
    self.createViewController.DataArray = self.dataArray;
}


#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    GTClickerMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GTClickerMainTableViewCellID forIndexPath:indexPath];
    GTClickerSchemeModel *schemeModel = self.dataArray[indexPath.row];
    [cell updateWithData:schemeModel];
    //获取行号
    cell.celldelegate = self;
    cell.tag = indexPath.row;
    cell.indexPath = indexPath;
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger firstVisibleRowIndex = [[tableView indexPathsForVisibleRows].firstObject row];
    self.firstPath = firstVisibleRowIndex;
    UIView *view = [GTSDKUtils getTopWindow].view;
    CGRect rectInTableView = [tableView rectForRowAtIndexPath:indexPath];
    CGRect rectInSuperview = [tableView convertRect:rectInTableView toView:view];
    rectInSuperview.size.height  += 15;
    CGRect Rect = [self.createSchemeButton convertRect:self.createSchemeButton.bounds toView:view];
    if (CGRectIntersectsRect(rectInSuperview, Rect)) {
        self.finalPath = indexPath.row;
    }else{
        self.finalPath = 0;
    }
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

//获取行号，创建视图。
#pragma mark - GTClickerMainTableViewCellDelegate
- (void)moreButtonClickedForRow:(NSIndexPath *)indexPath cell:(nonnull GTClickerMainTableViewCell *)cell{
    if (indexPath != nil) {
        [self.tableView.delegate tableView:self.tableView didSelectRowAtIndexPath:indexPath];
        cell.firstPath = self.firstPath;
        cell.finalPath = self.finalPath;
    }
}


- (void)enableButtonClickedForRow:(NSInteger)row {
    self.row = row ;
    GTClickerSchemeModel *model = self.dataArray[self.row];
    if (model.type == 0) { //录制
        [GTRecordWindowManager shareInstance].schemeModel = model;
        [GTRecordWindowManager shareInstance].schemeJsonString = [model modelToJSONString];
        NSMutableArray *copyArray = [NSMutableArray array];
        for (GTClickerActionModel *actionModel in [GTClickerWindowManager shareInstance].schemeModel.actionArray) {
            GTClickerActionModel *copyActionModel = [[GTClickerActionModel alloc] init];
            copyActionModel.tapCount = actionModel.tapCount;
            copyActionModel.pressDuration = actionModel.pressDuration;
            copyActionModel.clickInterval = actionModel.clickInterval;
            copyActionModel.centerX = actionModel.centerX;
            copyActionModel.centerY = actionModel.centerY;
            [copyArray addObject:copyActionModel];
        }
        [GTClickerWindowManager shareInstance].compareArray = [NSMutableArray arrayWithArray:copyArray];
        [GTClickerWindowManager shareInstance].schemeJsonString = [self.dataArray[self.row] modelToJSONString];
        
        //连点器启动时长埋点（开始计时）
        //神策开始计时
        GTSensorEventAutoClickerStartDurationID = [[GTDataTimeCounter sharedInstance] start:GTSensorEventAutoClickerStartDuration externParam:@{@"kEventName" : @"AutoClickerStartDuration", @"kProperties" : @{@"plan_id" : [NSNumber numberWithInt:-3]}}];
        //cp开始计时
//        [SMDurationEventReport startReport:ToolTypeClicker eventName:GTSensorEventAutoClickerStartDuration params:@{}];
        
//        GTRecordSetViewController *recordSetViewController = [GTRecordSetViewController new];
        GTRecordSchemeSetController *recordSetViewController = [GTRecordSchemeSetController new];
        recordSetViewController.DataArray = self.dataArray;
        recordSetViewController.row = self.row;
        [self.navigationController pushViewController:recordSetViewController animated:NO];
    }else { //连点
        [GTClickerWindowManager shareInstance].schemeModel = model;
        
        NSMutableArray *copyArray = [NSMutableArray array];
        for (GTClickerActionModel *actionModel in [GTClickerWindowManager shareInstance].schemeModel.actionArray) {
            GTClickerActionModel *copyActionModel = [[GTClickerActionModel alloc] init];
            copyActionModel.tapCount = actionModel.tapCount;
            copyActionModel.pressDuration = actionModel.pressDuration;
            copyActionModel.clickInterval = actionModel.clickInterval;
            copyActionModel.centerX = actionModel.centerX;
            copyActionModel.centerY = actionModel.centerY;
            [copyArray addObject:copyActionModel];
        }
        [GTClickerWindowManager shareInstance].compareArray = [NSMutableArray arrayWithArray:copyArray];
        [GTClickerWindowManager shareInstance].schemeJsonString = [self.dataArray[self.row] modelToJSONString];
        
        //从启用进入连点器悬浮窗，如果是不显示状态，则触点都不显示，其余状态显示.
        //新创建方案，不管pointShowType是什么状态，触点都显示
        if ([GTClickerWindowManager shareInstance].pointSetModel.pointShowType == ClickerWindowPointShowNo) {
            [GTClickerWindowManager shareInstance].isAllPointShow = NO;
        }else {
            [GTClickerWindowManager shareInstance].isAllPointShow = YES;
        }
        
        GTClickerPointSetViewController *pointSetViewController = [GTClickerPointSetViewController new];
        [self.navigationController pushViewController:pointSetViewController animated:NO];
        pointSetViewController.row = self.row;
        pointSetViewController.DataArray = self.dataArray;
        int plan_id = [[GTClickerManager shareInstance] getPlanId];
        [SMEventSensor startReport:ToolTypeClicker event:AutoClickerStartDurationEvent params:@{
            @"plan_id":@(plan_id)
        }];
        
    }
}

- (void)cellDidFinishEditingWithModel:(GTClickerSchemeModel *)data indexPath:(nonnull NSIndexPath *)indexPath{
    self.dataArray[indexPath.row] = data;
    [self.tableView reloadData];
    [NSData saveSchemeList:self.dataArray];
    
}

- (void)deleteButtonClickedInCell:(GTClickerMainTableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.dataArray removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
    [NSData saveSchemeList:self.dataArray];

    [[GTSDKUtils getTopWindow].view makeToast:localString(@"方案已删除") duration:0.5 position:CSToastPositionCenter];
    if (self.dataArray.count == 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.tableView showEmptyView];
        });
    }
}
#pragma mark - setter & getter

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.text = localString(@"连点器");
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [GTThemeManager share].colorModel.clicker_title_color;
        _titleLabel.font = [UIFont systemFontOfSize:15*WIDTH_RATIO];
    }
    return _titleLabel;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setImage:[[GTThemeManager share] imageWithName:@"clicker_set_icon"] forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(setClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [GTThemeManager share].colorModel.bgColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[GTClickerMainTableViewCell class] forCellReuseIdentifier:GTClickerMainTableViewCellID];
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
        if (@available(iOS 13.0, *)) {
            _tableView.automaticallyAdjustsScrollIndicatorInsets = NO;
            
        } else {
            // Fallback on earlier versions
        }
    }
    return _tableView;
}

- (UIButton *)createSchemeButton {
    if (!_createSchemeButton) {
        _createSchemeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _createSchemeButton.layer.cornerRadius = 12*WIDTH_RATIO;
        _createSchemeButton.layer.masksToBounds = YES;
        [_createSchemeButton setBackgroundColor:[UIColor themeColor]];
        
        [_createSchemeButton setTitle:localString(@"创建方案") forState:UIControlStateNormal];
        _createSchemeButton.titleLabel.font = [UIFont systemFontOfSize:13*WIDTH_RATIO];
        
        [_createSchemeButton setImage:[[GTThemeManager share] imageWithName:@"Light/clicker_number_add_icon"] forState:UIControlStateNormal];
        
        CGFloat spacing = 2.0;
       _createSchemeButton.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
       _createSchemeButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing);
        _createSchemeButton.adjustsImageWhenHighlighted = false;
        [_createSchemeButton addTarget:self action:@selector(createSchemeClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _createSchemeButton;
}



@end
