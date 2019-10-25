//
//  SelectTimeViewController.m
//  Massage
//
//  Created by htjd_IOS on 15/11/12.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "SelectTimeViewController.h"
#import "TimeTableViewCell.h"
@interface SelectTimeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray * serviceTimeList1;
    NSMutableArray * serviceTimeList2;
    NSMutableArray * serviceTimeList3;
    NSMutableArray * serviceTimeList4;
    
    UITableView * myTableView;
    
    NSMutableArray *arrayGroup1;
    
//    long defaultDay;
    
    NSString * showTimeStr;
    NSString * selectTimeStr;
    NSString * transportationFee;
    long currentDay;
    long selectDay;

    UIScrollView * scrView;
    
    NSMutableArray * dayArray;
    NSMutableArray * dayLabelArray;
    NSMutableArray * timeViewArray;
    NSMutableArray * timeArray;
    NSMutableArray *timeNameLabelArray;
    NSMutableDictionary *selectedDictionary;
    BOOL queren;
    
    NSMutableDictionary * selectTimedic;
    NSMutableDictionary * defaultTimedic;
}
@end

@implementation SelectTimeViewController
@synthesize serviceID;
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(selectTime:) name:@"selectTime" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titles = @"服务时间";
    selectTimeStr = @"";
    showTimeStr = @"";
