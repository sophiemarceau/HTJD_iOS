
//
//  ZCControl.m
//  Device
//
//  Created by ZhangCheng on 14-4-19.
//  Copyright (c) 2014年 zhangcheng. All rights reserved.
//

#import "ZCControl.h"

#define IOS7   [[UIDevice currentDevice]systemVersion].floatValue>=7.0
@interface ZCControl()


@end
@implementation ZCControl
+(UILabel*)createLabelWithFrame:(CGRect)frame Font:(int)font Text:(NSString*)text
{
    
    
    UILabel*label=[[UILabel alloc]initWithFrame:frame];
    //限制行数
    label.numberOfLines=0;
    //对齐方式
    label.textAlignment=NSTextAlignmentLeft;
    label.backgroundColor=[UIColor clearColor];
    label.font=[UIFont systemFontOfSize:font];
    //单词折行
    label.lineBreakMode=NSLineBreakByWordWrapping;
    //默认字体颜色是黑色
    label.textColor=[UIColor blackColor];
    //自适应（行数~字体大小按照设置大小进行设置）
    label.adjustsFontSizeToFitWidth=YES;
    label.text=text;
    return label;
}
+(UILabel *)createLabelLineFrame:(CGRect )frame
{
    UILabel*label=[[UILabel alloc]initWithFrame:frame];
    label.backgroundColor=[UIColor lightGrayColor];
    return label;
}

+(UIButton*)createButtonWithFrame:(CGRect)frame ImageName:(NSString*)imageName Target:(id)target Action:(SEL)action Title:(NSString*)title
{
    UIButton*button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=frame;
    button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    button.titleLabel.textColor = [UIColor whiteColor];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //设置背景图片，可以使文字与图片共存
//    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    //图片与文字如果需要同时存在，就需要图片足够小 详见人人项目按钮设置
     [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}
+(UIImageView*)createImageViewWithFrame:(CGRect)frame ImageName:(NSString*)imageName
{
    UIImageView*imageView=[[UIImageView alloc]initWithFrame:frame];
    imageView.image=[UIImage imageNamed:imageName];
    imageView.userInteractionEnabled=YES;
    return imageView ;
}
+(UIView*)viewWithFrame:(CGRect)frame
{
    UIView*view=[[UIView alloc]initWithFrame:frame];
    
    return view ;
    
}
+(UITextField*)createTextFieldWithFrame:(CGRect)frame placeholder:(NSString*)placeholder passWord:(BOOL)YESorNO leftImageView:(UIImageView*)imageView rightImageView:(UIImageView*)rightImageView Font:(float)font
{
    UITextField*textField=[[UITextField alloc]initWithFrame:frame];
    //灰色提示框
    textField.placeholder=placeholder;
    //设置光标颜色
    textField.tintColor = [UIColor lightGrayColor];
    //文字对齐方式
    textField.textAlignment=NSTextAlignmentLeft;
    textField.secureTextEntry=YESorNO;
    //边框
//    textField.borderStyle=UITextBorderStyleLine;
    //键盘类型
//    textField.keyboardType=UIKeyboardTypeEmailAddress;
    //关闭首字母大写
    textField.autocapitalizationType=NO;
    //清除按钮
    textField.clearButtonMode=YES;
    //左图片
//    textField.leftView=imageView;
//    textField.leftViewMode=UITextFieldViewModeAlways;
    //右图片
//    textField.rightView=rightImageView;
    //编辑状态下一直存在
//    textField.rightViewMode=UITextFieldViewModeWhileEditing;
    //自定义键盘
    //textField.inputView
    //字体
    textField.font=[UIFont systemFontOfSize:font];
    //字体颜色
//    textField.textColor=[UIColor blackColor];
    return textField ;
    
}
#pragma  mark 适配器方法
+(UITextField*)createTextFieldWithFrame:(CGRect)frame
                            placeholder:(NSString*)placeholder
                               passWord:(BOOL)YESorNO
                          leftImageView:(UIImageView*)imageView
                         rightImageView:(UIImageView*)rightImageView
                                   Font:(float)font
                    backgRoundImageName:(NSString*)imageName
{
    UITextField*text= [self createTextFieldWithFrame:frame placeholder:placeholder passWord:YESorNO leftImageView:imageView rightImageView:rightImageView Font:font];
    text.background=[UIImage imageNamed:imageName];
    return  text;
    
}
+(UIScrollView*)makeScrollViewWithFrame:(CGRect)frame andSize:(CGSize)size
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
    
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = size;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    return scrollView ;
}
+(UIPageControl*)makePageControlWithFram:(CGRect)frame
{
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:frame];
    pageControl.numberOfPages = 2;
    pageControl.currentPage = 0;
    return pageControl;
}
+(UISlider*)makeSliderWithFrame:(CGRect)rect AndImage:(UIImage*)image
{
    UISlider *slider = [[UISlider alloc]initWithFrame:rect];
    slider.minimumValue = 0;
    slider.maximumValue = 1;
    [slider setThumbImage:[UIImage imageNamed:@"qiu"] forState:UIControlStateNormal];
    slider.maximumTrackTintColor = [UIColor grayColor];
    slider.minimumTrackTintColor = [UIColor yellowColor];
    slider.continuous = YES;
    slider.enabled = YES;
    return slider ;
}
+(NSString *)stringFromDateWithHourAndMinute:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
   
    return destDateString;
}

