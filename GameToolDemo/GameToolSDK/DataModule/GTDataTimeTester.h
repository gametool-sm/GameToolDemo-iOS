//
//  GTDataTimeTester.h
//  GTSDK
//
//  Created by smwl on 2023/11/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 调试计时的封装，上线的时候必须配置为0；
#define IS_DEBUG_SHOW_GTDataTimeTester 0

@interface GTDataTimeTester : NSObject

-(void)show;

@end

NS_ASSUME_NONNULL_END
