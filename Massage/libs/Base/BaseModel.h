//
//  BaseModel.h
//  CountyHospital3
//
//  Created by 李牛顿 on 14-4-11.
//  Copyright (c) 2014年 Personal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject<NSCoding>

-(id)initWithDataDic:(NSDictionary*)data;
- (NSDictionary*)attributeMapDictionary;
- (void)setAttributes:(NSDictionary*)dataDic;
- (NSString *)customDescription;
- (NSString *)description;
- (NSData*)getArchivedData;

- (NSString *)cleanString:(NSString *)str;


@end
