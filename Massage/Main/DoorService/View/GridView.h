//
//  GridView.h
//  Pet
//
//  Created by ChinaSoft-Developer-01 on 14/7/24.
//  Copyright (c) 2014年 sophiemarceau_qu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GridView : UIView{
    UIButton *_bgView;
    UIImageView *backgroundView;
    UIImageView *picView;
    UILabel *_titleLabel;
    CGSize contentView;
}

@property(nonatomic,strong)NSString *data;
@property(nonatomic,strong)NSString * lie;
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
