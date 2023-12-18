//
//  GTThemeManager.h
//  GTSDK
//
//  Created by shangmi on 2023/7/28.
//

#import <Foundation/Foundation.h>
#import "GTThemeColorModel.h"
#import "GTThemeProtocol.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, GTSDKThemeType) {
    GTSDKThemeTypeLight,
    GTSDKThemeTypeDark,
    GTSDKThemeTypeFollowSystem,
};

@interface GTThemeManager : NSObject <GTThemeProtocol>

@property (nonatomic, assign) GTSDKThemeType theme;

@property (nonatomic, strong) GTThemeColorModel *colorModel;

+ (GTThemeManager *)share;

-(NSBundle *)getGTSDKBundle;

@end

NS_ASSUME_NONNULL_END
