//
//  MyCouponsViewController.m
//  Massage
//
//  Created by 牛先 on 15/10/21.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "MyCouponsViewController.h"
#import "publicTableViewCell.h"
#import "ExpiredViewController.h"
#import "noOrderView.h"
#import "noWifiView.h"
@interface MyCouponsViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIView * headerView;
    
    NSMutableArray * unUseArray;
    NSMutableArray * alUseArray;
    
    UITableView * myTableView;
    UITextField * ExchangecodeField;
    
    noOrderView * noCouponsView;
    noWifiView * failView;
}
@end

@implementation MyCouponsViewController

-(void)downLoadUnusedata
{
    [failView.activityIndicatorView startAnimating];
    failView.activityIndicatorView.hidden = NO;
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * userID = [userDefaults objectForKey:@"userID"];
    NSDictionary * dic = @{
                           @"userID":userID,
                           @"status":@"0",//0 未使用1 已使用 2 已过期
                            };
    NSLog(@"dic -- %@",dic);
    [[RequestManager shareRequestManager]  getUserCouponList:dic viewController:self successData:^(NSDictionary *result) {
        NSLog(@"优惠券列表result -- %@",result);
        if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
            failView.hidden = YES;
            [failView.activityIndicatorView stopAnimating];
            failView.activityIndicatorView.hidden = YES;
            [unUseArray removeAllObjects];
            [unUseArray addObjectsFromArray:[result objectForKey:@"couponList"]];
//            if (unUseArray.count == 0) {
//                noCouponsView.hidden = NO;
//            }else {
                noCouponsView.hidden = YES;
//            }
            [self downLoadAlusedata];
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

-(void)downLoadAlusedata
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
            
            [alUseArray removeAllObjects];
            [alUseArray addObjectsFromArray:[result objectForKey:@"couponList"]];
            
            if (unUseArray.count == 0 && alUseArray.count == 0) {
                noCouponsView.hidden = NO;
            }
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
    
    self.titles = @"优惠兑换";
    unUseArray = [[NSMutableArray alloc] initWithCapacity:0];
    alUseArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self initheaderView];
    
    [self downLoadUnusedata];
    
    [self initTableView];
}

-(void)initheaderView
{
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, 50*AUTO_SIZE_SCALE_X)];
    headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerView];
    
    UIView * textBgView = [[UIView alloc] initWithFrame:CGRectMake(10*AUTO_SIZE_SCALE_X, 7*AUTO_SIZE_SCALE_X, 245*AUTO_SIZE_SCALE_X, (50-14)*AUTO_SIZE_SCALE_X)];
    textBgView.backgroundColor = C8UIColorGray;
    textBgView.layer.cornerRadius = 2;
    [headerView addSubview:textBgView];
    
    ExchangecodeField = [[UITextField alloc] initWithFrame:CGRectMake(6*AUTO_SIZE_SCALE_X, 0, (245-12)*AUTO_SIZE_SCALE_X, (50-14)*AUTO_SIZE_SCALE_X)];
    ExchangecodeField.placeholder = @"请输入兑换码";//14
    ExchangecodeField.backgroundColor = [UIColor clearColor];
    ExchangecodeField.textColor = [UIColor blackColor];
    ExchangecodeField.font = [UIFont systemFontOfSize:14];
