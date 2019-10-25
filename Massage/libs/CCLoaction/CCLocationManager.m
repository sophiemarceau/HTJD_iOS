//
//  CCLocationManager.m
//  MMLocationManager
//
//  Created by WangZeKeJi on 14-12-10.
//  Copyright (c) 2014年 Chen Yaoqiang. All rights reserved.
//

#import "CCLocationManager.h"
#import "CLLocation+YCLocation.h"
#import <AMapSearchKit/AMapSearchKit.h>

@interface CCLocationManager ()< AMapSearchDelegate >
{
    CLLocationManager *_manager;
    
}
@property (nonatomic, strong) LocationBlock locationBlock;
@property (nonatomic, strong) NSStringBlock cityBlock;
@property (nonatomic, strong) NSStringBlock addressBlock;
@property (nonatomic, strong) LocationErrorBlock errorBlock;
@property (nonatomic, strong) AMapSearchAPI *search;

@end

@implementation CCLocationManager


+ (CCLocationManager *)shareLocation{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (id)init {
    self = [super init];
    if (self) {
        NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
        
        float longitude = [standard floatForKey:CCLastLongitude];
        float latitude = [standard floatForKey:CCLastLatitude];
        self.longitude = longitude;
        self.latitude = latitude;
        self.lastCoordinate = CLLocationCoordinate2DMake(longitude,latitude);
        self.lastCity = [standard objectForKey:CCLastCity];
        self.lastAddress=[standard objectForKey:CCLastAddress];
    }
    return self;
}
//获取经纬度
- (void) getLocationCoordinate:(LocationBlock) locaiontBlock
{
    self.locationBlock = [locaiontBlock copy];
    [self startLocation];
}
//CCLocation
- (void) getLocationCoordinate:(LocationBlock) locaiontBlock  withAddress:(NSStringBlock) addressBlock
{
    self.locationBlock = [locaiontBlock copy];
    self.addressBlock = [addressBlock copy];
    [self startLocation];
}

- (void) getAddress:(NSStringBlock)addressBlock
{
    self.addressBlock = [addressBlock copy];
    [self startLocation];
}
//获取省市
- (void) getCity:(NSStringBlock)cityBlock
{
    self.cityBlock = [cityBlock copy];
    [self startLocation];
}

//- (void) getCity:(NSStringBlock)cityBlock error:(LocationErrorBlock) errorBlock
//{
//    self.cityBlock = [cityBlock copy];
//    self.errorBlock = [errorBlock copy];
//    [self startLocation];
//}
#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
    CLLocation * location = [[CLLocation alloc]initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    CLLocation * marsLoction =   [location locationMarsFromEarth];
    
    
    CLGeocoder *geocoder=[[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:marsLoction completionHandler:^(NSArray *placemarks,NSError *error)
     {
         if (placemarks.count > 0) {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             _lastCity = placemark.locality;
             [standard setObject:_lastCity forKey:CCLastCity];//省市地址
             NSLog(@"______%@",_lastCity);
             if (![_lastCity isEqualToString:@""]) {
                 
                 
                 
                 if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
                     NSLog(@"cityName====================== %@", [_lastCity substringToIndex:2]);
                     
                     [self changeCityName:[_lastCity substringToIndex:2]];
                 }
             }
             _lastAddress = placemark.name;
             NSLog(@"______%@",_lastAddress);
         }
         if (_cityBlock) {
             _cityBlock(_lastCity);
             _cityBlock = nil;
         }
         if (_addressBlock) {
             _addressBlock(_lastAddress);
             _addressBlock = nil;
         }
         
         
     }];
    
    
    
    
    //    CLLocation *location=[locations firstObject];//取出第一个位置
    //    CLLocationCoordinate2D coordinate=location.coordinate;//位置坐标
    //
    //    // 获取当前所在的城市名
    //    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //    //根据经纬度反向地理编译出地址信息
    //    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *array, NSError *error)
    //     {
    //         if (array.count > 0)
    //         {
    //             CLPlacemark *placemark = [array objectAtIndex:0];
    //
    //             //将获得的所有信息显示到label上
    //             //                 NSLog(@"placemark.name====================== %@", placemark.name);
    //
    //             //获取城市
    //             NSString *cityName = placemark.locality;
    //             NSLog(@"city = %@", cityName);
    //             if (!cityName) {
    //                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
    //                 cityName = placemark.administrativeArea;
    //             }
    //             if (![cityName isEqualToString:@""]) {
    //                 cityName = [cityName substringToIndex:2];
    //
    //
    //                 if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
    //                     NSLog(@"cityName====================== %@", cityName);
    //
    //                     [self changeCityName:cityName];
    //                 }
    //             }
    //         }
    //         else if (error == nil && [array count] == 0)
    //         {
    //             NSLog(@"No results were returned.");
    //         }
    //         else if (error != nil)
    //         {
    //             NSLog(@"An error occurred = %@", error);
    //         }
    //     }];
    
    
    
    
    
    _lastCoordinate = CLLocationCoordinate2DMake(marsLoction.coordinate.latitude ,marsLoction.coordinate.longitude);
    if (_locationBlock) {
        _locationBlock(_lastCoordinate);
        _locationBlock = nil;
    }
    
    NSLog(@"经纬度------------------>%f------%f",marsLoction.coordinate.latitude,marsLoction.coordinate.longitude);
    [standard setObject:@(marsLoction.coordinate.latitude) forKey:CCLastLatitude];
    [standard setObject:@(marsLoction.coordinate.longitude) forKey:CCLastLongitude];
    
    
    //    //第一次启动，开启定位成功
    //    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"secLaunch"]) {
    //        //根据经纬度 反编译地址
    //        _search = [[AMapSearchAPI alloc] init];
    //        [AMapSearchServices sharedServices].apiKey = GDMapKey;
    //        self.search.delegate = self;
    //        AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
    //        //            regeoRequest.searchType = AMapSearchType_ReGeocode;
    //        regeoRequest.location = [AMapGeoPoint locationWithLatitude:marsLoction.coordinate.latitude longitude:marsLoction.coordinate.longitude];
    //        //    regeoRequest.radius = 10000;
    //        regeoRequest.requireExtension = YES;
    //
    //        NSString * lat = [NSString stringWithFormat:@"%f",marsLoction.coordinate.latitude];
    //        NSString * lon = [NSString stringWithFormat:@"%f",marsLoction.coordinate.longitude];
    //        NSUserDefaults *  userDefaults = [NSUserDefaults standardUserDefaults];
    //        [userDefaults setObject:lat forKey:@"latitude"];
    //        [userDefaults setObject:lon forKey:@"longitude"];
    //        //加数据--------------------------------------------------
    //        [userDefaults setObject:@"北京" forKey:@"cityName"];
    //        [userDefaults setObject:@"110100" forKey:@"cityCode"];
    //        //位置显示
    //        [userDefaults setObject:@"北京" forKey:@"formattedAddress"];
    //        //--------------------------------------------------------
    //        [userDefaults setBool:YES forKey:@"secLaunch"];
    //        [userDefaults synchronize];
    //
    //        //发起逆地理编码
    //        [_search AMapReGoecodeSearch: regeoRequest];
    //
    //}
    
    [manager stopUpdatingLocation];
    
}

//实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    NSLog(@"实现逆地理编码的回调函数");
    if(response.regeocode != nil)
    {
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
        //        NSString *result = [NSString stringWithFormat:@"ReGeocode: %@", response.regeocode];
        //        NSString *result = [NSString stringWithFormat:@"ReGeocode: %@", response.regeocode.addressComponent];
        //        NSLog(@"response: %@", response.regeocode.formattedAddress);
        //        NSLog(@"response.regeocode.addressComponent.province: %@//", response.regeocode.addressComponent.province);
        //        NSLog(@"response.regeocode.addressComponent.city: %@//", response.regeocode.addressComponent.city);
        //        NSLog(@"response.regeocode.addressComponent.district: %@//", response.regeocode.addressComponent.district);
        //        NSLog(@"response.regeocode.addressComponent.citycode: %@//", response.regeocode.addressComponent.citycode);
        
        NSLog(@"首次登陆反编译地址response.regeocode.formattedAddress-->%@",response.regeocode.formattedAddress);
        //调城市接口
        //查询城市列表
        //        NSDictionary * dic = @{
        //                               @"type":@"1",
        //                               };
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
            //            NSLog(@"result ------  %@",result);
            //            cityListDic = [NSDictionary dictionaryWithDictionary:result];
            NSArray * cityArray =  [NSArray arrayWithArray: [result objectForKey:@"cityList"] ] ;
            
            for (NSDictionary * dic in cityArray) {
                NSString * cityName = [NSString stringWithFormat:@"%@",[dic objectForKey:@"cityName"]];
                NSString * cityCode = [NSString stringWithFormat:@"%@",[dic objectForKey:@"cityCode"]];
                NSLog(@"cityName  %@",cityName);
                NSLog(@"province  %@",province);
                NSLog(@"city  %@",city);
                //[dis rangeOfString:cityName].location !=NSNotFound
                [userDefaults setObject:@"北京" forKey:@"cityName"];
                [userDefaults setObject:@"110100" forKey:@"cityCode"];
                //位置显示
                [userDefaults setObject:@"北京" forKey:@"formattedAddress"];
                //默认一个经纬度，公司经纬度
                [userDefaults setObject:@"39.913355" forKey:@"latitude"];
                [userDefaults setObject:@"116.451896" forKey:@"longitude"];
                [userDefaults synchronize];
                if ([city rangeOfString:cityName].location !=NSNotFound||[province rangeOfString:cityName].location !=NSNotFound||[cityName isEqualToString:province]||[cityName isEqualToString:city]) {
                    [userDefaults setObject:cityName forKey:@"cityName"];
                    [userDefaults setObject:cityCode forKey:@"cityCode"];
                    //位置显示
                    [userDefaults setObject:response.regeocode.formattedAddress forKey:@"formattedAddress"];
                    [userDefaults synchronize];
                    return  ;
                }
                
            }
            
        } failuer:^(NSError *error) {
            [userDefaults setObject:@"北京" forKey:@"cityName"];
            [userDefaults setObject:@"110100" forKey:@"cityCode"];
            //位置显示
            [userDefaults setObject:@"北京" forKey:@"formattedAddress"];
            //默认一个经纬度，公司经纬度
            [userDefaults setObject:@"39.913355" forKey:@"latitude"];
            [userDefaults setObject:@"116.451896" forKey:@"longitude"];
            [userDefaults synchronize];
        }];
        
    }
}

