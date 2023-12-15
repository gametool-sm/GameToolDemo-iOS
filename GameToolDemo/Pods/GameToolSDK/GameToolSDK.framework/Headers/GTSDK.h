//
//  GTSDK.h
//  GTSDK
//
//  Created by shangmi on 2023/6/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/**
 *  float ball style
 */
typedef NS_ENUM(NSInteger, GTSDKStyles) {
    /**
     *  default style
     *  Immediately display the floating ball after successful initialization
     *  The style is completely defined by SDK
     */
    GTSDKStylesDefault = 0,
    /**
     * Custom style
     * Successful initialization will not immediately display a floating pop-up window
     * Used in conjunction with the showFloatingWindow method, the floating ball pop-up window is only displayed after calling the showFloatingWindow method
     */
    GTSDKStylesCustom = 1,
};

@interface GTSDK : NSObject

/**
 *  Initializes GTSDK with appkey and style
 *  Required interface
 *  @param appkey : the unique identifier of GTSDK
 *  @param style : the style of GTSDK view, default is GTSDKViewStyleDefault
 *  success：Callback for successful initialization
 *  failure：Callbacks that failed to initialize（Can try reinitializing）
 */
+ (void)initWithAppKey:(NSString *)appkey style:(GTSDKStyles)style openDebugEnvironment:(BOOL)openDebugEnvironment andSuccess:(void (^)(void))success failure:(void (^)(NSString * errormsg))failure;

/**
 * login with userId, Called after successful initialization
 * optional interface
 * @param game_user_id : user's unique identification in the game
 * success：Callback for successful login
 * failure：Callbacks that failed to login（Can try reinitializing）
 * Calling this method can save the user's connection scheme and acceleration rate, and the user's cached data can be directly read the next time it is started
 */
+ (void)loginWithGameUserID:(NSString *)game_user_id andSuccess:(void (^)(void))success failure:(void (^)(NSString * errormsg))failure;

/**
 * Show floating pop-up window
 * Used in conjunction with the GTSDKStylesCustom type during initialization,
 * this method is called when a floating pop-up window needs to be displayed
 */
+ (void)showFloatingWindow;

+(void)durationEventReportTest;
@end

NS_ASSUME_NONNULL_END
