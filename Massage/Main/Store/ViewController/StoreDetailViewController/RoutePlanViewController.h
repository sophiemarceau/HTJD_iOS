//
//  RoutePlanViewController.h
//  Massage
//
//  Created by 屈小波 on 15/11/16.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
@interface RoutePlanViewController : BaseViewController<MAMapViewDelegate, AMapSearchDelegate>

@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) AMapSearchAPI *search;

@property (assign, nonatomic) double latitude;
@property (assign, nonatomic) double longitude;

@end
