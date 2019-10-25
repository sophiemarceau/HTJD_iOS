//
//  NetworkManager.h
//  MedicineTrace
//
//  Created by sophiemarceau_qu on 13-9-18.
//  Copyright (c) 2013年 pfizer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"


//#define  BaseUserIconPath @"http://testielts.staff.xdf.cn/IELTS/fileupload"

@interface NetworkManager : NSObject
@property (nonatomic,assign) BOOL hasNetWork;

+(NetworkManager*) SharedNetworkManager;

- (void)cancelAllRequest;
- (void)monitorNetwork;
- (AFHTTPRequestOperation *)requestGetWithParameters:(NSDictionary *)parameters
                        ApiPath:(NSString*)path
                        WithHeader:(NSDictionary*)headers
                        onTarget:(UIViewController *)target
                        success:(void (^)(NSDictionary *result,NSDictionary *headers))success
                        failure:(void (^)(NSError *error))failure;

- (AFHTTPRequestOperation *)requestPostWithParameters:(NSDictionary *)parameters
                         ApiPath:(NSString*)path
                      WithHeader:(NSDictionary*)headers
                        onTarget:(UIViewController *)target
                         success:(void (^)(NSDictionary *result,NSDictionary *headers))success
                         failure:(void (^)(NSError *error))failure;



@end
