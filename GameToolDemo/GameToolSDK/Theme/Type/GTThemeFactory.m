//
//  GTThemeFactory.m
//  GTSDK
//
//  Created by shangmi on 2023/8/11.
//

#import "GTThemeFactory.h"
#import "GTThemeType.h"
#import "GTThemeTypeLight.h"
#import "GTThemeTypeDark.h"

@interface GTThemeFactory ()

@property (nonatomic, strong) GTThemeType *themeType;

@end

@implementation GTThemeFactory

- (instancetype)initWithThemeType:(GTSDKThemeType)themeType {
    self = [super init];
    if (self) {
        switch (themeType) {
            case GTSDKThemeTypeLight:
                self.themeType = [GTThemeTypeLight new];
                break;
            case GTSDKThemeTypeDark:
                self.themeType = [GTThemeTypeDark new];
                break;
            default:
                break;
        }
    }
    return self;
}

//获取颜色
- (void)colorWithType {
    [self.themeType colorWithType];
}

//获取图片
- (UIImage *)imageWithName:(NSString *)imageName {
    return [self.themeType imageWithName:imageName];
}

//获取json文件
- (NSString *)jsonWithName:(NSString *)jsonName {
    return [self.themeType jsonWithName:jsonName];;
}

@end
