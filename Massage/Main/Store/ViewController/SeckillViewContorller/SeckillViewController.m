//
//  SeckillViewController.m
//  Massage
//
//  Created by htjd_IOS on 16/2/25.
//  Copyright © 2016年 sophiemarceau_qu. All rights reserved.
//

#import "SeckillViewController.h"
#import "SeckillTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "SeckillPayViewController.h"
#import "ServiceDetailViewController.h"
#import "LoginViewController.h"
@interface SeckillViewController ()<UITableViewDataSource,UITableViewDelegate,SeckillTableViewCellPayDelete,UIScrollViewDelegate>
{
    UIImageView * bgYuan1;
    UIButton * backsBtn;
    
    UITableView * seckillTableView;
    
    UIView * headerView;
    UIImageView * topIcon;
    
    UIView * sectionView;
    
    UIView * labelView;
    
    UILabel * defautlLabel;
    UILabel * sellLabel;
    UILabel * priceLabel;
    
    UIImageView * priceImv;
    
    UIView * selectLineView;
    
    NSString * selectType;
    
    int hour;
    int min;
    int sec;
    
    NSString * timeLeft;
    
    BOOL timeout;
    BOOL timebegin;

    UIView * timeLineView;
    NSMutableArray * timeArray;

    UILabel * timeleftLabel;
    
    NSTimer * timerToend;
    NSTimer * timerTobegin;
    
    NSString * sortType;
    
    NSMutableArray * activityListArray;
    
    int timeforbegin;
    int timeforend;
    NSMutableArray * activitydesc;
    NSMutableArray * featureDesc;
    UIView * lineView;

}
@end

@implementation SeckillViewController

