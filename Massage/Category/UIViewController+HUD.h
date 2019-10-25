/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface UIViewController (HUD)

- (void)showHudInView:(UIView *)view hint:(NSString *)hint;

- (void)hideHud;

- (void)showHint:(NSString *)hint;
- (void)showHintNoHide:(NSString *)hint;

// 从默认(showHint:)显示的位置再往上(下)yOffset
- (void)showHint:(NSString *)hint yOffset:(float)yOffset;



////加载提示
//- (void) showLoading:(BOOL)show;
////显示hud加载提示
//- (void) showHud:(NSString *)title;
////两种隐藏hud的方式
//- (void)hideHudWithComplete:(NSString *)title; //隐藏之前显示操作完成的提示


@property(nonatomic,strong)MBProgressHUD *hud;

@end
