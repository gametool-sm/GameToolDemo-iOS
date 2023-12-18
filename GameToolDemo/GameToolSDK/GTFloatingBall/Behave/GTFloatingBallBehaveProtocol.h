//
//  GTFloatingBallBehaveProtocol.h
//  GTSDK
//
//  Created by shangmi on 2023/6/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GTFloatingBallBehaveDefaultProtocol.h"
#import "GTFloatingBallBehaveControlProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol GTFloatingBallBehaveProtocol <NSObject>

//移动范围
- (CGPoint)floatingBallMoveArea:(CGPoint)movePoint;

//自动靠边
- (void)floatingBallWeltWithSpeed:(double)speed completion:(void (^ __nullable)(void))completion;

//贴边隐藏一半
- (void)floatingBallHideHalfWithCompletion:(void (^ __nullable)(void))completion;

//弹出，即拖动时恢复原样
- (void)floatinngBallPopUpWithCompletion:(void (^ __nullable)(void))completion;

//熄灭
- (void)floatingBallDarkWithCompletion:(void (^ __nullable)(void))completion;

//点亮
- (void)floatingBallLightWithCompletion:(void (^ __nullable)(void))completion;

@end

NS_ASSUME_NONNULL_END