-(void)viewWillDisappear:(BOOL)animated
{
//    [timerToend invalidate];
//    [timerTobegin invalidate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor clearColor];

//    self.navView.alpha = 1;
    
//    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    
    
//    int i = 65;
//    hour = i/3600;
//    min = i%3600/60;
//    sec = i%60;
//    
//    
//    
//    timeLeft = [NSString stringWithFormat:@"剩余时间 %d小时 %d分 %d秒",hour,min,sec];
//    NSLog(@"timeLeft %@",timeLeft);

    
    selectType = @"0";
    timeout = NO;
    sortType = @"";
    timeArray = [[NSMutableArray alloc] initWithCapacity:0];
    activityListArray = [[NSMutableArray alloc] initWithCapacity:0];
    activitydesc = [[NSMutableArray alloc] initWithCapacity:0];
    featureDesc = [[NSMutableArray alloc] initWithCapacity:0];
    
    if ([self.titles isEqualToString:@"秒杀专场"]) {
        timebegin = YES;
    }
    else if ([self.titles isEqualToString:@"预告专场"])
    {
        timebegin = NO;
    }
    
    [self initsectionView];
    
    [self initTableView];
    
    
    bgYuan1 = [[UIImageView alloc] init];
    bgYuan1.image = [UIImage imageNamed:@"icon_bg"];
    bgYuan1.alpha = 0.5;
    [self.view addSubview:bgYuan1];
    
    backsBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    backsBtn.frame = CGRectMake(0, 22*AUTO_SIZE_SCALE_X1,35*AUTO_SIZE_SCALE_X1, 44);
    [backsBtn setImage:[UIImage imageNamed:@"icon_sd_back"] forState:UIControlStateNormal];
    [backsBtn addTarget:self action:@selector(backsBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [backsBtn setBackgroundColor:[UIColor clearColor]];
    [self.view  addSubview:backsBtn];
    bgYuan1.frame = CGRectMake(5 , 22*AUTO_SIZE_SCALE_X1+(44-28*AUTO_SIZE_SCALE_X1)/2, 28*AUTO_SIZE_SCALE_X1, 28*AUTO_SIZE_SCALE_X1);
    


}

//#pragma mark 检查秒杀时间
//-(void)checkKillTime:(NSString *)currentT startTime:(NSString *)startT endTime:(NSString *)endT
//{
//    NSArray * currentTarray = [currentT componentsSeparatedByString:@":"]; //从字符A中分隔成2个元素的数组
//    NSString *currentTHH = currentTarray[0];
//    NSString *currentTMM= currentTarray[1];
//    NSString *currentTss = currentTarray[2];
//    NSInteger currentTh = [currentTHH integerValue];
//    NSInteger currentTm = [currentTMM integerValue];
//    NSInteger currentTs = [currentTss integerValue];
//    NSInteger currentThms = currentTh*3600 + currentTm*60 +currentTs;
//    
//    NSArray * startTarray = [startT componentsSeparatedByString:@":"]; //从字符A中分隔成2个元素的数组
//    NSString *startTHH = startTarray[0];
//    NSString *startTMM= startTarray[1];
//    NSString *startTss = startTarray[2];
//    NSInteger startTh = [startTHH integerValue];
//    NSInteger startTm = [startTMM integerValue];
//    NSInteger startTs = [startTss integerValue];
//    NSInteger startThms = startTh*3600 + startTm*60 +startTs;
//    
//    NSArray * endTarray = [endT componentsSeparatedByString:@":"]; //从字符A中分隔成2个元素的数组
//    NSString *endTHH = endTarray[0];
//    NSString *endTMM= endTarray[1];
//    NSString *endTss = endTarray[2];
//    NSInteger endTh = [endTHH integerValue];
//    NSInteger endTm = [endTMM integerValue];
//    NSInteger endTs = [endTss integerValue];
//    NSInteger endThms = endTh*3600 + endTm*60 +endTs;
//    
//
//    
//    
//    
//    timeforbegin = (int)(startThms - currentThms);
////    NSLog(@"  currentThms %d  startThms %d  endThms %d",currentThms,startThms,endThms);
//    //活动未开始 当前时间<开始时间
//    if (currentThms < startThms) {
//        timeforend = (int)(endThms - startThms );
//        timeleftLabel.text = [NSString stringWithFormat:@"距离本场开始时间还剩%d秒",timeforbegin];
//        timerTobegin = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethodtobegin:) userInfo:nil repeats:YES];
//        [[NSRunLoop currentRunLoop] addTimer:timerTobegin forMode:NSRunLoopCommonModes];
//    }
//    //活动进行中 开始时间<=当前时间<结束时间
//    else if (startThms <= currentThms && currentThms< endThms) {
//        timeforend = (int)(endThms - currentThms );
//        timeleftLabel.text = [NSString stringWithFormat:@"距离本场结束时间还剩%d秒",timeforend];
//        timerToend = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethodtoend:) userInfo:nil repeats:YES];
//        [[NSRunLoop currentRunLoop] addTimer:timerToend forMode:NSRunLoopCommonModes];
//    }
//    //活动结束 当前时间>=结束时间
//    else if (currentThms >= endThms) {
//        NSLog(@"本场活动已结束 ");
//        timeleftLabel.text = @"本场活动已结束 ";
//        timeout = YES;
//        [timerTobegin invalidate];
//        [timerToend invalidate];
//    }
//
//}
//
//- (void)timerFireMethodtoend:(NSTimer *)theTimer
//{
//    timeforend--;
//    timeleftLabel.text = [NSString stringWithFormat:@"距离本场结束时间还剩%d秒",timeforend];
//    if (timeforend == 0) {
//        [theTimer invalidate];
//        timeleftLabel.text = @"本场活动已结束 ";
//        timeout = YES;
//    }
//
//
//    
//}
//
//- (void)timerFireMethodtobegin:(NSTimer *)theTimer
//{
//    timeforbegin--;
//    timeleftLabel.text = [NSString stringWithFormat:@"距离本场开始时间还剩%d秒",timeforbegin];
//    if (timeforbegin == 0) {
//        [theTimer invalidate];
//        timerToend = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethodtoend:) userInfo:nil repeats:YES];
//        [[NSRunLoop currentRunLoop] addTimer:timerToend forMode:NSRunLoopCommonModes];
//    }
//    
//    
//}

#pragma mark －－－－－－－－－－－－
-(void)getQuerySpecialContext
{
    NSDictionary * dic = @{
                           @"ID":self.ID,
                           @"orderBy":selectType,//排序方式 0：默认排序字段,1:销量,2：价格升序,3:价格降序
                           };
//    NSLog(@"dic %@",dic);
    [[RequestManager shareRequestManager] getQuerySpecialContext:dic viewController:self successData:^(NSDictionary *result) {
        NSLog(@"查询秒杀专题内容result %@",result);
        if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
            [activityListArray removeAllObjects];
            [activityListArray addObjectsFromArray:[result   objectForKey:@"activityList"]];
            [activitydesc removeAllObjects];
            [topIcon setImageWithURL:[NSURL URLWithString:[result objectForKey:@"icon"]] placeholderImage:[UIImage imageNamed:@"icon_touxiang"]];
            [self countLabelViewHeight:result];
           
            [self countActivitydescHeight];

            [seckillTableView reloadData];
        }
    } failuer:^(NSError *error) {
        
    }];
}

#pragma mark 添加说明
-(void)addActivityLabel:(CGFloat )y Height:(CGFloat)height Data:(NSDictionary *)dic
{
    UILabel * label1 = [[UILabel alloc] initWithFrame:CGRectMake(20*AUTO_SIZE_SCALE_X1, y, 10*AUTO_SIZE_SCALE_X1, 15*AUTO_SIZE_SCALE_X1)];
    label1.text = @" · ";
    label1.font = [UIFont systemFontOfSize:12];
    label1.textColor = UIColorFromRGB(0x777777);
    [labelView addSubview:label1];
//    [activitydesc addObject:label1];
    
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(30*AUTO_SIZE_SCALE_X1, y, kScreenWidth-40*AUTO_SIZE_SCALE_X1, height)];
    //    label.backgroundColor = [UIColor redColor];
    label.backgroundColor = [UIColor clearColor];
    //    label.layer.borderWidth = 0.0;
    label.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"content"]];
    label.textColor = UIColorFromRGB(0x777777);
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:12];
    [labelView addSubview:label];
