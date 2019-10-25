//
//  AddressView.h
//  Massage
//
//  Created by htjd_IOS on 15/11/2.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressView : UIView
@property(nonatomic,strong)NSDictionary *dataDic;
@property (nonatomic,strong)UIView *contentView;
@property (nonatomic,assign) BOOL isFromAppointment;

@end
