//
//  GTRecordWindowBehave.m
//  GTSDK
//
//  Created by shangmi on 2023/10/27.
//

#import "GTRecordWindowBehave.h"
#import "GTRecordWindowAnimatiion.h"

@implementation GTRecordWindowBehave

/**
 判断连点器悬浮窗的合理移动区域
 */
+ (CGPoint)RecordWindowMoveArea:(CGPoint)movePoint {
    CGFloat width = [GTRecordWindowManager shareInstance].recordWinWindow.width;
    CGFloat height = [GTRecordWindowManager shareInstance].recordWinWindow.height;
    
    CGFloat top = SAFE_AREA_TOP + height/2;
    CGFloat bottom = SCREEN_HEIGHT - SAFE_AREA_BOTTOM - height/2;
    CGFloat left = recordWindow_distance + SAFE_AREA_LEFT + width/2;
    CGFloat right = SCREEN_WIDTH - SAFE_AREA_RIGHT - width/2 - recordWindow_distance;
    
    CGFloat newX = MAX(left, MIN(right, movePoint.x));
    CGFloat newY = MAX(top, MIN(bottom, movePoint.y));
    
    return CGPointMake(newX, newY);
}

@end
