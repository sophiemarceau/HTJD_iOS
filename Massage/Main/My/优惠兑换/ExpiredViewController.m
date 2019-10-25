//
//  ExpiredViewController.m
//  Massage
//
//  Created by htjd_IOS on 15/11/10.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "ExpiredViewController.h"
#import "publicTableViewCell.h"
#import "noWifiView.h"
@interface ExpiredViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * myTableView;
    NSMutableArray * expiredArray;
    noWifiView * failView;
}
@end

@implementation ExpiredViewController

-(void)downLoadUnusedata
{
    [failView.activityIndicatorView startAnimating];
    failView.activityIndicatorView.hidden = NO;
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * userID = [userDefaults objectForKey:@"userID"];
    NSDictionary * dic = @{
                           @"userID":userID,
                           @"status":@"2",//0 未使用1 已使用 2 已过期
                           };
    [[RequestManager shareRequestManager]  getUserCouponList:dic viewController:self successData:^(NSDictionary *result) {
        NSLog(@"优惠券列表result -- %@",result);
        if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
            failView.hidden = YES;
            [failView.activityIndicatorView stopAnimating];
            failView.activityIndicatorView.hidden = YES;
            
            [expiredArray addObjectsFromArray:[result objectForKey:@"couponList"]];
            [myTableView reloadData];
            
        }
        else{
            [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
        }
    } failuer:^(NSError *error) {
        failView.hidden = NO;
        [failView.activityIndicatorView stopAnimating];
        failView.activityIndicatorView.hidden = YES;
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titles = @"过期优惠券";
    expiredArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    
    [self downLoadUnusedata];
    
    [self initTableView];
    
}

-(void)initTableView
{
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myTableView];
    //加载数据失败时显示
    failView = [[noWifiView alloc]initWithFrame:CGRectMake(0,kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
    [failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    failView.hidden = YES;
    [self.view addSubview:failView];
}
- (void)reloadButtonClick:(UIButton *)sender {
    [self downLoadUnusedata];
}

#pragma mark UITableView代理

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115*AUTO_SIZE_SCALE_X;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return expiredArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellName = @"publicTableViewCell";
    publicTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        NSArray * nibArray = [[NSBundle mainBundle] loadNibNamed:cellName owner:nil options:nil];
        cell = (publicTableViewCell *)[nibArray objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.backgroundColor = [UIColor clearColor];
    UIImageView * bgImv = [[UIImageView alloc] initWithFrame:CGRectMake(15*AUTO_SIZE_SCALE_X, 10*AUTO_SIZE_SCALE_X, kScreenWidth-30*AUTO_SIZE_SCALE_X, 105*AUTO_SIZE_SCALE_X)];
    bgImv.image = [UIImage imageNamed:@"bg_user_coupon_gray"];
    [cell addSubview:bgImv];
    
    float price = [[[expiredArray objectAtIndex:indexPath.row] objectForKey:@"price"] floatValue];
    price = price/100.0;
    UILabel * priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30*AUTO_SIZE_SCALE_X, 95*AUTO_SIZE_SCALE_X, 17*AUTO_SIZE_SCALE_X)];
    priceLabel.text = [NSString stringWithFormat:@"¥ %0.2f",price];
    priceLabel.textColor = [UIColor whiteColor];
    priceLabel.textAlignment = NSTextAlignmentCenter;
    priceLabel.font = [UIFont systemFontOfSize:17];
    [bgImv addSubview:priceLabel];
    
    UILabel * typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, priceLabel.frame.origin.y+priceLabel.frame.size.height+12*AUTO_SIZE_SCALE_X, 95*AUTO_SIZE_SCALE_X, 14*AUTO_SIZE_SCALE_X)];
    typeLabel.text = [NSString stringWithFormat:@"%@",@"优惠券"];
    typeLabel.textColor = [UIColor whiteColor];
    typeLabel.textAlignment = NSTextAlignmentCenter;
    typeLabel.font = [UIFont systemFontOfSize:14];
    [bgImv addSubview:typeLabel];
    
    UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(110*AUTO_SIZE_SCALE_X, 18*AUTO_SIZE_SCALE_X, 170*AUTO_SIZE_SCALE_X, 13*AUTO_SIZE_SCALE_X)];
    nameLabel.text = [NSString stringWithFormat:@"%@",[[expiredArray objectAtIndex:indexPath.row] objectForKey:@"name"]];
    nameLabel.textColor = C6UIColorGray;
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.font = [UIFont systemFontOfSize:13];
    [bgImv addSubview:nameLabel];
    
    UILabel * introductionLabel = [[UILabel alloc] initWithFrame:CGRectMake(110*AUTO_SIZE_SCALE_X, nameLabel.frame.origin.y+nameLabel.frame.size.height+10*AUTO_SIZE_SCALE_X, 170*AUTO_SIZE_SCALE_X, 11*AUTO_SIZE_SCALE_X)];
    introductionLabel.text = [NSString stringWithFormat:@"%@",[[expiredArray objectAtIndex:indexPath.row] objectForKey:@"introduction"]];
    introductionLabel.textColor = C6UIColorGray;
    introductionLabel.textAlignment = NSTextAlignmentLeft;
    introductionLabel.font = [UIFont systemFontOfSize:11];
    [bgImv addSubview:introductionLabel];
    
    UILabel * timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(110*AUTO_SIZE_SCALE_X, introductionLabel.frame.origin.y+introductionLabel.frame.size.height+18*AUTO_SIZE_SCALE_X, 170*AUTO_SIZE_SCALE_X, 12*AUTO_SIZE_SCALE_X)];
    timeLabel.text = [NSString stringWithFormat:@"使用期限 %@~%@",[[expiredArray objectAtIndex:indexPath.row] objectForKey:@"startTime"],[[expiredArray objectAtIndex:indexPath.row] objectForKey:@"endTime"]];
    timeLabel.textColor = C6UIColorGray;
    timeLabel.textAlignment = NSTextAlignmentLeft;
    timeLabel.font = [UIFont systemFontOfSize:12];
    [bgImv addSubview:timeLabel];;
    
    
    UIImageView * posImv = [[UIImageView alloc] initWithFrame:CGRectMake(158*AUTO_SIZE_SCALE_X, 22*AUTO_SIZE_SCALE_X, 58*AUTO_SIZE_SCALE_X, 59*AUTO_SIZE_SCALE_X)];
    posImv.image = [UIImage imageNamed:@"bg_user_coupongraypos"];
    [bgImv addSubview:posImv];
    
    return cell;
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
