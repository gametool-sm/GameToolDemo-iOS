//
//  NetHeaderModel.h
//  GTSDK
//
//  Created by shangmi on 2023/7/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetHeaderModel : NSObject

@property (nonatomic, copy) NSString *UserAgent;
@property (nonatomic, copy) NSString *i18n;
@property (nonatomic, copy) NSString *deviceId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *gtClientInfo;
@property (nonatomic, copy) NSString *debugTokenName; //开启后门则传递
@property (nonatomic, copy) NSString *debugToken;     //开启后门则传递

- (NSDictionary *)propertyValueDict;

@end

NS_ASSUME_NONNULL_END