//    [activitydesc addObject:label];
}

-(void)countLabelViewHeight:(NSDictionary *)dic
{
    NSArray * array = [NSArray arrayWithArray:[dic objectForKey:@"featureDesc"]];
    float height = 0;
    if (array.count>0) {
        for (int j = 0; j<array.count; j++) {
            NSString * str = [[array objectAtIndex:j] objectForKey:@"content"];
            CGSize contentSize = CGSizeMake(kScreenWidth-40*AUTO_SIZE_SCALE_X1, 2000);
            CGSize contentLabelSize = [str sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:contentSize lineBreakMode:NSLineBreakByWordWrapping];
            [self addActivityLabel:height+5*AUTO_SIZE_SCALE_X1 Height:contentLabelSize.height  Data:[array objectAtIndex:j]];
            height = height+contentLabelSize.height+ 5*AUTO_SIZE_SCALE_X1;
        }
        labelView.frame = CGRectMake(0, topIcon.frame.origin.y+topIcon.frame.size.height, kScreenWidth, height+10);
    }
    else{
        
        labelView.frame = CGRectMake(0, topIcon.frame.origin.y+topIcon.frame.size.height, kScreenWidth, height);
    }

    
    lineView.frame = CGRectMake(0, labelView.frame.origin.y+labelView.frame.size.height, kScreenWidth, 6*AUTO_SIZE_SCALE_X1);

    headerView.frame = CGRectMake(0, 0, kScreenWidth, topIcon.frame.size.height+lineView.frame.size.height+labelView.frame.size.height);
    [seckillTableView setTableHeaderView:headerView];
    [seckillTableView sendSubviewToBack:headerView];
}

-(void)countActivitydescHeight
{
    for (int i =0; i<activityListArray.count; i++) {
        NSArray * array = [[activityListArray objectAtIndex:i] objectForKey:@"activitydesc"];
        float height = 0;
        if (array.count>0) {
            for (int j = 0; j<array.count; j++) {
                NSString * str = [[array objectAtIndex:j] objectForKey:@"content"];
                CGSize contentSize = CGSizeMake(kScreenWidth-40*AUTO_SIZE_SCALE_X1, 2000);
                CGSize contentLabelSize = [str sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:contentSize lineBreakMode:NSLineBreakByWordWrapping];
                height = height+contentLabelSize.height+ 5*AUTO_SIZE_SCALE_X1;
            }
            NSString * heightStr = [NSString stringWithFormat:@"%f",height];
            NSLog(@"heightStr %@",heightStr);
            [activitydesc addObject:heightStr];
            


        }
        else{
            NSString * heightStr = [NSString stringWithFormat:@"%f",0.0];
            [activitydesc addObject:heightStr];
        }
    }
}

