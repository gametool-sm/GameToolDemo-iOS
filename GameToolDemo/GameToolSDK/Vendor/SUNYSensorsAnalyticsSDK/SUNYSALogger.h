//
//  SUNYSALogger.h
//  SUNYSensorsAnalyticsSDK
//
//  Created by 曹犟 on 15/7/6.
//  Copyright © 2015－2018 Sensors Data Inc. All rights reserved.
//
#import <UIKit/UIKit.h>
#ifndef __SUNY__SensorsAnalyticsSDK__SALogger__
#define __SUNY__SensorsAnalyticsSDK__SALogger__

#define SUNYSALoggerLevel(lvl,fmt,...)\
[SUNYSALogger log : YES                                      \
level : lvl                                                  \
file : __FILE__                                            \
function : __PRETTY_FUNCTION__                       \
line : __LINE__                                           \
format : (fmt), ## __VA_ARGS__]

#define SUNYSALog(fmt,...)\
SUNYSALoggerLevel(SUNYSALoggerLevelInfo,(fmt), ## __VA_ARGS__)

#define SUNYSAError SUNYSALog
#define SUNYSADebug SUNYSALog

#endif/* defined(__SUNY__SensorsAnalyticsSDK__SALogger__) */
typedef NS_ENUM(NSUInteger,SUNYSALoggerLevel){
    SUNYSALoggerLevelInfo = 1,
    SUNYSALoggerLevelWarning ,
    SUNYSALoggerLevelError ,
};

@interface SUNYSALogger:NSObject
@property(class , readonly, strong) SUNYSALogger *sharedInstance;
+ (BOOL)isLoggerEnabled;
+ (void)enableLog:(BOOL)enableLog;
+ (void)log:(BOOL)asynchronous
      level:(NSInteger)level
       file:(const char *)file
   function:(const char *)function
       line:(NSUInteger)line
     format:(NSString *)format, ... ;
@end
