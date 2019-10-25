//
//  UIUtils.m
//  WXMovie
//


//

#import "UIUtils.h"

@implementation UIUtils

//将字符串格式化为Date对象
+(NSDate *)dateFromString:(NSString *)datestring formate:(NSString *)formate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:formate];
    NSDate *date = [dateFormatter dateFromString:datestring];

    return date;
}
//将日期格式化为NSString对象
+(NSString *)stringFromDate:(NSDate *)date formate:(NSString *)formate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:formate];
    NSString *datestring = [dateFormatter stringFromDate:date];
    return datestring;
}

//通过路径取得文件内容的大小
+(long long)contentFileSize:(NSString *)filePath
{
//  NSString *filepath = [NSBundle mainBundle]pathForResource:@"" ofType:<#(NSString *)#>;
    NSFileManager *fileManage = [NSFileManager defaultManager];
   //获取到目录下面所有的文件名
    NSArray *fileNames = [fileManage subpathsOfDirectoryAtPath:filePath error:nil];
    long long sum = 0;
    for (NSString *fileName in fileNames) {
        NSString *path = [filePath stringByAppendingPathComponent:fileName];
        //属性存到字典
        NSDictionary *attribute = [fileManage attributesOfItemAtPath:path error:nil];
        long long size = [attribute fileSize];
        sum += size;
    }
    return sum;
}

@end
