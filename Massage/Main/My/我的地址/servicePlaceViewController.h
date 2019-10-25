//
//  servicePlaceViewController.h
//  Massage
//
//  Created by htjd_IOS on 15/11/3.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>

typedef void (^ReturnServerAddressTextBlock)(NSString * cityName , NSString * userArea ) ;

@interface servicePlaceViewController : BaseViewController<MAMapViewDelegate, AMapSearchDelegate>
@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, copy) ReturnServerAddressTextBlock returnServerAddressTextBlock;
- (void)returnText:(ReturnServerAddressTextBlock)block;
@end
