//
//  AppDelegate.m
//  Massage
//
//  Created by 屈小波 on 14-10-16.
//  Copyright (c) 2014年 sophiemarceau_qu. All rights reserved.
//

#import "AppDelegate.h"

#import "AFNetworkActivityIndicatorManager.h"
#import <MAMapKit/MAMapKit.h>
#import "BaseNavgationController.h"
#import "payRequsestHandler.h"
#import "BaseNavgationController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "APIKey.h"
#import "ConfigData.h"
#import "GuideViewController.h"
#import "UMessage.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"

#import "LCProgressHUD.h"
#import "MobClick.h"

#import "firstFigureViewController.h"
#import "UIImageView+WebCache.h"
#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define _IPHONE80_ 80000

@interface AppDelegate (){
    UINavigationController *nav;
    BOOL openByUM;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    Class cls = NSClassFromString(@"UMANUtil");
//    SEL deviceIDSelector = @selector(openUDIDString);
//    NSString *deviceID = nil;
//    if(cls && [cls respondsToSelector:deviceIDSelector]){
//        deviceID = [cls performSelector:deviceIDSelector];
//    }
//    
//    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:@{@"oid" : deviceID}
//                                                       options:NSJSONWritingPrettyPrinted
//                                                         error:nil];
//    
//    NSLog(@"%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
// 
    
//    [MobClick setCrashReportEnabled:YES]; // 如果不需要捕捉异常，注释掉此行
    
    openByUM = NO;
    
    //分享
    [UMSocialData setAppKey:UMENG_APPKEY];
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:UMENG_APPKEY appSecret:@"2bqzk8meuh3a7jd7tip95qahrsjcaj7h" url:@"http://www.huatuojiadao.com"];
    //添加"复制链接"的自定义按钮
    UMSocialSnsPlatform *snsPlatform = [[UMSocialSnsPlatform alloc] initWithPlatformName:@"CustomPlatform"];
    snsPlatform.displayName = @"复制链接";
    snsPlatform.bigImageName = @"icon_share_Link";
    snsPlatform.snsClickHandler = ^(UIViewController *presentingController, UMSocialControllerService * socialControllerService, BOOL isPresentInController){
        NSLog(@"点击自定义平台的响应");
        UIPasteboard*pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.url;
        if (pasteboard == nil) {
            [LCProgressHUD showMessage:@"复制链接失败"];
        }else {
            [LCProgressHUD showMessage:@"已复制到剪切板"];
        }
        
    };
    [UMSocialConfig addSocialSnsPlatform:@[snsPlatform]];
    //设置你要在分享面板中出现的平台
    [UMSocialConfig setSnsPlatformNames:@[UMShareToWechatSession,UMShareToWechatTimeline,@"CustomPlatform"]];
    
    //推送
    [UMessage startWithAppkey:UMENG_APPKEY launchOptions:launchOptions];

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    if(UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        //register remoteNotification types （iOS 8.0及其以上版本）
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"action1_identifier";
        action1.title=@"Accept";
        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
        action2.identifier = @"action2_identifier";
        action2.title=@"Reject";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.destructive = YES;
        
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"category1";//这组动作的唯一标示
        [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
        
        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                     categories:[NSSet setWithObject:categorys]];
        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
        
    } else{
        //register remoteNotification types (iOS 8.0以下)
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
         |UIRemoteNotificationTypeSound
         |UIRemoteNotificationTypeAlert];
    }
#else
    
    //register remoteNotification types (iOS 8.0以下)
    [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
     |UIRemoteNotificationTypeSound
     |UIRemoteNotificationTypeAlert];
    
#endif
    //for log
    [UMessage setLogEnabled:YES];
    
      
    
    [self configureAPIKey];
    

    
    [MobClick setLogEnabled:NO];        // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
