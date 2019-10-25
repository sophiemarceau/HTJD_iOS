//
//  ServiceFoundViewController.h
//  Massage
//
//  Created by htjd_IOS on 15/10/29.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

typedef void (^ReturnServiceFoundFavoriteChangeBlock)(NSString * change);

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface ServiceFoundViewController : BaseViewController
@property (nonatomic , strong )NSString * ID;
@property (nonatomic , copy) ReturnServiceFoundFavoriteChangeBlock returnServiceFoundFavoriteChangeBlock;
-(void)returnText:(ReturnServiceFoundFavoriteChangeBlock)block;

@end
