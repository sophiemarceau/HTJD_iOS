
//


//

#import <Foundation/Foundation.h>

@interface UIUtils : NSObject
//将字符串格式化为Date对象
+(NSDate *)dateFromString:(NSString *)datestring formate:(NSString *)formate;
//将日期格式化为NSString对象
+(NSString *)stringFromDate:(NSDate *)date formate:(NSString *)formate;

//通过路径取得文件内容的大小
+(long long)contentFileSize:(NSString *)filePath;


@end
