//
//  FlashPayViewController.m
//  Massage
//
//  Created by htjd_IOS on 15/10/20.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "FlashPayViewController.h"

#import "publicTableViewCell.h"
#import "FlashPayViewController.h"
#import "NBTextField.h"
@interface FlashPayViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource >
{
    UIView * headView;
    UIView * footView;
    UITableView * myTableView;
    
    NSMutableArray * selectArray;
    
    UIView * bgView;
    UIView * messageView;
    
    NBTextField * ConsumptionField;
    
    UILabel * paymentLabel;
    
    BOOL isHaveDian;
    BOOL isHaveZero;
    
    NSString * currentStr;
}
@end

@implementation FlashPayViewController
@synthesize storeID;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = UIColorFromRGB(0xE6E5DE);
    
    //    NSString * str = @"56.5";
    //    double money = [str doubleValue];
    //    NSLog(@"money %f",money);
    
    selectArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    
    [self initheadView];
    
    [self initfootView];
    
    [self initTableView];
}

-(void)initheadView
{
    headView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavHeight, self.view.frame.size.width, self.view.frame.size.height-49-kNavHeight)];
#pragma mark 消费
    UIView * ConsumptionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 45)];
    ConsumptionView.backgroundColor = [UIColor whiteColor];
    
    UILabel * ConsumptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 55, 45)];
    ConsumptionLabel.text = @"消费金额";
    ConsumptionLabel.textColor = [UIColor blackColor];
    ConsumptionLabel.font = [UIFont systemFontOfSize:13];
    [ConsumptionView addSubview:ConsumptionLabel];
    
    //    ConsumptionField = [[UITextField alloc] initWithFrame:CGRectMake(15+ConsumptionLabel.frame.origin.x+ConsumptionLabel.frame.size.width, 0, 220, 45)];
    //    ConsumptionField.placeholder = @"请询问门店人员";
    //    ConsumptionField.textColor = [UIColor blackColor];
    //    ConsumptionField.font = [UIFont systemFontOfSize:13];
    //    ConsumptionField.keyboardType = UIKeyboardTypeDecimalPad;
    //    ConsumptionField.delegate = self;
    //    [ConsumptionView addSubview:ConsumptionField];
    
    [headView addSubview:ConsumptionView];
    
    ConsumptionField = [[NBTextField alloc] initWithFrame:CGRectMake(15+ConsumptionLabel.frame.origin.x+ConsumptionLabel.frame.size.width, 2, 220, 43)];
    ConsumptionField.NBregEx = REGEX_MONEY_TYPE;
    ConsumptionField.keyboardType = UIKeyboardTypeDecimalPad;
    ConsumptionField.textColor = [UIColor blackColor];
    ConsumptionField.font = [UIFont systemFontOfSize:13];
    [ConsumptionField setPlaceholder:@"请询问门店人员"];
    [ConsumptionField setReturnKeyType:UIReturnKeyDone];
    //    ConsumptionField.backgroundColor = [UIColor redColor];
    [ConsumptionField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    ConsumptionField.delegate = self;
    
    [headView addSubview: ConsumptionField];
#pragma mark 提示
    UIView * hintsView = [[UIView alloc] initWithFrame:CGRectMake(0, ConsumptionView.frame.origin.y+ConsumptionView.frame.size.height, self.view.frame.size.width, 30)];
    hintsView.backgroundColor = [UIColor clearColor];
    
    //    UILabel * hintsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 140, 30)];
    //    hintsLabel.text = @"买单可享以下优惠";
    //    hintsLabel.textColor = UIColorC3;
    //    hintsLabel.font = [UIFont systemFontOfSize:13];
    //    hintsLabel.textAlignment = NSTextAlignmentLeft;
    //    [hintsView addSubview:hintsLabel];
    
    [headView addSubview:hintsView];
    headView.frame = CGRectMake(0, 0, self.view.frame.size.width, hintsView.frame.size.height+hintsView.frame.origin.y);
    
    
}

-(void)initfootView
{
    footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    footView.backgroundColor = [UIColor clearColor];
    
    UIView * payView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, self.view.frame.size.width, 45)];
    payView.backgroundColor = [UIColor whiteColor];
    
    UILabel * nameLabel = [[UILabel  alloc] initWithFrame:CGRectMake(10, 0, 100, 45)];
    nameLabel.text = @"实付金额";
    nameLabel.font = [UIFont systemFontOfSize:13];
    [payView addSubview:nameLabel];
    
    paymentLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-110, 0, 100, 45)];
    paymentLabel.text = @"0.00";
//    paymentLabel.textColor = UIColorC4;
    paymentLabel.textAlignment = NSTextAlignmentRight;
    paymentLabel.font = [UIFont systemFontOfSize:16];
    [payView addSubview:paymentLabel];
    
    [footView addSubview:payView];
}

