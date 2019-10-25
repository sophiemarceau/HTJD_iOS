//
//  SelectCityViewController.h
//  Massage
//
//  Created by htjd_IOS on 15/11/4.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

typedef void (^ReturnselectCityInfo)(NSString * selectCityType);//selectCityType 0点击返回键 1选择城市返回

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

#import <MAMapKit/MAMapKit.h>
//#import <AMapSearchKit/AMapSearchAPI.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface SelectCityViewController : BaseViewController<MAMapViewDelegate, AMapSearchDelegate>
@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) NSString * city;
@property (nonatomic, strong) NSString * currentCode;
@property (nonatomic, strong) ReturnselectCityInfo returnselectCityInfo;
-(void)returnCityInfo:(ReturnselectCityInfo)block;
@end
