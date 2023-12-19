//
//  GTCacheTool.h
//  GTBaseComponent
//
//  Created by smwl_dxl on 2023/6/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GTCacheTool : NSObject
/**
 传入服务与键名获取钥匙串存储值
 一般情况1个服务下，会包含多个内容
 @param service 服务名
 @param key          键名
 @return        钥匙串存储值
 */
+ (NSString *)getContentFromKeyChain:(NSString *)service
                              ForKey:(NSString *)key;

/**
 传入存储内容、键名、与服务 向钥匙串中 存储内容
 一般情况1个服务下，会包含多个内容
 @param content 存储内容
 @param service 服务名
 @param key          键名
 @return       存储成功与否
 */
+ (BOOL)saveContentToKeyChain:(NSString *)content
                       ForKey:(NSString *)key
                      Service:(NSString *)service;

/**
 传入键名、与服务 向钥匙串中 移除存储内容
 一般情况1个服务下，会包含多个内容
 @param service 服务名
 @param key          键名
 @return       移除成功与否
 */
+ (BOOL)removeContentFromKeyChain:(NSString *)key
                          Service:(NSString *)service;
@end

NS_ASSUME_NONNULL_END