//    [ExchangecodeField setValue:C2UIColorGray forKeyPath:@"_placeholderLabel.textColor"];
    [ExchangecodeField setValue:C7UIColorGray forKeyPath:@"_placeholderLabel.textColor"];
    [ExchangecodeField setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    ExchangecodeField.tintColor = [UIColor blackColor];
    ExchangecodeField.keyboardType = UIKeyboardTypeNumberPad;
    ExchangecodeField.delegate = self;
    [textBgView addSubview:ExchangecodeField];
    
    UIButton * exchangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    exchangeBtn.frame = CGRectMake(textBgView.frame.origin.x+textBgView.frame.size.width+10*AUTO_SIZE_SCALE_X, 11*AUTO_SIZE_SCALE_X, 45*AUTO_SIZE_SCALE_X, 27*AUTO_SIZE_SCALE_X);
//    [exchangeBtn setTitle:@"兑换" forState:UIControlStateNormal];
//    [exchangeBtn setTitleColor:OrangeUIColorC4 forState:UIControlStateNormal];
    [exchangeBtn setBackgroundImage:[UIImage imageNamed:@"btn_coupon_exchange"] forState:UIControlStateNormal];
    [exchangeBtn addTarget:self action:@selector(exchangeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:exchangeBtn];
}

-(void)dismissKeyBoard
{
    [ExchangecodeField resignFirstResponder];
}

-(void)exchangeBtnPressed:(UIButton *)sender
{
    [ExchangecodeField resignFirstResponder];

    [failView.activityIndicatorView startAnimating];
    failView.activityIndicatorView.hidden = NO;
    NSLog(@"兑换 兑换码");

        [self dismissKeyBoard];
        if ([ExchangecodeField.text isEqualToString:@""]) {
            [[RequestManager shareRequestManager] tipAlert:@"兑换码不能为空" viewController:self];
            [failView.activityIndicatorView stopAnimating];
            failView.activityIndicatorView.hidden = YES;
            return;
        }
        if ([ExchangecodeField.text isEqualToString:@"请输入礼物券、兑换码等"]) {
            [[RequestManager shareRequestManager] tipAlert:@"请输入兑换码" viewController:self];
            [failView.activityIndicatorView stopAnimating];
            failView.activityIndicatorView.hidden = YES;
            return;
        }
        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
        NSString * userID = [userDefault objectForKey:@"userID"];
        NSDictionary * dic = @{@"userID":userID,
                               @"couponID":ExchangecodeField.text};
        //    NSLog(@"dic -----------> %@",dic);
        [[RequestManager shareRequestManager] AddcouponDetail:dic viewController:self successData:^(NSDictionary *result) {
            //        NSLog(@"result---------------->%@",result );
            //        NSLog(@"result---------------->%@",[result objectForKey:@"msg"]);
            //刷新优惠券tabView
            if (![[result objectForKey:@"code"]isEqualToString:@"0000"]) {
                [[RequestManager shareRequestManager] tipAlert:[NSString stringWithFormat:@"%@",[result objectForKey:@"msg"] ] viewController:self];
                return ;
            }
            if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
                failView.hidden = YES;
                [failView.activityIndicatorView stopAnimating];
                failView.activityIndicatorView.hidden = YES;
                
                if ([[NSString stringWithFormat:@"%@",[result objectForKey:@"couponType"]] isEqualToString:@"0"]) {
                    [[RequestManager shareRequestManager] tipAlert:[NSString stringWithFormat:@"您已成功充值%@元,可在“我的华佗－账户明细”中查看资金变动信息",[result objectForKey:@"couponPrice"] ]  viewController:self];
                }
                if ([[NSString stringWithFormat:@"%@",[result objectForKey:@"couponType"]] isEqualToString:@"1"]) {
                    [[RequestManager shareRequestManager] tipAlert:[NSString stringWithFormat:@"您已成功兑换%@元优惠券,可在“我的华佗－优惠兑换”中查看并使用",[result objectForKey:@"couponPrice"] ]  viewController:self];
//                    [self initData];
                    [self downLoadUnusedata];
                }
            }
        } failuer:^(NSError *error) {
            failView.hidden = NO;
            [failView.activityIndicatorView stopAnimating];
            failView.activityIndicatorView.hidden = YES;
        }];
        

}

-(void)initTableView
{
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, headerView.frame.origin.y+headerView.frame.size.height, kScreenWidth, kScreenHeight-(headerView.frame.origin.y+headerView.frame.size.height))];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myTableView];
    //没有相关数据时显示
    noCouponsView = [[noOrderView alloc]initWithFrame:CGRectMake(0, AUTO_SIZE_SCALE_X, kScreenWidth, kScreenHeight-(headerView.frame.origin.y+headerView.frame.size.height)-115*AUTO_SIZE_SCALE_X)];
    noCouponsView.noOrderLabel.text = @"您没有可用优惠券";
//    if (unUseArray.count == 0) {
//        noCouponsView.hidden = NO;
//    }else {
        noCouponsView.hidden = YES;
//    }
    [myTableView addSubview:noCouponsView];
    //加载数据失败时显示
    failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, headerView.frame.origin.y+headerView.frame.size.height, kScreenWidth, kScreenHeight-(headerView.frame.origin.y+headerView.frame.size.height))];
    [failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    failView.hidden = YES;
    [self.view addSubview:failView];
}
- (void)reloadButtonClick:(UIButton *)sender {
    [self downLoadUnusedata];
}
#pragma mark UITextFieldDelegate


#pragma mark UITableView代理

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 115*AUTO_SIZE_SCALE_X;
    }
    else if (indexPath.section == 1){
        return 115*AUTO_SIZE_SCALE_X;
    }
//    else if (indexPath.section == 2){
//        return 115*AUTO_SIZE_SCALE_X;
//    }
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return unUseArray.count;
    }
    else if (section == 1){
        if (alUseArray.count >0) {
            return 1;
        }
        return alUseArray.count;
    }
//    else if (section == 2){
//        return 1;
//    }
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
    if (indexPath.section == 0) {
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
        timeLabel.font = [UIFont systemFontOfSize:10];
        [bgImv addSubview:timeLabel];;
        
        return cell;

    }
    else if(indexPath.section == 1) {
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 115*AUTO_SIZE_SCALE_X)];
        label.text = @"查看过期优惠券";
        label.textColor = C6UIColorGray;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        [cell addSubview:label];
    }
//    else if(indexPath.section == 2) {
//  
//    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        ExpiredViewController * vc = [[ExpiredViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
