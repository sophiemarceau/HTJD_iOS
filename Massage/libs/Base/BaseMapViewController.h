//
//  BaseMapViewController.h
//  Massage
//
//  Created by 屈小波 on 15/11/16.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
@interface BaseMapViewController :UIViewController<MAMapViewDelegate, AMapSearchDelegate>

@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) AMapSearchAPI *search;

- (void)returnAction;

- (NSString *)getApplicationName;
- (NSString *)getApplicationScheme;

@end