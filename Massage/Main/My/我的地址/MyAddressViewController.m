//
//  MyAddressViewController.m
//  Massage
//
//  Created by 牛先 on 15/10/21.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "MyAddressViewController.h"
#import "AddressTableViewCell.h"
#import "ProgressHUD.h"
#import "AddNewAddressViewController.h"
#import "noWifiView.h"
@interface MyAddressViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * myTableView;
    noWifiView * failView;
    NSMutableArray * dataArray;
    
    NSString * addressID;
    UIButton * addAddressBtn;
    
    NSDictionary * selectAddressDic;
    
}
@end

@implementation MyAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titles = @"我的地址";
    self.view.backgroundColor = C2UIColorGray;
    dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(resetDefaultAddress:) name:@"resetDefaultAddress" object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(deleteAddress:) name:@"deleteAddress" object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(reloadAddress:) name:@"reloadAddress" object:nil];
    
//    [ProgressHUD show:@"加载中"];
    [self showHintNoHide:@"正在加载..."];
    
    [self downLoadData];
    
    [self initTableView];
}

-(void)reloadAddress:(NSNotification *)ntf
{

    [self showHintNoHide:@"正在加载..."];
    [self downLoadData];
    
}


-(void)resetDefaultAddress:(NSNotification *)ntf
{
    [failView.activityIndicatorView startAnimating];
    failView.activityIndicatorView.hidden = NO;
    NSLog(@"设置为默认地址,刷新tableView");
//    [ProgressHUD show:@"加载中"];
    [self showHintNoHide:@"正在加载..."];
    myTableView.userInteractionEnabled = NO;
    addAddressBtn.userInteractionEnabled = NO;
    addressID = ntf.object;
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString * userID = [userDefault objectForKey:@"userID"];
    NSDictionary * dic = @{@"userID":userID,
                           @"addressID":addressID,
                           @"isDefault":@"1"
                           };
    NSLog(@"dic-------->%@",dic);
    [[RequestManager shareRequestManager] AddNewAddressInfo:dic viewController:self successData:^(NSDictionary *result) {
           [self hideHud];
        NSLog(@"result %@",result);
        if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
            failView.hidden = YES;
            [failView.activityIndicatorView stopAnimating];
            failView.activityIndicatorView.hidden = YES;
            
            [self downLoadData];
        }else{
            [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
            myTableView.userInteractionEnabled = YES;
            //            addAddressBtn.userInteractionEnabled = YES;
            
        }
    } failuer:^(NSError *error) {
        failView.hidden = NO;
        [failView.activityIndicatorView stopAnimating];
        failView.activityIndicatorView.hidden = YES;
           [self hideHud];
        myTableView.userInteractionEnabled = YES;
        //        addAddressBtn.userInteractionEnabled = YES;
        
    }];
    
}

-(void)deleteAddress:(NSNotification *)ntf
{
    addressID = ntf.object;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:@"是否删除地址"
                                                   delegate:self
                                          cancelButtonTitle:@"否"
                                          otherButtonTitles:@"是",nil];
    [alert show];
}

#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"取消删除");
        return;
    }
    if (buttonIndex == 1) {
        [failView.activityIndicatorView startAnimating];
        failView.activityIndicatorView.hidden = NO;
//        [ProgressHUD show:@"加载中"];
        [self showHintNoHide:@"正在加载..."];
        myTableView.userInteractionEnabled = NO;
        addAddressBtn.userInteractionEnabled = NO;
        
        NSDictionary * dic = @{
                               @"addressID":addressID
                               };
        [[RequestManager shareRequestManager] DeleteAddressDetail:dic viewController:self successData:^(NSDictionary *result) {
               [self hideHud];
            if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
                failView.hidden = YES;
                [failView.activityIndicatorView stopAnimating];
                failView.activityIndicatorView.hidden = YES;
                [self downLoadData];
            }else{
                [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
                myTableView.userInteractionEnabled = YES;
                //                addAddressBtn.userInteractionEnabled = YES;
            }
        } failuer:^(NSError *error) {
            failView.hidden = NO;
            [failView.activityIndicatorView stopAnimating];
            failView.activityIndicatorView.hidden = YES;
               [self hideHud];
            myTableView.userInteractionEnabled = YES;
            //            addAddressBtn.userInteractionEnabled = YES;
            
        }];
    }
}


