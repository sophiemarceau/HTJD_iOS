//
//  CommentMethod.h
//  IELTSStudent
//
//  Created by Hello酷狗 on 15/6/5.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentMethod : NSObject

#pragma mark - RGB颜色值
+ (UIColor *) colorFromHexRGB:(NSString *) inColorString;

#pragma mark - 解析Json
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

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

#pragma mark --创建Label
+(UILabel*)createLabelWithFont:(int)font Text:(NSString*)text;
+(UILabel*)createLabelWithText:(NSString*)text  TextColor:(UIColor *)textcolor BgColor:(UIColor *)bgColor TextAlignment:(NSTextAlignment)alignment Font:(int )font;
+(UILabel*)initLabelWithText:(NSString*)text textAlignment:(NSTextAlignment)alignment font:(CGFloat)font;

#pragma mark --创建imageView
+(UIImageView *)createImageViewWithImageName:(NSString*)imageName;


#pragma mark --创建button
+(UIButton *)createButtonWithImageName:(NSString*)imageName Target:(id)target Action:(SEL)action Title:(NSString*)title;
+(UIButton *)createButtonWithBackgroundColor:(UIColor *)BgColor Target:(id)target Action:(SEL)action Title:(NSString*)title FontColor:(UIColor *)FontColor FontSize:(float)fontsize;
+(UIButton *)createButtonWithBackgroundImage:(UIImage *)image Target:(id)target Action:(SEL)action Title:(NSString*)title;
#pragma mark --创建UITextField
+(UITextField*)createTextFieldWithPlaceholder:(NSString*)placeholder passWord:(BOOL)YESorNO Font:(float)font;

+(UITextField *)createTextFieldWithPlaceholder:(NSString*)placeholder Font:(float)font;

+(UITextField *)createTextFieldWithPlaceholder:(NSString*)placeholder TextColor:(UIColor *)textcolor Font:(float)font KeyboardType:(UIKeyboardType)keyboardType;
#pragma mark - 
+(CGSize)widthForNickName:(NSString *)nickName testLablWidth:(NSInteger)width textLabelFont:(NSInteger)font;


@end
