//
//  consumptionTableViewCell.h
//  Massage
//
//  Created by 屈小波 on 15/11/20.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface consumptionTableViewCell : UITableViewCell
@property (nonatomic,strong)NSMutableDictionary *data;
@property (nonatomic,strong)UIView *BGView;
@property (nonatomic,strong)UIView *doorView;
@property (nonatomic,strong)UIImageView *statusImageView;
@property (nonatomic,strong)UIImageView *pictureImageView;
@property (nonatomic,strong)UILabel *doorLabel;
@property (nonatomic,strong)UIImageView *arrowImageView;
@property (nonatomic,strong)UIImageView *lineImageView;
@property (nonatomic,strong)UIImageView *line1ImageView;
@property (nonatomic,strong)UILabel *serviceLabel;
@property (nonatomic,strong)UILabel *serviceTimeLabel;
@property (nonatomic,strong)UILabel *serviceAddressLabel;
@property (nonatomic,strong)UILabel *codeLabel;
@property (nonatomic,strong)UILabel *codeLabel1;
@end
