//
//  MainViewController.m
//  Massage
//
//  Created by sophiemarceau_qu on 15/5/25.
//  Copyright (c) 2015年 sophiemarceau_qu. All rights reserved.
//

#import "MainViewController.h"
#import "BaseNavgationController.h"
#import "AFNetworkReachabilityManager.h"
#import <CoreLocation/CoreLocation.h>
#import "Reachability.h"
#import "CCLocationManager.h"
#import "StoreServiceHomePageViewController.h"
#import "DoorServiceHomePageViewController.h"
#import "OrderListViewController.h"
#import "MyPersonalInfoViewController.h"
#import "LoveHealthyViewController.h"
#import "LoginViewController.h"
#import <AMapSearchKit/AMapSearchKit.h>


#import "StoreDetailViewController.h"
#import "TechnicianMyselfViewController.h"
#import "ServiceDetailViewController.h"
#import "LoveHealthyViewController.h"
#import "DetailFoundViewController.h"
#import "StoreFoundViewController.h"
#import "ServiceFoundViewController.h"
#import "WorkerFoundViewController.h"
#import "ConfigData.h"
#import "WaitForStoreServiceViewController.h"

#import "SDWebImageManager.h"

#import "StoreDetailViewController.h"
#import "ServiceDetailViewController.h"
#import "TechnicianMyselfViewController.h"
#import "technicianViewController.h"

#import "StoreActivityViewController.h"
#import "ServiceActivityViewController.h"
#import "WorkerActivityViewController.h"
//#import "LCProgressHUD.h"

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#import "MobClick.h"

@interface MainViewController  ()<UINavigationControllerDelegate,CLLocationManagerDelegate,AMapSearchDelegate ,UIAlertViewDelegate>//HomeViewControllerDelegate
{
    UIImageView *_selectImageView;
    NSArray * selectArray;
    NSArray * norArray;
    NSArray * labeltextArray;
    
    NSMutableDictionary * currentLocationDic;
    
    UIView * redView;
    
    UIActivityIndicatorView *       activityIndicator;
    UIView * bgView;
    
    NSString *UMpushType;
    NSDictionary *UMpushInfo;
    
    UIView *ADView;
    BOOL firstUse;
    
    NSString * firstFigureUrl;
    
    UILabel * CountdownLabel;
    int CountdownNum;
    
    BOOL canUMPush;
}

@property (nonatomic,strong)UIButton *tabButton;
@property(nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) UIView *navView;
@property (strong, nonatomic) UIView *searchView;
@property (nonatomic, strong) AMapSearchAPI *search;

@end

@implementation MainViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    
    //     [RequestManager shareRequestManager].hasNetWork = [self isConnectionAvailable];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    
    
}

- (NSString *) macaddress
{
    //    int                    mib[6];
    //    size_t                len;
    //    char                *buf;
    //    unsigned char        *ptr;
    //    struct if_msghdr    *ifm;
    //    struct sockaddr_dl    *sdl;
    //
    //    mib[0] = CTL_NET;
    //    mib[1] = AF_ROUTE;
    //    mib[2] = 0;
    //    mib[3] = AF_LINK;
    //    mib[4] = NET_RT_IFLIST;
    //
    //    if ((mib[5] = if_nametoindex("en0")) == 0) {
    //        printf("Error: if_nametoindex error/n");
    //        return NULL;
    //    }
    //
    //    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
    //        printf("Error: sysctl, take 1/n");
    //        return NULL;
    //    }
    //
    //    if ((buf = malloc(len)) == NULL) {
    //        printf("Could not allocate memory. error!/n");
    //        return NULL;
    //    }
    //
    //    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
    //        printf("Error: sysctl, take 2");
    //        return NULL;
    //    }
    //
    //    ifm = (struct if_msghdr *)buf;
    //    sdl = (struct sockaddr_dl *)(ifm + 1);
    //    ptr = (unsigned char *)LLADDR(sdl);
    //    // NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    //    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    //    free(buf);
    //    return [outstring uppercaseString];
    int                 mgmtInfoBase[6];
    char                *msgBuffer = NULL;
    size_t              length;
    unsigned char       macAddress[6];
    struct if_msghdr    *interfaceMsgStruct;
    struct sockaddr_dl  *socketStruct;
    NSString            *errorFlag = NULL;
    
    // Setup the management Information Base (mib)
    mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
    mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
    mgmtInfoBase[2] = 0;
    mgmtInfoBase[3] = AF_LINK;        // Request link layer information
    mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
    
    // With all configured interfaces requested, get handle index
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
        errorFlag = @"if_nametoindex failure";
    else
    {
        // Get the size of the data available (store in len)
        if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)
            errorFlag = @"sysctl mgmtInfoBase failure";
        else
        {
            // Alloc memory based on above call
            if ((msgBuffer = malloc(length)) == NULL)
                errorFlag = @"buffer allocation failure";
            else
            {
                // Get system information, store in buffer
                if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
                    errorFlag = @"sysctl msgBuffer failure";
            }
        }
    }
    
    // Befor going any further...
    if (errorFlag != NULL)
    {
        NSLog(@"Error: %@", errorFlag);
        return errorFlag;
    }
    
    // Map msgbuffer to interface message structure
    interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
    
    // Map to link-level socket structure
    socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
    
    // Copy link layer address data in socket structure to an array
    memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
    
    // Read from char array into a string object, into traditional Mac address format
    NSString *macAddressString = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x",
                                  macAddress[0], macAddress[1], macAddress[2],
                                  macAddress[3], macAddress[4], macAddress[5]];
    NSLog(@"Mac Address: %@", macAddressString);
    
    // Release the buffer memory
    free(msgBuffer);
    
    return macAddressString;
}

