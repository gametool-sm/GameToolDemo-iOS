//
//  LOTComposition+GTBundle.m
//  GameToolSDK
//
//  Created by smwl on 2023/12/7.
//

#import "LOTComposition+GTBundle.h"
#import "GTOperationControl.h"

@implementation LOTComposition (GTBundle)
+ (nullable instancetype)animationNamed:(nonnull NSString *)animationName inBundle:(nonnull NSBundle *)bundle themeType:(NSString *)themeType sdkStyle:(NSString *)sdkStyle{
    if (!animationName) {
        return nil;
    }
    NSArray *components = [animationName componentsSeparatedByString:@"."];
    animationName = components.firstObject;
    
    LOTComposition *comp = [[LOTAnimationCache sharedCache] animationForKey:animationName];
    if (comp) {
        return comp;
    }
    NSError *error;
    NSString *themeTypeDirectory = [@"json" stringByAppendingPathComponent:themeType];
    NSString *sdkStyleDirectory = [themeTypeDirectory stringByAppendingPathComponent:sdkStyle];
//    NSString *filePath = [bundle pathForResource:animationName ofType:@"json" inDirectory:inDirectory];
    NSString *filePath = [bundle pathForResource:animationName ofType:@"json" inDirectory:sdkStyleDirectory];
    if(!filePath){
        filePath = [bundle pathForResource:animationName ofType:@"json" inDirectory:themeTypeDirectory];;
    }
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:filePath];
    
    if (@available(iOS 9.0, *)) {
        if (!jsonData) {
            jsonData = [[NSDataAsset alloc] initWithName:animationName bundle:bundle].data;
        }
    }
    
    NSDictionary  *JSONObject = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData
                                                                           options:0 error:&error] : nil;
    if (JSONObject && !error) {
        LOTComposition *laScene = [[self alloc] initWithJSON:JSONObject withAssetBundle:bundle];
        [[LOTAnimationCache sharedCache] addAnimation:laScene forKey:animationName];
        laScene.cacheKey = animationName;
        return laScene;
    }
    NSLog(@"%s: Animation Not Found", __PRETTY_FUNCTION__);
    return nil;
}

+ (nullable instancetype)autoDirectoryAnimationNamed:(nonnull NSString *)animationName inBundle:(nonnull NSBundle *)bundle{
    NSString *sdk_Style = nil;
    NSString *themeType = nil;
    GTSDKThemeType theme = [GTThemeManager share].theme;
    GTSDKStyle sdkStyle = [GTOperationControl shareInstance].gtSDKStyle;
    
    switch(theme){
        case GTSDKThemeTypeLight:
            themeType = @"Light";
            break;
        case GTSDKThemeTypeDark:
            themeType = @"Dark";
            break;
        default:
            break;
    }
    switch(sdkStyle){
        case GTSDKStyleDefault:
            sdk_Style = @"Default";
            break;
            
        case GTSDKStyleCustomFloatingBall:
            sdk_Style = @"CustomFloatingBal";
            break;
            
        default:
            break;
    }
    return [self animationNamed:animationName inBundle:bundle themeType:themeType sdkStyle:sdk_Style];
}
@end