//    self.currentDay = 0;
//    defaultDay = self.currentDay;
    
    currentDay = self.defaultDay;
    selectDay = self.defaultDay;
    selectTimedic = self.defaultDictionary;
    defaultTimedic = self.defaultDictionary;
    
    queren = NO;
    serviceTimeList1 = [[NSMutableArray alloc] initWithCapacity:0];
    serviceTimeList2 = [[NSMutableArray alloc] initWithCapacity:0];
    serviceTimeList3 = [[NSMutableArray alloc] initWithCapacity:0];
    serviceTimeList4 = [[NSMutableArray alloc] initWithCapacity:0];
    arrayGroup1 = [[NSMutableArray alloc] initWithCapacity:0];
    dayArray = [[NSMutableArray alloc] initWithCapacity:0];
    dayLabelArray = [[NSMutableArray alloc] initWithCapacity:0];
    timeArray = [[NSMutableArray alloc] initWithCapacity:0];
    timeViewArray = [[NSMutableArray alloc] initWithCapacity:0];
    timeNameLabelArray  = [[NSMutableArray alloc] initWithCapacity:0];
    [arrayGroup1 addObject:serviceTimeList1];
    [arrayGroup1 addObject:serviceTimeList2];
    [arrayGroup1 addObject:serviceTimeList3];
    [arrayGroup1 addObject:serviceTimeList4];
    
    
    
    
    [self downTimeData];
    
    
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(12*AUTO_SIZE_SCALE_X, kNavHeight+45*AUTO_SIZE_SCALE_X+9*AUTO_SIZE_SCALE_X, kScreenWidth-24*AUTO_SIZE_SCALE_X, kScreenHeight-(kNavHeight+45*AUTO_SIZE_SCALE_X)-9*AUTO_SIZE_SCALE_X)];
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.showsVerticalScrollIndicator = YES;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myTableView];
    
    UIButton * quedingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    quedingBtn.frame = CGRectMake(kScreenWidth-50*AUTO_SIZE_SCALE_X, 20, 50*AUTO_SIZE_SCALE_X, 44);
    [quedingBtn setTitle:@"确定" forState:UIControlStateNormal];
    [quedingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [quedingBtn setBackgroundColor:[UIColor clearColor]];
    [quedingBtn addTarget:self action:@selector(quedingBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:quedingBtn];
    
}

-(void)downTimeData
{
    NSDictionary * dic = @{
                           @"workerID":self.workerID,
                           @"serviceID":self.serviceID,
                           @"amount":self.beltStr,//钟数
                           };
    NDLog(@"预约时间dic-->%@",dic);
    [[RequestManager shareRequestManager]  getServiceTime:dic viewController:self successData:^(NSDictionary *result) {
                NSLog(@"result -- > %@",result);
        if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
            [serviceTimeList1 addObjectsFromArray:[result objectForKey:@"serviceTimeList1"]];
            
            if (serviceTimeList1.count == 0) {
                [[RequestManager shareRequestManager] tipAlert:@"店铺时间不可约" viewController:self];
                return ;
            }
            
            
            
            NSMutableArray * currentarray = [[NSMutableArray alloc]initWithCapacity:0];
            NSMutableArray * array1 =[NSMutableArray array];
            if (serviceTimeList1.count > 0) {
                NSMutableArray *cellArray = [array1 lastObject];
                for (int i = 0; i < serviceTimeList1.count; i++) {
                    if (cellArray.count == 4 || cellArray == nil) {
                        cellArray = [NSMutableArray arrayWithCapacity:4];
                        [array1 addObject:cellArray];
                    }
                    NSDictionary *dic = serviceTimeList1[i];
                    [cellArray addObject:dic];
                }
            }
            [ currentarray addObjectsFromArray:array1];
            [arrayGroup1 replaceObjectAtIndex:0 withObject:currentarray];
            
            [serviceTimeList2 addObjectsFromArray:[result objectForKey:@"serviceTimeList2"]];
            NSMutableArray * currentarray2 = [[NSMutableArray alloc]initWithCapacity:0];
            NSMutableArray * array2 =[NSMutableArray array];
            if (serviceTimeList2.count > 0) {
                NSMutableArray *cellArray = [array2 lastObject];
                for (int i = 0; i < serviceTimeList2.count; i++) {
                    if (cellArray.count == 4 || cellArray == nil) {
                        cellArray = [NSMutableArray arrayWithCapacity:4];
                        [array2 addObject:cellArray];
                    }
                    NSDictionary *dic = serviceTimeList2[i];
                    [cellArray addObject:dic];
                }
            }
            [ currentarray2 addObjectsFromArray:array2];
            [arrayGroup1 replaceObjectAtIndex:1 withObject:currentarray2];
            
            
            [serviceTimeList3 addObjectsFromArray:[result objectForKey:@"serviceTimeList3"]];
            NSMutableArray * currentarray3 = [[NSMutableArray alloc]initWithCapacity:0];
            NSMutableArray * array3 =[NSMutableArray array];
            if (serviceTimeList3.count > 0) {
                NSMutableArray *cellArray = [array3 lastObject];
                for (int i = 0; i < serviceTimeList3.count; i++) {
                    if (cellArray.count == 4 || cellArray == nil) {
                        cellArray = [NSMutableArray arrayWithCapacity:4];
                        [array3 addObject:cellArray];
                    }
                    NSDictionary *dic = serviceTimeList3[i];
                    [cellArray addObject:dic];
                }
            }
            [ currentarray3 addObjectsFromArray:array3];
            [arrayGroup1 replaceObjectAtIndex:2 withObject:currentarray3];
            
            [serviceTimeList4 addObjectsFromArray:[result objectForKey:@"serviceTimeList4"]];
            NSMutableArray * currentarray4 = [[NSMutableArray alloc]initWithCapacity:0];
            NSMutableArray * array4 =[NSMutableArray array];
            if (serviceTimeList4.count > 0) {
                NSMutableArray *cellArray = [array4 lastObject];
                for (int i = 0; i < serviceTimeList4.count; i++) {
                    if (cellArray.count == 4 || cellArray == nil) {
                        cellArray = [NSMutableArray arrayWithCapacity:4];
                        [array4 addObject:cellArray];
                    }
                    NSDictionary *dic = serviceTimeList4[i];
                    [cellArray addObject:dic];
                }
            }
            [ currentarray4 addObjectsFromArray:array4];
            [arrayGroup1 replaceObjectAtIndex:3 withObject:currentarray4];
            
            [myTableView reloadData];

            [self initheadView];
            
        }
    } failuer:^(NSError *error) {
        
    }];
}

