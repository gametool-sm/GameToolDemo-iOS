//
//  GTThemeFactory.h
//  GTSDK
//
//  Created by shangmi on 2023/8/11.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface GTThemeFactory : NSObject <GTThemeProtocol>

- (instancetype)initWithThemeType:(GTSDKThemeType)themeType;

@end

NS_ASSUME_NONNULL_END