-(void)backsBtnPressed:(UIButton *)sender
{
//    if ([self.backType isEqualToString:@"1"]) {
//        [self.navigationController popToRootViewControllerAnimated:YES];
//        return;
//    }
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)initsectionView
{
//    sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40*AUTO_SIZE_SCALE_X1+40*AUTO_SIZE_SCALE_X1+40*AUTO_SIZE_SCALE_X1)];
    sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40*AUTO_SIZE_SCALE_X1)];
    sectionView.backgroundColor = [UIColor whiteColor];
    
    UIView * lV = [[UIView alloc] initWithFrame:CGRectMake(0, sectionView.frame.size.height-1, kScreenWidth, 1)];
    lV.backgroundColor = C2UIColorGray;
    [sectionView addSubview:lV];
    
    defautlLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 4, kScreenWidth/3, 40*AUTO_SIZE_SCALE_X1-8)];
    defautlLabel.tag = 101;
    defautlLabel.text = @"默认";
    defautlLabel.textColor = UIColorFromRGB(0x1D1D1D);
    defautlLabel.textAlignment = NSTextAlignmentCenter;
    defautlLabel.font = [UIFont systemFontOfSize:14];
    [sectionView addSubview:defautlLabel];
    defautlLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer * defaultLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionViewTap:)];
    [defautlLabel addGestureRecognizer:defaultLabelTap];
    

    sellLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/3, 4, kScreenWidth/3, 40*AUTO_SIZE_SCALE_X1-8)];
    sellLabel.tag = 102;
    sellLabel.text = @"销量优先";
    sellLabel.textColor = UIColorFromRGB(0x1D1D1D);
    sellLabel.textAlignment = NSTextAlignmentCenter;
    sellLabel.font = [UIFont systemFontOfSize:14];
    [sectionView addSubview:sellLabel];
    sellLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer * sellLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionViewTap:)];
    [sellLabel addGestureRecognizer:sellLabelTap];
    
    priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/3*2, 4, kScreenWidth/3, 40*AUTO_SIZE_SCALE_X1-8)];
    priceLabel.tag = 103;
    priceLabel.text = @"价格";
    priceLabel.textColor = UIColorFromRGB(0x1D1D1D);
    priceLabel.textAlignment = NSTextAlignmentCenter;
    priceLabel.font = [UIFont systemFontOfSize:14];
    [sectionView addSubview:priceLabel];
    priceLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer * priceLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionViewTap:)];
    [priceLabel addGestureRecognizer:priceLabelTap];
    
    priceImv = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/3/2+20, (40*AUTO_SIZE_SCALE_X1-8-10)/2, 7, 10)];
    priceImv.image = [UIImage imageNamed:@"icon_screen"];
    [priceLabel addSubview:priceImv];
    
    selectLineView = [[UIView alloc] init];
    selectLineView.backgroundColor = UIColorFromRGB(0xD83219);
    [sectionView addSubview:selectLineView];


    
//    UIScrollView * scrView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40*AUTO_SIZE_SCALE_X1, kScreenWidth, 40*AUTO_SIZE_SCALE_X1)];
//    scrView.delegate = self;
//    scrView.showsHorizontalScrollIndicator = NO;
//    scrView.backgroundColor = [UIColor blackColor];
//    scrView.tag = 999;
//    [sectionView addSubview:scrView];
//    
//    timeLineView = [[UIView alloc] initWithFrame:CGRectMake(15, 40*AUTO_SIZE_SCALE_X1-3, 40, 3)];
//    timeLineView.backgroundColor = UIColorFromRGB(0xC03230);
//    [scrView addSubview:timeLineView];
//    
//    for (int i = 0; i<10; i++) {
//        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(70*i, 3, 70, 40*AUTO_SIZE_SCALE_X1-6)];
//        view.backgroundColor = [UIColor blackColor];
//        [scrView addSubview:view];
//        
//        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 40, 40*AUTO_SIZE_SCALE_X1-6)];
//        label.text = [NSString stringWithFormat:@"%d%d:%d%d",i,i,i,i];
//        label.textColor = UIColorFromRGB(0x747474);
//        label.textAlignment = NSTextAlignmentCenter;
//        label.font = [UIFont systemFontOfSize:13];
//        label.tag = 200+i;
//        [view addSubview:label];
//        label.userInteractionEnabled = YES;
//        [timeArray addObject:label];
//        UITapGestureRecognizer * labelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTaped:)];
//        [label addGestureRecognizer:labelTap];
//        
//        if (i == 0) {
//            label.textColor = UIColorFromRGB(0xFFFFFF);
//            label.font = [UIFont systemFontOfSize:14];
//        }
//    }
//    scrView.contentSize = CGSizeMake(70*10, 40*AUTO_SIZE_SCALE_X1);
//
//    UIView * timeView = [[UIView alloc] initWithFrame:CGRectMake(0,80*AUTO_SIZE_SCALE_X1, kScreenWidth, 40*AUTO_SIZE_SCALE_X1)];
//    timeView.backgroundColor = C2UIColorGray;
//    [sectionView addSubview:timeView];
//    
//    timeleftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40*AUTO_SIZE_SCALE_X1)];
//    timeleftLabel.text = timeLeft;
//    timeleftLabel.textAlignment = NSTextAlignmentCenter;
//    timeleftLabel.font = [UIFont systemFontOfSize:13];
//    timeleftLabel.textColor = UIColorFromRGB(0x747474);
//    [timeView addSubview:timeleftLabel];
    
}

