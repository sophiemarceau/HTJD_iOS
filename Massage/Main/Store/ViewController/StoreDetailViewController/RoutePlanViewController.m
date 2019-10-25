//
//  RoutePlanViewController.m
//  Massage
//
//  Created by 屈小波 on 15/11/16.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "RoutePlanViewController.h"
#import "MANaviAnnotationView.h"
#import "CCLocationManager.h"
#import "LocalizedCurrentLocation.h"
#import <MapKit/MKPlacemark.h>
#import <AddressBook/AddressBook.h>


@interface RoutePlanViewController ()<UIActionSheetDelegate>{
    MAPointAnnotation *_startAnnotation;
}

@property (nonatomic, strong) MAPointAnnotation * destination;
@property (nonatomic, assign) BOOL isFirstAppear;

@end

@implementation RoutePlanViewController

@synthesize search  = _search;

-(void)backAction
{
    [super backAction];
    
    [self clearMapView];
    
    [self clearSearch];
}

- (void)clearMapView
{
    self.mapView.showsUserLocation = NO;
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    [self.mapView removeOverlays:self.mapView.overlays];
    
    self.mapView.delegate = nil;
}

- (void)clearSearch
{
    self.search.delegate = nil;
}

- (void)hookAction
{
}

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor redColor];
    self.mapView =[[MAMapView alloc] init];
    _isFirstAppear = YES;
    
    [self initMapView];
    
    [self initSearch];
    
    [self initStart];
    
    [self initDestination];
}

#pragma mark - Initialization

- (void)initMapView
{
    self.mapView.frame = CGRectMake(0, kNavHeight,kScreenWidth,kScreenHeight-kNavHeight);
    
    self.mapView.delegate = self;
    
    [self.view addSubview:self.mapView];
}

- (void)initSearch
{
    self.search.delegate = self;
}

-(void)initStart{
    if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
        [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
            
            _startAnnotation = [[MAPointAnnotation alloc] init];
            _startAnnotation.coordinate = locationCorrrdinate;
        }];
    }else{
        
    }
}

- (void)initDestination
{
    self.destination = [[MAPointAnnotation alloc] init];
    
    self.destination.coordinate = CLLocationCoordinate2DMake(self.latitude,self.longitude);
    
    NDLog(@"destination------>%f",self.destination.coordinate.latitude);
    self.destination.title = @"该门店位置";
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_isFirstAppear)
    {
        _isFirstAppear = NO;
        
        [self hookAction];
    }
    
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [self.mapView setZoomLevel:13 animated:YES];
    [self.mapView addAnnotation:self.destination];
    [self.mapView selectAnnotation:self.destination animated:YES];
}

- (void)dealloc
{
    self.mapView.visibleMapRect = MAMapRectMake(220880104, 101476980, 272496, 466656);
}

- (NSString *)getApplicationName
{
    NSDictionary *bundleInfo = [[NSBundle mainBundle] infoDictionary];
    return [bundleInfo valueForKey:@"CFBundleDisplayName"] ?: [bundleInfo valueForKey:@"CFBundleName"];
}

- (NSString *)getApplicationScheme
{
    NSDictionary *bundleInfo    = [[NSBundle mainBundle] infoDictionary];
    NSString *bundleIdentifier  = [[NSBundle mainBundle] bundleIdentifier];
    NSArray *URLTypes           = [bundleInfo valueForKey:@"CFBundleURLTypes"];
    
    NSString *scheme;
    for (NSDictionary *dic in URLTypes)
    {
        NSString *URLName = [dic valueForKey:@"CFBundleURLName"];
        if ([URLName isEqualToString:bundleIdentifier])
        {
            scheme = [[dic valueForKey:@"CFBundleURLSchemes"] objectAtIndex:0];
            break;
        }
    }
    return scheme;
}

#pragma mark - AMapSearchDelegate

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"%s: searchRequest = %@, errInfo= %@", __func__, [request class], error);
}

#pragma mark - mapView delegate

- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    
    if ([view.annotation isKindOfClass:[MAPointAnnotation class]])
    {
        if ([control tag] == 1)
        {
            [self OpenMap];
        }
        else if([control tag] == 2)
        {
            [self callMapShowPathFromCurrentLocationTo:view.annotation.coordinate andDesName:nil];
        }
    }
    
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        MANaviAnnotationView *annotationView = (MANaviAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        
        if (annotationView == nil)
        {
            annotationView = [[MANaviAnnotationView alloc] initWithAnnotation:annotation
                                                              reuseIdentifier:pointReuseIndetifier];
        }
        
        annotationView.canShowCallout               = YES;
        annotationView.animatesDrop                 = YES;
        annotationView.draggable                    = YES;
        //show detail by right callout accessory view.
        annotationView.rightCalloutAccessoryView     = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        annotationView.rightCalloutAccessoryView.tag = 1;
        
        //call online navi by left accessory.
        annotationView.leftCalloutAccessoryView.tag  = 2;
        return annotationView;
        
    }
    
    return nil;
}

