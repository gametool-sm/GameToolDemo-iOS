//
//  GTNetworkManager.h
//  GTSDK
//
//  Created by shangmi on 2023/7/17.
//

#import <Foundation/Foundation.h>
#import <AFHTTPSessionManager.h>
#import "NetHeaderModel.h"

typedef void (^HttpSuccess)(id _Nullable responseObject);
typedef void (^HttpFailure)(NSError * _Nullable error);
typedef void (^HttpBody)(id <AFMultipartFormData> _Nullable formData);

NS_ASSUME_NONNULL_BEGIN

@interface GTNetworkManager : NSObject

@property (nonatomic, strong) NetHeaderModel *headerModel;
@property (nonatomic, strong) NSDictionary *debugDict;    

+ (GTNetworkManager *)shareManager;

- (NSURLSessionTask *)POST:(NSString *)url parameters:(NSDictionary *)parameters success:(HttpSuccess)success failure:(HttpFailure)failure;
- (NSURLSessionTask *)POST:(NSString *)url parameters:(NSDictionary *)parameters body:(HttpBody)body success:(HttpSuccess)success failure:(HttpFailure)failure;
- (void)GET:(NSString *)url parameters:(NSDictionary *)parameters success:(HttpSuccess)success failure:(HttpFailure)failure;

@end

NS_ASSUME_NONNULL_END