-(void)labelTaped:(UITapGestureRecognizer *)sender
{
    timeLineView.frame = CGRectMake(15+70*(sender.view.tag-200), 40*AUTO_SIZE_SCALE_X1-3, 40, 3);
    for (UILabel * label in timeArray) {
        label.textColor = UIColorFromRGB(0x747474);
        label.font = [UIFont systemFontOfSize:13];
        if (label.tag == sender.view.tag) {
            label.textColor = UIColorFromRGB(0xFFFFFF);
            label.font = [UIFont systemFontOfSize:14];
        }
    }
}

-(void)initTableView
{
    
    seckillTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    seckillTableView.delegate = self;
    seckillTableView.dataSource = self;
    seckillTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    seckillTableView.backgroundColor = C2UIColorGray;
    seckillTableView.showsVerticalScrollIndicator = NO;
    seckillTableView.bounces = NO;
    [self.view addSubview:seckillTableView];
   
    
    headerView = [[UIView alloc] init];
    headerView.backgroundColor = C2UIColorGray;
    
    topIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 282*AUTO_SIZE_SCALE_X1)];
    [headerView addSubview:topIcon];
    
    labelView = [[UIView alloc] init];
    labelView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:labelView];
    
    lineView = [[UIView alloc] init];
    lineView.backgroundColor = C2UIColorGray;
    [headerView addSubview:lineView];
    
//    headerView.frame = CGRectMake(0, 0, kScreenWidth, topIcon.frame.size.height+labelView.frame.size.height+lineView.frame.size.height);
//    [seckillTableView setTableHeaderView:headerView];
    
//    headerView.frame = CGRectMake(0, 0, kScreenWidth, topIcon.frame.size.height+6*AUTO_SIZE_SCALE_X1+labelView.frame.size.height);
//    [seckillTableView setTableHeaderView:headerView];
//    
//    [seckillTableView sendSubviewToBack:headerView];
    
    self.navView.alpha = 0.0;
    [self.view addSubview:self.navView];
    
    [self changeType];

}


#pragma mark sectionViewTap
-(void)sectionViewTap:(UITapGestureRecognizer *)sender
{
    
    
    if (sender.view.tag == 101) {
        selectType = @"0";
        sortType = @"";
        priceImv.image = [UIImage imageNamed:@"icon_screen"];
    }
    else if (sender.view.tag == 102) {
        selectType = @"1";
        sortType = @"";
        priceImv.image = [UIImage imageNamed:@"icon_screen"];
    }
    else if (sender.view.tag == 103) {
        if ( [sortType isEqualToString:@""]) {
            sortType = @"1";
            priceImv.image = [UIImage imageNamed:@"icon_screenr1"];
            selectType = @"2";
        }
        else if ([sortType isEqualToString:@"1"]){
            sortType = @"2";
            priceImv.image = [UIImage imageNamed:@"icon_screenr2"];
            selectType = @"3";
        }
        else if([sortType isEqualToString:@"2"]){
            sortType = @"1";
            priceImv.image = [UIImage imageNamed:@"icon_screenr1"];
            selectType = @"2";
        }
    }
    [self changeType];
}

