//
//  CustomCellTableViewCell.m
//  Pet
//
//  Created by ChinaSoft-Developer-01 on 14/7/24.
//  Copyright (c) 2014年 sophiemarceau_qu. All rights reserved.
//

#import "CustomCellTableViewCell.h"
#import "GridView.h"

@implementation CustomCellTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initView];
    }
    return self;
}
- (void)awakeFromNib
{
    // Initialization code
     [self _initView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)_initView
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    self.contentView.backgroundColor =[UIColor clearColor];
    
}

-(void)layoutSubviews{

    [super layoutSubviews];
    if (self.bgview) {
        [self.bgview removeFromSuperview];
    }
    self.bgview = [UIView new];
    
    self.bgview.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
    self.bgview.backgroundColor =[UIColor clearColor];
    [self.contentView addSubview:self.bgview];
    
    _gridViews = [[NSMutableArray alloc]init];
    for (int i=0; i<self.data.count; i++) {
        GridView *grid = [[GridView alloc]initWithFrame:CGRectZero];
        [_gridViews addObject:grid];
        [self.bgview addSubview:grid];
    }


    for (int i=0; i<self.data.count; i++) {
        GridView *grid =[_gridViews objectAtIndex:i];
//        if (i == 0) {
//            grid.frame = CGRectMake(1.25+kScreenWidth/2*i, 0, kScreenWidth/2-5, (108.75f+88.0f)*AUTO_SIZE_SCALE_X+10.0f);
//        }else if (i == 1 ) {
//            grid.frame = CGRectMake(kScreenWidth/2*i-1.25, 0, kScreenWidth/2-5, (108.75f+88.0f)*AUTO_SIZE_SCALE_X+10.0f);
//        }
        if (i == 0) {
            grid.frame = CGRectMake( kScreenWidth/2*i, 0, kScreenWidth/2, (108.75f+88.0f)*AUTO_SIZE_SCALE_X+10.0f);
            grid.lie = @"0";
        }else if (i == 1 ) {
            grid.frame = CGRectMake(kScreenWidth/2*i , 0, kScreenWidth/2, (108.75f+88.0f)*AUTO_SIZE_SCALE_X+10.0f);
            grid.lie = @"1";
        }
        if (i<self.data.count) {
            grid.hidden = NO;

            grid.dataDic = self.data[i];
        }else{
            grid.hidden = YES;
        }
    }
}
@end
