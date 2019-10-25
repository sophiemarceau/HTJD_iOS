//
//  AddNewAddressViewController.h
//  Massage
//
//  Created by htjd_IOS on 15/11/3.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface AddNewAddressViewController : BaseViewController
@property (nonatomic ,assign) BOOL isNew;
@property (nonatomic ,strong) NSString * addressID;
@property (nonatomic ,strong) NSString * isDefault;
@property (nonatomic ,strong) NSDictionary * addressDic;
@end
