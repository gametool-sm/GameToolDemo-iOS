//
//  GTDataTimeTester.m
//  GTSDK
//
//  Created by smwl on 2023/11/16.
//

#import "GTDataTimeTester.h"
#import "GTDataTimeCounter.h"

@interface GTDataTimeTester()

@property (nonatomic, strong) GTDataTimeCounterType type;

@end

@implementation GTDataTimeTester

-(void)show {
#ifdef DEBUG
    if (IS_DEBUG_SHOW_GTDataTimeTester == 1) {
        [self debugShow];
    }
#endif
}

-(void)debugShow {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"test" message:@"time counter" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *actionStart = [UIAlertAction actionWithTitle:@"开始计时" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.type = [[GTDataTimeCounter sharedInstance] start:@"tmp_start_id" externParam:@{
            @"kPresetCountdownTime": @(40),
            @"kEventName": @"iOSTestLocal"
        }];
        
        [[GTDataTimeCounter sharedInstance] registerAction:^(long initTime, long useTime, long countdownTime) {
            NSLog(@"=========registerAction callback start ===============");
            NSLog(@"初始化时间【用于神策数据上报】: %ld毫秒", initTime);
            NSLog(@"useTime: %ld毫秒", useTime);
            NSLog(@"countdownTime: %ld毫秒", countdownTime);
        } type:self.type];
        
        [self debugShow];
    }];
    
    UIAlertAction *actionStop = [UIAlertAction actionWithTitle:@"暂停计时" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[GTDataTimeCounter sharedInstance] stop:YES type:self.type];
        
        [self debugShow];
    }];
    
    UIAlertAction *actionContinue = [UIAlertAction actionWithTitle:@"继续计时" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[GTDataTimeCounter sharedInstance] stop:NO type:self.type];
        
        [self debugShow];
    }];
    
    UIAlertAction *actionEnd = [UIAlertAction actionWithTitle:@"结束计时" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[GTDataTimeCounter sharedInstance] end:self.type];
        
        [self debugShow];
    }];
    
    [controller addAction:actionStart];
    [controller addAction:actionStop];
    [controller addAction:actionContinue];
    [controller addAction:actionEnd];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:controller animated:YES completion:nil];
    
    
}

@end