-(void)initheadView
{
    
    UIView * headView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, 45*AUTO_SIZE_SCALE_X)];
    headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headView];
    for (int i=0; i<4; i++) {
        UIView * timeView = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth/4-38*AUTO_SIZE_SCALE_X)/2+kScreenWidth/4*i, 3*AUTO_SIZE_SCALE_X, 38*AUTO_SIZE_SCALE_X, 38*AUTO_SIZE_SCALE_X)];
        timeView.tag = i+1;
        timeView.layer.cornerRadius = 5.0;
        [headView addSubview:timeView];
        UITapGestureRecognizer * timeViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(timeViewTaped:)];
        [timeView addGestureRecognizer:timeViewTap];
        [timeViewArray addObject:timeView];
        
        UILabel * dayNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5*AUTO_SIZE_SCALE_X, 38*AUTO_SIZE_SCALE_X, 11*AUTO_SIZE_SCALE_X)];
        if(i==0){
            dayNameLabel.text = @"今天";
        }else if(i==1){
            dayNameLabel.text = @"明天";
        }else if(i==2){
            NSString * nameStr = [[serviceTimeList3 objectAtIndex:0] objectForKey:@"date"];
            nameStr = [self changeToWeek:nameStr];
            dayNameLabel.text = nameStr;
        }else if(i==3){
            NSString * nameStr = [[serviceTimeList4 objectAtIndex:0] objectForKey:@"date"];
            nameStr = [self changeToWeek:nameStr];
            dayNameLabel.text = nameStr;
        }
        dayNameLabel.tag =i+1;
        [dayArray addObject:dayNameLabel.text];
        [dayLabelArray addObject:dayNameLabel];
        dayNameLabel.textAlignment = NSTextAlignmentCenter;
        dayNameLabel.font = [UIFont systemFontOfSize:11];
        dayNameLabel.backgroundColor = [UIColor clearColor];
        [timeView addSubview:dayNameLabel];
        
        NSString * timeStr =@"";
        if(i==0){
            if (serviceTimeList1.count >0) {
                timeStr = [[serviceTimeList1 objectAtIndex:0] objectForKey:@"date"];
            }
        }else if(i==1){
            if (serviceTimeList2.count >0){
                timeStr = [[serviceTimeList2 objectAtIndex:0] objectForKey:@"date"];
            }
            
        }else if(i==2){
            if (serviceTimeList3.count >0){
               timeStr = [[serviceTimeList3 objectAtIndex:0] objectForKey:@"date"];
            }
        }else if(i==3){
            if (serviceTimeList4.count >0){
                timeStr = [[serviceTimeList4 objectAtIndex:0] objectForKey:@"date"];
            }
        }
        
        if (![timeStr isEqualToString:@""]) {
            timeStr = [timeStr substringFromIndex:5];
            timeStr = [timeStr stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
            NSLog(@"timeStr--%@",timeStr);
            [timeArray addObject:timeStr];
            UILabel * timeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, dayNameLabel.frame.origin.y+dayNameLabel.frame.size.height+5*AUTO_SIZE_SCALE_X, 38*AUTO_SIZE_SCALE_X, 11*AUTO_SIZE_SCALE_X)];
            timeNameLabel.backgroundColor = [UIColor clearColor];
            timeNameLabel.text = timeStr;
            timeNameLabel.tag  = i+1;
            timeNameLabel.textColor = UIColorBlackString;
            timeNameLabel.textAlignment = NSTextAlignmentCenter;
            timeNameLabel.font = [UIFont systemFontOfSize:11];
            [timeNameLabelArray addObject:timeNameLabel];
            [timeView addSubview:timeNameLabel];

        }
        
    }
    [self onclick];
}

