//
//  StoreActivityViewController.h
//  Massage
//
//  Created by htjd_IOS on 15/11/20.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface StoreActivityViewController : BaseViewController
@property (nonatomic , strong) NSString * ID;
@property (nonatomic , strong) NSString * name;
@property (nonatomic,strong) NSString * backType; //1返回时回到到店首页

@end
