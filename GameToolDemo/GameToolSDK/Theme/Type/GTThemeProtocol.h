//
//  GTThemeProtocol.h
//  GTSDK
//
//  Created by shangmi on 2023/8/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GTThemeProtocol <NSObject>

@optional
//获取颜色
- (void)colorWithType;
//获取图片
- (UIImage *)imageWithName:(NSString *)imageName;
//获取json文件
- (NSString *)jsonWithName:(NSString *)jsonName;

@end

NS_ASSUME_NONNULL_END
