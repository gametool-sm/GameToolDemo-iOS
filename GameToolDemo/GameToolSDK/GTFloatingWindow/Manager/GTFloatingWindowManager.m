//
//  GTFloatingWindowManager.m
//  GTSDK
//
//  Created by shangmi on 2023/8/16.
//

#import "GTFloatingWindowManager.h"
#import "GTFloatingBallManager.h"
#import "GTClickerWindowManager.h"
#import "GTRecordWindowManager.h"

@implementation GTFloatingWindowManager

+ (GTFloatingWindowManager *)shareInstance {
   static GTFloatingWindowManager *manager = nil;
   static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{
       manager = [[GTFloatingWindowManager alloc]init];       
   });
   return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - GTFloatingWindowOperationProtocol

/**
 *  悬浮弹窗显示
 */
- (void)floatingWindowShow {
//    if (!_windowWindow) {
//        [self.windowWindow makeKeyAndVisible];
//    }
    [self.windowWindow setHidden:NO];
    
    if ([GTClickerWindowManager shareInstance].clickerWinWindow) {
        [[GTClickerWindowManager shareInstance] clickerWindowHide];
    }
    if ([GTRecordWindowManager shareInstance].recordWinWindow) {
        [[GTRecordWindowManager shareInstance] recordWindowHide];
    }
}

/**
 *  悬浮弹窗隐藏
 */
- (void)floatingWindowHide {
    [self.windowWindow setHidden:YES];
}

#pragma mark - setter & getter

- (GTFloatingWindowWindow *)windowWindow {
    if (!_windowWindow) {
        _windowWindow = [[GTFloatingWindowWindow alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [UIScreen mainScreen].bounds.size.height)];
        _windowWindow.windowLevel = 30000;
        _windowWindow.userInteractionEnabled = YES;
        GTFloatingWindowViewController *vc = [[GTFloatingWindowViewController alloc] init];
        vc.orientation = [[UIApplication sharedApplication] statusBarOrientation];
        _windowWindow.rootViewController = vc;
    }
    return _windowWindow;
}

@end