-(void)changeCityName:(NSString *)cityname{
    
    [[RequestManager shareRequestManager] GetMyCityInfo:nil viewController:nil successData:^(NSDictionary *result) {
        
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


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([manager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [manager requestWhenInUseAuthorization];     //NSLocationWhenInUseDescription
                [manager requestAlwaysAuthorization];
            }
            break;
        case kCLAuthorizationStatusDenied:
            if ([manager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [manager requestWhenInUseAuthorization];     //NSLocationWhenInUseDescription
                [manager requestAlwaysAuthorization];
            }
            break;
        default:
            break;
    }
}


-(void)startLocation
{
    if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
        _manager=[[CLLocationManager alloc]init];
        _manager.delegate=self;
        _manager.desiredAccuracy = kCLLocationAccuracyBest;
        
        if(IOS8){
            [_manager requestAlwaysAuthorization];
        }
        
        _manager.distanceFilter=100;//十米定位一次
        _manager.desiredAccuracy=kCLLocationAccuracyHundredMeters;
        [_manager startUpdatingLocation];
        
    }
    else
    {
        UIAlertView *alvertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"需要开启定位服务,请到设置->隐私,打开定位服务" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alvertView show];
        
        [RequestManager shareRequestManager].curentlatitude =@"";
        [RequestManager shareRequestManager].curentlongitude =@"";
        
        
        
    }
    
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    
    //    UIAlertView *alvertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"需要开启定位服务,请到设置->隐私,打开定位服务" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    //    [alvertView show];
    [RequestManager shareRequestManager].curentlatitude =@"";
    [RequestManager shareRequestManager].curentlongitude =@"";
    
    NSLog(@"%d",[[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]);
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        
        NSUserDefaults *  userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"北京" forKey:@"cityName"];
        [userDefaults setObject:@"110100" forKey:@"cityCode"];
        //        [userDefaults setObject:@"2" forKey:@"openStatus"];
        [userDefaults synchronize];
    }
    
    //    //第一次启动，开启定位失败
    //    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"secLaunch"]) {
    //
    //        NSUserDefaults *  userDefaults = [NSUserDefaults standardUserDefaults];
    //        [userDefaults setObject:@"北京" forKey:@"cityName"];
    //        [userDefaults setObject:@"110100" forKey:@"cityCode"];
    //        //        [userDefaults setObject:@"2" forKey:@"openStatus"];
    //        //位置显示
    //        [userDefaults setObject:@"北京" forKey:@"formattedAddress"];
    //        //默认一个经纬度，公司经纬度
    //        [userDefaults setObject:@"39.913355" forKey:@"latitude"];
    //        [userDefaults setObject:@"116.451896" forKey:@"longitude"];
    //        
    //        [userDefaults setBool:YES forKey:@"secLaunch"];
    //        [userDefaults synchronize];
    //    }
    [self stopLocation];
    
}
-(void)stopLocation
{
    _manager = nil;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];//移除通知
}
@end
