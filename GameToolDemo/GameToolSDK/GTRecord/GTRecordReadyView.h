//
//  GTRecordReadyView.h
//  GTSDK
//
//  Created by smwl on 2023/10/26.
//

#import <UIKit/UIKit.h>


typedef void(^ReadyFinishCallBack)(BOOL isCanceled);

NS_ASSUME_NONNULL_BEGIN

@interface GTRecordReadyView : UIView


/// <#Description#>
/// - Parameter finishCallBack: 完成回调 isCanceled YES： 取消录制 isCanceled：NO 进行录制
+(instancetype)showReadyView:(ReadyFinishCallBack)finishCallBack;

@end

NS_ASSUME_NONNULL_END