-(void)onclick{
    
    for (UIView * v in timeViewArray) {
        if(v.tag -1 ==currentDay){
            v.backgroundColor =OrangeUIColorC4;
        }else{
            v.backgroundColor =[UIColor clearColor];
        }
    }
    
    for (UILabel *t in dayLabelArray) {
        if(t.tag -1 ==currentDay){
            t.textColor =[UIColor whiteColor];
        }else{
            t.textColor =UIColorBlackString;
        }
    }
    
    for (UILabel *t in timeNameLabelArray) {
        if(t.tag -1 ==currentDay){
            t.textColor =[UIColor whiteColor];
        }else{
            t.textColor =UIColorBlackString;
        }
    }
}
#pragma mark - 广播 接收选择时间
-(void)selectTime:(NSNotification *)ntf
{
    NSDictionary * dic = [NSDictionary dictionaryWithDictionary:ntf.object];
    if ([[dic objectForKey:@"isAvailable"] isEqualToString:@"0"]) {
        [[RequestManager shareRequestManager] tipAlert:@"选择时间段已被占用，请选择其他时间" viewController:self ];
    }
    else if([[dic objectForKey:@"isAvailable"] isEqualToString:@"1"])
    {

//        selectTimedic = [NSDictionary dictionaryWithDictionary:dic];
        selectTimedic = [NSMutableDictionary dictionaryWithDictionary:dic];
        defaultTimedic = [NSMutableDictionary dictionaryWithDictionary:dic];
        selectTimeStr = [NSString stringWithFormat:@"%@ %@",[dic objectForKey:@"date"],[dic objectForKey:@"timeSlot"]];
        showTimeStr = [NSString stringWithFormat:@"%@ %@",[dayArray objectAtIndex:currentDay],[dic objectForKey:@"timeSlot"]]; ;
//        defaultDay = self.currentDay;
        selectDay = currentDay;
        if ([dic objectForKey:@"transportationFee"]) {
            transportationFee = [NSString stringWithFormat:@"%@",[dic objectForKey:@"transportationFee"]];
        }else{
            transportationFee = @"";
        }
        
        [myTableView reloadData];
    }
    NSLog(@"%@ %@",[dic objectForKey:@"date"],[dic objectForKey:@"timeSlot"]);
}

