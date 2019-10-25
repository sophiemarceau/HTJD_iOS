//
//  NetworkManager.m
//  MedicineTrace
//
//  Created by melp on 13-9-18.
//  Copyright (c) 2013年 pfizer. All rights reserved.
//

#import "NetworkManager.h"
//#import "CacheManage.h"

static NetworkManager *_sharedNetworkManager;

@interface NetworkManager ()
@property(nonatomic ,strong) AFHTTPRequestOperationManager *requestManager;
@property (nonatomic) BOOL NetworkStatus;
@end

@implementation NetworkManager
+(NetworkManager*) SharedNetworkManager
{
    static NetworkManager *shareRusult;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        shareRusult = [[self alloc]init];
    });
    return shareRusult;
}



- (void)cancelAllRequest
{
    [self.requestManager.operationQueue cancelAllOperations];
}

- (AFHTTPRequestOperation *)requestGetWithParameters:(NSDictionary *)parameters
                                             ApiPath:(NSString*)path
                                          WithHeader:(NSDictionary*)headers
                                            onTarget:(UIViewController *)target
                                             success:(void (^)(NSDictionary *result,NSDictionary *headers))success
                                             failure:(void (^)(NSError *error))failure
{
    //    if(!_NetworkStatus)
    //    {
    //        NSDictionary *cacheData = [[CacheManage SharedCacheManages] CachedResponse:path];
    //        NSString *cached = [cacheData objectForKey:@"cache"];
    //        if([cached isEqualToString:@"YES"])
    //        {
    //            id jObj = [cacheData objectForKey:@"json"];
    //            success(jObj,nil);
    //            return;
    //        }else
    //        {
    //            [[RusultManage shareRusultManage]tipAlert:@"请检查网络状态"];
    //            return;
    //        }
    //    }
    NSMutableDictionary *hrParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    
    path = [NSString stringWithFormat:@"%@%@",BaseURLString,path];
    self.requestManager = [AFHTTPRequestOperationManager manager];
    self.requestManager.requestSerializer.timeoutInterval = 45;
    if (headers != nil) {
        self.requestManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        self.requestManager.requestSerializer = [AFJSONRequestSerializer serializer];
        self.requestManager.responseSerializer = [AFJSONResponseSerializer serializer];
        [self.requestManager.requestSerializer setValue:[headers objectForKey:@"Authentication"] forHTTPHeaderField:@"Authentication"];
    }
    
    return  [self.requestManager GET:path
                          parameters:hrParameters
                             success:^(AFHTTPRequestOperation *operation, id responseObject)
             {
                 //        NDLog(@"\n[API]= %@\n[RES]= %@", apiPath,[operation responseString]);
                 
                 //        [[CacheManage SharedCacheManages] CacheWebAPI:apiPath AndResponse:[operation responseString]];
                 
                 success(responseObject,[operation.response allHeaderFields]);
             }
                             failure:^(AFHTTPRequestOperation *operation, NSError *error)
             {
                 NDLog(@"Error: %@", [operation responseString]);
                 failure(error);
                 
                 if([operation responseString] == nil) return;
             }];
}

- (AFHTTPRequestOperation *)requestPostWithParameters:(NSDictionary *)parameters
                                              ApiPath:(NSString*)path
                                           WithHeader:(NSDictionary*)headers
                                             onTarget:(UIViewController *)target
                                              success:(void (^)(NSDictionary *result,NSDictionary *headers))success
                                              failure:(void (^)(NSError *error))failure
{
    //     if(!_NetworkStatus)
    //     {
    //         NSDictionary *cacheData = [[CacheManage SharedCacheManages] CachedResponse:path];
    //         NSString *cached = [cacheData objectForKey:@"cache"];
    //         if([cached isEqualToString:@"YES"])
    //         {
    //             id jObj = [cacheData objectForKey:@"json"];
    //             success(jObj,nil);
    //             return;
    //         }else
    //         {
    //             [[RusultManage shareRusultManage]tipAlert:@"请检查网络状态"];
    //             return;
    //         }
    //     }
    NSMutableDictionary *hrParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    path = [NSString stringWithFormat:@"%@%@",BaseURLString,path];
    
    self.requestManager = [AFHTTPRequestOperationManager manager];
//    self.requestManager.requestSerializer.timeoutInterval = 45;

    // 设置超时时间
    [self.requestManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    self.requestManager.requestSerializer.timeoutInterval = 10.f;
    [self.requestManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    if (headers != nil) {
        self.requestManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        self.requestManager.requestSerializer = [AFJSONRequestSerializer serializer];
        self.requestManager.responseSerializer = [AFJSONResponseSerializer serializer];
        [self.requestManager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    }
    return  [self.requestManager POST:path
                           parameters:hrParameters
                              success:^(AFHTTPRequestOperation *operation, id responseObject)
             {
//                          NDLog(@"\n[API]= %@\n[RES]= %@", path,[operation responseString]);
                 //缓存数据
                 //         [[CacheManage SharedCacheManages] CacheWebAPI:apiPath AndResponse:[operation responseString]];
                 success(responseObject,[operation.response allHeaderFields]);
             }
                              failure:^(AFHTTPRequestOperation *operation, NSError *error)
             {
//                 if ([error code] == NSURLErrorCancelled) {
//                     return;
//                 }
                 NDLog(@"Error: %@", [operation responseString]);
                 NSLog(@"error----------->%@",error);
                 failure(error);
                 if([operation responseString] == nil) return;
             }];
}

- (void)monitorNetwork
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status == AFNetworkReachabilityStatusNotReachable ||
            status ==AFNetworkReachabilityStatusUnknown) {
            //没网
            [RequestManager shareRequestManager].hasNetWork = NO;
            _NetworkStatus = NO;
            UIViewController *keyWindow =[UIApplication sharedApplication].keyWindow.rootViewController;
            [keyWindow showHint:@"请检测网络状态"];
        }else{
            //有网
            UIViewController *keyWindow =[UIApplication sharedApplication].keyWindow.rootViewController;
            [RequestManager shareRequestManager].hasNetWork = YES;
            _NetworkStatus = YES;
            [keyWindow showHint:@"网络连接正常"];
        }
    }];
}


@end