-(void)initTableView
{
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight, self.view.frame.size.width, self.view.frame.size.height-49-kNavHeight)];
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.rowHeight = 45;
    myTableView.showsVerticalScrollIndicator = NO;
    [myTableView setTableHeaderView:headView];
    [myTableView setTableFooterView:footView];
    [self.view addSubview:myTableView];
    
    UIView * btnView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-48, self.view.frame.size.width, 48)];
//    btnView.backgroundColor = UIColorC7;
    
    UIButton * payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    payBtn.frame = CGRectMake(10, 9, self.view.frame.size.width-20, 30);
    [payBtn setBackgroundImage:[UIImage imageNamed:@"icon_denglu"] forState:UIControlStateNormal];
    //    [payBtn setBackgroundImage:[UIImage imageNamed:@"icon_denglu"] forState:UIControlStateHighlighted];
    [payBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    //    payBtn.titleLabel.text = @"确认支付";
    payBtn.titleLabel.textColor = [UIColor whiteColor];
    payBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    payBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [payBtn addTarget:self action:@selector(payBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:payBtn];
    
    [self.view addSubview:btnView];
}

-(void)payBtnPressed:(UIButton *)sender
{
    if ([ConsumptionField.text isEqualToString:@""]) {
        [[RequestManager shareRequestManager] tipAlert:@"请输入消费金额" viewController:self];
        return;
    }
    
    
    NSLog(@"确认支付");
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.5;
    [self.view.window addSubview:bgView];
    
    messageView = [[UIView alloc] initWithFrame:CGRectMake(30 , (self.view.frame.size.height-160)/2, self.view.frame.size.width-60 , 160)];
    messageView.backgroundColor = [UIColor whiteColor];
    messageView.layer.cornerRadius = 5;
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, messageView.frame.size.width-70, 80)];
    label.text =[NSString stringWithFormat:@"您正在向%@进行支付操作，请与门店确认",self.titles];
