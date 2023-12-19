//
//  GTNetworkManager+CPReport.m
//  GTSDK
//
//  Created by smwl on 2023/11/22.
//

#import "GTNetworkManager+CPReport.h"

@implementation GTNetworkManager (CPReport)
- (NSURLSessionTask *)CPPOST:(NSString *)url parameters:(NSDictionary *)parameters success:(HttpSuccess)success failure:(HttpFailure)failure {
    [self update];
    return [self.session POST:url parameters:parameters headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString * decodeResponseObject;
        if ([responseObject isKindOfClass:[NSData class]]) {
            NSString * str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            decodeResponseObject = [SMEncryptUtil getDecryptResponseDataWithResponseData:str];
        } else {
            decodeResponseObject = responseObject;
        }
        if (decodeResponseObject) {
            NSDictionary * resultDict = [GTSDKUtils dictionaryWithJsonString:decodeResponseObject];
            if (success) {
                success(resultDict);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}
@end