#pragma mark 检查版本更新
-(void)checkVersion
{
    NSDictionary * versionDic = @{
                                  @"ct":@"ios",
                                  @"type":@"user",
                                  @"version":[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],
                                  };
    NSLog(@"versionDic %@",versionDic);
    [[RequestManager shareRequestManager] getVersionInfo:versionDic viewController:self successData:^(NSDictionary *result) {
        NSLog(@"客户端版                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   本信息result %@",result);
        NSLog(@"客户端版本信息msg %@",[result objectForKey:@"msg"]);
        if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
            if ([[NSString stringWithFormat:@"%@",[result objectForKey:@"status"]] isEqualToString:@"1"]) {
                NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
                NSString * VersionAletshow = [userDefaults objectForKey:@"VersionAletshow"];
                if (VersionAletshow) {
                    //已提示     
                }
                else{
                    //可更新
                    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"版本更新提示" message:@"当前版本有新的更新，是否现在去更新" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
                    alertView.tag = 101;
                    [alertView show];
                    VersionAletshow = @"1";
                    [userDefaults setObject:VersionAletshow forKey:@"VersionAletshow"];
                }
                
            }
            else if ([[NSString stringWithFormat:@"%@",[result objectForKey:@"status"]] isEqualToString:@"2"]) {
                //必须更新
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"版本更新提示" message:@"当前版本已不可用，请更新后使用" delegate:self cancelButtonTitle:@"去更新" otherButtonTitles: nil];
                alertView.tag = 102;
                [alertView show];
            }
        }
        else{
            
        }
    } failuer:^(NSError *error) {
        // 检查版本更新
        [self checkVersion];
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    canUMPush = YES;
    //    NSString * macID = [self macaddress];
    //    NSLog(@"macID--%@",macID);
    [RequestManager shareRequestManager].canuUMPush = NO;
    
    //    [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];获得应用的Verison号
    //    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]//获得build号
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"checkVersion" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkVersion) name:@"checkVersion" object:nil];
    // 检查版本更新
    [self checkVersion];
    
    //    //identifierForVendor对供应商来说是唯一的一个值，也就是说，由同一个公司发行的的app在相同的设备上运行的时候都会有这个相同的标识符。然而，如果用户删除了这个供应商的app然后再重新安装的话，这个标识符就会不一致
    //    NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
    ////    NSString *identifierForAdvertising = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
    //    NSLog(@"identifierForVendor--%@",identifierForVendor);
    
    firstFigureUrl = @"";
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * city = [userDefaults objectForKey:@"cityName"];
    
    UMpushType = @"0";
    //接收推送的通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UMPushNotification" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(UMPushNotificationMethod:) name:@"UMPushNotification" object:nil];
    
    if (city&&![city isEqualToString:@""]) {
        firstUse = NO;
        ADView = [[UIView alloc] init];
        ADView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        [self.view addSubview:ADView];
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        if (kScreenHeight == 480) {
            imageV.image = [UIImage imageNamed:@"Default"];
        }
        else if(kScreenHeight == 568){
            imageV.image = [UIImage imageNamed:@"Default-568h"];
        }
        else if(kScreenHeight == 667){
            imageV.image = [UIImage imageNamed:@"Default-800-667h"];
        }
        else if(kScreenHeight == 736){
            imageV.image = [UIImage imageNamed:@"Default-800-Portrait-736h"];
        }
        [ADView addSubview:imageV];
        
    }
    else
    {
        firstUse = YES;
        redView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
        redView.backgroundColor = RedUIColorC1;
        [self.view addSubview:redView];
        
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 44)];
        titleLabel.text = @"华佗驾到";
        titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        //    titleLabel.font = [UIFont systemFontOfSize:18];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        [redView addSubview:titleLabel];
        
        
        activityIndicator = [[UIActivityIndicatorView alloc]
                             initWithActivityIndicatorStyle:
                             UIActivityIndicatorViewStyleWhiteLarge];
        activityIndicator.color = [UIColor blackColor];
        activityIndicator.center = CGPointMake(self.view.center.x, self.view.center.y);;
        [activityIndicator startAnimating]; // 开始旋转
        [self.view addSubview:activityIndicator];
        
        bgView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-60, kScreenWidth, 60)];
        bgView.backgroundColor = C2UIColorGray;
        [self.view addSubview:bgView];
        
    }
    //        [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(removeADView) userInfo:nil repeats:NO];
    
    self.view.backgroundColor = C2UIColorGray;
    
    //开启定位
    if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
        //        [LCProgressHUD showLoading:@"正在加载"];
        
        //是否有网络
        //有网络
        if ( [self isConnectionAvailable]) {
            [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
                
                NSLog(@"latitude －－－ %f longitude －－－ %f",locationCorrrdinate.latitude ,locationCorrrdinate.longitude);
                //根据经纬度 反编译地址
                _search = [[AMapSearchAPI alloc] init];
                [AMapSearchServices sharedServices].apiKey = GDMapKey;
                self.search.delegate = self;
                AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
                //            regeoRequest.searchType = AMapSearchType_ReGeocode;
                regeoRequest.location = [AMapGeoPoint locationWithLatitude:locationCorrrdinate.latitude longitude:locationCorrrdinate.longitude];
//                regeoRequest.location = [AMapGeoPoint locationWithLatitude:0.0 longitude:0.0];
                //                regeoRequest.location = [AMapGeoPoint locationWithLatitude:22.15 longitude:114.15];
                //    regeoRequest.radius = 10000;
                regeoRequest.requireExtension = YES;
                
                NSString * lat = [NSString stringWithFormat:@"%f",locationCorrrdinate.latitude];
                NSString * lon = [NSString stringWithFormat:@"%f",locationCorrrdinate.longitude];
                NSUserDefaults *  userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:lat forKey:@"latitude"];
                [userDefaults setObject:lon forKey:@"longitude"];
                //假数据--------------------------------------------------
                //                [userDefaults setObject:@"北京" forKey:@"cityName"];
                //                [userDefaults setObject:@"110100" forKey:@"cityCode"];
                //                //位置显示
                //                [userDefaults setObject:@"北京" forKey:@"formattedAddress"];
                //--------------------------------------------------------
                [userDefaults setBool:YES forKey:@"secLaunch"];
                [userDefaults synchronize];
                
                //发起逆地理编码
                [_search AMapReGoecodeSearch: regeoRequest];
                
            }];
            
        }
        //无网络
        else{
            NSUserDefaults *  userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:@"北京" forKey:@"cityName"];
            [userDefaults setObject:@"110100" forKey:@"cityCode"];
            //        [userDefaults setObject:@"2" forKey:@"openStatus"];
            //位置显示
            [userDefaults setObject:@"北京" forKey:@"formattedAddress"];
            //默认一个经纬度，公司经纬度
            [userDefaults setObject:@"39.913355" forKey:@"latitude"];
            [userDefaults setObject:@"116.451896" forKey:@"longitude"];
            
            //        [userDefaults setBool:YES forKey:@"secLaunch"];
            [userDefaults synchronize];
            
            //自定义分栏控制器
            //            [self _initTabBar];
            //            [self _initViewControll];
            [self downLoadAdvertisement];
            
            //            [LCProgressHUD hide];
            
        }
    }
    //未开启定位
    else{
        NSUserDefaults *  userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"北京" forKey:@"cityName"];
        [userDefaults setObject:@"110100" forKey:@"cityCode"];
        //        [userDefaults setObject:@"2" forKey:@"openStatus"];
        //位置显示
        [userDefaults setObject:@"北京" forKey:@"formattedAddress"];
        //默认一个经纬度，公司经纬度
        [userDefaults setObject:@"39.913355" forKey:@"latitude"];
        [userDefaults setObject:@"116.451896" forKey:@"longitude"];
        
        //        [userDefaults setBool:YES forKey:@"secLaunch"];
        [userDefaults synchronize];
        
        //自定义分栏控制器
        //        [self _initTabBar];
        //        [self _initViewControll];
        [self downLoadAdvertisement];
        
        //        [LCProgressHUD hide];
        
        //        [self downloadPayData];
    }
    
    //接收登陆通知
    //    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"LoginPageDataNtf" object:nil];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoginPageDataNtf:) name:@"LoginPageDataNtf" object:nil];
    
    //    [self setdefaultAddress];
    
}

//跳过广告
-(void)skipButtonPressed:(UIButton *)sender
{
    [self performSelector:@selector(_initViewControll) withObject:nil afterDelay:0.0];
    [self performSelector:@selector(dismissADView) withObject:nil afterDelay:0.0];
    
}

-(void)timerFireMethod:(NSTimer *)theTimer
{
    CountdownNum = CountdownNum -1;
    CountdownLabel.text = [NSString stringWithFormat:@"%ds",CountdownNum];
    if (CountdownNum == 0) {
        [theTimer invalidate];
    }
}

-(void)downLoadAdvertisement
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * city = [userDefaults objectForKey:@"cityName"];
    NSLog(@"city -- %@",city);
    if (!firstUse&&!UMpushInfo) {
        [[RequestManager shareRequestManager] getfirstFigure:nil viewController:self successData:^(NSDictionary *result) {
            NSLog(@"查询广告result %@",result);
            if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
                NSString * str = [NSString stringWithFormat:@"%@",[result objectForKey:@"firstFigurePath"]];
                NSString * str2 = [result objectForKey:@"firstFigureUrl"] ;
                if (str2 && ![str2 isEqualToString:@""]) {
                    firstFigureUrl = str2;
                }
                if (str && ![str isEqualToString:@""]) {
                    //                        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
                    
                    NSURL * url = [NSURL URLWithString:str];
                    NSData * data = [NSData dataWithContentsOfURL:url];
                    UIImage * AdvertisementImg = [UIImage imageWithData:data];
                    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-80*AUTO_SIZE_SCALE_X)];
                    imageV.image = AdvertisementImg;
                    [ADView addSubview:imageV];
                    imageV.userInteractionEnabled = YES;
                    UITapGestureRecognizer * tap = [[UITapGestureRecognizer  alloc]  initWithTarget:self action:@selector(gotoViewController:)];
                    [imageV addGestureRecognizer:tap];
                    
                    UIView * buttomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-80*AUTO_SIZE_SCALE_X, kScreenWidth, 80*AUTO_SIZE_SCALE_X)];
                    buttomView.backgroundColor = [UIColor whiteColor];
                    [ADView  addSubview:buttomView];
                    
                    UIImageView * adImv = [[UIImageView alloc] initWithFrame:CGRectMake(14, (80*AUTO_SIZE_SCALE_X-45)/2, 196, 45)];
                    adImv.image = [UIImage imageNamed:@"img_ad"];
                    [buttomView addSubview:adImv];
                    
                    UIButton * skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    skipButton.frame = CGRectMake(kScreenWidth-54-14, (80*AUTO_SIZE_SCALE_X-30)/2, 54, 30);
                    //                        skipButton.layer.cornerRadius = 15.0;
                    [skipButton setImage:[UIImage imageNamed:@"icon_skip"] forState:UIControlStateNormal];
                    [skipButton addTarget:self action:@selector(skipButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                    [buttomView addSubview:skipButton];
                    
                    UIView * secView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth-29-14, 26, 29, 29)];
                    secView.layer.cornerRadius = 14.5;
                    secView.backgroundColor = [UIColor blackColor];
                    secView.alpha = 0.5;
                    [ADView addSubview:secView];
                    
                    CountdownNum = 3;
                    
                    CountdownLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 9, 29, 11)];
                    CountdownLabel.text = [NSString stringWithFormat:@"%ds",CountdownNum];
                    CountdownLabel.font = [UIFont systemFontOfSize:11];
                    CountdownLabel.textColor = [UIColor whiteColor];
                    CountdownLabel.textAlignment = NSTextAlignmentCenter;
                    [secView addSubview:CountdownLabel];
                    
                    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
                    [self performSelector:@selector(_initViewControll) withObject:nil afterDelay:0.0];
                    [self performSelector:@selector(dismissADView) withObject:nil afterDelay:4.0];
                }
                else{
                    [self performSelector:@selector(_initViewControll) withObject:nil afterDelay:0.0];
                    [self performSelector:@selector(dismissADView) withObject:nil afterDelay:0.0];
                }
                
            }
            else{
                [self performSelector:@selector(_initViewControll) withObject:nil afterDelay:0.0];
                [self performSelector:@selector(dismissADView) withObject:nil afterDelay:0.0];
            }
        } failuer:^(NSError *error) {
            [[RequestManager shareRequestManager] tipAlert:@"网络加载失败" viewController:self];
            [self performSelector:@selector(_initViewControll) withObject:nil afterDelay:0.0];
            [self performSelector:@selector(dismissADView) withObject:nil afterDelay:2.0];
        }];
        
    }
    else{
        [self _initViewControll];
    }
}

