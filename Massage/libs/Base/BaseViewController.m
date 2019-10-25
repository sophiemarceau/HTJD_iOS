//
//  BaseViewController.m
//  WXMovie
//
//  Created by 牛顿、 on 13-9-4.
//  Copyright (c) 2013年 www.736014814@qq.com牛顿. All rights reserved.
//

#import "BaseViewController.h"
#import "MBProgressHUD.h"
#import "MainViewController.h"
#import "AppDelegate.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.isModalButton = NO;
        self.isBackButton = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

//    if (self.navigationController.viewControllers.count > 1) {
//        self.isBackButton = YES;
//    }
    /*
     if (self.isBackButton ||self.isModalButton) {
     //创建返回的按钮
     UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
     button.showsTouchWhenHighlighted = YES;
     [button setImage:[UIImage imageNamed:@"arraw_back_17x32.png"] forState:UIControlStateNormal];
     [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
     button.frame = CGRectMake(0, 0, 13, 24);
     
     UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
     self.navigationItem.leftBarButtonItem = item;
     }
     
     if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
     self.navigationController.interactivePopGestureRecognizer.enabled = NO;
     }
     */
    
    //设置背景
    self.view.backgroundColor = C2UIColorGray;
//    self.view.backgroundColor =[UIColor blackColor];
    
//    BaseNavView *navView = [[BaseNavView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
//    navView.backgroundColor = [UIColor colorWithRed:0 green:170.0/255.0 blue:250.0/255.0 alpha:1.0f];
//    self.navView = navView;
    [self.view addSubview:self.navView];
    
    self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)];
    [self.view addSubview:self.contentView];

    
    
    if (self.navigationController.viewControllers.count > 1) {
//        NSLog(@"self.navigationController.viewControllers.count -- > %lu",self.navigationController.viewControllers.count);
//        if (self.isBackButton ||self.isModalButton) {
            //创建返回的按钮
//            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//            button.showsTouchWhenHighlighted = YES;
//            [button setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
//            [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
//            button.frame = CGRectMake(20, 20+(44-22)/2, 12, 22);  //125 × 49
        UIView * button = [[UIView alloc] initWithFrame:CGRectMake(0, 20+7, 60, 30)];
        button.userInteractionEnabled = YES;
        button.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer * buttonTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backAction)];
        [button addGestureRecognizer:buttonTap];
        UIImageView * imv = [[UIImageView alloc] initWithFrame:CGRectMake(15, 6, 10, 17)];
        imv.image = [UIImage imageNamed:@"icon_sd_back"];
        [button addSubview:imv];
            [self.navView addSubview:button];
//        }
    }
}

- (void)setTitles:(NSString *)titles
{
    if (_titles != titles) {
        _titles = titles;
        self.navView.title = titles;
    }
}

- (BaseNavView *)navView
{
    if (!_navView) {
        _navView = [[BaseNavView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
//        _navView.backgroundColor = [UIColor colorWithRed:0 green:170.0/255.0 blue:250.0/255.0 alpha:1.0f];
        
        _navView.backgroundColor   =RedUIColorC1;
    }
    return _navView;
}




-(void)backAction
{
//    if (self.isBackFromOrderPay) {
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"本次订单还未付款,返回后将退出当前界面，您可在我的订单中继续操作此订单，是否退出当前界面" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
//        alert.tag = 1001;
//        [alert show];
////        [self.navigationController popToRootViewControllerAnimated:YES];
//
//        return;
//    }
    if (self.isModalButton)
    {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    
//    if (buttonIndex == 0) {
//        return;
//    }
//    if (buttonIndex == 1) {
//        [self.navigationController popToRootViewControllerAnimated:YES];
//        return;
////        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
////        MainViewController  *mainVC= (MainViewController *) appDelegate.window.rootViewController;
////        
////        UIButton *tempbutton =[[UIButton alloc]init];
////        tempbutton.tag =3;
////        [mainVC selectorAction:tempbutton];
//    }
//    
//    
//}


@end
