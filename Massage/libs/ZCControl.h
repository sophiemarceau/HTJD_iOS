//
//  ZCControl.h
//  Device
//
//  Created by ZhangCheng on 14-4-19.
//  Copyright (c) 2014年 zhangcheng. All rights reserved.
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ZCControl : NSObject



//#if TARGET_IPHONE_SIMULATOR


//#elif TARGET_OS_IPHONE
//
////真机获取物理屏幕的尺寸
//#define kScreenHeight [UIScreen mainScreen].bounds.size.width-20
//#define kScreenWidth  [UIScreen mainScreen].bounds.size.height
//
//#endif

#pragma mark --判断设备型号
+(NSString *)platformString;
#pragma mark --创建Label
+(UILabel *)createLabelWithFrame:(CGRect )frame Font:(int)font Text:(NSString*)text;
+(UILabel *)createLabelLineFrame:(CGRect )frame;
#pragma mark --创建View
+(UIView *)viewWithFrame:(CGRect)frame;
#pragma mark --创建imageView
+(UIImageView *)createImageViewWithFrame:(CGRect)frame ImageName:(NSString*)imageName;
#pragma mark --创建button
+(UIButton *)createButtonWithFrame:(CGRect)frame ImageName:(NSString*)imageName Target:(id)target Action:(SEL)action Title:(NSString*)title;
#pragma mark --创建UITextField
+(UITextField*)createTextFieldWithFrame:(CGRect)frame placeholder:(NSString*)placeholder passWord:(BOOL)YESorNO leftImageView:(UIImageView*)imageView rightImageView:(UIImageView*)rightImageView Font:(float)font;

//适配器的方法  扩展性方法
//现有方法，已经在工程里面存在，如果修改工程内所有方法，工作量巨大，就需要使用适配器的方法
+(UITextField*)createTextFieldWithFrame:(CGRect)frame placeholder:(NSString*)placeholder passWord:(BOOL)YESorNO leftImageView:(UIImageView*)imageView rightImageView:(UIImageView*)rightImageView Font:(float)font backgRoundImageName:(NSString*)imageName;
#pragma mark 创建UIScrollView
+(UIScrollView*)makeScrollViewWithFrame:(CGRect)frame andSize:(CGSize)size;
#pragma mark 创建UIPageControl
+(UIPageControl*)makePageControlWithFram:(CGRect)frame;
#pragma mark 创建UISlider
+(UISlider*)makeSliderWithFrame:(CGRect)rect AndImage:(UIImage*)image;
#pragma mark 创建时间转换字符串
+(NSString *)stringFromDateWithHourAndMinute:(NSDate *)date;
+ (NSString *)stringFromDate:(NSDate *)date formate:(NSString *)formate;
+ (NSDate *)dateFromString:(NSString *)dateString formate:(NSString *)formate;
#pragma mark --判断导航的高度64or44
+(float)isIOS7;

#pragma mark 内涵图需要的方法
+ (NSString *)stringDateWithTimeInterval:(NSString *)timeInterval;

+ (CGFloat)textHeightWithString:(NSString *)text width:(CGFloat)width fontSize:(NSInteger)fontSize;

+ (NSString *)addOneByIntegerString:(NSString *)integerString;

#pragma mark 比较时间
+(NSInteger)timeSpanStartDay:(NSDate *)startDay withEndDay:(NSDate *)endDay;

#pragma mark 颜色转换为图片
+ (UIImage *) createImageWithColor: (UIColor*) color;

#pragma mark - 处理圆型图片
+ (void) circleImage:(UIImageView *)img;

#pragma mark - 处理圆形按钮
+ (void) circleButton:(UIButton *)buttons;
#pragma mark - 处理圆形图片
+ (void) circleView:(UIView *)view;

#pragma mark - 处理label
+ (void) circleLabel:(UILabel *)view;


#pragma mark - 弹出视图
+ (void)presentModalFromController:(UIViewController *)fromController
                      toController:(UIViewController *)toController
                       isHiddenNav:(BOOL)isHiddenNav
                             Width:(CGFloat)w
                            Height:(CGFloat)h;

#pragma mark -iOS7重新设置nav的宽高
+ (void)presentNavController:(UIViewController *)toController
                       Width:(CGFloat)width
                      Height:(CGFloat)height;

#pragma mark - 弹提示
+ (void)AlertBox:(NSString *)msg;


#pragma mark - 判断当前图片的类型
+ (NSString *)imgTypeCatagory:(NSString *)catagory;

#pragma mark - 修改创建时间
+ (NSString *)changeCreatTime:(NSNumber *)creatTime;  //年月日
+ (NSString *)changeCreatSeconTime:(NSNumber *)creatTime; //时分秒
+ (NSString *)changeCreatDateAndTime:(NSNumber *)creatTime;//年月日+时分秒
#pragma mark - 三色值
+ (UIColor *) colorFromHexRGB:(NSString *) inColorString;

@end