#pragma mark 改变列表顺序
-(void)changeType
{
    defautlLabel.textColor = UIColorFromRGB(0x1D1D1D);
    sellLabel.textColor = UIColorFromRGB(0x1D1D1D);
    priceLabel.textColor = UIColorFromRGB(0x1D1D1D);
    if ([selectType isEqualToString:@"0"]) {
        defautlLabel.textColor = UIColorFromRGB(0xD83219);
        CGSize size = [defautlLabel intrinsicContentSize];
        selectLineView.frame = CGRectMake((kScreenWidth/3-size.width)/2, 40*AUTO_SIZE_SCALE_X1-4, size.width, 4);
    }
    else if([selectType isEqualToString:@"1"]){
        sellLabel.textColor = UIColorFromRGB(0xD83219);
        CGSize size = [sellLabel intrinsicContentSize];
        selectLineView.frame = CGRectMake(kScreenWidth/3+(kScreenWidth/3-size.width)/2, 40*AUTO_SIZE_SCALE_X1-4, size.width, 4);
    }
    else if([selectType isEqualToString:@"2"]||[selectType isEqualToString:@"3"]){
        priceLabel.textColor = UIColorFromRGB(0xD83219);
        CGSize size = [priceLabel intrinsicContentSize];
        selectLineView.frame = CGRectMake(kScreenWidth/3*2+(kScreenWidth/3-size.width)/2, 40*AUTO_SIZE_SCALE_X1-4, size.width, 4);
    }
    [self getQuerySpecialContext];
}

#pragma mark 秒杀按钮代理
-(void)gotoSecKillPay:(NSDictionary *)dic
{
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * userID = [userDefaults objectForKey:@"userID"];
    if (!userID) {
        seckillTableView.userInteractionEnabled = NO;
        [[RequestManager shareRequestManager] tipAlert:@"您还未登录，不能使用预约功能" viewController:self];
        [self performSelector:@selector(gotoLogVC) withObject:nil afterDelay:1.0];
        return;
    }

    SeckillPayViewController * vc = [[SeckillPayViewController alloc] init];
    vc.minPrice = [NSString stringWithFormat:@"%@",[dic objectForKey:@"minPrice"]];
    vc.specialID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ID"]];
    if ([dic objectForKey:@"priceID"]) {
        vc.priceID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"priceID"]];
    }
    else{
        vc.priceID = @"";
    }
    vc.servName = [NSString stringWithFormat:@"%@",[dic objectForKey:@"servName"]];
    vc.storeName = [NSString stringWithFormat:@"%@",[dic objectForKey:@"storeName"]];
    vc.servIcom = [NSString stringWithFormat:@"%@",[dic objectForKey:@"icon"]];
    vc.activitydescArray = [NSMutableArray arrayWithArray:[dic objectForKey:@"activitydesc"]];
    [self.navigationController pushViewController:vc animated:YES];
    return;

}

-(void)gotoLogVC
{
//    favoriteBtn.userInteractionEnabled = YES;
//    favoritesBtn.userInteractionEnabled = YES;
//    yuyueBtn.userInteractionEnabled = YES;
    seckillTableView.userInteractionEnabled = YES;
    LoginViewController * vc = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 跳转到项目详情
-(void)gotoServiceDetail:(NSDictionary *)dic
{
    NSString * stockStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"stock"]];
    if (!timebegin||[stockStr isEqualToString:@"0"]) {
        NSLog(@"可以跳转");
        ServiceDetailViewController * vc = [[ServiceDetailViewController alloc] init];
        vc.serviceID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"servID"]];
        vc.isSelfOwned = @"0";
        vc.serviceType = @"0";
        vc.isStore = YES;
        vc.haveWorker = NO;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark UItableView代理
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
        return sectionView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    return 40*AUTO_SIZE_SCALE_X1 +40*AUTO_SIZE_SCALE_X1+40*AUTO_SIZE_SCALE_X1;
    return 40*AUTO_SIZE_SCALE_X1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return activityListArray.count;
}

