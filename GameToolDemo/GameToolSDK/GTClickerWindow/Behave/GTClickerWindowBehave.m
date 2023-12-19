//
//  GTClickerWindowBehave.m
//  GTSDK
//
//  Created by shangmi on 2023/8/16.
//

#import "GTClickerWindowBehave.h"
#import "GTClickerWindowAnimation.h"

@interface GTClickerWindowBehave ()

@end

@implementation GTClickerWindowBehave

/**
 判断连点器悬浮窗的合理移动区域
 */
+ (CGPoint)clickerWindowMoveArea:(CGPoint)movePoint {
    CGFloat width = [GTClickerWindowManager shareInstance].clickerWinWindow.width;
    CGFloat height = [GTClickerWindowManager shareInstance].clickerWinWindow.height;
    if ([GTSDKUtils isPortrait]) { //竖屏
        CGFloat top = SAFE_AREA_TOP + height/2;
        CGFloat bottom = SCREEN_HEIGHT - SAFE_AREA_BOTTOM - height/2;
        CGFloat left = clickerWindow_distance + SAFE_AREA_LEFT + width/2;
        CGFloat right = SCREEN_WIDTH - SAFE_AREA_RIGHT - width/2 - clickerWindow_distance;
        
        CGFloat newX = MAX(left, MIN(right, movePoint.x));
        CGFloat newY = MAX(top, MIN(bottom, movePoint.y));
        
        return CGPointMake(newX, newY);
    }else { //横屏
        UIInterfaceOrientation interfaceOritation = [[UIApplication sharedApplication] statusBarOrientation];
        switch (interfaceOritation) {
            case UIInterfaceOrientationLandscapeLeft: { //左横屏（home键在左边）
                CGFloat top;
                CGFloat bottom;
                CGFloat left;
                CGFloat right;
                
                top = SAFE_AREA_TOP + height/2;
                bottom = SCREEN_HEIGHT - SAFE_AREA_BOTTOM - height/2;
                left = clickerWindow_distance + SAFE_AREA_LEFT + width/2;
                right = SCREEN_WIDTH - SAFE_AREA_RIGHT - width/2 - clickerWindow_distance;
                
                CGFloat newX = MAX(left, MIN(right, movePoint.x));
                CGFloat newY = MAX(top, MIN(bottom, movePoint.y));
                
                return CGPointMake(newX, newY);
            }
                break;
            case UIInterfaceOrientationLandscapeRight: { //右横屏（home键在右边）
                CGFloat top;
                CGFloat bottom;
                CGFloat left;
                CGFloat right;
                
                top = SAFE_AREA_TOP + height/2;
                bottom = SCREEN_HEIGHT - SAFE_AREA_BOTTOM - height/2;
                left = clickerWindow_distance + SAFE_AREA_LEFT + width/2;
                right = SCREEN_WIDTH - SAFE_AREA_RIGHT - width/2 - clickerWindow_distance;
                
                CGFloat newX = MAX(left, MIN(right, movePoint.x));
                CGFloat newY = MAX(top, MIN(bottom, movePoint.y));
                
                return CGPointMake(newX, newY);
            }
                break;
            case UIInterfaceOrientationPortrait:
            case UIInterfaceOrientationPortraitUpsideDown:
            default:
                return movePoint;
                break;
        }
    }
}

/**
 判断连点器触点的合理移动区域
 */
+ (CGPoint)clickerPointMoveArea:(CGPoint)movePoint {
    CGFloat width;
    switch ([GTClickerWindowManager shareInstance].pointSetModel.pointSize) {
        case ClickerWindowPointSizeOfSmall:
            width = clickerWindow_point_small_width;
            break;
        case ClickerWindowPointSizeOfMedium:
            width = clickerWindow_point_medium_width;
            break;
        case ClickerWindowPointSizeOfLarge:
            width = clickerWindow_point_large_width;
            break;
        default:
            break;
    }
    if ([GTSDKUtils isPortrait]) { //竖屏
        CGFloat top = SAFE_AREA_TOP + width/2;
        CGFloat bottom = SCREEN_HEIGHT - SAFE_AREA_BOTTOM - width/2;
        CGFloat left = SAFE_AREA_LEFT + width/2;
        CGFloat right = SCREEN_WIDTH - SAFE_AREA_RIGHT - width/2;
        
        CGFloat newX = MAX(left, MIN(right, movePoint.x));
        CGFloat newY = MAX(top, MIN(bottom, movePoint.y));
        
        return CGPointMake(newX, newY);
    }else { //横屏
        UIInterfaceOrientation interfaceOritation = [[UIApplication sharedApplication] statusBarOrientation];
        switch (interfaceOritation) {
            case UIInterfaceOrientationLandscapeLeft: { //左横屏（home键在左边）
                CGFloat top;
                CGFloat bottom;
                CGFloat left;
                CGFloat right;
                
                top = SAFE_AREA_TOP + width/2;
                bottom = SCREEN_HEIGHT - SAFE_AREA_BOTTOM - width/2;
                left = SAFE_AREA_LEFT + width/2;
                right = SCREEN_WIDTH - SAFE_AREA_RIGHT - width/2;
                
                CGFloat newX = MAX(left, MIN(right, movePoint.x));
                CGFloat newY = MAX(top, MIN(bottom, movePoint.y));
                
                return CGPointMake(newX, newY);
            }
                break;
            case UIInterfaceOrientationLandscapeRight: { //右横屏（home键在右边）
                CGFloat top;
                CGFloat bottom;
                CGFloat left;
                CGFloat right;
                
                top = SAFE_AREA_TOP + width/2;
                bottom = SCREEN_HEIGHT - SAFE_AREA_BOTTOM - width/2;
                left = SAFE_AREA_LEFT + width/2;
                right = SCREEN_WIDTH - SAFE_AREA_RIGHT - width/2;
                
                CGFloat newX = MAX(left, MIN(right, movePoint.x));
                CGFloat newY = MAX(top, MIN(bottom, movePoint.y));
                
                return CGPointMake(newX, newY);
            }
                break;
            case UIInterfaceOrientationPortrait:
            case UIInterfaceOrientationPortraitUpsideDown:
            default:
                return movePoint;
                break;
        }
    }
}


@end