-(void)dismissADView
{
    [ADView removeFromSuperview];
    [self.view addSubview:_tabbarView];
}

-(void)gotoViewController:(UITapGestureRecognizer *)sender
{
    sender.view.userInteractionEnabled = NO;
    NSArray *strarray = [firstFigureUrl componentsSeparatedByString:@"#"];
    NSString * type = @"";
    NSString * needID = @"";
    
    if (strarray.count>1) {
        NSString *str1 = [strarray objectAtIndex:1];
        NSArray * finalstrArray = [str1 componentsSeparatedByString:@"?id="];
        if (finalstrArray.count>1){
            type = [finalstrArray objectAtIndex:0];
            needID = [finalstrArray objectAtIndex:1];
            NSLog(@"type  %@  needID  %@",type,needID);
        }else{
            //            [[RequestManager shareRequestManager] tipAlert:@"广告内容错误" viewController:self];
            //            [self performSelector:@selector(_initViewControll) withObject:nil afterDelay:CountdownNum];
            //            [self performSelector:@selector(dismissADView) withObject:nil afterDelay:CountdownNum];
            
            //            [self performSelector:@selector(setupCamera) withObject:nil afterDelay:2.0];
        }
    }else{
        //        [[RequestManager shareRequestManager] tipAlert:@"广告内容错误" viewController:self];
        //        [self performSelector:@selector(_initViewControll) withObject:nil afterDelay:CountdownNum];
        //        [self performSelector:@selector(dismissADView) withObject:nil afterDelay:CountdownNum];
        
        //        [self performSelector:@selector(setupCamera) withObject:nil afterDelay:2.0];
    }
    
    
    //门店
    if ([type isEqualToString:@"shop-detail"]) {
        
        //门店详情接口
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        NSString * userID = [userDefaults objectForKey:@"userID"];
        NSString * longitude = [userDefaults objectForKey:@"longitude"];
        NSString * latitude = [userDefaults objectForKey:@"latitude"];
        if (!userID) {
            userID = @"";
        }
        NSDictionary * dic = @{
                               @"ID":needID,
                               @"userID":userID,
                               @"longitude":longitude,
                               @"latitude":latitude,
                               };
        NSLog(@"dic %@",dic);
        [[RequestManager shareRequestManager] getSysStoreDetail:dic viewController:self successData:^(NSDictionary *result) {
            NDLog(@"门店详情--%@",result);
            if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
                StoreDetailViewController * vc = [[StoreDetailViewController alloc] init];
                vc.storeID = needID;
                [self.navigationController pushViewController:vc animated:YES];
                [self performSelector:@selector(dismissADView) withObject:nil afterDelay:0.5];
                
            }
            
            else{
                [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
                [self performSelector:@selector(_initViewControll) withObject:nil afterDelay:1.0];
                [self performSelector:@selector(dismissADView) withObject:nil afterDelay:1.0];
                
                //                [self performSelector:@selector(setupCamera) withObject:nil afterDelay:2.0];
            }
        } failuer:^(NSError *error) {
            [[RequestManager shareRequestManager] tipAlert:@"网络失去连接,请检查当前的网络环境" viewController:self];
            [self performSelector:@selector(_initViewControll) withObject:nil afterDelay:1.0];
            [self performSelector:@selector(dismissADView) withObject:nil afterDelay:1.0];
            
            //            [self performSelector:@selector(setupCamera) withObject:nil afterDelay:2.0];
        }];
    }
    //项目
    else if ([type isEqualToString:@"project-detail"]){
        
        //项目详情接口
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        NSString * userID = [userDefaults objectForKey:@"userID"];
        NSString * longitude = [userDefaults objectForKey:@"longitude"];
        NSString * latitude = [userDefaults objectForKey:@"latitude"];
        if (!userID) {
            userID = @"";
        }
        NSDictionary * dic = @{
                               @"ID":needID,
                               @"userID":userID,
                               @"longitude":longitude,
                               @"latitude":latitude,
                               @"skillWorkerID":@"",
                               };
        [[RequestManager shareRequestManager] getSysServiceDetail:dic viewController:self successData:^(NSDictionary *result) {
            NDLog(@"项目详情result-->%@",result);
            if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
                ServiceDetailViewController * vc =[[ServiceDetailViewController alloc] init];
                vc.haveWorker = NO;
                //                    vc.serviceType = serviceType;
                if ([[NSString stringWithFormat:@"%@",[result objectForKey:@"isSelfOwned"]] isEqualToString:@"0"]) {
                    vc.isStore = YES;
                    vc.isSelfOwned = @"0";
                }else if([[NSString stringWithFormat:@"%@",[result objectForKey:@"isSelfOwned"]] isEqualToString:@"1"]) {
                    vc.isStore = NO;
                    vc.isSelfOwned = @"1";
                }
                vc.serviceID = [NSString stringWithFormat:@"%@",[result objectForKey:@"ID"]];
                [self.navigationController pushViewController:vc animated:YES];
                [self performSelector:@selector(dismissADView) withObject:nil afterDelay:0.5];
                
            }
            else{
                [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
                [self performSelector:@selector(_initViewControll) withObject:nil afterDelay:1.0];
                [self performSelector:@selector(dismissADView) withObject:nil afterDelay:1.0];
                
                //                [self performSelector:@selector(setupCamera) withObject:nil afterDelay:2.0];
            }
            
            
        } failuer:^(NSError *error) {
            [[RequestManager shareRequestManager] tipAlert:@"网络失去连接,请检查当前的网络环境" viewController:self];
            [self performSelector:@selector(_initViewControll) withObject:nil afterDelay:1.0];
            [self performSelector:@selector(dismissADView) withObject:nil afterDelay:1.0];
            
            //            [self performSelector:@selector(setupCamera) withObject:nil afterDelay:2.0];
        }];
        
    }
    //技师
    else if ([type isEqualToString:@"pt-detail"]){
        
        //技师详情接口
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        NSString * userID = [userDefaults objectForKey:@"userID"];
        NSString * longitude = [userDefaults objectForKey:@"longitude"];
        NSString * latitude = [userDefaults objectForKey:@"latitude"];
        if (!userID) {
            userID = @"";
        }
        NSDictionary * dic = @{
                               @"ID":needID,
                               @"userID":userID,
                               @"longitude":longitude,
                               @"latitude":latitude,
                               };
        [[RequestManager shareRequestManager] getSysSkillDetailInfo:dic viewController:self successData:^(NSDictionary *result) {
            NDLog(@" %@",result);
            if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
                if ([[NSString stringWithFormat:@"%@",[result objectForKey:@"isSelfOwned"] ] isEqualToString:@"1"]) {
                    TechnicianMyselfViewController * vc = [[TechnicianMyselfViewController alloc] init];
                    vc.workerID = needID;
                    [self.navigationController pushViewController:vc animated:YES];
                    [self performSelector:@selector(dismissADView) withObject:nil afterDelay:0.5];
                }else{
                    technicianViewController *VC =[[technicianViewController alloc] init];
                    VC.flag = @"0";
                    VC.workerID = needID;
                    [self.navigationController pushViewController:VC animated:YES];
                    [self performSelector:@selector(dismissADView) withObject:nil afterDelay:0.5];
                    
                }
            }
            else{
                [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
                [self performSelector:@selector(_initViewControll) withObject:nil afterDelay:1.0];
                [self performSelector:@selector(dismissADView) withObject:nil afterDelay:1.0];
                //  [self performSelector:@selector(setupCamera) withObject:nil afterDelay:2.0];
            }
            
        } failuer:^(NSError *error) {
            [[RequestManager shareRequestManager] tipAlert:@"网络失去连接,请检查当前的网络环境" viewController:self];
            [self performSelector:@selector(_initViewControll) withObject:nil afterDelay:1.0];
            [self performSelector:@selector(dismissADView) withObject:nil afterDelay:1.0];
            
            //            [self performSelector:@selector(setupCamera) withObject:nil afterDelay:2.0];
        }];
        
    }
    //门店广告
    else if ([type isEqualToString:@"shop-topic"]){
        
        //门店广告接口
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        NSString * longitude = [userDefaults objectForKey:@"longitude"];
        NSString * latitude = [userDefaults objectForKey:@"latitude"];
        NSDictionary * dic = @{
                               @"ID":needID,
                               @"latitude":latitude,
                               @"longitude":longitude,
                               @"pageStart":@"1",
                               @"pageOffset":@"1",
                               @"orderBy":@"1",
                               };
        NSLog(@"dic --%@",dic);
        [[RequestManager shareRequestManager ] getadList:dic viewController:self successData:^(NSDictionary *result) {
            NSLog(@"msg--%@",[result objectForKey:@"msg"]);
            if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
                StoreActivityViewController * vc = [[StoreActivityViewController alloc] init];
                vc.ID = needID;
                vc.name = [result objectForKey:@"adName"];
                [self.navigationController pushViewController:vc animated:YES];
                [self performSelector:@selector(dismissADView) withObject:nil afterDelay:0.5];
                
            }     else{
                [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
                [self performSelector:@selector(_initViewControll) withObject:nil afterDelay:1.0];
                [self performSelector:@selector(dismissADView) withObject:nil afterDelay:1.0];
                //                [self performSelector:@selector(setupCamera) withObject:nil afterDelay:2.0];
            }
        } failuer:^(NSError *error) {
            [[RequestManager shareRequestManager] tipAlert:@"网络失去连接,请检查当前的网络环境" viewController:self];
            [self performSelector:@selector(_initViewControll) withObject:nil afterDelay:1.0];
            [self performSelector:@selector(dismissADView) withObject:nil afterDelay:1.0];
            //            [self performSelector:@selector(setupCamera) withObject:nil afterDelay:2.0];
        }];
        
    }
    //项目广告
    else if ([type isEqualToString:@"project-topic"]){
        //项目广告接口
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        NSString * longitude = [userDefaults objectForKey:@"longitude"];
        NSString * latitude = [userDefaults objectForKey:@"latitude"];
        NSDictionary * dic = @{
                               @"ID":needID,
                               @"latitude":latitude,
                               @"longitude":longitude,
                               @"pageStart":@"1",
                               @"pageOffset":@"1",
                               @"orderBy":@"1",
                               };
        NSLog(@"dic --%@",dic);
        [[RequestManager shareRequestManager ] getadList:dic viewController:self successData:^(NSDictionary *result) {
            NSLog(@"msg--%@",[result objectForKey:@"msg"]);
            if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
                ServiceActivityViewController * vc = [[ServiceActivityViewController alloc] init];
                vc.ID = needID;
                vc.name = [result objectForKey:@"adName"];
                [self.navigationController pushViewController:vc animated:YES];
                [self performSelector:@selector(dismissADView) withObject:nil afterDelay:0.5];
                
            }     else{
                [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
                [self performSelector:@selector(_initViewControll) withObject:nil afterDelay:1.0];
                [self performSelector:@selector(dismissADView) withObject:nil afterDelay:1.0];
                //                [self performSelector:@selector(setupCamera) withObject:nil afterDelay:2.0];
            }
        } failuer:^(NSError *error) {
            [[RequestManager shareRequestManager] tipAlert:@"网络失去连接,请检查当前的网络环境" viewController:self];
            [self performSelector:@selector(_initViewControll) withObject:nil afterDelay:1.0];
            [self performSelector:@selector(dismissADView) withObject:nil afterDelay:1.0];
            //            [self performSelector:@selector(setupCamera) withObject:nil afterDelay:2.0];
        }];
        
    }
    //技师广告
    else if ([type isEqualToString:@"pt-topic"]){
        
        //技师广告接口
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        NSString * longitude = [userDefaults objectForKey:@"longitude"];
        NSString * latitude = [userDefaults objectForKey:@"latitude"];
        NSDictionary * dic = @{
                               @"ID":needID,
                               @"latitude":latitude,
                               @"longitude":longitude,
                               @"pageStart":@"1",
                               @"pageOffset":@"1",
                               @"orderBy":@"1",
                               };
        NSLog(@"dic --%@",dic);
        [[RequestManager shareRequestManager ] getadList:dic viewController:self successData:^(NSDictionary *result) {
            NSLog(@"msg--%@",[result objectForKey:@"msg"]);
            if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
                WorkerActivityViewController * vc = [[WorkerActivityViewController alloc] init];
                vc.ID = needID;
                vc.name = [result objectForKey:@"adName"];
                [self.navigationController pushViewController:vc animated:YES];
                [self performSelector:@selector(dismissADView) withObject:nil afterDelay:0.5];
            }     else{
                [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
                [self performSelector:@selector(_initViewControll) withObject:nil afterDelay:1.0];
                [self performSelector:@selector(dismissADView) withObject:nil afterDelay:1.0];
                //                [self performSelector:@selector(setupCamera) withObject:nil afterDelay:2.0];
            }
        } failuer:^(NSError *error) {
            [[RequestManager shareRequestManager] tipAlert:@"网络失去连接,请检查当前的网络环境" viewController:self];
            [self performSelector:@selector(_initViewControll) withObject:nil afterDelay:1.0];
            [self performSelector:@selector(dismissADView) withObject:nil afterDelay:1.0];
            //            [self performSelector:@selector(setupCamera) withObject:nil afterDelay:2.0];
        }];
        
    }
    else{
        NSLog(@"广告内容错误");
        //        [[RequestManager shareRequestManager] tipAlert:@"广告内容错误" viewController:self];
        //        [self performSelector:@selector(_initViewControll) withObject:nil afterDelay:2.0];
        //        [self performSelector:@selector(dismissADView) withObject:nil afterDelay:2.0];
        //        [self performSelector:@selector(setupCamera) withObject:nil afterDelay:2.0];
        
        //            [self setupCamera];
        
    }
    
}

