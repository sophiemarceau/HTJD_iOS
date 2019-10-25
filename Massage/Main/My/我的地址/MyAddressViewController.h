//
//  MyAddressViewController.h
//  Massage
//
//  Created by 牛先 on 15/10/21.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^ReturnAddressInfoBlock)(NSDictionary * dic);

@interface MyAddressViewController : BaseViewController
@property (nonatomic , assign) BOOL isFromAppointment;

@property (nonatomic , copy) ReturnAddressInfoBlock returnAddressInfoBlock;
-(void)returnAddressInfo:(ReturnAddressInfoBlock)block;

@end
