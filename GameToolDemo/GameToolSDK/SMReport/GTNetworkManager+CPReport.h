//
//  GTNetworkManager+CPReport.h
//  GTSDK
//
//  Created by smwl on 2023/11/22.
//

#import "GTNetworkManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface GTNetworkManager (CPReport)

@property (nonatomic, strong) AFHTTPSessionManager *session;
- (void)update;

//解决原POST方法后台数据返回为nil时不会回调的问题
- (NSURLSessionTask *)CPPOST:(NSString *)url parameters:(NSDictionary *)parameters success:(HttpSuccess)success failure:(HttpFailure)failure;

@end

NS_ASSUME_NONNULL_END
