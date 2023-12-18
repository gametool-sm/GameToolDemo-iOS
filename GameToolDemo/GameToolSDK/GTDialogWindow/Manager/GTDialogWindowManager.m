//
//  GTDialogWindowManager.m
//  GTSDK
//
//  Created by shangmi on 2023/9/12.
//

#import "GTDialogWindowManager.h"
#import "GTClickerWindowManager.h"
#import "GTFloatingBallManager.h"

@implementation GTDialogWindowManager

+ (GTDialogWindowManager *)shareInstance {
   static GTDialogWindowManager *manager = nil;
   static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{
       manager = [[GTDialogWindowManager alloc]init];
   });
   return manager;
}

#pragma mark - GTDialogWindowOperationProtocol

- (void)dialogWindowShow {
    [self.dialogWindow setHidden:NO];
}

- (void)dialogWindowHide {
    [GTClickerWindowManager shareInstance].clickerWinWindow.windowLevel = 29000;
    [GTFloatingBallManager shareInstance].ballWindow.windowLevel = 30000;
    [self.dialogVC.view removeAllSubviews];
    [self.dialogWindow setHidden:YES];
    
}

#pragma mark - setter & getter

- (GTDialogWindow *)dialogWindow {
    if (!_dialogWindow) {
        _dialogWindow = [[GTDialogWindow alloc] initWithFrame:CGRectZero];
        _dialogWindow.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _dialogWindow.windowLevel = 30100;
        _dialogWindow.userInteractionEnabled = YES;
        _dialogWindow.hidden = YES;
        
        _dialogVC = [[GTDialogViewController alloc] init];
        _dialogWindow.rootViewController = _dialogVC;
    }
    return _dialogWindow;
}

@end
