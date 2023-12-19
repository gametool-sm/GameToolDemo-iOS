//
//  GTRecordGuideView.h
//  GTSDK
//
//  Created by smwl on 2023/10/26.
//

#import <UIKit/UIKit.h>

typedef void(^GuideCloseCallBack)(void);

NS_ASSUME_NONNULL_BEGIN

@interface GTRecordGuideView : UIView


/// 关闭引导页
-(void)closeGuide;
+(void)closeGuide;
+(void)closeGuideNow;
-(void)closeGuideWithCloseCallBack:(GuideCloseCallBack)closeCallBack;
/// 展示引导蒙层
/// - Parameter closeCallBack: <#closeCallBack description#>
+(instancetype)showGuideViewWithCloseCallBack:(GuideCloseCallBack)closeCallBack;

@end

NS_ASSUME_NONNULL_END