#pragma -mark 判断导航的高度
+(float)isIOS7{
    
    float height;
    if (IOS7) {
        height=64.0;
    }else{
        height=44;
    }
    
    return height;
}
//+(NSString *)platformString{
//    // Gets a string with the device model
//    size_t size;
//    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
//    char *machine = malloc(size);
//    sysctlbyname("hw.machine", machine, &size, NULL, 0);
//    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
//    free(machine);
//    NSDictionary* d = nil;
//    if (d == nil)
//    {
//        d = @{
//              @"iPhone1,1": @"iPhone 2G",
//              @"iPhone1,2": @"iPhone 3G",
//              @"iPhone2,1": @"iPhone 3GS",
//              @"iPhone3,1": @"iPhone 4",
//              @"iPhone3,2": @"iPhone 4",
//              @"iPhone3,3": @"iPhone 4 (CDMA)",
//              @"iPhone4,1": @"iPhone 4S",
//              @"iPhone5,1": @"iPhone 5",
//              @"iPhone5,2": @"iPhone 5 (GSM+CDMA)",
//              
//              @"iPod1,1": @"iPod Touch (1 Gen)",
//              @"iPod2,1": @"iPod Touch (2 Gen)",
//              @"iPod3,1": @"iPod Touch (3 Gen)",
//              @"iPod4,1": @"iPod Touch (4 Gen)",
//              @"iPod5,1": @"iPod Touch (5 Gen)",
//              
//              @"iPad1,1": @"iPad",
//              @"iPad1,2": @"iPad 3G",
//              @"iPad2,1": @"iPad 2 (WiFi)",
//              @"iPad2,2": @"iPad 2",
//              @"iPad2,3": @"iPad 2 (CDMA)",
//              @"iPad2,4": @"iPad 2",
//              @"iPad2,5": @"iPad Mini (WiFi)",
//              @"iPad2,6": @"iPad Mini",
//              @"iPad2,7": @"iPad Mini (GSM+CDMA)",
//              @"iPad3,1": @"iPad 3 (WiFi)",
//              @"iPad3,2": @"iPad 3 (GSM+CDMA)",
//              @"iPad3,3": @"iPad 3",
//              @"iPad3,4": @"iPad 4 (WiFi)",
//              @"iPad3,5": @"iPad 4",
//              @"iPad3,6": @"iPad 4 (GSM+CDMA)",
//              
//              @"i386": @"Simulator",
//              @"x86_64": @"Simulator"
//              };
//    }
//    NSString* ret = [d objectForKey: platform];
//    
//    if (ret == nil)
//    {
//        return platform;
//    }
//    return ret;
//}

