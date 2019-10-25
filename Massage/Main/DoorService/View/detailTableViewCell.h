//
//  detailTableViewCell.h
//  Massage
//
//  Created by 屈小波 on 15/12/15.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface detailTableViewCell : UITableViewCell
@property (nonatomic,strong) NSDictionary * listArrayData;
@property (nonatomic , strong) UIView *ClientView;

@property (nonatomic , strong) UIView *StoreNameView;
@property (nonatomic , strong) UILabel *StoreNameLabel;
@property (nonatomic , strong) UIImageView *phoneView;
@property (nonatomic , strong) UIImageView *line1ImageView;

@property (nonatomic , strong) UIView *ServiceView;
@property (nonatomic , strong) UIImageView *ServiceImageView;

@property (nonatomic , strong) UILabel *ServiceDistrictLabel;//自营的 服务商圈
@property (nonatomic , strong) UILabel *distanceLabel;
@property (nonatomic , strong) UIImageView *line2ImageView;

@property (nonatomic , strong) UIView *ClientSayView;
@property (nonatomic , strong) UIImageView *ClientImageview;
@property (nonatomic , strong) UILabel *ClientLabel;
@property (nonatomic , strong) UILabel *ClientCountLabel;


@property (nonatomic , strong) UIImageView *ClientArrow1;
@property (nonatomic , strong) UIImageView *ClientArrow2;
@property (nonatomic , strong) UIImageView *ClientArrow3;

@property (nonatomic , strong) UIView *ServiceUIView;
@property (nonatomic , strong) UILabel *ServiceLabel;
@property (nonatomic , strong) UILabel *ServiceZoneLabel;

@end
