//
//  CommentMethod.m
//  IELTSStudent
//
//  Created by Hello酷狗 on 15/6/5.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "CommentMethod.h"

@implementation CommentMethod

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
    [l setCornerRadius:img.frame.size.width/2.0];
}

#pragma mark - 处理按钮
+ (void) circleButton:(UIButton *)buttons
{
    buttons.layer.cornerRadius = buttons.frame.size.width/2;
    buttons.layer.masksToBounds = YES;
}

#pragma mark - 处理按钮
+ (void) circleView:(UIView *)view
{
    view.layer.cornerRadius = view.frame.size.width/2;
    view.layer.masksToBounds = YES;
}

#pragma mark - 处理label
+ (void) circleLabel:(UILabel *)view
{
    view.layer.cornerRadius = view.frame.size.width/2;
    view.layer.masksToBounds = YES;
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


+(UILabel*)createLabelWithFont:(int)font Text:(NSString*)text
{
    UILabel*label=[UILabel new];
    //限制行数
    label.numberOfLines=0;
    //对齐方式
    label.textAlignment=NSTextAlignmentLeft;
    label.backgroundColor=[UIColor clearColor];
    label.font=[UIFont systemFontOfSize:font];
    //单词折行
//    label.lineBreakMode=NSLineBreakByWordWrapping;
    //默认字体颜色是黑色
    label.textColor=[UIColor whiteColor];
    //自适应（行数~字体大小按照设置大小进行设置）
    label.adjustsFontSizeToFitWidth=YES;
    label.text=text;
    return label;
}

//名称 字体颜色 背景颜色 字体对齐方式 字体大小
+(UILabel*)createLabelWithText:(NSString*)text  TextColor:(UIColor *)textcolor BgColor:(UIColor *)bgColor TextAlignment:(NSTextAlignment)alignment Font:(int )font
{
    UILabel*label=[[UILabel alloc] init];
    //名称
    label.text=text;
    //字体颜色
    label.textColor= textcolor;
    //背景颜色
    label.backgroundColor= bgColor;
    //对齐方式
//    label.textAlignment= alignment;
    //字体大小
    label.font=[UIFont systemFontOfSize:font];
    
    //限制行数
    label.numberOfLines=0;
    //单词折行
//    label.lineBreakMode=NSLineBreakByCharWrapping;
//    label.lineBreakMode=NSLineBreakByTruncatingMiddle;
//    自适应（行数~字体大小按照设置大小进行设置）
    label.adjustsFontSizeToFitWidth=YES;
    label.userInteractionEnabled = YES;
    return label;
}
+(UILabel*)initLabelWithText:(NSString*)text textAlignment:(NSTextAlignment)alignment font:(CGFloat)font{
    UILabel*label=[[UILabel alloc] init];
    //名称
    label.text=text;
    //对齐方式
    label.textAlignment= alignment;
    //字体大小
    label.font=[UIFont systemFontOfSize:font];
    return label;
}

#pragma mark --创建UIImageView

+(UIImageView *)createImageViewWithImageName:(NSString*)imageName
{
    UIImageView *imageView=[UIImageView new];
    imageView.image=[UIImage imageNamed:imageName];
    imageView.userInteractionEnabled=YES;
    return imageView ;
}

#pragma mark --创建button
+(UIButton *)createButtonWithImageName:(NSString*)imageName Target:(id)target Action:(SEL)action Title:(NSString*)title
{
    UIButton*button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    button.titleLabel.textColor = [UIColor whiteColor];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //设置背景图片，可以使文字与图片共存
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    //图片与文字如果需要同时存在，就需要图片足够小 详见人人项目按钮设置
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}
//背景色＋按钮名称
+(UIButton *)createButtonWithBackgroundColor:(UIColor *)BgColor Target:(id)target Action:(SEL)action Title:(NSString*)title FontColor:(UIColor *)FontColor FontSize:(float)fontsize
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:fontsize];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:FontColor forState:UIControlStateNormal];
    [button setBackgroundColor:BgColor];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
    
}
//背景图片＋按钮名称
+(UIButton *)createButtonWithBackgroundImage:(UIImage *)image Target:(id)target Action:(SEL)action Title:(NSString*)title
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

#pragma mark --创建UITextField
+(UITextField *)createTextFieldWithPlaceholder:(NSString*)placeholder passWord:(BOOL)YESorNO Font:(float)font
{
    UITextField *textField=[UITextField new];
    //灰色提示框
    textField.placeholder=placeholder;
    //设置光标颜色
    textField.tintColor = [UIColor whiteColor];
    textField.textColor = [UIColor whiteColor];
    //文字对齐方式
    textField.secureTextEntry=YESorNO;
    //边框
    textField.borderStyle = UITextBorderStyleNone;
    //键盘类型
    textField.keyboardType = UIKeyboardTypeDefault;
    //关闭首字母大写
    textField.autocapitalizationType=NO;
    //清除按钮
    textField.clearButtonMode=UITextFieldViewModeAlways;
    
    //字体
    textField.font=[UIFont systemFontOfSize:font];
    return textField ;
}

+(UITextField *)createTextFieldWithPlaceholder:(NSString*)placeholder TextColor:(UIColor *)textcolor Font:(float)font KeyboardType:(UIKeyboardType)keyboardType
{
    UITextField *textField=[UITextField new];
    //灰色提示框
    textField.placeholder=placeholder;
    //设置光标颜色
    textField.tintColor = [UIColor whiteColor];
    textField.textColor = textcolor;
    //边框
    textField.borderStyle = UITextBorderStyleNone;
    //键盘类型
    textField.keyboardType = keyboardType;
    //关闭首字母大写
    textField.autocapitalizationType=NO;
    //清除按钮
    textField.clearButtonMode=UITextFieldViewModeAlways;
    
    //字体
    textField.font=[UIFont systemFontOfSize:font];
    return textField ;
}

+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+(CGSize)widthForNickName:(NSString *)nickName testLablWidth:(NSInteger)width textLabelFont:(NSInteger)font
{
    CGSize textBlockMinSize = {width, CGFLOAT_MAX};
    CGSize size;
    
    static float systemVersion;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    });
    if (systemVersion >= 7.0) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        size = [nickName boundingRectWithSize:textBlockMinSize options:NSStringDrawingTruncatesLastVisibleLine |
                NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                   attributes:@{
                                                NSFontAttributeName:[[self class] textLabelFont:font],
                                                NSParagraphStyleAttributeName:paragraphStyle
                                                }
                                      context:nil].size;
    }
    else{
        size = [nickName sizeWithFont:[[self class ] textLabelFont:font]
                    constrainedToSize:textBlockMinSize
                        lineBreakMode:NSLineBreakByCharWrapping];
    }
    return size;
}

+(UIFont *)textLabelFont:(NSInteger)font
{
    return [UIFont systemFontOfSize:font*AUTO_SIZE_SCALE_X];
}



@end