-(void)downLoadData
{
    [failView.activityIndicatorView startAnimating];
    failView.activityIndicatorView.hidden = NO;
    [dataArray removeAllObjects];
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * userID = [userDefaults objectForKey:@"userID"];
    NSDictionary * dic = @{
                           @"userID":userID,
                           };
    [[RequestManager shareRequestManager] GetMyAddressInfo:dic viewController:self successData:^(NSDictionary *result) {
        [self hideHud];

        NSLog(@"地址列表 resault %@",result);
        if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
            failView.hidden = YES;
            [failView.activityIndicatorView stopAnimating];
            failView.activityIndicatorView.hidden = YES;
            
            [dataArray addObjectsFromArray:[result   objectForKey:@"data"]];
            [myTableView reloadData];
            [ProgressHUD dismiss];
            myTableView.userInteractionEnabled = YES;
            addAddressBtn.userInteractionEnabled = YES;
        }else{
            [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
            myTableView.userInteractionEnabled = YES;
            addAddressBtn.userInteractionEnabled = YES;
        }
    } failuer:^(NSError *error) {
        failView.hidden = NO;
        [failView.activityIndicatorView stopAnimating];
        failView.activityIndicatorView.hidden = YES;
        
        [self hideHud];
	
        myTableView.userInteractionEnabled = YES;
        addAddressBtn.userInteractionEnabled = YES;
    }];
}

-(void)initTableView
{
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight-50*AUTO_SIZE_SCALE_X)];
    myTableView.backgroundColor = [UIColor  clearColor];
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.dataSource  = self;
    myTableView.delegate = self;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myTableView];
    
    UIView * btnView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-50*AUTO_SIZE_SCALE_X, kScreenWidth, 500*AUTO_SIZE_SCALE_X)];
    btnView.backgroundColor = [UIColor  whiteColor];
    [self.view addSubview:btnView];
    
    UIImageView * zhixianImv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    zhixianImv.image = [UIImage imageNamed:@"icon_zhixian"];
    [btnView addSubview:zhixianImv];
    
    addAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addAddressBtn.frame = CGRectMake(15, 5*AUTO_SIZE_SCALE_X, kScreenWidth-30, 40*AUTO_SIZE_SCALE_X);
    [addAddressBtn setBackgroundImage:[UIImage imageNamed:@"btn_login_yellow"] forState:UIControlStateNormal];
    [addAddressBtn setTitle:@"添加新地址" forState:UIControlStateNormal];
    [addAddressBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addAddressBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [addAddressBtn addTarget:self action:@selector(addAddressBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:addAddressBtn];
    
    //加载数据失败时显示
    failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight-100*AUTO_SIZE_SCALE_X)];
    [failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    failView.hidden = YES;
    [self.view addSubview:failView];
    
}
- (void)reloadButtonClick:(UIButton *)sender {
    [self downLoadData];
}
-(void)addAddressBtnPressed:(UIButton *)sender
{
    AddNewAddressViewController * vc = [[AddNewAddressViewController alloc] init];
    vc.isNew = YES;
    vc.addressID = @"";
    vc.isDefault = @"0";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark UITableView代理

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 122*AUTO_SIZE_SCALE_X;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify =@"AddressTableViewCell";
    
    AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell) {
        cell = [[AddressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.listArrayData = [dataArray objectAtIndex:indexPath.row];
    cell.isFromAppointment = self.isFromAppointment;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isFromAppointment) {
        selectAddressDic = [NSDictionary dictionaryWithDictionary:[dataArray objectAtIndex:indexPath.row]];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    AddNewAddressViewController * vc = [[AddNewAddressViewController alloc] init];
    vc.isNew = NO;
    vc.addressID = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"ID"];
    vc.isDefault = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"isDefault"];
    vc.addressDic = [dataArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark bolck
-(void)returnAddressInfo:(ReturnAddressInfoBlock)block
{
    self.returnAddressInfoBlock = block;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    if (self.isFromAppointment) {
        if (self.returnAddressInfoBlock != nil) {
            self.returnAddressInfoBlock(selectAddressDic);
            
        }
    }
    
}

@end
