//
//  CityChangeViewController.h
//  Massage
//
//  Created by htjd_IOS on 15/10/19.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
typedef void (^ReturnChangeCityInfoBlock)(NSDictionary * dic);
@interface CityChangeViewController : BaseViewController
@property (nonatomic,copy) ReturnChangeCityInfoBlock returnChangeCityInfoBlock;
-(void)returnCityInfo:(ReturnChangeCityInfoBlock)block;
@end
