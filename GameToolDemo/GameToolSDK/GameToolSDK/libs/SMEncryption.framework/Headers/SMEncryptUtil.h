//
//  SMEncryptUtil.h
//  SMEncryption
//
//  Created by smwl_dxl on 2023/6/20.
//  Copyright © 2023 smwl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMEncryptUtil : NSObject
/*
 对请求参数加密
 */
+ (NSDictionary *)getEncryptParameWithOriginDic:(NSDictionary *)originDic;
/*
 对请求地址加密
 originUrl : 原地址，不包含域名
 api ： 用于规则匹配，可以不填或者任意填（有具体接口定义，会在接口文档说明）
 */
+ (NSString *)getEncryptResquestUrlWithOriginUrl:(NSString *)originUrl andApi:(NSString *)api;

+ (NSString *)getDecryptResponseDataWithResponseData:(NSString *)responseData;

@end

NS_ASSUME_NONNULL_END
