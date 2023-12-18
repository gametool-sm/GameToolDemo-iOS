//
//  GTClickerWindowOperationProtocol.h
//  GTSDK
//
//  Created by shangmi on 2023/8/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GTClickerWindowOperationProtocol <NSObject>

/**
 *  连点器悬浮窗显示
 */
- (void)clickerWindowShow;

/**
 *  连点器悬浮窗隐藏
 */
- (void)clickerWindowHide;


@end

NS_ASSUME_NONNULL_END