//    [MobClick setLogEnabled:YES];
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:(ReportPolicy) BATCH channelId:nil];//BATCH为启动时发送 REALTIME
//    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:(ReportPolicy) REALTIME channelId:nil];//REALTIME为测试使用
    
    //向微信注册
    [WXApi registerApp:APP_ID withDescription:@"Massage3.0.3"];
    [NSThread sleepForTimeInterval:1.5];
    

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onMain) name:NOTIFICATION_NAME_USER_LOGOUT object:nil];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                                                             categories:nil]];  
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        //这里还是原来的代码
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
    //推送通知
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        openByUM = YES;
        NDLog(@"点击推送进入app");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UMPushNotification"
                                                                object:nil userInfo:userInfo];
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor clearColor];
    
    //开启网络管理
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    //设置状态栏
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    [self.window makeKeyAndVisible];

    BOOL isLaunch = [[ConfigData sharedInstance]isFirstLaunch];
   
    if (isLaunch) {
        [self _intoGuideViewController];
    }else
    {
        [self onMain];
//        [self onFirstfigure];
        
//        [[RequestManager shareRequestManager] getfirstFigure:nil viewController:nil successData:^(NSDictionary *result) {
//            NSLog(@"客户端首图result  %@",result);
//            NSURL * url = [NSURL URLWithString:[result objectForKey:@"firstFigureUrl"]];
//            //                    NSURL * url = [NSURL URLWithString:  @"http://www.jerehedu.com/images/temp/logo.gif"];
//            
//            //        SDWebImageDownloader * downloader = [SDWebImageDownloader sharedDownloader];
//            //        [downloader downloadImageWithURL:url options:SDWebImageDownloaderUseNSURLCache progress:NULL completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
//            //            [[SDImageCache sharedImageCache] storeImage:image forKey:@"aaa"];
//            //            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NAME_USER_LOGOUT object:nil];
//            //
//            //        }];
//            
////            _ADView = [[NSBundle mainBundle ]loadNibNamed:@"LaunchScreen" owner:nil options:nil][0];
//
//            _ADView = [[UIView alloc] init ];
//            _ADView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
//            [self.window addSubview:_ADView];
//            UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
//            [imageV setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
//            [_ADView addSubview:imageV];
//            [self.window bringSubviewToFront:_ADView];
//            [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(removeADView) userInfo:nil repeats:NO];
//            
//        } failuer:^(NSError *error) {
//            NSLog(@"加载失败");
//        }];
 
        
    }

//    _ADView = [[NSBundle mainBundle ]loadNibNamed:@"LaunchScreen" owner:nil options:nil][0];
    
    
//    Class cls = NSClassFromString(@"UMANUtil");
//    SEL deviceIDSelector = @selector(openUDIDString);
//    NSString *deviceID = nil;
//    if(cls && [cls respondsToSelector:deviceIDSelector]){
//        deviceID = [cls performSelector:deviceIDSelector];
//    }
//    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:@{@"oid" : deviceID}
//                                                       options:NSJSONWritingPrettyPrinted
//                                                         error:nil];
//    
//    NSLog(@"jsonData %@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
    return YES;
}

-(void)removeADView
{
    [_ADView removeFromSuperview];
//    [self onMain];
}
#pragma mark - intoController

- (void)_intoGuideViewController
{
    GuideViewController *guid = [[GuideViewController alloc]init];
    self.window.rootViewController = guid;
}

