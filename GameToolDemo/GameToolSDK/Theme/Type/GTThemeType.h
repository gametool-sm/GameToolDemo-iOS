//
//  GTThemeType.h
//  GTSDK
//
//  Created by shangmi on 2023/8/1.
//

#import <Foundation/Foundation.h>
#import "GTThemeProtocol.h"
#import "GTThemeManager.h"
#import "GTOperationControl.h"

NS_ASSUME_NONNULL_BEGIN

@interface GTThemeType : NSObject <GTThemeProtocol>

@property (nonatomic, strong) NSBundle *bundle;

-(UIImage *)imageWithName:(NSString *)imageName themeType:(NSString *)themeType;

@end

NS_ASSUME_NONNULL_END
