//
//  CommentTableViewCell.h
//  Massage
//
//  Created by 屈小波 on 15/11/26.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWStarRateView.h"
@interface CommentTableViewCell : UITableViewCell
@property (nonatomic,strong)NSMutableDictionary *listData;
@property(nonatomic,strong)UIView *BGView;
@property(nonatomic,strong)UIImageView *headView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)UIImageView *lineView;
@property(nonatomic,strong)CWStarRateView *startView;//评级
@end