//    label.textColor = UIColorC3;
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:13];
    [messageView addSubview:label];
    
    UIImageView * imv = [[UIImageView alloc] initWithFrame:CGRectMake(20 , label.frame.origin.y+label.frame.size.height, messageView.frame.size.width-40, 0.5)];
    imv.image = [UIImage imageNamed:@"icon_zhixian"];
    [messageView addSubview:imv];
    
    UIButton * cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.frame = CGRectMake(30, imv.frame.origin.y+imv.frame.size.height+15, 95, 35);
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
//    [cancleBtn setTitleColor:UIColorC3 forState:UIControlStateNormal];
    cancleBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//    cancleBtn.layer.borderColor = UIColorC3.CGColor;
    cancleBtn.layer.borderWidth = 1;
    cancleBtn.layer.cornerRadius = 5;
    [cancleBtn addTarget:self action:@selector(cancelBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [messageView addSubview:cancleBtn];
    
    UIButton * confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(cancleBtn.frame.origin.x+cancleBtn.frame.size.width+15, cancleBtn.frame.origin.y, cancleBtn.frame.size.width, cancleBtn.frame.size.height);
//    [confirmBtn setBackgroundColor:UIColorC4];
    [confirmBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    confirmBtn.layer.cornerRadius = 5;
    [confirmBtn addTarget:self action:@selector(confirmBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [messageView addSubview:confirmBtn];
    
    [self.view.window addSubview:messageView];
}

-(void)cancelBtnPressed:(UIButton *)sender
{
    [messageView removeFromSuperview];
    [bgView removeFromSuperview];
}

-(void)confirmBtnPressed:(UIButton *)sender
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * userID = [userDefaults objectForKey:@"userID"];
    
    double a = [ConsumptionField.text doubleValue];
    double p = [paymentLabel.text doubleValue];
    
    NSString * myAllprice =[NSString stringWithFormat:@"%0.2f",a];
    NSString * myPayment = [NSString stringWithFormat:@"%0.2f",p];
    
    NSDictionary * dic = @{
                           @"storeID":self.storeID,
                           @"userID":userID,
                           @"payment":myPayment,//paymentLabel.text
                           @"allprice":myAllprice,//ConsumptionField.text
                           @"activityID":@"",
                           @"client":@"ios",
                           };
    NSLog(@"dic  %@",dic);
    [[RequestManager shareRequestManager ] genQuickPayOrder:dic viewController:self successData:^(NSDictionary *result) {
        NSLog(@" 提交闪付订单 result %@",result);
        [messageView removeFromSuperview];
        [bgView removeFromSuperview];
        if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
//            FlashPayViewController * vc = [[FlashPayViewController alloc] init];
//            vc.titles = self.titles;
//            vc.allprice = [result objectForKey:@"allprice"];
//            vc.payment = [result objectForKey:@"payment"];
//            vc.orderID = [result objectForKey:@"orderID"];
//            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [[RequestManager shareRequestManager] tipAlert:[result objectForKey:@"msg"] viewController:self];
        }
        
        
    } failuer:^(NSError *error) {
        [messageView removeFromSuperview];
        [bgView removeFromSuperview];
    }];
    
    
    
}

#pragma mark UITableView代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellName = @"publicTableViewCell";
    publicTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        NSArray * nibArray = [[NSBundle mainBundle] loadNibNamed:@"publicTableViewCell" owner:self options:nil];
        cell = (publicTableViewCell *)[nibArray objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    UIView * discountView = [[UIView alloc] init];
    discountView.backgroundColor = [UIColor whiteColor];
    
    UIView * perView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 45)];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 250, 45)];
    label.text = [NSString stringWithFormat:@"%@",@"任意两单减50"];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:13];
    [perView addSubview:label];
    
    UIImageView * imv = [[UIImageView alloc] initWithFrame:CGRectMake(285, 10, 25, 25)];
    imv.image = [UIImage imageNamed:@"icon_baiyuan"];
    [perView addSubview:imv];
    
    for (NSString * str in selectArray) {
        if ([str isEqualToString:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]) {
            UIImageView * imv = [[UIImageView alloc] initWithFrame:CGRectMake(285, 10, 25, 25)];
            imv.image = [UIImage imageNamed:@"icon_duigou"];
            [perView addSubview:imv];
        }
    }
    
    [cell addSubview:perView];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectArray.count == 0) {
        [selectArray addObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        [myTableView reloadData];
        return;
    }
    
    for (int i = 0; i<selectArray.count; i++) {
        if (indexPath.row == [[selectArray objectAtIndex:i] integerValue]) {
            [selectArray removeObjectAtIndex:i];
            [myTableView reloadData];
            return;
        }
    }
    [selectArray addObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    [myTableView reloadData];
    
}
#pragma mark UITextField

- (void)textFieldDidChange:(UITextField *)textField
{
    if ([ConsumptionField.text isEqualToString:@""]) {
        isHaveDian=NO;
        isHaveZero=NO;
        
    }
    
    double price = [ConsumptionField.text doubleValue];
    NSLog(@"price  %f",price);
    if (price >= 10000) {
        NSLog(@"price >= 10000");
        if (isHaveDian) {
            //            NSRange range = NSMakeRange(1, 7);
            //            ConsumptionField.text = [ConsumptionField.text substringWithRange:range];
            ConsumptionField.text = currentStr;
            return;
        }
        else{
            //            ConsumptionField.text = [ConsumptionField.text substringToIndex:4];
            ConsumptionField.text = currentStr;
            return;
        }
    }
    else{
        currentStr = textField.text;
        
    }
    
}



-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string length]>0)
    {
        unichar single=[string characterAtIndex:0];//当前输入的字符
        if ((single >='0' && single<='9') || single=='.')//数据格式正确
        {
            //首字母不能为小数点
            if([ConsumptionField.text length]==0){
                if(single == '.'){
                    NSLog(@"亲，第一个数字不能为小数点");
                    [ConsumptionField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
                
                if (single=='0')
                {
                    if(!isHaveZero)
                    {
                        isHaveZero=YES;
                        //                        NSLog(@"文字  %@",ConsumptionField.text);
                        
                        return YES;
                    }
                }
                
            }
            if([ConsumptionField.text length]==1){
                
                if (single >='0' && single<='9')
                {
                    if(!isHaveZero)
                    {
                        //                        NSLog(@"文字  %@",ConsumptionField.text);
                        
                        return YES;
                    }else
                    {
                        NSLog(@"亲，0后面不能再有0－9");
                        
                        [ConsumptionField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }
            }
            
            
            if (single=='.')
            {
                if(!isHaveDian)//text中还没有小数点
                {
                    isHaveDian=YES;
                    isHaveZero = NO;
                    //                    NSLog(@"文字  %@",ConsumptionField.text);
                    
                    return YES;
                }else
                {
                    NSLog(@"亲，您已经输入过小数点了");
                    
                    [ConsumptionField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            else
            {
                if (isHaveDian)//存在小数点
                {
                    //判断小数点的位数
                    NSRange ran=[ConsumptionField.text rangeOfString:@"."];
                    int tt = range.location-ran.location;
                    if (tt <= 2){
                        return YES;
                    }else{
                        NSLog(@"亲，您最多输入两位小数");
                        
                        return NO;
                    }
                }
                else
                {
                    //                    NSLog(@"文字  %@",ConsumptionField.text);
                    
                    return YES;
                }
                
            }
        }else{//输入的数据格式不正确
            NSLog(@"亲，您输入的格式不正确");
            [ConsumptionField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {
        //        NSLog(@"文字  %@",ConsumptionField.text);
        
        return YES;
    }
}



-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    if ([textField.text isEqualToString:@""]) {
        paymentLabel.text = @"0.00";
    }
    double allPrice = [textField.text doubleValue];
    
    paymentLabel.text = [NSString stringWithFormat:@"%0.2f",allPrice];
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
