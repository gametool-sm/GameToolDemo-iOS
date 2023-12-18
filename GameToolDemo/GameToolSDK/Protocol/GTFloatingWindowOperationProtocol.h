//
//  GTFloatingWindowOperationProtocol.h
//  GTSDK
//
//  Created by shangmi on 2023/6/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GTFloatingWindowOperationProtocol <NSObject>

/**
 *  悬浮窗口显示
 */
- (void)floatingWindowShow;

/**
 *  悬浮窗口隐藏
 */
- (void)floatingWindowHide;

@end

NS_ASSUME_NONNULL_END
