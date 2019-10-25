//
//  SingleLevelServiceTableViewCell.m
//  Massage
//
//  Created by htjd_IOS on 15/12/9.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "SingleLevelServiceTableViewCell.h"
#import "SingleLevelServiceView.h"
@implementation SingleLevelServiceTableViewCell

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
        SingleLevelServiceView *grid = [[SingleLevelServiceView alloc]initWithFrame:CGRectZero];
        [_gridViews addObject:grid];
        [self.bgview addSubview:grid];
    }
    
    //    NSLog(@"self.data = %@",self.data);
    for (int i=0; i<self.data.count; i++) {
        SingleLevelServiceView *grid =[_gridViews objectAtIndex:i];
        if (i == 0) {
            grid.frame = CGRectMake( kScreenWidth/2*i, 0, kScreenWidth/2 , (108.75f+88.0f)*AUTO_SIZE_SCALE_X+10.0f-20);
            grid.lie = @"0";
        }else if (i == 1 ) {
            grid.frame = CGRectMake(kScreenWidth/2*i , 0, kScreenWidth/2 , (108.75f +88.0f )*AUTO_SIZE_SCALE_X+10.0f-20 );
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