#pragma mark 内涵图需要的方法
+ (NSString *)stringDateWithTimeInterval:(NSString *)timeInterval
{
    NSTimeInterval seconds = [timeInterval integerValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [format stringFromDate:date];
}

+ (CGFloat)textHeightWithString:(NSString *)text width:(CGFloat)width fontSize:(NSInteger)fontSize
{
    NSDictionary *dict = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    // 根据第一个参数的文本内容，使用280*float最大值的大小，使用系统14号字，返回一个真实的frame size : (280*xxx)!!
    CGRect frame = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return frame.size.height + 5;
}

// 返回一个整数字符串加1后的新字符串
+ (NSString *)addOneByIntegerString:(NSString *)integerString
{
    NSInteger integer = [integerString integerValue];
    return [NSString stringWithFormat:@"%d",integer+1];
}

//字符串转换为日期
+ (NSDate *)dateFromString:(NSString *)dateString formate:(NSString *)formate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formate];
    NSDate *date = [dateFormatter dateFromString:dateString];
    return date;
}
//将日期格式化为NSString对象
+ (NSString *)stringFromDate:(NSDate *)date formate:(NSString *)formate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formate];
    NSString *datestring = [dateFormatter stringFromDate:date];
    return datestring;
}


+(NSInteger)timeSpanStartDay:(NSDate *)startDay withEndDay:(NSDate *)endDay
{

    NSTimeInterval startTime = [startDay timeIntervalSince1970];
    NSTimeInterval endTime = [endDay timeIntervalSince1970];
    CGFloat timeFloat = startTime - endTime;
    CGFloat day = 24*60*60;
    if (timeFloat - day < 0) {
        return 0;
    }else
    {
        return (timeFloat - day);
    }
}

+ (UIImage *) createImageWithColor: (UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage*theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

#pragma mark - 处理圆型图片
+ (void) circleImage:(UIImageView *)img
{
    CALayer *l = [img layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:img.width/2.0];
}

#pragma mark - 处理按钮
+ (void) circleButton:(UIButton *)buttons
{
    buttons.layer.cornerRadius = buttons.width/2;
    buttons.layer.masksToBounds = YES;
}

#pragma mark - 处理按钮
+ (void) circleView:(UIView *)view
{
    view.layer.cornerRadius = view.width/2;
    view.layer.masksToBounds = YES;
}

#pragma mark - 处理label
+ (void) circleLabel:(UILabel *)view
{
    view.layer.cornerRadius = view.width/2;
    view.layer.masksToBounds = YES;
}


#pragma mark 弹提示
+ (void)AlertBox:(NSString *)msg
{
    UIAlertView *alertViews = [[UIAlertView alloc]initWithTitle:@"提示"
                                                        message:msg
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    [alertViews show];
}



#pragma mark - 修改创建时间
+ (NSString *)changeCreatTime:(NSNumber *)creatTime
{
    long long time = [creatTime longLongValue];
    long long  times =  time/1000;
    NSDate *creatDate = [NSDate dateWithTimeIntervalSince1970:times];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"]; //hh:mm:ss
    NSString *dateTime =  [dateFormatter stringFromDate:creatDate];

   return dateTime;
}

+ (NSString *)changeCreatSeconTime:(NSNumber *)creatTime
{
    long long time = [creatTime longLongValue];
    long long  times =  time/1000;
    NSDate *creatDate = [NSDate dateWithTimeIntervalSince1970:times];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"hh:mm:ss"];
    NSString *dateTime =  [dateFormatter stringFromDate:creatDate];
    
    return dateTime;
}

+ (NSString *)changeCreatDateAndTime:(NSNumber *)creatTime
{
    long long time = [creatTime longLongValue];
    long long  times =  time/1000;
    NSDate *creatDate = [NSDate dateWithTimeIntervalSince1970:times];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    NSString *dateTime =  [dateFormatter stringFromDate:creatDate];
    
    return dateTime;
}



+ (UIColor *) colorFromHexRGB:(NSString *) inColorString
{
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    return result;
}





@end
