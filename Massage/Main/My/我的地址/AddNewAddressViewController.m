//
//  AddNewAddressViewController.m
//  Massage
//
//  Created by htjd_IOS on 15/11/3.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "AddNewAddressViewController.h"
#import "servicePlaceViewController.h"

@interface AddNewAddressViewController ()
{
    UITextField * nameField;
    UITextField * contactField;
    UITextField * detailPlaceField;
    
    UIImageView * manImv;
    UIImageView * womenImv;
    
    UILabel * servicePlaceInfoLabel;
    
    NSString * sex;
}
@end

@implementation AddNewAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.isNew) {
        self.titles = @"添加地址";
    } else{
        self.titles = @"修改地址";
    }
    sex = @"男";
    //姓名
    UIView * nameView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, 45*AUTO_SIZE_SCALE_X)];
    nameView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:nameView];
    
    UIImageView * zhixianImv1 = [[UIImageView alloc] initWithFrame:CGRectMake(10*AUTO_SIZE_SCALE_X, 45*AUTO_SIZE_SCALE_X-0.5, kScreenWidth-10*AUTO_SIZE_SCALE_X, 0.5)];
    zhixianImv1.image = [UIImage imageNamed:@"icon_zhixian"];
    [nameView addSubview:zhixianImv1];
    
    UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*AUTO_SIZE_SCALE_X, 0, 55*AUTO_SIZE_SCALE_X, 45*AUTO_SIZE_SCALE_X)];
    nameLabel.text = @"姓名";
    nameLabel.textColor = C6UIColorGray;
    nameLabel.font = [UIFont systemFontOfSize:13];
    [nameView addSubview:nameLabel];
    
    nameField = [[UITextField alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x+nameLabel.frame.size.width+10*AUTO_SIZE_SCALE_X, 0, 200*AUTO_SIZE_SCALE_X, 45*AUTO_SIZE_SCALE_X)];
    nameField.placeholder = @"请输入联系人姓名";
    nameField.tintColor = C6UIColorGray;
    nameField.textColor = C6UIColorGray;
    [nameField setValue:C6UIColorGray forKeyPath:@"_placeholderLabel.textColor"];
    [nameField setValue:[UIFont boldSystemFontOfSize:13*AUTO_SIZE_SCALE_X] forKeyPath:@"_placeholderLabel.font"];
    nameField.font = [UIFont systemFontOfSize:13];
    [nameView addSubview:nameField];
    
    //性别
    UIView * sexView = [[UIView alloc] initWithFrame:CGRectMake(0, nameView.frame.origin.y+nameView.frame.size.height, kScreenWidth, 45*AUTO_SIZE_SCALE_X)];
    sexView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:sexView];
    
    UIImageView * zhixianImv2 = [[UIImageView alloc] initWithFrame:CGRectMake(10*AUTO_SIZE_SCALE_X, 45*AUTO_SIZE_SCALE_X-0.5, kScreenWidth-10*AUTO_SIZE_SCALE_X, 0.5)];
    zhixianImv2.image = [UIImage imageNamed:@"icon_zhixian"];
    [sexView addSubview:zhixianImv2];

    UILabel * sexLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*AUTO_SIZE_SCALE_X, 0, 55*AUTO_SIZE_SCALE_X, 45*AUTO_SIZE_SCALE_X)];
    sexLabel.text = @"性别";
    sexLabel.textColor = C6UIColorGray;
    sexLabel.font = [UIFont systemFontOfSize:13];
    [sexView addSubview:sexLabel];
    
    UIView * manView = [[UIView alloc] initWithFrame:CGRectMake(sexLabel.frame.origin.x+sexLabel.frame.size.width+10*AUTO_SIZE_SCALE_X, 0, 50*AUTO_SIZE_SCALE_X, 45*AUTO_SIZE_SCALE_X)];
    manView.backgroundColor = [UIColor clearColor];
    [sexView addSubview:manView];
    UITapGestureRecognizer * manViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(manViewTaped:)];
    [manView addGestureRecognizer:manViewTap];
    
    manImv = [[UIImageView alloc] initWithFrame:CGRectMake(0, (45-17)/2*AUTO_SIZE_SCALE_X, 17*AUTO_SIZE_SCALE_X, 17*AUTO_SIZE_SCALE_X)];
    manImv.image = [UIImage imageNamed:@"icon_address_def"];
    [manView addSubview:manImv];
    
    UILabel * manLabel = [[UILabel alloc] initWithFrame:CGRectMake(manImv.frame.origin.x+manImv.frame.size.width+5*AUTO_SIZE_SCALE_X, 0, manView.frame.size.width-manImv.frame.size.width, 45*AUTO_SIZE_SCALE_X)];
    manLabel.text = @"先生";
    manLabel.textColor = C6UIColorGray;
    manLabel.font = [UIFont systemFontOfSize:13];
    [manView addSubview:manLabel];
    
    UIView * womenView = [[UIView alloc] initWithFrame:CGRectMake(manView.frame.origin.x+manView.frame.size.width+25*AUTO_SIZE_SCALE_X, 0, 50*AUTO_SIZE_SCALE_X, 45*AUTO_SIZE_SCALE_X)];
    womenView.backgroundColor = [UIColor clearColor];
    [sexView addSubview:womenView];
    UITapGestureRecognizer * womenViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(womenViewTaped:)];
    [womenView addGestureRecognizer:womenViewTap];
    
    womenImv = [[UIImageView alloc] initWithFrame:CGRectMake(0, (45-17)/2*AUTO_SIZE_SCALE_X, 17*AUTO_SIZE_SCALE_X, 17*AUTO_SIZE_SCALE_X)];
    womenImv.image = [UIImage imageNamed:@"icon_address_nodef"];
    [womenView addSubview:womenImv];
    
    UILabel * womenLabel = [[UILabel alloc] initWithFrame:CGRectMake(womenImv.frame.origin.x+womenImv.frame.size.width+5*AUTO_SIZE_SCALE_X, 0, womenView.frame.size.width-womenImv.frame.size.width, 45*AUTO_SIZE_SCALE_X)];
    womenLabel.text = @"女士";
    womenLabel.textColor = C6UIColorGray;
    womenLabel.font = [UIFont systemFontOfSize:13];
    [womenView addSubview:womenLabel];
    
    //联系方式
    UIView * contactView = [[UIView alloc] initWithFrame:CGRectMake(0, sexView.frame.origin.y+sexView.frame.size.height, kScreenWidth, 45*AUTO_SIZE_SCALE_X)];
    contactView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contactView];
    
    UIImageView * zhixianImv3 = [[UIImageView alloc] initWithFrame:CGRectMake(10*AUTO_SIZE_SCALE_X, 45*AUTO_SIZE_SCALE_X-0.5, kScreenWidth-10*AUTO_SIZE_SCALE_X, 0.5)];
    zhixianImv3.image = [UIImage imageNamed:@"icon_zhixian"];
    [contactView addSubview:zhixianImv3];

    UILabel * contactLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*AUTO_SIZE_SCALE_X, 0, 55*AUTO_SIZE_SCALE_X, 45*AUTO_SIZE_SCALE_X)];
    contactLabel.text = @"联系方式";
    contactLabel.textColor = C6UIColorGray;
    contactLabel.font = [UIFont systemFontOfSize:13];
    [contactView addSubview:contactLabel];

    contactField = [[UITextField alloc] initWithFrame:CGRectMake(contactLabel.frame.origin.x+contactLabel.frame.size.width+10*AUTO_SIZE_SCALE_X, 0, 200*AUTO_SIZE_SCALE_X, 45*AUTO_SIZE_SCALE_X)];
    contactField.placeholder = @"请输入联系电话";
    contactField.tintColor = C6UIColorGray;
    contactField.textColor = C6UIColorGray;
    contactField.keyboardType = UIKeyboardTypeNumberPad;
    [contactField setValue:C6UIColorGray forKeyPath:@"_placeholderLabel.textColor"];
    [contactField setValue:[UIFont boldSystemFontOfSize:13*AUTO_SIZE_SCALE_X] forKeyPath:@"_placeholderLabel.font"];
    contactField.font = [UIFont systemFontOfSize:13];
    [contactField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [contactView addSubview:contactField];
    
    //服务地址
    UIView * servicePlaceView = [[UIView alloc] initWithFrame:CGRectMake(0, contactView.frame.origin.y+contactView.frame.size.height, kScreenWidth, 45*AUTO_SIZE_SCALE_X)];
    servicePlaceView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:servicePlaceView];
    UITapGestureRecognizer * servicePlaceViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(servicePlaceViewTaped:)];
    [servicePlaceView addGestureRecognizer:servicePlaceViewTap];
    
    UIImageView * zhixianImv4 = [[UIImageView alloc] initWithFrame:CGRectMake(10*AUTO_SIZE_SCALE_X, 45*AUTO_SIZE_SCALE_X-0.5, kScreenWidth-10*AUTO_SIZE_SCALE_X, 0.5)];
    zhixianImv4.image = [UIImage imageNamed:@"icon_zhixian"];
    [servicePlaceView addSubview:zhixianImv4];
    
    UILabel * servicePlaceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*AUTO_SIZE_SCALE_X, 0, 55*AUTO_SIZE_SCALE_X, 45*AUTO_SIZE_SCALE_X)];
    servicePlaceLabel.text = @"服务地址";
    servicePlaceLabel.textColor = C6UIColorGray;
    servicePlaceLabel.font = [UIFont systemFontOfSize:13];
    [servicePlaceView addSubview:servicePlaceLabel];
    
    servicePlaceInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(servicePlaceLabel.frame.origin.x+servicePlaceLabel.frame.size.width+10*AUTO_SIZE_SCALE_X, 0, 200*AUTO_SIZE_SCALE_X, 45*AUTO_SIZE_SCALE_X)];
    servicePlaceInfoLabel.text = @"请输入服务地址";
    servicePlaceInfoLabel.textColor = C6UIColorGray;
    servicePlaceInfoLabel.font = [UIFont systemFontOfSize:13];
    servicePlaceInfoLabel.numberOfLines = 0;
    [servicePlaceView addSubview:servicePlaceInfoLabel];
    
    UIImageView * nextImv4 = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-10*AUTO_SIZE_SCALE_X-10*AUTO_SIZE_SCALE_X, (45-17)/2*AUTO_SIZE_SCALE_X, 10*AUTO_SIZE_SCALE_X, 17*AUTO_SIZE_SCALE_X)];
    nextImv4.image = [UIImage imageNamed:@"icon_sd_next"];
    [servicePlaceView addSubview:nextImv4];
    
     //详细地址
    UIView * detailPlaceView = [[UIView alloc] initWithFrame:CGRectMake(0, servicePlaceView.frame.origin.y+servicePlaceView.frame.size.height, kScreenWidth, 40*AUTO_SIZE_SCALE_X)];
    detailPlaceView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:detailPlaceView];
    
    UILabel * detailPlaceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*AUTO_SIZE_SCALE_X, 0, 55*AUTO_SIZE_SCALE_X, 40*AUTO_SIZE_SCALE_X)];
    detailPlaceLabel.text = @"详细地址";
    detailPlaceLabel.textColor = C6UIColorGray;
    detailPlaceLabel.font = [UIFont systemFontOfSize:13];
    [detailPlaceView addSubview:detailPlaceLabel];
    
    detailPlaceField = [[UITextField alloc] initWithFrame:CGRectMake(detailPlaceLabel.frame.origin.x+detailPlaceLabel.frame.size.width+10*AUTO_SIZE_SCALE_X, 0, 200*AUTO_SIZE_SCALE_X, 40*AUTO_SIZE_SCALE_X)];
    detailPlaceField.placeholder = @"请填写详细地址(门牌号等)";
    detailPlaceField.tintColor = C6UIColorGray;
    detailPlaceField.textColor = C6UIColorGray;
    [detailPlaceField setValue:C6UIColorGray forKeyPath:@"_placeholderLabel.textColor"];
    [detailPlaceField setValue:[UIFont boldSystemFontOfSize:13*AUTO_SIZE_SCALE_X] forKeyPath:@"_placeholderLabel.font"];
    detailPlaceField.font = [UIFont systemFontOfSize:13];
    [detailPlaceView addSubview:detailPlaceField];
    
    if (!self.isNew) {
        nameField.text = [self.addressDic objectForKey:@"name"];
        sex = [self.addressDic objectForKey:@"gender"];
        if ([sex isEqualToString:@"男"]) {
            //男士对勾选中
            manImv.image = [UIImage imageNamed:@"icon_address_def"];
            womenImv.image = [UIImage imageNamed:@"icon_address_nodef"];

        }else{
            //女士对勾选中
            manImv.image = [UIImage imageNamed:@"icon_address_nodef"];
            womenImv.image = [UIImage imageNamed:@"icon_address_def"];
        }
        contactField.text = [NSString stringWithFormat:@"%@",[self.addressDic objectForKey:@"mobile"]];
        servicePlaceInfoLabel.text = [self.addressDic objectForKey:@"userArea"];
        detailPlaceField.text = [self.addressDic objectForKey:@"address"];
    }
    
    //保存布局
    UIView * btnView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-50*AUTO_SIZE_SCALE_X, kScreenWidth, 500*AUTO_SIZE_SCALE_X)];
    btnView.backgroundColor = [UIColor  whiteColor];
    [self.view addSubview:btnView];
    
    UIImageView * zhixianImv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    zhixianImv.image = [UIImage imageNamed:@"icon_zhixian"];
    [btnView addSubview:zhixianImv];
    
    UIButton * saveAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveAddressBtn.frame = CGRectMake(15, 5*AUTO_SIZE_SCALE_X, kScreenWidth-30, 40*AUTO_SIZE_SCALE_X);
    [saveAddressBtn setBackgroundImage:[UIImage imageNamed:@"btn_login_yellow"] forState:UIControlStateNormal];
    [saveAddressBtn setTitle:@"保存地址" forState:UIControlStateNormal];
    [saveAddressBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveAddressBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [saveAddressBtn addTarget:self action:@selector(saveAddressBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:saveAddressBtn];
}

//跳转到选择服务地址页面
-(void)servicePlaceViewTaped:(UITapGestureRecognizer *)sender
{
    [nameField resignFirstResponder];
    [contactField resignFirstResponder];
    [detailPlaceField resignFirstResponder];
    servicePlaceViewController * vc = [[servicePlaceViewController alloc] init];
    [vc returnText:^(NSString *cityName, NSString *userArea) {
        NSLog(@"userarea -- > %@",userArea);
        if ([userArea isEqualToString:@""]||userArea == nil||[userArea isKindOfClass:[NSNull class]]) {
            
        }else{
//            myuserArea = userArea;
            servicePlaceInfoLabel.text = userArea;
//            placeTextLabel.textColor = [UIColor blackColor];
//            CGSize placeTextLabelSize = placeTextLabel.intrinsicContentSize;
//            if (placeTextLabelSize.width > placeTextLabel.frame.size.width) {
//                placeTextLabel.numberOfLines = 0;
//            }h
            
        }
        
    }];


    [self.navigationController pushViewController:vc animated:YES];
}

-(void)saveAddressBtnPressed:(UIButton *)sender
{
    sender.userInteractionEnabled = NO;
    
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString * userID = [userDefault objectForKey:@"userID"];
    NSString * cityName = [userDefault objectForKey:@"cityName"];

    if ([nameField.text isEqualToString:@""]) {
        [[RequestManager shareRequestManager] tipAlert:@"请输入联系人姓名" viewController:self];
        sender.userInteractionEnabled = YES;
        return;
    }
    else if ([contactField.text isEqualToString:@""]) {
        [[RequestManager shareRequestManager] tipAlert:@"请输入联系方式" viewController:self];
        sender.userInteractionEnabled = YES;
        return;
    }
    else if ( contactField.text.length != 11) {
        [[RequestManager shareRequestManager] tipAlert:@"联系方式错误，请重新输入" viewController:self];
        sender.userInteractionEnabled = YES;
        return;
    }else if ([servicePlaceInfoLabel.text isEqualToString:@"请输入服务地址"]||[servicePlaceInfoLabel.text isEqualToString:@""]) {
        [[RequestManager shareRequestManager] tipAlert:@"请输入服务地址" viewController:self];
        sender.userInteractionEnabled = YES;
        return;
    }else if ( [detailPlaceField.text isEqualToString:@""]) {
        [[RequestManager shareRequestManager] tipAlert:@"请填写详细地址(门牌号等)" viewController:self];
        sender.userInteractionEnabled = YES;
        return;
    }
    NSDictionary * dic = @{@"userID":userID,
                           @"addressID":self.addressID,
                           @"userName":nameField.text,
                           @"gender":sex,
                           @"mobile":contactField.text,
                           @"address":detailPlaceField.text,
                           @"isDefault":self.isDefault,
                           @"cityName":cityName,
                           @"userArea":servicePlaceInfoLabel.text,
                           };
    [[RequestManager shareRequestManager] AddNewAddressInfo:dic viewController:self successData:^(NSDictionary *result) {
                    NSLog(@"--msg---------------->%@",[result objectForKey:@"msg"]);
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadAddress" object:nil];
        sender.userInteractionEnabled = YES;
    } failuer:^(NSError *error) {
        sender.userInteractionEnabled = YES;
        
    }];

//    [self.navigationController popViewControllerAnimated:YES];
}

-(void)manViewTaped:(UITapGestureRecognizer *)sender
{
    sex = @"男";
    manImv.image = [UIImage imageNamed:@"icon_address_def"];
    womenImv.image = [UIImage imageNamed:@"icon_address_nodef"];
}

-(void)womenViewTaped:(UITapGestureRecognizer *)sender
{
    sex = @"女";
    womenImv.image = [UIImage imageNamed:@"icon_address_def"];
    manImv.image = [UIImage imageNamed:@"icon_address_nodef"];
}

-(void)textFieldDidChange:(UITextField *)textField
{
    if (contactField.text.length>11) {
        contactField.text = [contactField.text substringToIndex:11];
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