#pragma mark - 确认时间
-(void)quedingBtnPressed:(UIButton *)sender
{
    
    NSLog(@"showTimeStr---%@  selectTimeStr--%@",showTimeStr,selectTimeStr);
    NSLog(@"selectTimedic--%@", selectTimedic);
//    if (([selectTimeStr isEqualToString:@""]&&[self.defaultSelectTimeStr isEqualToString:@""])) {
//        [[RequestManager shareRequestManager] tipAlert:@"请选择时间" viewController:self];
//        return;
//    }
//    queren = YES;
//    [self.navigationController popViewControllerAnimated:YES];
    
    if (currentDay == self.defaultDay) {
        if (([selectTimeStr isEqualToString:@""]&&[self.defaultSelectTimeStr isEqualToString:@""])){
            [[RequestManager shareRequestManager] tipAlert:@"请选择时间" viewController:self];
            return;
        }
    }
    else{
        if (([selectTimeStr isEqualToString:@""])) {
            [[RequestManager shareRequestManager] tipAlert:@"请选择时间" viewController:self];
            return;
        }
    }
        queren = YES;
        [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 切换时间
-(void)timeViewTaped:(UITapGestureRecognizer *)sender
{
    if (currentDay!=sender.view.tag-1) {
        currentDay = sender.view.tag-1;
        NSLog(@"currentDay %ld",currentDay);//[arrayGroup1 objectAtIndex:currentDay]
        NSLog(@"数据 %@",[arrayGroup1 objectAtIndex:currentDay]);//[arrayGroup1 objectAtIndex:currentDay]
        
        if (currentDay!=selectDay) {
            selectTimedic  = nil;
            showTimeStr = @"";
            selectTimeStr = @"";
            transportationFee = @"";
        }
        else{
            selectTimedic = defaultTimedic;
            selectTimeStr = [NSString stringWithFormat:@"%@ %@",[defaultTimedic objectForKey:@"date"],[defaultTimedic objectForKey:@"timeSlot"]];
            showTimeStr = [NSString stringWithFormat:@"%@ %@",[dayArray objectAtIndex:currentDay],[defaultTimedic objectForKey:@"timeSlot"]]; ;
            transportationFee = [NSString stringWithFormat:@"%@",[defaultTimedic objectForKey:@"transportationFee"]];

        }


        [self onclick];
        
        [myTableView reloadData];
    }
}

#pragma mark - 时间格式整理
//-(NSString *)ClientOrderDay:(int)time
//{
//    NSDate *aDate = [NSDate date];
//    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    NSDateComponents *components = [gregorian components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:aDate];
//    [components setDay:([components day]+time)];
//    
//    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
//    NSDateFormatter *dateday = [[NSDateFormatter alloc] init];
//    [dateday setDateFormat:@"YYYY-MM-dd"];
//    return [dateday stringFromDate:beginningOfWeek];
//}

-(NSString *)changeToWeek:(NSString *)str
{
    NSString* string = str;
    NSDateFormatter *inputFormatter =  [[NSDateFormatter alloc] init]  ;
    [inputFormatter setLocale: [NSLocale currentLocale]  ];//zh_CN  en_US
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* inputDate = [inputFormatter dateFromString:string];
    
    NSString * s ;
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    s = [weekdays objectAtIndex:theComponents.weekday];
    
    NSLog(@"s %@",s);
    return s;
}

#pragma mark UITableView代理
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (45+2)*(AUTO_SIZE_SCALE_X);
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [[arrayGroup1 objectAtIndex:currentDay] count];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify =@"TimeTableViewCell";
    TimeTableViewCell *cell = (TimeTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[TimeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    cell.data = [[arrayGroup1 objectAtIndex:currentDay] objectAtIndex:indexPath.row];
//    cell.cellRow = indexPath.row;
    cell.backgroundColor = [UIColor clearColor];

//    if (currentDay == self.defaultDay) {
        cell.selectDictionary = selectTimedic;
//    }
//    else{
//        cell.selectDictionary = nil;
//    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    

//    if (selectArray.count == 0) {
//        [selectArray addObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
//        [myTableView reloadData];
//        return;
//    }
}

#pragma mark -回调
- (void)returnText:(ReturnSelectTimeBlock)block {
    self.returnSelectTimeBlock = block;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"selectTime" object:nil];
    if (!queren) {
        if ([self.defaultSelectTimeStr isEqualToString:@""]) {
            showTimeStr = @"";
            selectTimeStr = @"";
            transportationFee = @"";
             selectTimedic = nil;
            currentDay = 0;
        }
        else{
            showTimeStr = self.defaultShowTimeStr;
            selectTimeStr = self.defaultSelectTimeStr;
            transportationFee = self.defaultTransFee;
            currentDay = self.defaultDay;
            selectTimedic = self.defaultDictionary;
//            self.selectTimedic = nil;
//            self.currentDay = 0;
        }
    }
    else{
        if ([selectTimeStr isEqualToString:@""]) {
            showTimeStr = self.defaultShowTimeStr;
            selectTimeStr = self.defaultSelectTimeStr;
            transportationFee = self.defaultTransFee;
            currentDay = self.defaultDay;
            selectTimedic = self.defaultDictionary;
        }
    }
    if (self.returnSelectTimeBlock != nil) {
        self.returnSelectTimeBlock(showTimeStr,selectTimeStr,transportationFee, selectTimedic,currentDay);
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
