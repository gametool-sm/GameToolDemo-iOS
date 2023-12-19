//
//  GTDialogWindowOperationProtocol.h
//  GTSDK
//
//  Created by shangmi on 2023/7/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GTDialogWindowOperationProtocol <NSObject>

/**
 *  弹窗窗口显示
 */
- (void)dialogWindowShow;

/**
 *  弹窗窗口隐藏
 */
- (void)dialogWindowHide;

@end

NS_ASSUME_NONNULL_END
