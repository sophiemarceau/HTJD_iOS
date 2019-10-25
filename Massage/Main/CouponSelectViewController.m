//
//  CouponSelectViewController.m
//  Massage
//
//  Created by htjd_IOS on 15/11/21.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "CouponSelectViewController.h"
#import "publicTableViewCell.h"
#import "noOrderView.h"
@interface CouponSelectViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSDictionary * couponDic;
    NSMutableArray * unUseArray;
    
    UITableView * myTableView;
    
    noOrderView * noDataView;
    
    UIView * btnView;
    UIImageView * zhixianImv;
}
@end

@implementation CouponSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titles = @"优惠券";
    
    unUseArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    btnView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-49*AUTO_SIZE_SCALE_X, kScreenWidth, 49*AUTO_SIZE_SCALE_X)];
    btnView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:btnView];
    
    zhixianImv = [[UIImageView alloc] initWithFrame:CGRectMake(0, kScreenHeight-49*AUTO_SIZE_SCALE_X-0.5, kScreenWidth, 0.5)];
    zhixianImv.image = [UIImage imageNamed:@"icon_zhixian"];
    [self.view addSubview:zhixianImv];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(15*AUTO_SIZE_SCALE_X, 5*AUTO_SIZE_SCALE_X, kScreenWidth-30*AUTO_SIZE_SCALE_X, 49*AUTO_SIZE_SCALE_X-10*AUTO_SIZE_SCALE_X);
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_login_yellow"] forState:UIControlStateNormal];
    [btn setTitle:@"不使用优惠券" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:btn];
    
    btnView.hidden = YES;
    zhixianImv.hidden = YES;
    
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight-50*AUTO_SIZE_SCALE_X)];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myTableView];

    [self downLoadUnusedata];

}

-(void)btnPressed:(UIButton *)sender
{
    couponDic = @{
                  @"ID":@"",
                  @"price":@"0",
                  };
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)downLoadUnusedata
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * userID = [userDefaults objectForKey:@"userID"];
    NSLog(@"self.serviceID  %@",self.serviceID);
    NSLog(@"self.workerId  %@",self.workerId);
    NSLog(@"self.payment  %@",self.payment);
    NSDictionary * dic = @{
                           @"userID":userID,
                           @"status":@"0",//0 未使用1 已使用 2 已过期
                           @"serviceId":self.serviceID,
                           @"workerId":self.workerId,
                           @"storeID":self.storeID,
                           @"payment":self.payment,
                           };
    NSLog(@"dic %@",dic);
    [[RequestManager shareRequestManager]  getUserCouponList:dic viewController:self successData:^(NSDictionary *result) {
        NSLog(@"优惠券列表result -- %@",result);
        if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
        
            [unUseArray removeAllObjects];
            [unUseArray addObjectsFromArray:[result objectForKey:@"couponList"]];
            if (unUseArray.count>0) {
                [myTableView reloadData];
                btnView.hidden = NO;
                zhixianImv.hidden = NO;
            }else{
                noDataView = [[noOrderView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
                noDataView.noOrderLabel.text = @"您还没有符合条件的优惠券";
                [self.view addSubview:noDataView];
                myTableView.hidden = YES;
                btnView.hidden = YES;
                zhixianImv.hidden = YES;
            }
        }
//        else{
//            [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
//        }
    } failuer:^(NSError *error) {
        
    }];
}


#pragma mark UITableView代理

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 115*AUTO_SIZE_SCALE_X;
    }
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return unUseArray.count;
    }
    return 0;
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
        bgImv.image = [UIImage imageNamed:@"bg_user_coupon"];
        [cell addSubview:bgImv];
        
        float price = [[[unUseArray objectAtIndex:indexPath.row] objectForKey:@"price"] floatValue];
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
        nameLabel.text = [NSString stringWithFormat:@"%@",[[unUseArray objectAtIndex:indexPath.row] objectForKey:@"name"]];
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.font = [UIFont systemFontOfSize:13];
        [bgImv addSubview:nameLabel];
        
        UILabel * introductionLabel = [[UILabel alloc] initWithFrame:CGRectMake(110*AUTO_SIZE_SCALE_X, nameLabel.frame.origin.y+nameLabel.frame.size.height+10*AUTO_SIZE_SCALE_X, 170*AUTO_SIZE_SCALE_X, 11*AUTO_SIZE_SCALE_X)];
        introductionLabel.text = [NSString stringWithFormat:@"%@",[[unUseArray objectAtIndex:indexPath.row] objectForKey:@"introduction"]];
        introductionLabel.textColor = C6UIColorGray;
        introductionLabel.textAlignment = NSTextAlignmentLeft;
        introductionLabel.font = [UIFont systemFontOfSize:11];
        [bgImv addSubview:introductionLabel];
        
        UILabel * timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(110*AUTO_SIZE_SCALE_X, introductionLabel.frame.origin.y+introductionLabel.frame.size.height+18*AUTO_SIZE_SCALE_X, 170*AUTO_SIZE_SCALE_X, 12*AUTO_SIZE_SCALE_X)];
        timeLabel.text = [NSString stringWithFormat:@"使用期限 %@~%@",[[unUseArray objectAtIndex:indexPath.row] objectForKey:@"startTime"],[[unUseArray objectAtIndex:indexPath.row] objectForKey:@"endTime"]];
        timeLabel.textColor = C6UIColorGray;
        timeLabel.textAlignment = NSTextAlignmentLeft;
        timeLabel.font = [UIFont systemFontOfSize:12];
        [bgImv addSubview:timeLabel];;
        
        return cell;
        
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    couponDic = [NSDictionary dictionaryWithDictionary:[unUseArray objectAtIndex:indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)returnCouponInfo:(ReturnCouponInfoBlock)block
{
    self.returnCouponInfo = block;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    if (self.returnCouponInfo != nil) {
        self.returnCouponInfo(couponDic);
    }
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
