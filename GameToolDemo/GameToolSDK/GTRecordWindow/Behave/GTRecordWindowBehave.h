//
//  GTRecordWindowBehave.h
//  GTSDK
//
//  Created by shangmi on 2023/10/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GTRecordWindowBehave : NSObject

/**
 判断录制悬浮窗的合理移动区域
 */
+ (CGPoint)RecordWindowMoveArea:(CGPoint)movePoint;

@end

NS_ASSUME_NONNULL_END