//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 30;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float activitydescHeight = [[activitydesc objectAtIndex:indexPath.row] floatValue] ;
    if ([[NSString stringWithFormat:@"%@",[[activityListArray objectAtIndex:indexPath.row] objectForKey:@"isLevel"] ] isEqualToString:@"0"]) {
        return (366+ (55*1))*AUTO_SIZE_SCALE_X1+7*AUTO_SIZE_SCALE_X1+activitydescHeight ;
    }
    return (366+ (55*[[[activityListArray objectAtIndex:indexPath.row] objectForKey:@"servLevelList"] count]))*AUTO_SIZE_SCALE_X1+7*AUTO_SIZE_SCALE_X1+activitydescHeight ;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellName = @"SeckillTableViewCell";
    SeckillTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    
    if (!cell) {
        cell = [[SeckillTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (activityListArray.count > 0 ) {
        cell.timeout = timeout;
        cell.timebegin = timebegin;
        cell.type = @"1";
        cell.dataDic = [activityListArray objectAtIndex:indexPath.row] ;
        cell.delegate = self;
    }
    
//    if ([[NSString stringWithFormat:@"%@",[[activityListArray objectAtIndex:indexPath.row] objectForKey:@"isLevel"] ] isEqualToString:@"0"]) {
//        cell.mycount = 0;
//    }
//    else{
//        cell.mycount = (int)[[[activityListArray objectAtIndex:indexPath.row] objectForKey:@"servLevelList"] count]-1;
//    }

    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == 999) {
        return;
    }
//    [self.view sendSubviewToBack:headerView];
        topIcon.center = CGPointMake(kScreenWidth/2, (282*AUTO_SIZE_SCALE_X1+scrollView.contentOffset.y)/2);
//    self.navView.alpha = scrollView.contentOffset.y/(282.0*AUTO_SIZE_SCALE_X1);
    self.navView.alpha = scrollView.contentOffset.y/(250*AUTO_SIZE_SCALE_X1-kNavHeight);
        CGFloat xx = 0.0; //0-1
//    xx = (scrollView.contentOffset.y-headerView.frame.size.height+labelView.frame.size.height+6*AUTO_SIZE_SCALE_X1)/(labelView.frame.size.height+6*AUTO_SIZE_SCALE_X1);
//    xx = (scrollView.contentOffset.y-topIcon.frame.size.height+kNavHeight)/(labelView.frame.size.height+6*AUTO_SIZE_SCALE_X1);
//    xx = (scrollView.contentOffset.y)/(headerView.frame.size.height-kNavHeight);
    
    xx = (scrollView.contentOffset.y-250*AUTO_SIZE_SCALE_X1+kNavHeight)/(headerView.frame.size.height-250*AUTO_SIZE_SCALE_X1+kNavHeight);

    
//    NSLog(@"xx %f  scrollView.contentOffset.y  %f",xx,scrollView.contentOffset.y);
//    if (scrollView.contentOffset.y >= 282*AUTO_SIZE_SCALE_X1-20) {
//        topIcon.hidden = YES;
//    }
//    else{
//        topIcon.hidden = NO;
//    }
    if ( 0< xx && xx<=1 ) {
        seckillTableView.frame = CGRectMake(0, kNavHeight*(xx) , kScreenWidth, kScreenHeight-kNavHeight*(xx) );
        }
        else if (xx <= 0)
        {
            seckillTableView.frame = CGRectMake(0, 0 , kScreenWidth, kScreenHeight  );
        }
        else if (xx > 1)
        {
            seckillTableView.frame = CGRectMake(0, kNavHeight , kScreenWidth,  kScreenHeight -kNavHeight );
        }
    
        if (scrollView.contentOffset.y <= 0)
        {
            CGPoint offset = scrollView.contentOffset;
            offset.y = 0;
            scrollView.contentOffset = offset;
        }
    
        if (self.navView.alpha != 0) {
            bgYuan1.hidden = YES;
//            bgYuan2.hidden = YES;
//            bgYuan3.hidden = YES;
//            favoritesBtn.hidden = YES;
//            sharesBtn.hidden = YES;
            backsBtn.hidden = YES;
        }
        if (self.navView.alpha == 0) {
            bgYuan1.hidden = NO;
//            bgYuan2.hidden = NO;
//            bgYuan3.hidden = NO;
//            favoritesBtn.hidden = NO;
//            sharesBtn.hidden = NO;
            backsBtn.hidden = NO;
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
