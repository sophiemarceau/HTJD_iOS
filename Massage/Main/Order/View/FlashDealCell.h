//
//  FlashDealCell.h
//  Massage
//
//  Created by 牛先 on 16/2/24.
//  Copyright © 2016年 sophiemarceau_qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "nxUILabel.h"

@interface FlashDealCell : UITableViewCell
@property (nonatomic,strong)NSMutableDictionary *data;
@property (strong, nonatomic) UIView *backView;
@property (strong, nonatomic) UILabel *storeNameLabel;
@property (strong, nonatomic) UILabel *waitingForLabel;
@property (strong, nonatomic) UIImageView *storeImageView;
@property (strong, nonatomic) UILabel *serviceNameLabel;
@property (strong, nonatomic) UIImageView *homeOrStoreImageView;
//@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) nxUILabel *addressLabel;
@property (strong, nonatomic) UILabel *moneyLabel;
@property (strong, nonatomic) UIButton *IWantButton;
@property (strong, nonatomic) UIView *buttonBackView;
@property (strong, nonatomic) UIView *storeBackView;
@property (strong, nonatomic) nxUILabel *dizhi;
//@property (strong, nonatomic) UIView *storeTelPhoneView;
//@property (strong, nonatomic) UILabel *storeTelPhoneLabel;
//@property (strong, nonatomic) UIImageView *storeTelPhoneImage;
@end
