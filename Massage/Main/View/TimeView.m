//
//  TimeView.m
//  Massage
//
//  Created by htjd_IOS on 15/11/13.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "TimeView.h"

@implementation TimeView
//{
//    UIView * contentView;
//}
//@synthesize dataDic;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initView];
    }
    return self;
}


-(void)_initView{
    
  

}


-(void)layoutSubviews{
    
    [super layoutSubviews];
    self.contentView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (kScreenWidth-24*AUTO_SIZE_SCALE_X-6*AUTO_SIZE_SCALE_X)/4, 45*AUTO_SIZE_SCALE_X)];
    self.contentView.backgroundColor = [UIColor whiteColor];
//    [self.contentView setHighlightedImage:[UIImage imageNamed:@"icon_timesel"]];
    [self.contentView setHighlightedImage:[UIImage imageNamed:@"icon_selectiontime"]];
    [self addSubview:self.contentView];
    self.contentView.userInteractionEnabled =YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer  alloc] initWithTarget:self action:@selector(ViewTaped:)];
    [self.contentView addGestureRecognizer:tap];
    
    UILabel * label = [[UILabel alloc] initWithFrame:self.contentView.frame];
    label.text = [self.dataDic objectForKey:@"timeSlot"];
    label.textAlignment = NSTextAlignmentCenter;
    if ([[NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"isAvailable"]] isEqualToString:@"1"]) {
        label.textColor = [UIColor blackColor];
    }else{
        label.textColor = C7UIColorGray;
        label.backgroundColor = C2UIColorGray   ;
        label.layer.borderColor = C7UIColorGray.CGColor;
        label.layer.borderWidth = 1;
    
    }
    [self.contentView addSubview:label];
    
    if ([self.selectFlag isEqualToString:@"0"]) {
        
        [self.contentView setHighlighted:NO];
        
    }else if ([self.selectFlag isEqualToString:@"1"]){
        
        [self.contentView setHighlighted:YES];
    }
}

-(void)ViewTaped:(UITapGestureRecognizer *)sender
{

     [[NSNotificationCenter defaultCenter] postNotificationName:@"selectTime" object:self.dataDic];
    NSLog(@"self.selectFlag %@",self.selectFlag);
}

-(void)setDataDic:(NSDictionary *)dataDic{
    if (_dataDic!=dataDic) {
        _dataDic =dataDic;
    }
    [self setNeedsLayout];
}
@end
