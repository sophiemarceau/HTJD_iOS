//
//  AppDelegate.h
//  Massage
//
//  Created by 屈小波 on 14-10-16.
//  Copyright (c) 2014年 sophiemarceau_qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "WXApi.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate>
{

}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MainViewController *mainController;
@property float autoSizeScaleX;
@property (strong, nonatomic) UIView *ADView;
@property float autoSizeScaleY;
@property (strong, nonatomic) NSString *url;
- (void)onMain;
- (void)loginWithUsername:(NSString *)username password:(NSString *)password;
- (void)logoutAction;

@end