-(void)OpenMap{ // 直接调用ios自己带的apple map
    UIActionSheet *t_actionSheet = [[UIActionSheet alloc]initWithTitle:@"请选择地图" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
    t_actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    
    //这个判断其实是不需要的 😄
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"http://maps.apple.com/"]])
    {
        [t_actionSheet addButtonWithTitle:@"苹果自带地图导航"];
    }
    
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]])
    {
        [t_actionSheet addButtonWithTitle:@"百度地图导航"];
    }
    
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]])
    {
        [t_actionSheet addButtonWithTitle:@"高德地图导航"];
    }
    
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]])
    {
        [t_actionSheet addButtonWithTitle:@"google地图导航"];
    }
    
    [t_actionSheet showInView:self.view];
}


#pragma mark - actionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {//苹果自带导航
        
        [self callMapShowPathFromCurrentLocationTo:self.destination.coordinate andDesName:nil];
        
    }else if (buttonIndex == 2) {//百度 导航
        
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02",self.destination.coordinate.latitude, self.destination.coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        
    }else if(buttonIndex == 3) {//高德 导航
        MARouteConfig *config = [MARouteConfig new];
        config.appName = [self getApplicationName];
        config.appScheme = [self getApplicationScheme];
        config.startCoordinate = _startAnnotation.coordinate;
        config.destinationCoordinate  = self.destination.coordinate;
        config.routeType = MARouteSearchTypeDriving;
        [MAMapURLSearch openAMapRouteSearch:config];
        
        if(![MAMapURLSearch openAMapRouteSearch:config])
        {
            [MAMapURLSearch getLatestAMapApp];
        }
    }else if(buttonIndex == 4) {//google 导航
        
        NSString *urlScheme =@"comgooglemaps://";
        
        NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving",[self getApplicationName],urlScheme,self.destination.coordinate.latitude, self.destination.coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //            NSLog(@"%@",urlString);
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
}

#pragma mark - 苹果自带导航
-(void)callMapShowPathFromCurrentLocationTo:(CLLocationCoordinate2D)desCoordinate andDesName:(NSString *)desName{
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 6.0f) {
        //ios_version为4.0～5.1时 调用谷歌地图客户端
        
        //生成url字符串
        NSString *currentLocation = [LocalizedCurrentLocation currentLocationStringForCurrentLanguage];
        NSString *desLocation = [NSString stringWithFormat:@"%f,%f",
                                 desCoordinate.latitude,
                                 desCoordinate.longitude];
        NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%@&daddr=%@",
                               currentLocation,desLocation];
        //转换为utf8编码
        urlString =  [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        
        UIApplication *app =[UIApplication sharedApplication];
        NSURL *url = [NSURL URLWithString:urlString];
        
        //验证url是否可用
        if ([app canOpenURL:url]) {
            [app openURL:url];
        }else{
            //手机客户端不支持此功能 或者 目的地有误
            [self showAlertTitle:@"不能打开该地址" andContent:@"您输入的位置可能有误"];
        }
        
    }else{
        //ios_version为 >=6.0时 调用苹果地图客户端
        
        //验证MKMapItem的有效性
        Class itemClass = [MKMapItem class];
        if (itemClass && [itemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)]) {
            desName = desName?desName:@"该门店地址";
            NSDictionary *dicOfAddress = [NSDictionary dictionaryWithObjectsAndKeys:
                                          desName,(NSString *)kABPersonAddressStreetKey, nil];
            MKPlacemark *palcemake = [[MKPlacemark alloc] initWithCoordinate:desCoordinate addressDictionary:dicOfAddress];
            MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:palcemake];
            
            NSDictionary *dicOfMode = [NSDictionary dictionaryWithObjectsAndKeys:
                                       MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsDirectionsModeKey, nil];
            

            if (![mapItem openInMapsWithLaunchOptions:dicOfMode]) {
                //打开失败
                [self showAlertTitle:@"不能打开该地址" andContent:@"您输入的位置可能有误"];
            }
        }
    }
}

/**
 用于弹出警告提示信息
 @param title:警告框的标题
 @param content:警告框显示的提示性内容
 */
-(void)showAlertTitle:(NSString *)title andContent:(NSString *)content{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:title
                                                 message:content
                                                delegate:nil
                                       cancelButtonTitle:@"确定"
                                       otherButtonTitles:nil, nil];
    [av show];
    
}
@end
