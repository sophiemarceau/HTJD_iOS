//
//  StoreAppointmentViewController.m
//  Massage
//
//  Created by htjd_IOS on 15/11/9.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "StoreAppointmentViewController.h"
#import "UIImageView+WebCache.h"

@interface StoreAppointmentViewController ()
{
    UIView * serviceIntroView;
    UIView * serviceLevelView;
    UIView * serviceTimeView;
    UIView * serviceInfoView;
    UIView * serviceMoneyView;
    UIView * servicePayView;
    
    NSString * perPrice;
    NSString * remarkPrice;
}
@end

@implementation StoreAppointmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titles = @"预约到店";
    perPrice = @"198";
    
    [self initserviceIntroView];
    [self initserviceLevelView];
    [self initserviceTimeView];
    [self initserviceInfoView];
    [self initserviceMoneyView];
    [self initservicePayView];
}

-(void)initserviceIntroView
{
    serviceIntroView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavHeight+10*AUTO_SIZE_SCALE_X, kScreenWidth, 90*AUTO_SIZE_SCALE_X)];
    serviceIntroView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:serviceIntroView];
    
    UIImageView * touxiangImv = [[UIImageView alloc] initWithFrame:CGRectMake(11*AUTO_SIZE_SCALE_X, 11*AUTO_SIZE_SCALE_X, 66*AUTO_SIZE_SCALE_X, 66*AUTO_SIZE_SCALE_X)];
    [touxiangImv setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"icon_touxiang"]];
    touxiangImv.layer.borderColor = C6UIColorGray.CGColor;
    touxiangImv.layer.borderWidth = 1;
    touxiangImv.layer.cornerRadius = 5.0;
    [serviceIntroView addSubview:touxiangImv];
    
    UILabel * serviceNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(touxiangImv.frame.origin.x+touxiangImv.frame.size.width+10*AUTO_SIZE_SCALE_X, touxiangImv.frame.origin.y, kScreenWidth-(touxiangImv.frame.origin.x+touxiangImv.frame.size.width+10*AUTO_SIZE_SCALE_X+10*AUTO_SIZE_SCALE_X), 16*AUTO_SIZE_SCALE_X)];
    serviceNameLabel.text = [NSString stringWithFormat:@"%@",@"全身经络按摩"];
    serviceNameLabel.font = [UIFont systemFontOfSize:16];
    serviceNameLabel.textAlignment = NSTextAlignmentLeft;
    [serviceIntroView addSubview:serviceNameLabel];
    
    UILabel * servicePerTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(serviceNameLabel.frame.origin.x, serviceNameLabel.frame.origin.y+serviceNameLabel.frame.size.height+10*AUTO_SIZE_SCALE_X, 180*AUTO_SIZE_SCALE_X, 14*AUTO_SIZE_SCALE_X)];
    servicePerTimeLabel.text = [NSString stringWithFormat:@"%@分钟",@"45"];
    servicePerTimeLabel.textColor = C6UIColorGray;
    servicePerTimeLabel.textAlignment = NSTextAlignmentLeft;
    servicePerTimeLabel.font = [UIFont systemFontOfSize:14];
    [serviceIntroView addSubview: servicePerTimeLabel];
    
    NSString * perPriceStr = [NSString stringWithFormat:@"¥%@",perPrice];
    NSMutableAttributedString * perPriceAttstr = [[NSMutableAttributedString alloc] initWithString:perPriceStr];
    [perPriceAttstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:9] range:NSMakeRange(0, 1)];
    [perPriceAttstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(1, perPrice.length)];
    [perPriceAttstr addAttribute:NSForegroundColorAttributeName value:RedUIColorC1 range:NSMakeRange(0, perPriceStr.length)];
    
    UILabel * servicePerPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(servicePerTimeLabel.frame.origin.x, servicePerTimeLabel.frame.origin.y+servicePerTimeLabel.frame.size.height+10*AUTO_SIZE_SCALE_X, 100, 15*AUTO_SIZE_SCALE_X)];
    servicePerPriceLabel.attributedText = perPriceAttstr;
    CGSize perPriceLabelSize = [servicePerPriceLabel intrinsicContentSize];
    servicePerPriceLabel.frame = CGRectMake(servicePerPriceLabel.frame.origin.x, servicePerPriceLabel.frame.origin.y, perPriceLabelSize.width, servicePerPriceLabel.frame.size.height);
    [serviceIntroView addSubview:servicePerPriceLabel];
    
//    NSString * remarkPriceStr 
    
    
}

-(void)initserviceLevelView
{
    
}

-(void)initserviceTimeView
{
    
}

-(void)initserviceInfoView
{
    
}

-(void)initserviceMoneyView
{
    
}

-(void)initservicePayView
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
