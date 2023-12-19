//
//  GTThemeManager.m
//  GTSDK
//
//  Created by shangmi on 2023/7/28.
//

#import "GTThemeManager.h"
#import "GTThemeFactory.h"

@interface GTThemeManager ()

@end

@implementation GTThemeManager

+ (GTThemeManager *)share {
    static GTThemeManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[GTThemeManager alloc]init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.colorModel = [GTThemeColorModel new];
    }
    return self;
}

- (void)setTheme:(GTSDKThemeType)theme {
    _theme = theme;
    [self updateConfig];
}

- (void)updateConfig {
    GTThemeFactory *themeFactory = [[GTThemeFactory alloc] initWithThemeType:self.theme];
    [themeFactory colorWithType];
}

- (UIImage *)imageWithName:(NSString *)imageName {
    GTThemeFactory *themeFactory = [[GTThemeFactory alloc] initWithThemeType:self.theme];
    return [themeFactory imageWithName:imageName];
}

- (NSString *)jsonWithName:(NSString *)jsonName {
    GTThemeFactory *themeFactory = [[GTThemeFactory alloc] initWithThemeType:self.theme];
    return [themeFactory jsonWithName:jsonName];
}

-(NSBundle *)getGTSDKBundle{
    NSString *path =  [[NSBundle mainBundle] pathForResource:@"Frameworks/GameToolSDK.framework/GTSDK" ofType: @"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:path];
    return bundle;
}
@end
