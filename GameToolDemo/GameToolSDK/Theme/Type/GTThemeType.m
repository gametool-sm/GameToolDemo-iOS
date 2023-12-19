//
//  GTThemeType.m
//  GTSDK
//
//  Created by shangmi on 2023/8/1.
//

#import "GTThemeType.h"

@implementation GTThemeType

- (instancetype)init {
    if (self = [super init]) {
//        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"GTSDK" ofType:@"bundle"];
//        self.bundle = [NSBundle bundleWithPath:bundlePath];
        NSString *path =  [[NSBundle mainBundle] pathForResource:@"Frameworks/GameToolSDK.framework/GTSDK" ofType: @"bundle"];
        NSBundle *bundle = [NSBundle bundleWithPath:path];
        self.bundle = bundle;
    }
    return self;
}
-(UIImage *)imageWithName:(NSString *)imageName themeType:(NSString *)themeType{
    CGFloat scale = [UIScreen mainScreen].scale;
    NSString *imageScaleName = [NSString stringWithFormat:@"%@@%dx",imageName,(int)scale];
    
    NSString *imagePath = [self.bundle pathForResource:imageScaleName ofType:@"png" inDirectory:themeType];
    if(!imagePath){
        imagePath = [self.bundle pathForResource:imageName ofType:@"png" inDirectory:themeType];
    }
    if(!imagePath){
        imagePath = [self.bundle pathForResource:imageScaleName ofType:@"png"];
    }
    if(!imagePath){
        imagePath = [self.bundle pathForResource:imageName ofType:@"png"];
    }
    
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:imagePath];
    return image;
}
@end
