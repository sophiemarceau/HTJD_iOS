//
//  BaseNavgationController.m
//  YouYiLian
//
//  Created by DevNiudun on 15/3/19.
//  Copyright (c) 2015年 niudun. All rights reserved.
//

#import "BaseNavgationController.h"

@interface BaseNavgationController ()

@end

@implementation BaseNavgationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    //set NavigationBar 背景颜色&title 颜色
//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:20/255.0 green:155/255.0 blue:213/255.0 alpha:1.0]];
//    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];
    
    //@{}代表Dictionary
//    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.071 green:0.060 blue:0.086 alpha:1.000]];
    //    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    /* 
     //6月1日修改
     
     [self.navigationBar setBackgroundImage:[ZCControl createImageWithColor:RGBACOLOR(0, 170, 250, 1.0)] forBarMetrics:UIBarMetricsDefault];
     
     self.navigationBar.translucent = NO;

     
     [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
     
     [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
     
     [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
     [UIColor whiteColor], NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:16.0f], NSFontAttributeName, nil]];
     
     
     [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
     */
    
    self.navigationBarHidden = YES;
    self.interactivePopGestureRecognizer.delegate =(id)self; //右滑
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor], NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:16.0f], NSFontAttributeName, nil]];
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
}


#pragma mark 自定义push动画
- (void)pushViewController:(UIViewController *)viewController direction:(TransitionDirection)direction
{
    NSString *subType = nil;
    switch (direction) {
        case TransitionLeft:
            subType = kCATransitionFromLeft;
            break;
        case TransitionRight:
            subType = kCATransitionFromRight;
            break;
        case TransitionTop:
            subType = kCATransitionFromTop;
            break;
        case TransitionBottom:
            subType = kCATransitionFromBottom;
            break;
        default:
            subType = kCATransitionFromLeft;
            break;
    }
    CATransition *transition = [CATransition animation];
    transition.duration = 0.35f;
    transition.timingFunction = UIViewAnimationCurveEaseInOut;
    transition.type = kCATransitionPush;
    transition.subtype = subType;
    transition.fillMode=kCAFillModeForwards;
    [self.view.layer addAnimation:transition forKey:@"animation"];
    [super pushViewController:viewController animated:NO];
    
    
}

@end
