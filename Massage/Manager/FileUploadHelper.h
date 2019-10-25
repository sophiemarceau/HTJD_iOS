//
//  FileUploadHelper.h
//  IELTS
//
//  Created by sophiemarceau_qu on 14/11/27.
//  Copyright (c) 2014年 Neworiental. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileUploadHelper : NSObject

+(NSString *)PreUploadImagePath:(UIImage *)img AndFileName:(NSString *)fileName;
+(NSString *)GetTempSaveImagePath;
+(BOOL)writeImage:(UIImage*)image toFileAtPath:(NSString*)aPath;
+(void) FileUploadWithUrl:(NSString *)url FilePath:(NSString *)path FileName:(NSString *)fileName Success:(void (^)(NSDictionary *result))success;
+(void) fileUploadMp3WithUrl:(NSString *)url FilePath:(NSString *)path FileName:(NSString *)fileName Success:(void (^)(NSDictionary *result))success;
@property (nonatomic,assign)BOOL isMp3;

@end
