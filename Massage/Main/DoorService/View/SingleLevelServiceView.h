//
//  SingleLevelServiceView.h
//  Massage
//
//  Created by htjd_IOS on 15/12/9.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleLevelServiceView : UIView{
    UIButton *_bgView;
    UIImageView *backgroundView;
    UIImageView *picView;
    UILabel *_titleLabel;
    CGSize contentView;
}

@property(nonatomic,strong)NSString *data;
@property(nonatomic,strong)NSString *lie;
@property(nonatomic,strong)NSDictionary *dataDic;
@property (nonatomic,strong)UIView *contentView;
@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *AddressLabel;
@property (nonatomic,strong)UILabel *PriceLabel;
@property (nonatomic,strong)UILabel *Price1Label;
@property (nonatomic,strong)UILabel *Price2Label;
@property (nonatomic,strong)UILabel *markLabel;
@property (nonatomic,strong)UILabel *markStrLabel;
@property (nonatomic,strong)UILabel *remarkPriceLabel;


@end
