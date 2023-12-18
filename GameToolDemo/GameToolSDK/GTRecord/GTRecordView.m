//
//  GTRecordView.m
//  GTSDK
//
//  Created by smwl on 2023/10/17.
//

#import "GTRecordView.h"
#import <CoreFoundation/CFRunLoop.h>
#import <LinkerPlugin/LinkerSDKConfig.h>


@interface GTRecordView()

@property(nonatomic,strong)UITapGestureRecognizer *tapGesture;

@property(nonatomic,strong)UILongPressGestureRecognizer *longPressGesture;

@property(nonatomic,strong)UIPanGestureRecognizer *panGesture;

@end

static GTRecordView *recordView = nil;

@implementation GTRecordView

#pragma mark--初始化和UI设置
-(instancetype)initWithFrame:(CGRect)frame{
    if(self=[super initWithFrame:frame]){
        [self setUI];
        [self.longPressGesture requireGestureRecognizerToFail:self.tapGesture];
        [self.panGesture requireGestureRecognizerToFail:self.longPressGesture];
        self.recordViewMode = RecordViewModeNone;//默认录制模式
    }
    return self;
}

-(void)setUI{
    
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
    
}

#pragma mar--public method
+(instancetype)recordView{
    if(!recordView){
        recordView = [[self alloc] initWithFrame:CGRectZero];
//        recordView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        recordView.backgroundColor = [UIColor  clearColor];
       
    }
    return recordView;
}

-(void)remove{
    [[SMRecordSDK shareSDK] finishScheme];
    [SMRecordSDK shareSDK].delegate = nil;
    [self removeFromSuperview];
    recordView = nil;
}


#pragma mark--getter/setter

-(NSMutableArray<GTLineDrawer *> *)lineDrawers{
    if(!_lineDrawers){
        _lineDrawers = [NSMutableArray array];
    }
    return _lineDrawers;
}

-(UIButton *)buttonWithTitle:(NSString *)title action:(SEL)action{
    UIButton *button = [[UIButton alloc]init];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:[UIColor whiteColor]];
    button.layer.cornerRadius = 15.0;
    button.clipsToBounds = YES;
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [button setTitle:title forState:UIControlStateNormal];
    [self addSubview:button];
    return button;
}
-(void)setRecordViewMode:(RecordViewMode)recordViewMode{
    _recordViewMode = recordViewMode;
    BOOL gestureEnable = recordViewMode == RecordViewModeRecord;
    self.tapGesture.enabled = gestureEnable;
    self.longPressGesture.enabled = gestureEnable;
    self.panGesture.enabled = gestureEnable;
}


-(UIPanGestureRecognizer *)panGesture{
    if(!_panGesture){
        //panGesture: 在GTRecordView+GTRecord.h
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
        _panGesture = panGesture;
        [self addGestureRecognizer:panGesture];
    }
    return _panGesture;
}
-(UITapGestureRecognizer *)tapGesture{
    if(!_tapGesture){
        //tapGesture: 在GTRecordView+GTRecord.h
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        tapGesture.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapGesture];
        _tapGesture = tapGesture;
    }
    return _tapGesture;
}
-(UILongPressGestureRecognizer *)longPressGesture{
    if(!_longPressGesture){
        //longPressGesture: 在GTRecordView+GTRecord.h
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
        longPressGesture.numberOfTouchesRequired = 1;
        longPressGesture.minimumPressDuration = 1;
        longPressGesture.allowableMovement = 10;
        [self addGestureRecognizer:longPressGesture];
        _longPressGesture = longPressGesture;
    }
    
    return _longPressGesture;
}


/// 读取触点显示模式
-(ClickerWindowPointShowType)loadPointShowType{
    BOOL revealSwitchState = [[NSUserDefaults standardUserDefaults] boolForKey:@"revealSwitchState"];
    BOOL reveal = [[NSUserDefaults standardUserDefaults] boolForKey:@"reveal"];
    if(!revealSwitchState&&reveal){
        return ClickerWindowPointShowNo;
    }
    NSInteger pointOpera = [[NSUserDefaults standardUserDefaults] integerForKey:@"pointOpera"];
    if(pointOpera==1){
        return ClickerWindowPointShowAll;
    }
    return ClickerWindowPointShowExecute;//pointOpera==0
}
-(void)dealloc{
    LOGDealloc()
}

@end