- (void)UMPushNotificationMethod:(NSNotification *)notification {
    UMpushInfo = [NSDictionary dictionaryWithDictionary:notification.userInfo];
    
    NSLog(@"UMpushInfo--%@",UMpushInfo);
    
    if ([UMpushType isEqualToString:@"1"]) {
        
        
        if ([[UMpushInfo objectForKey:@"open_type"]isEqualToString:@"app"]) {
            NDLog(@"打开app");
        }else if ([[UMpushInfo objectForKey:@"open_type"]isEqualToString:@"store"]) {
            NDLog(@"进入门店页");
            StoreDetailViewController *vc = [[StoreDetailViewController alloc]init];
            vc.storeID = [UMpushInfo objectForKey:@"store"];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([[UMpushInfo objectForKey:@"open_type"]isEqualToString:@"service"]) {
            NDLog(@"进入服务页");
            ServiceDetailViewController *vc = [[ServiceDetailViewController alloc]init];
            vc.serviceID = [UMpushInfo objectForKey:@"service"];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([[UMpushInfo objectForKey:@"open_type"]isEqualToString:@"skillWorker"]) {
            NDLog(@"进入技师页");
            TechnicianMyselfViewController *vc = [[TechnicianMyselfViewController alloc]init];
            vc.workerID = [UMpushInfo objectForKey:@"skillWorker"];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([[UMpushInfo objectForKey:@"open_type"]isEqualToString:@"url"]) {
            NDLog(@"直接打开URL地址");
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[UMpushInfo objectForKey:@"url"]]];
            });
        }else if ([[UMpushInfo objectForKey:@"open_type"]isEqualToString:@"order"]) {
            NDLog(@"定时提醒任务的单播");
            NDLog(@"==================%@",[UMpushInfo objectForKey:@"order"]);
            WaitForStoreServiceViewController *vc = [[WaitForStoreServiceViewController alloc]init];
            vc.orderID = [NSString stringWithFormat:@"%@",[UMpushInfo objectForKey:@"order"]];
            vc.isNotFromOrderList = @"1";
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([[UMpushInfo objectForKey:@"open_type"]isEqualToString:@"find"]) {
            NDLog(@"进入发现页");
            if ([[UMpushInfo objectForKey:@"type"]isEqualToString:@"0"]) {//门店
                StoreFoundViewController *vc = [[StoreFoundViewController alloc]init];
                vc.ID = [UMpushInfo objectForKey:@"find"];
                [self.navigationController pushViewController:vc animated:YES];
            }else if ([[UMpushInfo objectForKey:@"type"]isEqualToString:@"1"]) {//项目
                ServiceFoundViewController *vc = [[ServiceFoundViewController alloc]init];
                vc.ID = [UMpushInfo objectForKey:@"find"];
                [self.navigationController pushViewController:vc animated:YES];
            }else if ([[UMpushInfo objectForKey:@"type"]isEqualToString:@"2"]) {//技师
                WorkerFoundViewController *vc = [[WorkerFoundViewController alloc]init];
                vc.ID = [UMpushInfo objectForKey:@"find"];
                [self.navigationController pushViewController:vc animated:YES];
            }else if ([[UMpushInfo objectForKey:@"type"]isEqualToString:@"3"]) {//图文
                DetailFoundViewController *vc = [[DetailFoundViewController alloc]init];
                vc.ID = [UMpushInfo objectForKey:@"find"];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        
        
        
    }
    else{
        
        
        
    }
    
}

-(void)setdefaultAddress
{
    
}

-(void)checktest
{
    //    currentLocationDic = [[NSMutableDictionary alloc] init];
    //    if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    //    {
    //        NSLog(@"开启定位");
    //        [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
    //
    //            NSLog(@"latitude %f longitude %f",locationCorrrdinate.latitude ,locationCorrrdinate.longitude);
    //            [currentLocationDic setValue:[NSString stringWithFormat:@"%f",locationCorrrdinate.latitude] forKey:@"latitude"];
    //            [currentLocationDic setValue:[NSString stringWithFormat:@"%f",locationCorrrdinate.longitude] forKey:@"longitude"];
    //
    //
    //            //根据经纬度 反编译地址
    //            _search = [[AMapSearchAPI alloc] init];
    //            [AMapSearchServices sharedServices].apiKey = GDMapKey;
    //            self.search.delegate = self;
    //            AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
    //            //            regeoRequest.searchType = AMapSearchType_ReGeocode;
    //            regeoRequest.location = [AMapGeoPoint locationWithLatitude:locationCorrrdinate.latitude longitude:locationCorrrdinate.longitude];
    //            //    regeoRequest.radius = 10000;
    //            regeoRequest.requireExtension = YES;
    //
    //            //发起逆地理编码
    //            [_search AMapReGoecodeSearch: regeoRequest];
    //
    //        }];
    //
    //    }else{
    //        NSLog(@"123");
    //    }
    
}

//实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    NSLog(@"实现逆地理编码的回调函数");
    if(response.regeocode != nil)
    {
        NSLog(@"response.regeocode.formattedAddress-->%@",response.regeocode.formattedAddress);
        NSString *  province = @"";
        NSString *  city = @"";
        if (response.regeocode.addressComponent.province) {
            province = response.regeocode.addressComponent.province;
        }
        if (response.regeocode.addressComponent.city) {
            city = response.regeocode.addressComponent.city;
        }
        NSUserDefaults *  userDefaults = [NSUserDefaults standardUserDefaults];
        
        [[RequestManager shareRequestManager] GetMyCityInfo:nil viewController:nil successData:^(NSDictionary *result) {
            
            NSArray * cityArray =  [NSArray arrayWithArray: [result objectForKey:@"cityList"] ] ;
            for (NSDictionary * dic in cityArray) {
                NSString * city_Name = [NSString stringWithFormat:@"%@",[dic objectForKey:@"cityName"]];
                NSString * city_Code = [NSString stringWithFormat:@"%@",[dic objectForKey:@"cityCode"]];
                NSLog(@"cityName  %@",city_Name);
                NSLog(@"province  %@",province);
                NSLog(@"city  %@",city);
                if ([city rangeOfString:city_Name].location !=NSNotFound||[province rangeOfString:city_Name].location !=NSNotFound||[city_Name isEqualToString:province]||[city_Name isEqualToString:city]) {
                    [userDefaults setObject:city_Name forKey:@"cityName"];
                    [userDefaults setObject:city_Code forKey:@"cityCode"];
                    //位置显示
                    [userDefaults setObject:response.regeocode.formattedAddress forKey:@"formattedAddress"];
                    [userDefaults synchronize];
                    //自定义分栏控制器
                    //                    [self _initViewControll];
                    [self downLoadAdvertisement];
                    //                    [LCProgressHUD hide];
                    
                    //                    [self downloadPayData];
                    return  ;
                }
            }
            [userDefaults setObject:@"北京" forKey:@"cityName"];
            [userDefaults setObject:@"110100" forKey:@"cityCode"];
            //位置显示
            [userDefaults setObject:@"北京" forKey:@"formattedAddress"];
            //默认一个经纬度，公司经纬度
            [userDefaults setObject:@"39.913355" forKey:@"latitude"];
            [userDefaults setObject:@"116.451896" forKey:@"longitude"];
            [userDefaults synchronize];
            [self downLoadAdvertisement];
            
        } failuer:^(NSError *error) {
            [userDefaults setObject:@"北京" forKey:@"cityName"];
            [userDefaults setObject:@"110100" forKey:@"cityCode"];
            //位置显示
            [userDefaults setObject:@"北京" forKey:@"formattedAddress"];
            //默认一个经纬度，公司经纬度
            [userDefaults setObject:@"39.913355" forKey:@"latitude"];
            [userDefaults setObject:@"116.451896" forKey:@"longitude"];
            [userDefaults synchronize];
            //自定义分栏控制器
            //            [self _initTabBar];
            //            [self _initViewControll];
            [self downLoadAdvertisement];
            //            [LCProgressHUD hide];
            //            [self downloadPayData];
        }];
    }
    else{
        NSUserDefaults *  userDefaults = [NSUserDefaults standardUserDefaults];
        
        [userDefaults setObject:@"北京" forKey:@"cityName"];
        [userDefaults setObject:@"110100" forKey:@"cityCode"];
        //位置显示
        [userDefaults setObject:@"北京" forKey:@"formattedAddress"];
        //默认一个经纬度，公司经纬度
        [userDefaults setObject:@"39.913355" forKey:@"latitude"];
        [userDefaults setObject:@"116.451896" forKey:@"longitude"];
        [userDefaults synchronize];
        //自定义分栏控制器
        //            [self _initTabBar];
        //        [self _initViewControll];
        [self downLoadAdvertisement];
        
        //            [LCProgressHUD hide];
        
        //            [self downloadPayData];
        
    }
}

#pragma mark UIAlertView代理
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //    if (buttonIndex == 0) {
    //        NSLog(@"不切换");
    //    }
    //    else if (buttonIndex == 1){
    //        NSLog(@"切换到当前位置 并刷新数据");
    //        NSUserDefaults * userDefauls = [NSUserDefaults standardUserDefaults];
    //
    //        [userDefauls setObject:[currentLocationDic objectForKey:@"cityName"] forKey:@"cityName"];
    //        [userDefauls setObject:[currentLocationDic objectForKey:@"cityCode"] forKey:@"cityCode"];
    //        [userDefauls setObject:[currentLocationDic objectForKey:@"formattedAddress"] forKey:@"formattedAddress"];
    //        [userDefauls setObject:[currentLocationDic objectForKey:@"latitude"] forKey:@"latitude"];
    //        [userDefauls setObject:[currentLocationDic objectForKey:@"longitude"] forKey:@"longitude"];
    //        [userDefauls synchronize];
    //
    //        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeToCurrentCity" object:nil];
    
    //    }
    
    //可以使用，更新
    if (alertView.tag == 101) {
        if (buttonIndex == 0){
            
        }
        else if (buttonIndex == 1){
            NSString *str = [NSString stringWithFormat:
                             @"itms-apps://itunes.apple.com/cn/app/hua-tuo-jia-dao-tui-na-zu/id945956826?l=en&mt=8" ];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
    }
    //不可使用，必须更新
    else if(alertView.tag == 102){
        NSString *str = [NSString stringWithFormat:
                         @"itms-apps://itunes.apple.com/cn/app/hua-tuo-jia-dao-tui-na-zu/id945956826?l=en&mt=8" ];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
    
    
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:YES];
//    //接收待付款订单变化的通知
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"PayOrderNtf" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payOrderDataNtf:) name:@"PayOrderNtf" object:nil];
//}
////待付款订单通知
//- (void)payOrderDataNtf:(NSNotification *)ntf {
//    NSDictionary *info =ntf.object;
//    NSString *infoStr =[info objectForKey:@"pay"];
//    if([infoStr isEqualToString:@"changed"]){
//        [self downloadPayData];
//    }
//}
//登陆通知
-(void)LoginPageDataNtf:(NSNotification *)ntf{
    NSDictionary *info =ntf.object;
    NSString *ret =[info objectForKey:@"ret"];
    if([ret isEqualToString:@"20001"]){
        //已登录
        [self downloadPayData];
        //未登录
    }else if([ret isEqualToString:@"20002"]) {
        _orderCountImg.hidden = YES;
        _countLabel.hidden = YES;
    }
}
- (void)startLoaction
{
    
    [[CCLocationManager shareLocation] startLocation];
    
    //    //定位管理器
    //    if (_locationManager == nil) {
    //
    //        _locationManager=[[CLLocationManager alloc]init];
    //
    //        if (![CLLocationManager locationServicesEnabled]) {
    //            NSLog(@"定位服务当前可能尚未打开，请设置打开！");
    //            [[RequestManager shareRequestManager]tipAlert:@"定位服务当前可能尚未打开，请设置打开！"];
    //            return;
    //        }
    //        //设置代理
    //        _locationManager.delegate=self;
    //        //设置定位精度
    //        _locationManager.desiredAccuracy=kCLLocationAccuracyHundredMeters;
    //        //定位频率,每隔多少米定位一次
    //        CLLocationDistance distance=100.0;//十米定位一次
    //        _locationManager.distanceFilter=distance;
    //    }
    //    //启动跟踪定位
    //    [_locationManager startUpdatingLocation];
    
}

