//
//  CacheManage.h
//  CountyHospital2
//
//  Created by sophiemarceau_qu on 13-11-29.
//  Copyright (c) 2013年 pfizer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheManage : NSObject

+(CacheManage *) SharedCacheManage;

@property (nonatomic) BOOL ShouldCache;

- (void)CacheWebAPI:(NSString *)api AndResponse:(NSString *)res;
- (NSDictionary *)CachedResponse:(NSString *)api;

@end
