//
//  GTFloatingBallOperationProtocol.h
//  GTSDK
//
//  Created by 童威 on 2023/6/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GTFloatingBallOperationProtocol <NSObject>

/**
 *  悬浮球显示
 */
- (void)floatingBallShow;

/**
 *  悬浮球隐藏
 */
- (void)floatingBallHide;

@end

NS_ASSUME_NONNULL_END