//创建子控制器
-(void)_initViewControll{
    //    personalVC.delegate = self;
    redView.hidden = YES;
    [activityIndicator stopAnimating];
    activityIndicator.hidden = YES;
    bgView.hidden = YES;
    
    
    StoreServiceHomePageViewController * StoreServiceHomepageVC = [[StoreServiceHomePageViewController alloc] init];
    DoorServiceHomePageViewController * DoorServiceHomePageVC = [[DoorServiceHomePageViewController alloc]init];
    
    LoveHealthyViewController * LoveHealthyVC = [[LoveHealthyViewController alloc]init];
    OrderListViewController * OrderListVC = [[OrderListViewController alloc] init];
    MyPersonalInfoViewController * MyPersonalInfo = [[MyPersonalInfoViewController alloc]init];
    //存储三级控制器
    NSArray *viewCtrl = @[StoreServiceHomepageVC,DoorServiceHomePageVC,LoveHealthyVC,OrderListVC,MyPersonalInfo];
    
    //    //创建二级视图导航控制器
    //    NSMutableArray *viewControllers = [[NSMutableArray alloc]init];
    //    for (int i = 0; i < viewCtrl.count; i++) {
    //        UIViewController *viewControll = viewCtrl[i];
    //        viewControll.hidesBottomBarWhenPushed = NO;
    //        //创建二级导航控制器
    //        BaseNavgationController *nav = [[BaseNavgationController alloc]initWithRootViewController:viewControll];
    //        nav.delegate = self;
    //        [viewControllers addObject:nav];
    //    }
    
    //将二级导航器交给控制器
    self.viewControllers = viewCtrl;
    [self _initTabBar];
    
    if ([UMpushType isEqualToString:@"0"]) {
        if (UMpushInfo) {
            [self dismissADView];
        }
        UMpushType = @"1";
        if ([[UMpushInfo objectForKey:@"open_type"]isEqualToString:@"app"]) {
            NDLog(@"打开app");
        }else if ([[UMpushInfo objectForKey:@"open_type"]isEqualToString:@"store"]) {
            NDLog(@"进入门店页");
            StoreDetailViewController *vc = [[StoreDetailViewController alloc]init];
            vc.storeID = [UMpushInfo objectForKey:@"store"];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([[UMpushInfo objectForKey:@"open_type"]isEqualToString:@"service"]) {
            NDLog(@"进入服务页");
            ServiceDetailViewController *vc = [[ServiceDetailViewController alloc]init];
            vc.serviceID = [UMpushInfo objectForKey:@"service"];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([[UMpushInfo objectForKey:@"open_type"]isEqualToString:@"skillWorker"]) {
            NDLog(@"进入技师页");
            TechnicianMyselfViewController *vc = [[TechnicianMyselfViewController alloc]init];
            vc.workerID = [UMpushInfo objectForKey:@"skillWorker"];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([[UMpushInfo objectForKey:@"open_type"]isEqualToString:@"url"]) {
            NDLog(@"直接打开URL地址");
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[UMpushInfo objectForKey:@"url"]]];
            });
        }else if ([[UMpushInfo objectForKey:@"open_type"]isEqualToString:@"order"]) {
            NDLog(@"定时提醒任务的单播");
            WaitForStoreServiceViewController *vc = [[WaitForStoreServiceViewController alloc]init];
            vc.orderID = [NSString stringWithFormat:@"%@",[UMpushInfo objectForKey:@"order"]];
            vc.isNotFromOrderList = @"1";
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([[UMpushInfo objectForKey:@"open_type"]isEqualToString:@"find"]) {
            NDLog(@"进入发现页");
            if ([[UMpushInfo objectForKey:@"type"]isEqualToString:@"0"]) {//门店
                StoreFoundViewController *vc = [[StoreFoundViewController alloc]init];
                vc.ID = [UMpushInfo objectForKey:@"find"];
                [self.navigationController pushViewController:vc animated:YES];
            }else if ([[UMpushInfo objectForKey:@"type"]isEqualToString:@"1"]) {//项目
                ServiceFoundViewController *vc = [[ServiceFoundViewController alloc]init];
                vc.ID = [UMpushInfo objectForKey:@"find"];
                [self.navigationController pushViewController:vc animated:YES];
            }else if ([[UMpushInfo objectForKey:@"type"]isEqualToString:@"2"]) {//技师
                WorkerFoundViewController *vc = [[WorkerFoundViewController alloc]init];
                vc.ID = [UMpushInfo objectForKey:@"find"];
                [self.navigationController pushViewController:vc animated:YES];
            }else if ([[UMpushInfo objectForKey:@"type"]isEqualToString:@"3"]) {//图文
                DetailFoundViewController *vc = [[DetailFoundViewController alloc]init];
                vc.ID = [UMpushInfo objectForKey:@"find"];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//自定义分栏控制器
-(void)_initTabBar
{
    //隐藏状态栏
    self.tabBar.hidden = YES;
    
    // 设置tabbar的背景颜色和位置
    /*
     kScreenHeight - 49 和 kScreenHeight - 49 - 20  后者由于加载到了DDMenuController上面
     二级控制器的frame是（0 ，0 ，320，460）;
     DDMenuController的frame是（0，20，320，460）;
     */
    
    //设置tabbar的背景颜色和位置
    _tabbarView = [[UIImageView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 49, kScreenWidth, 49)];
    _tabbarView.image =[UIImage imageNamed:@"tabbar_bg"];
    //    _tabbarView.backgroundColor = C4UIColorGray;
    //    _tabbarView.backgroundColor = [UIColor redColor];
    
    _tabbarView.userInteractionEnabled = YES;
    if (!firstUse) {
        
    }else
    {
        [self.view addSubview:_tabbarView];
    }
    
    norArray = [NSArray arrayWithObjects:@"tab_home", @"tab_door", @"tab_found", @"tab_orders",@"tab_usercenter", nil];
    selectArray = [NSArray arrayWithObjects:@"tab_home_che", @"tab_door_che", @"tab_found_che", @"tab_orders_che",@"tab_usercenter_che", nil];
    labeltextArray = [NSArray arrayWithObjects:@"到店", @"上门", @"发现", @"订单",@"我的", nil];
    
    self.buttons = [NSMutableArray arrayWithCapacity:0];
    self.imvArray = [NSMutableArray arrayWithCapacity:0];
    self.labelArray = [NSMutableArray arrayWithCapacity:0];
    
    float with = kScreenWidth/labeltextArray.count;
    
    for (int i = 0;  i < labeltextArray.count ; i++) {
        //遍历图片 127 × 88
        //        NSString *norMalImge = [NSString stringWithFormat:@"nav%d.png",i];
        //        NSString *selectImge = [NSString stringWithFormat:@"nav%d_select.png",i];
        
        //设置自定义按钮
        //        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake( i*with, 0, with, 49)];
        UIView * view = [[UIButton alloc]initWithFrame:CGRectMake( i*with, 0, with, 49)];
        UIImageView * imv = [[UIImageView alloc] initWithFrame:CGRectMake((with-24)/2, 5, 24, 24)];
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 29, with, 20)];
        
        label.text = [labeltextArray objectAtIndex:i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:11];
        
        if (i == 0) {
            imv.image = [UIImage imageNamed:[selectArray objectAtIndex:i]];
            label.textColor = RedUIColorC1;
        }else{
            imv.image = [UIImage imageNamed:[norArray objectAtIndex:i]];
            label.textColor = C6UIColorGray;
        }
        [view addSubview:label];
        [view addSubview:imv];
        UITapGestureRecognizer * Viewtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ViewTaped:)];
        view.userInteractionEnabled = YES;
        [view addGestureRecognizer:Viewtap];
        view.tag = i;
        [self.imvArray addObject:imv];
        [self.labelArray addObject:label];
        [_tabbarView addSubview:view];
        
        //        button.imageView.size =CGSizeMake(44, 44);
        //        [button setImage:[UIImage imageNamed:[norArray objectAtIndex:i]] forState:UIControlStateNormal];
        //        [button setImage:[UIImage imageNamed:[selectArray objectAtIndex:i]] forState:UIControlStateSelected];
        
        //        [button setImageEdgeInsets:UIEdgeInsetsMake(2.5f,31.34f,2.5f,31.34f)];
        
        
        //        button.showsTouchWhenHighlighted = YES;
        //        button.tag = i;
        //        [self.buttons addObject:button];
        //
        //        if (button.tag == 0) {
        //            [self selectorAction:button];
        //        }
        //        //设置按钮事件
        //        [button addTarget:self action:@selector(selectorAction:) forControlEvents:UIControlEventTouchUpInside];
        
        //        [_tabbarView addSubview:button];
    }
    //待付款订单数量的"角标"
    _orderCountImg = [[UIImageView alloc]initWithFrame:CGRectMake(with*4-with/2+2, 2, 15, 15)];
    [_orderCountImg setImage:[UIImage imageNamed:@"bg_order-number"]];
    
    _countLabel = [[UILabel alloc]initWithFrame:CGRectMake(with*4-with/2+2.2, 3.4, 15, 12)];
    _countLabel.backgroundColor = [UIColor clearColor];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.textColor = [UIColor whiteColor];
    _countLabel.font = [UIFont systemFontOfSize:11];
    [_tabbarView addSubview:_orderCountImg];
    [_tabbarView addSubview:_countLabel];
    _orderCountImg.hidden = YES;
    _countLabel.hidden = YES;
    
    
    [self downloadPayData];
}
#pragma mark 获取待付款数据
- (void)downloadPayData {
    //获取订单列表
    NSUserDefaults *userDetaults = [NSUserDefaults standardUserDefaults];
    NSString * userID = [userDetaults objectForKey:@"userID"];
    NSLog(@"userid === %@",userID);
    if ([userID isEqualToString:@""]||[userID isKindOfClass:[NSNull class]] ||userID ==nil) {
        //未登录
    }else{
        //已登陆
        NSDictionary * dic = @{
                               @"userID":userID,
                               @"orderStatus":@"1",//待付款
                               };
        [[RequestManager shareRequestManager] getOrderList:dic viewController:self successData:^(NSDictionary *result) {
            if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
                NSString *count = [NSString stringWithFormat:@"%@",[result objectForKey:@"tupleCount"]];
                NDLog(@"小圆球的数量：%@",count);
                if ([count isEqualToString:@"0"]) {
                    _orderCountImg.hidden = YES;
                    _countLabel.hidden = YES;
                }else if ([count intValue]>9) {
                    _orderCountImg.hidden = NO;
                    _countLabel.hidden = NO;
                    _countLabel.text = @"···";
                }else {
                    _orderCountImg.hidden = NO;
                    _countLabel.hidden = NO;
                    _countLabel.text = count;
                }
            }
        } failuer:^(NSError *error) {
            
        }];
    }
}
-(void)ViewTaped:(UITapGestureRecognizer *)sender
{
    //友盟自定义事件 统计
//    NSString * str = [NSString stringWithFormat:@"%ld",sender.view.tag];
//    NSDictionary * dic = @{
//                           @"tag":str,
//                           };
//    [MobClick event:@"StoreTabbarBtn" attributes:dic];
    if (sender.view.tag == 0) {
        [MobClick event:TAB_STORE];
    }
    else if (sender.view.tag == 1){
        [MobClick event:TAB_DOOR];
    }
    else if (sender.view.tag == 2){
        [MobClick event:TAB_DISCOVER];
    }
    else if (sender.view.tag == 3){
        [MobClick event:TAB_ORDER];
    }
    else if (sender.view.tag == 4){
        [MobClick event:TAB_MY];
    }
    NSLog(@"%ld",(long)sender.view.tag);
    self.selectedIndex = sender.view.tag;
    for (int i=0; i < self.imvArray.count; i++) {
        UIImageView * selectimv = (UIImageView *)[self.imvArray objectAtIndex:i];
        if (sender.view.tag == i) {
            selectimv.image = [UIImage imageNamed:[selectArray objectAtIndex:i]];
        }else
        {
            selectimv.image = [UIImage imageNamed:[norArray objectAtIndex:i]];
        }
    }
    for (int i=0; i < self.labelArray.count; i++) {
        UILabel * selectlabel = (UILabel *)[self.labelArray objectAtIndex:i];
        if (sender.view.tag == i) {
            selectlabel.textColor = RedUIColorC1;
        }else
        {
            selectlabel.textColor = C6UIColorGray;
        }
    }
    if (sender.view.tag == 3) {
        _orderCountImg.hidden = YES;
        _countLabel.hidden = YES;
    }
    
}
//分栏按钮事件
- (void)selectorAction:(UIButton *)butt
{
    
    self.selectedIndex = butt.tag;
    
    for (int i=0; i < self.imvArray.count; i++) {
        UIImageView * selectimv = (UIImageView *)[self.imvArray objectAtIndex:i];
        if (butt.tag == i) {
            selectimv.image = [UIImage imageNamed:[selectArray objectAtIndex:i]];
        }else
        {
            selectimv.image = [UIImage imageNamed:[norArray objectAtIndex:i]];
        }
    }
    for (int i=0; i < self.labelArray.count; i++) {
        UILabel * selectlabel = (UILabel *)[self.labelArray objectAtIndex:i];
        if (butt.tag == i) {
            selectlabel.textColor = RedUIColorC1;
        }else
        {
            selectlabel.textColor = C6UIColorGray;
        }
    }
    
    // 1.控制状态
    self.tabButton.selected = NO;
    for (UIButton *temp in self.buttons) {
        if (temp.tag ==butt.tag) {
            temp.selected = YES;
            self.tabButton = temp;
            [UIView animateWithDuration:0.35 animations:^{
                _selectImageView.center = temp.center;
            }];
        }
    }
}