- (void)configureAPIKey
{
    if ([APIKey length] == 0)
    {
        NSString *reason = [NSString stringWithFormat:@"apiKey为空，请检查key是否正确设置。"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:reason delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    
    [MAMapServices sharedServices].apiKey = (NSString *)APIKey;
}

-(void)onFirstfigure
{
    firstFigureViewController * vc = [[firstFigureViewController alloc] init];
    self.window.rootViewController = vc;

}

- (void)onMain
{
    MainViewController *main = [[MainViewController alloc]initWithNibName:@"MainViewController" bundle:nil];
    self.mainController = main;
    BaseNavgationController *baseNav =[[BaseNavgationController alloc] initWithRootViewController:main];
    
    self.window.rootViewController =baseNav;
}



//登出
- (void)onLogoffChange:(id)sender{
    //清除用户信息
    [UserModel deletUserInfo];
    //退回登录页面
    [self loginController];
    //退出环信账号
    [self logoutAction];
}

- (void)loginController
{
//    LoginViewController *login = [[LoginViewController alloc]init];
//    BaseNavgationController *baseNav = [[BaseNavgationController alloc]initWithRootViewController:login];
//    self.window.rootViewController = baseNav;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSUserDefaults *userDetaults = [NSUserDefaults standardUserDefaults];

    [userDetaults setBool:NO forKey:@"firstLaunch"];
//    [userDetaults setBool:NO forKey:@"firstLaunchCity"];
    [userDetaults synchronize];
    [RequestManager shareRequestManager].canuUMPush = YES;

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"从后台进入到了app");

    [[NSNotificationCenter defaultCenter] postNotificationName:@"checkVersion" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadSecKill" object:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [RequestManager shareRequestManager].canuUMPush = NO;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSUserDefaults *userDetaults = [NSUserDefaults standardUserDefaults];
    
    [userDetaults setBool:NO forKey:@"firstLaunch"];

    [userDetaults synchronize];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString *deviceTokenStr = [NSString stringWithFormat:@"%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                                                  stringByReplacingOccurrencesOfString: @">" withString: @""]
                                                                 stringByReplacingOccurrencesOfString: @" " withString: @""]];
    
    NDLog(@"deviceToken:-->%@",deviceTokenStr);
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"deviceToken"];
    [userDefaults setValue:deviceTokenStr forKey:@"deviceToken"];
    
    [UMessage registerDeviceToken:deviceToken];
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *) error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required
    [UMessage didReceiveRemoteNotification:userInfo];
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"UMPushNotificaiton"
//                                                        object:userInfo] ;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {

    NSLog(@"openURL----------->%@", [[url scheme] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
    if ([[[url scheme] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] isEqualToString:@"huatuojiadaoiOS"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        return YES;
    }else{
        NSLog(@"openURL----------->%@", url);

        return [WXApi handleOpenURL:url delegate:self];
    }
   
}

#ifdef __IPHONE_7_0
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    //关闭友盟对话框
//    [UMessage setAutoAlert:NO]; 

    NSLog(@"[RequestManager shareRequestManager].canuUMPush  %d",[RequestManager shareRequestManager].canuUMPush);
    
    if ([RequestManager shareRequestManager].canuUMPush||openByUM) {
        [UMessage didReceiveRemoteNotification:userInfo];
        
        NDLog(@"userinfo-------------------------------->%@",userInfo);
        NDLog(@"userinfo-------------------------------->%@",completionHandler);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UMPushNotification"
                                                            object:nil userInfo:userInfo];
        [RequestManager shareRequestManager].canuUMPush = NO;

    }
    
    
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    {
        NSString * msg = [NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]];
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                         message:msg
                                                        delegate:self
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil];
//        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    [UMessage sendClickReportForRemoteNotification:self.userInfo];
}
#endif

#pragma WeiXinPay
-(void)onReq:(BaseReq *)req{
//    if([req isKindOfClass:[GetMessageFromWXReq class]])
//    {
//        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
//        NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
//        NSString *strMsg = @"微信请求App提供内容，App要调用sendResp:GetMessageFromWXResp返回给微信";
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        alert.tag = 1000;
//        [alert show];
//        
//    }
//    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
//    {
//        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
//        WXMediaMessage *msg = temp.message;
//        
//        //显示微信传过来的内容
//        WXAppExtendObject *obj = msg.mediaObject;
//        
//        NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
//        NSString *strMsg = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%lu bytes\n\n", msg.title, msg.description, obj.extInfo, msg.thumbData.length];
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//        
//    }
//    else if([req isKindOfClass:[LaunchFromWXReq class]])
//    {
//        //从微信启动App
//        NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
//        NSString *strMsg = @"这是从微信启动的消息";
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//        
//    }
    
}

-(void)onResp:(BaseResp *)resp{

    NSString *strTitle;
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        if (resp.errCode == WXSuccess ) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"wechatMessaage"  object:@{@"returnCode":@"0" ,@"requestflag":@"支付订单成功"}];
        }else if(resp.errCode == WXErrCodeUserCancel){

                [[NSNotificationCenter defaultCenter] postNotificationName:@"wechatMessaage"  object:@{@"returnCode":@"-2" ,@"requestflag":@"您中途取消了 订单支付"}];
        }else {
            
        }
        
//        switch (resp.errCode) {
//            case WXSuccess:
//                strMsg = @"支付结果：成功！";
//                NSLog(@"wechat----------------------支付成功－PaySuccess，retcode = %d", resp.errCode);
//                
//                [[RequestManager shareRequestManager] tipAlert:@"提交订单成功 请您在我的订单中 查看您的订单状态" viewController:self.mainController];
//                [self performSelector:@selector(delayShow) withObject:self afterDelay:3.0];
//                
//
//                UIButton *tempbutton =[[UIButton alloc]init];
//                tempbutton.tag =3;
//                [self.mainController selectorAction:tempbutton];
//                
//                break;
//            case WXErrCodeUserCancel:
//                strMsg = @"您已取消支付";
//                NSLog(@"wechat----------------------支付取消－PaySuccess，retcode = %d", resp.errCode);
//                [[RequestManager shareRequestManager] tipAlert:@"您中途取消了 订单支付" viewController:self.mainController];
//                break;
//            default:
//                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
//                NSLog(@"wechat----------------------错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
//                break;
//        }
    }
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
    
}

@end
