//
//  ViewController.m
//  GameToolDemo
//
//  Created by smwl on 2023/12/1.
//

#import "ViewController.h"

#import <GameToolSDK/GameToolSDK.h>
static NSString *GTSDKStyleKey = @"GTSDKStyleKey";
//static NSString *appKey = @"Your appKey";

//static NSString *appKey = @"f975a83744de431cdc300dabff7b8179";
static NSString *appKey = @"686cdc96abd2249024df34af729dbbcd";

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *appKeyTextField;
@property (weak, nonatomic) IBOutlet UITextField *userIdTextField;
@property (weak, nonatomic) IBOutlet UIButton *sdkInitTypeButton;
@property (strong, nonatomic) IBOutlet UIButton *showFloatingWindowButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    BOOL openDebug = YES;
    GTSDKStyles style = [[NSUserDefaults standardUserDefaults] integerForKey:GTSDKStyleKey];
//    [self initSDK:appKey style:style openDebug:openDebug];
    [self setUIWithStyle:style];
    
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        BOOL openDebug = YES;
        GTSDKStyles style = [[NSUserDefaults standardUserDefaults] integerForKey:GTSDKStyleKey];
        [self initSDK:appKey style:style openDebug:openDebug];
    });

}
-(void)setUIWithStyle:(GTSDKStyles)style{
    [self addLeftPadding:self.appKeyTextField];
    [self addLeftPadding:self.userIdTextField];
    NSString *styleStr = @"自定义";
    self.showFloatingWindowButton.hidden = YES;
    if(style==GTSDKStylesCustom){
        styleStr = @"默认";
        self.showFloatingWindowButton.hidden = NO;
    }
    [self.sdkInitTypeButton setTitle:styleStr forState:UIControlStateNormal];
    self.appKeyTextField.text = [appKey isEqualToString:@"Your appKey"]?nil:appKey;
    
}
-(void)addLeftPadding:(UITextField *)textField{
    UIView *paddingLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12.0, 64.0)];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = paddingLeftView;
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma mark--SDK初始化
/// 初始化SDK
/// - Parameters:
///   - appKey: 登录gametool官方网站创建应用获取
///
///   - style:SDK初始化模式，决定初始化后悬浮球是否立即显示
///     GTSDKStylesDefault 默认模式：初始化后显示小兔子悬浮球
///     GTSDKStylesCustom 自定义模式：初始化后不显示小兔子悬浮球，需调用[GTSDK showFloatingWindow];唤起悬浮球
///
///   - openDebug: 是否开启调试环境
///     YES:开启,可在管理后台调整加速器倍率
///     NO:不开启,加速器倍率不可调整，由加速配置文件决定
-(void)initSDK:(NSString *)appKey style:(GTSDKStyles)style openDebug:(BOOL)openDebug{
    [GTSDK initWithAppKey:appKey style:GTSDKStylesDefault openDebugEnvironment:openDebug andSuccess:^{
        NSLog(@"init success");
        
    } failure:^(NSString * _Nonnull errormsg) {
        //初始化失败回调
        NSLog(@"%@",errormsg);
    }];

}


/// 登录SDK
/// - Parameter userID: 您的用户ID
-(void)loginWithUserID:(NSString *)userID{
    [GTSDK loginWithGameUserID:userID andSuccess:^{
        //登录成功回调
        
    } failure:^(NSString * _Nonnull errormsg) {
        //登录失败回调
        
    }];
}

#pragma mark--click actions

/// 登录
/// - Parameter sender: <#sender description#>
- (IBAction)loginAction:(UIButton *)sender {
//    NSString *userID = @"Your userId";
    NSString *userID = self.userIdTextField.text;
    [self loginWithUserID:userID];
}

/// 切换初始化方式
/// - Parameter sender: <#sender description#>
- (IBAction)sdkInitTypeChangeAction:(UIButton *)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"即将退出示例demo，请退出后重新打开demo" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        GTSDKStyles style = [[NSUserDefaults standardUserDefaults] integerForKey:GTSDKStyleKey];
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        if(style==GTSDKStylesDefault){
            [userDefault setInteger:GTSDKStylesCustom forKey:GTSDKStyleKey];
        }else{
            [userDefault setInteger:GTSDKStylesDefault forKey:GTSDKStyleKey];
        }
        [userDefault synchronize];
        exit(0);
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:confirmAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

/// 打开弹窗
/// - Parameter sender: <#sender description#>
- (IBAction)showFloatingWindowAction:(UIButton *)sender {
    [GTSDK showFloatingWindow];
}


@end
