//
//  GTDialogWindowManager.h
//  GTSDK
//
//  Created by shangmi on 2023/9/12.
//

#import <Foundation/Foundation.h>
#import "GTDialogWindowOperationProtocol.h"
#import "GTDialogWindow.h"
#import "GTDialogViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GTDialogWindowManager : NSObject <GTDialogWindowOperationProtocol>

@property (nonatomic, strong, nullable) GTDialogWindow * dialogWindow;
@property (nonatomic, strong) GTDialogViewController *dialogVC;

+ (GTDialogWindowManager *)shareInstance;

@end

NS_ASSUME_NONNULL_END
