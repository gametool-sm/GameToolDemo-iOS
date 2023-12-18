//
//  LOTComposition+GTBundle.h
//  GameToolSDK
//
//  Created by smwl on 2023/12/7.
//

#import "LOTComposition+GTBundle.h"
NS_ASSUME_NONNULL_BEGIN

@interface LOTAnimationView (GTBundle)

/// 根据GameToolSDK.framework配置自动选择暗黑或浅色模式bundle资源路径
/// - Parameters:
///   - animationName: 动画json配置文件名称
///   - bundle: json文件所在bundle
+ (nonnull instancetype)autoDirectoryAnimationNamed:(nonnull NSString *)animationName inBundle:(nonnull NSBundle *)bundle;
@end

NS_ASSUME_NONNULL_END
