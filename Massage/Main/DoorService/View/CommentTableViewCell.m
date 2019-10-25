//
//  CommentTableViewCell.m
//  Massage
//
//  Created by 屈小波 on 15/11/26.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "UIImageView+WebCache.h"
@implementation CommentTableViewCell{
    UIButton  *serviceScoreBtn;
    NSMutableArray *serviceScoreBtnArray;//存储项目按钮
}

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
    [self _initView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)_initView
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor =C2UIColorGray;
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self.contentView addSubview:self.BGView];
    [self.BGView addSubview:self.headView];
    [self.BGView addSubview:self.nameLabel];
    [self.BGView addSubview:self.timeLabel];
    [self.BGView addSubview:self.contentLabel];
    [self.BGView addSubview:self.lineView];

    [self initStar];

    
    self.BGView.frame = CGRectMake(0, 0, kScreenWidth, self.contentView.frame.size.height);
    self.headView.frame = CGRectMake(10, 12, 40, 40);
    self.nameLabel.frame = CGRectMake(10+40+8, 18, 130, 13);
    self.timeLabel.frame = CGRectMake(kScreenWidth-10-120, 20, 120, 11);


    UIFont *font = [UIFont systemFontOfSize:13];
    NSString *remarkstring =  [NSString stringWithFormat:@"%@",[self.listData objectForKey:@"remark"]];

    CGSize titleSize = [remarkstring sizeWithFont:font constrainedToSize:CGSizeMake(kScreenWidth-45-(10+40+8), MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    float small =  MAX(ceilf(titleSize.height) ,  13);
    
 
    self.contentLabel.frame = CGRectMake(10+40+8, self.headView.frame.origin.y+self.headView.frame.size.height+12, kScreenWidth-45-(10+40+8), small);
    self.contentLabel.text= remarkstring;

    [self.headView setImageWithURL:[NSURL URLWithString:[self.listData objectForKey:@"icon"]] placeholderImage:[UIImage imageNamed:@"icon_touxiang"]];
    self.nameLabel.text =[NSString stringWithFormat:@"%@",[self.listData objectForKey:@"name"]];
    self.timeLabel.text =[NSString stringWithFormat:@"%@",[self.listData objectForKey:@"evalTime"]];

    self.lineView.frame = CGRectMake(15, self.contentView.frame.size.height-0.5, kScreenWidth-15, 0.5);
}





-(UIView *)BGView{
    if (_BGView ==nil) {
        _BGView = [UIView new];
        _BGView.backgroundColor =[UIColor whiteColor];
       
        
    }
    return _BGView;
}

-(UIImageView *)headView{
    if (_headView ==nil) {
        _headView = [UIImageView new];
        _headView.backgroundColor =[UIColor clearColor];
        _headView.layer.cornerRadius = 20.0;
        _headView.layer.masksToBounds = YES;

    }
    return _headView;

}

-(UILabel *)nameLabel{
    if (_nameLabel ==nil) {
        _nameLabel = [UILabel new];
        _nameLabel.backgroundColor =[UIColor clearColor];
        _nameLabel.font = [UIFont systemFontOfSize:13];
        _nameLabel.textColor =BlackUIColorC5;
        
    }
    return _nameLabel;
}

-(UILabel *)timeLabel{
    if (_timeLabel ==nil) {
        _timeLabel = [UILabel new];
        _timeLabel.backgroundColor =[UIColor clearColor];
        _timeLabel.font = [UIFont systemFontOfSize:10];
        _timeLabel.textColor = UIColorGrayString;
        _timeLabel.textAlignment = NSTextAlignmentRight;
        
    }
    return _timeLabel;
}

-(UILabel *)contentLabel{
    if (_contentLabel ==nil) {
        _contentLabel = [UILabel new];
        _contentLabel.backgroundColor =[UIColor clearColor];
        _contentLabel.numberOfLines =0;
        _contentLabel.font = [UIFont systemFontOfSize:13];
        _contentLabel.textColor =BlackUIColorC5;
        
    }
    return _contentLabel;
}


-(UIImageView *)lineView{
    if (_lineView ==nil) {
        _lineView = [UIImageView new];
        _lineView.backgroundColor =[UIColor lightGrayColor];
        
    }
    return _lineView;
    
}

-(void)initStar{
    serviceScoreBtnArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    for (int i = 4000; i < 4005; i++) {
        serviceScoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];//12.5 12.5
        serviceScoreBtn.frame = CGRectMake((10+40+8) + (6+12.5)*(i-4000), 31+8, 12.5, 12.5);
        [serviceScoreBtn setBackgroundImage:[UIImage imageNamed:@"icon_stars-11"] forState:UIControlStateNormal];
        serviceScoreBtn.tag = i;
        serviceScoreBtn.userInteractionEnabled =NO;
        [serviceScoreBtnArray addObject:serviceScoreBtn];
        [self addSubview:serviceScoreBtn];
    }
    

    
    NSString *temp = [self.listData objectForKey:@"score"];

    int Score  = [temp intValue];
    for (serviceScoreBtn in serviceScoreBtnArray) {
        if ((serviceScoreBtn.tag -4000)+1<=  Score) {
            [serviceScoreBtn setBackgroundImage:[UIImage imageNamed:@"icon_stars"] forState:UIControlStateNormal];
        }else {
            [serviceScoreBtn setBackgroundImage:[UIImage imageNamed:@"icon_nostars"] forState:UIControlStateNormal];
        }
    }
}
@end              
