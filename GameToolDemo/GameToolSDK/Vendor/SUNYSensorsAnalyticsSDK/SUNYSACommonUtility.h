//
//  SUNYSACommonUtility.h
//  SUNYSensorsAnalyticsSDK
//
//  Created by 储强盛 on 2018/7/26.
//  Copyright © 2015－2018 Sensors Data Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SUNYSACommonUtility : NSObject

///按字节截取指定长度字符，包括汉字
+ (NSString *)subByteString:(NSString *)string byteLength:(NSInteger )len;

@end
