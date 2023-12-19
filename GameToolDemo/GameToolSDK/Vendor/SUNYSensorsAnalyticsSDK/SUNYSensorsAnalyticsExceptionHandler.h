//
//  SUNYSensorsAnalyticsExceptionHandler.h
//  SUNYSensorsAnalyticsSDK
//
//  Created by 王灼洲 on 2017/5/26.
//  Copyright © 2015－2018 Sensors Data Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SUNYSensorsAnalyticsSDK;

@interface SUNYSensorsAnalyticsExceptionHandler : NSObject

+ (instancetype)sharedHandler;
- (void)addSensorsAnalyticsInstance:(SUNYSensorsAnalyticsSDK *)instance;

@end
