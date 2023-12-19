//
//  GTRecordWindowOperationProtocol.h
//  GTSDK
//
//  Created by shangmi on 2023/10/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GTRecordWindowOperationProtocol <NSObject>

/**
 *  录制悬浮窗显示
 */
- (void)recordWindowShow;

/**
 *  录制悬浮窗隐藏
 */
- (void)recordWindowHide;

@end

NS_ASSUME_NONNULL_END