- (void)changeView:(int)tag
{
    //    NSLog(@"seleto");
    //    self.selectedIndex = tag;
    //    // 1.控制状态
    //    self.tabButton.selected = NO;
    ////    button.selected = YES;
    //    if
    //
    ////    self.tabButton = button;
    ////
    //    [UIView animateWithDuration:0.35 animations:^{
    //        _selectImageView.center = button.center;
    //    }];
    
}

//-(void)showTabbar
//{
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.2];
//    _tabbarView.left = 0;
//    [UIView commitAnimations];
//
//}
//-(void)hideTabbar
//{
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.2];
//    _tabbarView.left = -kScreenWidth;
//    [UIView commitAnimations];
//
//}

//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
////    [self showTabbar];
////    self.tabBar.hidden = YES;
//
//    for (UIView *subView in self.tabBar.subviews) {
//        if ([subView isKindOfClass:[UITabBarController class]]) {
//            [subView removeFromSuperview];
//        }
//    }
//}

//-(void)viewWillDisappear:(BOOL)animated
//{
//
//}



//#pragma mark - UINavigationController delegate
//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//
//
//    self.tabBar.hidden = YES;
////    //子控制器个数
//    NSInteger count = navigationController.viewControllers.count;
//    if (count == 2)
//    {
//        [self hideTabbar];
//    }else if (count == 1)
//    {
//        [self showTabbar];
//    }
//
//
//
//}

