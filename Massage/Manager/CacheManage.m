//
//  CacheManage.m
//  CountyHospital2
//
//  Created by sophiemarceau_qu on 13-11-29.
//  Copyright (c) 2013年 pfizer. All rights reserved.
//

#import "CacheManage.h"
#import "DBHelper.h"

static CacheManage *_SharedCacheManage;

@implementation CacheManage

+(CacheManage *) SharedCacheManage
{
    if(_SharedCacheManage == nil)
    {
        _SharedCacheManage = [[CacheManage alloc] init];
    }
    
    return _SharedCacheManage;
}

//+(CacheManage *)SharedCacheManages
//{
//   static dispatch_once_t token;
//   dispatch_once(&token, ^{
//      _SharedCacheManage = [[self alloc]init];
//   });
//    return _SharedCacheManage;
//}

- (id) init
{
    self = [super init];
    
    _ShouldCache = YES;
    
    return self;
}

- (void)CacheWebAPI:(NSString *)api AndResponse:(NSString *)res
{
    if([self IsFilter:api]) return;
    
    api = [self FileterApiString:api];
    
    /*
    NSString *sql = [NSString stringWithFormat:@"select * from CacheTable where APIPath='%@'",api];
    
    FMResultSet *rs = [[DBHelper sharedDBHelper] Query:sql];
    int pkid = 0;
    while ([rs next])
    {
        pkid = [rs intForColumn:@"PKID"];
        break;
    }
    [rs close];
    */
    
     NSString *sql = [NSString stringWithFormat:@"delete from CacheTable where APIPath='%@'",api];
    [[DBHelper sharedDBHelper] ExecuteSql:sql];
    
    res = [res stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    /*
    if (pkid != 0)
    {
        sql = [NSString stringWithFormat:@"update CacheTable set Response='%@' where APIPath='%@'",res,api];
    }
    else*/
    {
        sql = [NSString stringWithFormat:@"insert into CacheTable(APIPath,Response) values('%@','%@') ",api,res];
    }
    
    [[DBHelper sharedDBHelper] ExecuteSql:sql];
}

- (NSDictionary *)CachedResponse:(NSString *)api
{
    api = [self FileterApiString:api];
    
    NSString *sql = [NSString stringWithFormat:@"select * from CacheTable where APIPath='%@'",api];
    
    FMResultSet *rs = [[DBHelper sharedDBHelper] Query:sql];
    NSString *res = @"";
    while ([rs next])
    {
        res  = [rs stringForColumn:@"Response"];
        break;
    }
    [rs close];
    
    NSString *cached = @"NO";
    id jsonObj = @{};
    if(![res isEqualToString:@""])
    {
        NSData *jsonData = [res dataUsingEncoding: NSUTF8StringEncoding];
        NSError *error = nil;
        
        id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
        
        if (jsonObject != nil && error == nil)
        {
            if ([jsonObject isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *deserializedDictionary = (NSDictionary *)jsonObject;
                
                jsonObj = deserializedDictionary;
                cached = @"YES";
                NSLog(@"Dersialized JSON Dictionary = %@", deserializedDictionary);
                
            }
            else if ([jsonObject isKindOfClass:[NSArray class]])
            {
                NSArray *deserializedArray = (NSArray *)jsonObject;
                jsonObj = deserializedArray;
                cached = @"YES";
                NSLog(@"Dersialized JSON Array = %@", deserializedArray);
                    
            }
            else
            {
                NSLog(@"An error happened while deserializing the JSON data.");
            }
        }
    }
    
    return @{@"cache":cached,@"res":res,@"json":jsonObj};
}

- (NSString *) FileterApiString:(NSString *)api
{
    NSRange range = [api rangeOfString:@"&HCPTicket="];
    if(range.location == NSNotFound)
    {
        return api;
    }
    else
    {
        api = [api substringWithRange:NSMakeRange(0, range.location)];
        return api;
    }
}

- (BOOL) IsFilter:(NSString *)api
{
    int ret = 0;
    
    NSRange range = [api rangeOfString:@"hcp/login"];
    if(range.location != NSNotFound) ret++;
    
    range = [api rangeOfString:@"hcp/GetEncryptKey"];
    if(range.location != NSNotFound) ret++;

    range = [api rangeOfString:@"OnlineQAOperation/RegOnlineQA"];
    if(range.location != NSNotFound) ret++;
    
    range = [api rangeOfString:@"OnlineQAOperation/ObserverOnlineQA"];
    if(range.location != NSNotFound) ret++;
    
    range = [api rangeOfString:@"OnlineQAOperation/RequestOnlineQARecords"];
    if(range.location != NSNotFound) ret++;
    
    range = [api rangeOfString:@"OnlineQAOperation/RequestOnlineQAHeadRecords"];
    if(range.location != NSNotFound) ret++;
    
    range = [api rangeOfString:@"OnlineQAOperation/AppendOnlineQARecord"];
    if(range.location != NSNotFound) ret++;
    
    return (ret>0);
}

@end