#pragma mark - 网络连接状态
- (void)monitorNetwork
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //        NDLog(@"%ld", status);
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
            {
                //                [self showToastWithMessage:@"当前网络不可用" showTime:1.5f];
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                //                [self showToastWithMessage:@"当前使用WIFI网络" showTime:1.5f];
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                //                [self showToastWithMessage:@"当前使用数据流量" showTime:1.5f];
                break;
            }
            default:
                break;
        }
    }];
}

#pragma mark - CoreLocation 代理
#pragma mark 跟踪定位代理方法，每次位置发生变化即会执行（只要定位到相应位置）
//可以通过模拟器设置一个虚拟位置，否则在模拟器中无法调用此方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *location=[locations firstObject];//取出第一个位置
    CLLocationCoordinate2D coordinate=location.coordinate;//位置坐标
    
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *array, NSError *error)
     {
         if (array.count > 0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];
             
             //将获得的所有信息显示到label上
             //                 NSLog(@"placemark.name====================== %@", placemark.name);
             
             //获取城市
             NSString *cityName = placemark.locality;
             NSLog(@"city = %@", cityName);
             if (!cityName) {
                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 cityName = placemark.administrativeArea;
             }
             if (![cityName isEqualToString:@""]) {
                 cityName = [cityName substringToIndex:2];
                 
                 
                 if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
                     NSLog(@"cityName====================== %@", cityName);
                     
                     [self changeCityName:cityName];
                 }
             }
         }
         else if (error == nil && [array count] == 0)
         {
             NSLog(@"No results were returned.");
         }
         else if (error != nil)
         {
             NSLog(@"An error occurred = %@", error);
         }
     }];
    
    NSLog(@"经度：%f,纬度：%f,海拔：%f,航向：%f,行走速度：%f",coordinate.longitude,coordinate.latitude,location.altitude,location.course,location.speed);
    //更新位置
    [self  changeLocation:coordinate.latitude longitude:coordinate.longitude];
    
}


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [self.locationManager requestWhenInUseAuthorization];     //NSLocationWhenInUseDescription
                [self.locationManager requestAlwaysAuthorization];
            }
            NSLog(@"kCLAuthorizationStatusNotDetermined");
            break;
            
        case kCLAuthorizationStatusDenied:
            if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [self.locationManager requestWhenInUseAuthorization];     //NSLocationWhenInUseDescription
                [self.locationManager requestAlwaysAuthorization];
            }
            NSLog(@"kCLAuthorizationStatusDenied");
            [[RequestManager shareRequestManager]tipAlert:@"定位服务当前可能尚未打开，请设置打开！"];
            break;
            
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [_locationManager startUpdatingLocation];
            NSLog(@"kCLAuthorizationStatusAuthorizedWhenInUse1");
            break;
            
        case kCLAuthorizationStatusAuthorizedAlways:
            [_locationManager startUpdatingLocation];
            NSLog(@"kCLAuthorizationStatusAuthorizedWhenInUse");
            break;
            
        default:
            break;
    }
}

#pragma mark - 更新位置
- (void)changeLocation:(float)latitude  longitude:(float)longitude
{
    
    [RequestManager shareRequestManager].curentlatitude =  [NSString stringWithFormat:@"%f",latitude];
    [RequestManager shareRequestManager].curentlongitude = [NSString stringWithFormat:@"%f",longitude];
    NSLog(@"%@",[RequestManager shareRequestManager].curentlatitude);
    NSLog(@"%@",[RequestManager shareRequestManager].curentlongitude);
    
    //    NSString *curentLat = [NSString stringWithFormat:@"%f",latitude];
    //    NSString *curentLong = [NSString stringWithFormat:@"%f",longitude];
    //    //更新用户位置
    //    NSDictionary *dic = @{@"latitude":curentLat,
    //                          @"longitude":curentLong};
    //    [[RequestManager shareRequestManager]locatedUser:dic successData:^(NSDictionary *result) {
    //        NDLog(@"更新了用户的位置------\n --------%@",result);
    //    } failuer:^(NSError *error) {
    //
    //    }];
    
    
    
}


- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    NSLog(@"didFailWithError--------->%@",error);
    
    [RequestManager shareRequestManager].curentlatitude =@"";
    [RequestManager shareRequestManager].curentlongitude=@"";
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        
        NSUserDefaults *  userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"北京" forKey:@"cityName"];
        [userDefaults setObject:@"110100" forKey:@"cityCode"];
        //        [userDefaults setObject:@"2" forKey:@"openStatus"];
        [userDefaults synchronize];
    }
    
    [_locationManager stopUpdatingLocation];
    
}


-(void)changeCityName:(NSString *)cityname{
    
    [[RequestManager shareRequestManager] GetMyCityInfo:nil viewController:self successData:^(NSDictionary *result) {
        
        NSMutableArray  *_cityResourceData =[NSMutableArray arrayWithCapacity:0];
        [_cityResourceData addObjectsFromArray:[result objectForKey:@"cityList"]];
        
        
        for (int i = 0; i<_cityResourceData.count; i++) {
            NSString *tempname =[_cityResourceData[i] objectForKey:@"cityName"];
            
            if ([tempname isEqualToString:cityname]) {
                
                NSUserDefaults *  userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:[[_cityResourceData objectAtIndex:i] objectForKey:@"cityName"] forKey:@"cityName"];
                [userDefaults setObject:[[_cityResourceData objectAtIndex:i] objectForKey:@"cityCode"] forKey:@"cityCode"];
                [userDefaults setObject:[[_cityResourceData objectAtIndex:i] objectForKey:@"openStatus"] forKey:@"openStatus"];
                
                [userDefaults synchronize];
            }
        }
        NDLog(@"------\n --cityCode------%@----------------cityName----------->%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"cityCode"],[[NSUserDefaults standardUserDefaults] objectForKey:@"cityName"]);
    } failuer:^(NSError *error) {
        
    }];
}








-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:YES];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        [self showIntroWithCrossDissolve];
    }
}




#pragma EAIntroPage
- (void)showIntroWithCrossDissolve {
    EAIntroPage *page1 = [EAIntroPage page];
    //    page1.title = @"Hello world";
    //    page1.desc = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
    page1.bgImage = [UIImage imageNamed:@"引导页_1"];
    page1.titleImage = [UIImage imageNamed:@"original"];
    
    EAIntroPage *page2 = [EAIntroPage page];
    //    page2.title = @"This is page 2";
    //    page2.desc = @"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore.";
    page2.bgImage = [UIImage imageNamed:@"引导页_2"];
    page2.titleImage = [UIImage imageNamed:@"supportcat"];
    
    EAIntroPage *page3 = [EAIntroPage page];
    //    page3.title = @"This is page 3";
    //    page3.desc = @"Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem.";
    page3.bgImage = [UIImage imageNamed:@"引导页_3"];
    page3.titleImage = [UIImage imageNamed:@"femalecodertocat"];
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3]];
    
    [intro setDelegate:self];
    
    
    //    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    ////    [btn setBackgroundImage:[UIImage imageNamed:@"skipButton"] forState:UIControlStateNormal];
    ////    [btn setFrame:CGRectMake((320-230)/2, [UIScreen mainScreen].bounds.size.height - 60, 230, 40)];
    //    [btn setTitle:@"立即体验" forState:UIControlStateNormal];
    //    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    //    intro.skipButton = btn;
    
    [intro showInView:self.view animateDuration:0.0];
}

- (void)showBasicIntroWithBg {
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"Hello world";
    page1.desc = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
    page1.titleImage = [UIImage imageNamed:@"original"];
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"This is page 2";
    page2.desc = @"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore.";
    page2.titleImage = [UIImage imageNamed:@"supportcat"];
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = @"This is page 3";
    page3.desc = @"Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem.";
    page3.titleImage = [UIImage imageNamed:@"femalecodertocat"];
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3]];
    intro.bgImage = [UIImage imageNamed:@"introBg"];
    
    [intro setDelegate:self];
    [intro showInView:self.view animateDuration:0.0];
}

- (void)showBasicIntroWithFixedTitleView {
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"Hello world";
    page1.desc = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"This is page 2";
    page2.desc = @"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore.";
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = @"This is page 3";
    page3.desc = @"Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem.";
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3]];
    UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"original"]];
    intro.titleView = titleView;
    intro.backgroundColor = [UIColor colorWithRed:0.0f green:0.49f blue:0.96f alpha:1.0f]; //iOS7 dark blue
    
    [intro setDelegate:self];
    [intro showInView:self.view animateDuration:0.0];
}

- (void)showCustomIntro {
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"Hello world";
    page1.desc = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
    page1.titleImage = [UIImage imageNamed:@"original"];
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"This is page 2";
    page2.titlePositionY = 180;
    page2.desc = @"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore.";
    page2.descPositionY = 160;
    page2.titleImage = [UIImage imageNamed:@"supportcat"];
    page2.imgPositionY = 70;
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = @"This is page 3";
    page3.titleFont = [UIFont fontWithName:@"Georgia-BoldItalic" size:20];
    page3.titlePositionY = 220;
    page3.desc = @"Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit.";
    page3.descFont = [UIFont fontWithName:@"Georgia-Italic" size:18];
    page3.descPositionY = 200;
    page3.titleImage = [UIImage imageNamed:@"femalecodertocat"];
    page3.imgPositionY = 100;
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3]];
    intro.backgroundColor = [UIColor colorWithRed:1.0f green:0.58f blue:0.21f alpha:1.0f]; //iOS7 orange
    
    intro.pageControlY = 100.0f;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setBackgroundImage:[UIImage imageNamed:@"skipButton"] forState:UIControlStateNormal];
    [btn setFrame:CGRectMake((320-230)/2, [UIScreen mainScreen].bounds.size.height - 60, 230, 40)];
    [btn setTitle:@"SKIP NOW" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    intro.skipButton = btn;
    
    [intro setDelegate:self];
    [intro showInView:self.view animateDuration:0.0];
}

- (void)showIntroWithCustomView {
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"Hello world";
    page1.desc = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
    page1.bgImage = [UIImage imageNamed:@"1"];
    page1.titleImage = [UIImage imageNamed:@"original"];
    
    UIView *viewForPage2 = [[UIView alloc] initWithFrame:self.view.bounds];
    UILabel *labelForPage2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 220, 300, 30)];
    labelForPage2.text = @"Some custom view";
    labelForPage2.font = [UIFont systemFontOfSize:32];
    labelForPage2.textColor = [UIColor whiteColor];
    labelForPage2.backgroundColor = [UIColor clearColor];
    labelForPage2.transform = CGAffineTransformMakeRotation(M_PI_2*3);
    [viewForPage2 addSubview:labelForPage2];
    EAIntroPage *page2 = [EAIntroPage pageWithCustomView:viewForPage2];
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = @"This is page 3";
    page3.desc = @"Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem.";
    page3.bgImage = [UIImage imageNamed:@"3"];
    page3.titleImage = [UIImage imageNamed:@"femalecodertocat"];
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3]];
    
    [intro setDelegate:self];
    [intro showInView:self.view animateDuration:0.0];
}

- (void)showIntroWithSeparatePagesInit {
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds];
    
    [intro setDelegate:self];
    [intro showInView:self.view animateDuration:0.0];
    
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"Hello world";
    page1.desc = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
    page1.bgImage = [UIImage imageNamed:@"1"];
    page1.titleImage = [UIImage imageNamed:@"original"];
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"This is page 2";
    page2.desc = @"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore.";
    page2.bgImage = [UIImage imageNamed:@"2"];
    page2.titleImage = [UIImage imageNamed:@"supportcat"];
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = @"This is page 3";
    page3.desc = @"Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem.";
    page3.bgImage = [UIImage imageNamed:@"3"];
    page3.titleImage = [UIImage imageNamed:@"femalecodertocat"];
    
    [intro setPages:@[page1,page2,page3]];
}

- (void)introDidFinish {
    NSLog(@"Intro callback");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HomePageDataNtf"  object:@{@"ret":@"20001" ,@"requestflag":@"addressLauch"}];
}

#pragma mark - 判断网络是否开启
-(BOOL) isConnectionAvailable{
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            //NSLog(@"notReachable");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            //NSLog(@"WIFI");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            //NSLog(@"3G");
            break;
    }
    
    //    if (!isExistenceNetwork) {
    //        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];//<span style="font-family: Arial, Helvetica, sans-serif;">MBProgressHUD为第三方库，不需要可以省略或使用AlertView</span>
    //        hud.removeFromSuperViewOnHide =YES;
    //        hud.mode = MBProgressHUDModeText;
    //        hud.labelText = @"当前网络不可用，请检查网络连接";  //提示的内容
    //        hud.minSize = CGSizeMake(132.f, 108.0f);
    //        [hud hide:YES afterDelay:3];
    //        return NO;
    //    }
    
    return isExistenceNetwork;
}
@end
