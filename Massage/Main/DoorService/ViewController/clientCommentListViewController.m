//
//  clientCommentListViewController.m
//  Massage
//
//  Created by 屈小波 on 15/11/26.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "clientCommentListViewController.h"
#import "BaseTableView.h"
#import "CommentTableViewCell.h"

@interface clientCommentListViewController ()<UITableViewDataSource,UITableViewDelegate,BaseTableViewDelegate>{
    int _page;
    UIButton *tagBtn;//tag按钮
    NSString *tagID;
    NSString *firstInitFlag;
    NSMutableArray * selectBtnArray;//存储选中状态按钮
    NSMutableArray * normalBtnArray;//存储一般状态按钮
    
}
@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UIView *TableheaderView;
@property (nonatomic,strong) BaseTableView *listview;
@property (nonatomic,strong) NSMutableArray *evalList;
@property (nonatomic,strong) NSMutableArray *tagList ;

@end

@implementation clientCommentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.evalList = [NSMutableArray array];
    self.tagList = [[NSMutableArray alloc]initWithCapacity:0];
    selectBtnArray = [[NSMutableArray alloc]initWithCapacity:0];
    normalBtnArray = [[NSMutableArray alloc]initWithCapacity:0];
    self.titles =@"评价";
    tagID = @"";
    firstInitFlag =@"1";
    [self.view addSubview:self.listview];
    [self initRequestDataWithTagID:tagID];

}

-(void)initRequestDataWithTagID:(NSString *)tagStr{
     _page = 1;
     NSDictionary  *dic = @{
                            @"ID":self.ID,
                             @"type":self.type,
                             @"tagID":tagStr,
                             @"pageStart":@"1",
                             @"pageOffset":@"10",
                           };
        
    
    [self showHintNoHide:@"正在加载..."];
    
    NDLog(@"dic --- > %@",dic);
    [[RequestManager shareRequestManager] getCommenList :dic
                                          viewController:self
                                           successData:^(NSDictionary *result) {
                                               
                                               
                                               NDLog(@"result %@",result);
                                               if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {                                                   
                                                       [self.evalList removeAllObjects];
                                                       [self.evalList addObjectsFromArray:[result objectForKey:@"evalList"]];
                                                       if (self.evalList.count < 10|| self.evalList.count ==0 ) {
                                                           [self.listview.foot finishRefreshing];
                                                       }else
                                                       {
                                                           [self.listview.foot endRefreshing];
                                                       }
                                                   if ([firstInitFlag isEqualToString:@"1"]) {
                                                       
                                                     
                                                       


                                                   NSArray *tagArray =    [result objectForKey:@"tagList"];
                                                       for (int i = 0; i < tagArray.count; i++) {
                                                           NSString *name =[[tagArray objectAtIndex:i] objectForKey:@"tagName"];
                                                           
                                                           if ([name isEqualToString:@"全部"] || [name isEqualToString:@"好评"] || [name isEqualToString:@"差评"]) {
                                                               [self.tagList addObject:tagArray[i]];
                                                           }else{
                                                                NSString *totalcount = [NSString stringWithFormat:@"%@",[[tagArray objectAtIndex:i] objectForKey:@"totalCount"] ];
                                                               if ([totalcount isEqualToString:@"0"]) {
                                                               }else{
                                                                   
                                                               [self.tagList addObject:tagArray[i]];
                                                               
                                                               }
                                                           }

                                                       }
                                                           [self.headerView removeFromSuperview];
                                                           [normalBtnArray removeAllObjects];
                                                           [self initTagCloud];
                                                   }
                                                  
                                            


                                                   [self.listview reloadData];
                                                   
                                               }else{
                                                   [[RequestManager shareRequestManager]resultFail:result];
                                               }
                                               [self hideHud];
                                               
                                           } failuer:^(NSError *error) {
                                               [self hideHud];
                                           }];
}


#pragma mark - 刷新
- (void)refreshViewStart:(MJRefreshBaseView *)refreshView
{
    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
        //        _page = 1;
        //        _dataArray = [[NSMutableArray alloc]init];
    }else{
        _page ++ ;
    }
    
    NSString *pageString =[NSString stringWithFormat:@"%d",_page];
    

    NSDictionary  *dic = @{
                           @"ID":self.ID,
                           @"type":self.type,
                           @"tagID":tagID,
                           @"pageStart":pageString,
                           @"pageOffset":@"10",
                           };
    
    
    [self showHintNoHide:@"正在加载..."];
    
    NDLog(@"dic --- > %@",dic);
    [[RequestManager shareRequestManager] getCommenList :dic
                                          viewController:self
                                             successData:^(NSDictionary *result) {
                                                 
                                                 
                                                 NDLog(@"result %@",result);
                                                 if ([[result objectForKey:@"code"] isEqualToString:@"0000"]) {
                                                     NSArray *getevalList =[result objectForKey:@"evalList"];
                                                     [self.evalList addObjectsFromArray:getevalList];
                                                     if(self.evalList!=nil && self.evalList.count !=0){
                                                         if (getevalList.count < 10|| getevalList.count ==0 ) {
                                                             [self.listview.foot finishRefreshing];
                                                         }else
                                                         {
                                                             [self.listview.foot endRefreshing];
                                                         }
                                                         
                                                         [self.listview reloadData];
                                                     }
                                                 }else{
                                                     [[RequestManager shareRequestManager]resultFail:result];
                                                 }
                                                 [self hideHud];
                                                 
                                             } failuer:^(NSError *error) {
                                                 [self hideHud];
                                             }];
}



#pragma mark - delegate
#pragma mark - tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.evalList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *remarkString = [[self.evalList objectAtIndex:indexPath.row] objectForKey:@"remark"];
    UIFont *font = [UIFont systemFontOfSize:13];

    CGSize titleSize = [remarkString sizeWithFont:font constrainedToSize:CGSizeMake(kScreenWidth-45-(10+40+8), MAXFLOAT)  lineBreakMode:UILineBreakModeWordWrap];
    float small =  MAX(ceilf(titleSize.height) ,  13);
    return 18+13+8+12+15+18+small;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identify =@"doorcell";
    
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    if ([self.evalList count]>0) {
        cell.listData = [self.evalList objectAtIndex:indexPath.row];
        cell.backgroundColor = [UIColor clearColor];

    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(UIView *)TableheaderView{
    if (_TableheaderView ==nil) {
        _TableheaderView = [UIView new];
        _TableheaderView.backgroundColor =[UIColor clearColor];

        //        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taped:)];
        //        [_headerView addGestureRecognizer:tap];
    }
    return _TableheaderView;
}

-(UIView *)headerView{
    if (_headerView ==nil) {
        _headerView = [UIView new];
        _headerView.backgroundColor =[UIColor whiteColor];
       
//        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taped:)];
//        [_headerView addGestureRecognizer:tap];
    }
    return _headerView;
}

-(UIView *)listview{
    if (_listview ==nil) {
        _listview = [[BaseTableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
        _listview.delegate = self;
        _listview.dataSource = self;
        _listview.delegates = self;
        [_listview.head removeFromSuperview];

        
    }
    return _listview;
}

-(void)initTagCloud{
 
    //标签页
    CGFloat w = 0;//保存前一个button的宽以及前一个button距离屏幕边缘的距离
    CGFloat h = 10;//用来控制button距离父视图的高
    for (int i = 0; i < self.tagList.count; i++) {
        NSString *name =[[self.tagList objectAtIndex:i] objectForKey:@"tagName"];
        
        NDLog(@"--tagName-------%@",[[self.tagList objectAtIndex:i] objectForKey:@"tagName"] );
        tagBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        tagBtn.layer.cornerRadius = 3.0;
        tagBtn.layer.masksToBounds = YES;
        tagBtn.layer.borderWidth = 1.0;
        tagBtn.layer.borderColor = UIColorFromRGB(0xf1c2c1).CGColor;
        tagBtn.tag = 101 + i;
        tagBtn.backgroundColor = [UIColor whiteColor];
        tagBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [tagBtn addTarget:self action:@selector(TagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [tagBtn setTitleColor:RedUIColorC1 forState:UIControlStateNormal];
        //根据计算文字的大小
        
        NSString *string = [NSString stringWithFormat:@"%@(%@)",[[self.tagList objectAtIndex:i] objectForKey:@"tagName"] ,[[self.tagList objectAtIndex:i] objectForKey:@"totalCount"] ];
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
        CGFloat length = [string boundingRectWithSize:CGSizeMake(kScreenWidth, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
        //为button赋值
        [tagBtn setTitle:string forState:UIControlStateNormal];
        //设置button的frame
        tagBtn.frame = CGRectMake(15 + w, h, length + 15 , 30);
        //当button的位置超出屏幕边缘时换行 320 只是button所在父视图的宽度
        if(15 + w + length + 15 > kScreenWidth){
            w = 0; //换行时将w置为0
            h = h + tagBtn.frame.size.height + 8;//距离父视图也变化
            tagBtn.frame = CGRectMake(15 + w, h, length + 15, 30);//重设button的frame
        }
        w = tagBtn.frame.size.width + tagBtn.frame.origin.x - 8;//间距为15-8
        [self.headerView addSubview:tagBtn];
         self.headerView.frame = CGRectMake(0, 10, kScreenWidth, h + tagBtn.frame.size.height + 10);
       
//        self.TableheaderView.frame = CGRectMake(0, 0, kScreenWidth, self.headerView.frame.size.height + 20);
        self.TableheaderView.frame = CGRectMake(0, kNavHeight, kScreenWidth, self.headerView.frame.size.height + 20);
        
        [normalBtnArray addObject:tagBtn];
    }
    [self.TableheaderView addSubview:self.headerView];
    [self.view addSubview:self.TableheaderView];
    self.listview.frame = CGRectMake(0, kNavHeight+self.TableheaderView.frame.size.height, kScreenWidth, kScreenHeight-(kNavHeight+self.TableheaderView.frame.size.height));
//    [self.listview setTableHeaderView:self.TableheaderView];
//    [self.TableheaderView addSubview:self.headerView];
}


//标签 Click
- (void)TagBtnClick:(UIButton *)sender {
    firstInitFlag = @"0";
    NSLog(@"%ld",(long)sender.tag);

    for (UIButton *temp in normalBtnArray) {
        if (sender.tag ==temp.tag) {
            temp.backgroundColor = RedUIColorC1;
            [temp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        }else{
            temp.backgroundColor = [UIColor whiteColor];
            [temp setTitleColor:RedUIColorC1 forState:UIControlStateNormal];
        }
    }
    
    
    for (int i =0; i<self.tagList.count; i++) {
        
        
          NSArray *list=[sender.titleLabel.text componentsSeparatedByString:@"("];
        if ([list[0] isEqualToString:[[self.tagList objectAtIndex:i] objectForKey:@"tagName"]]) {

            NSString *tagStr = [NSString stringWithFormat:@"%@",[[self.tagList objectAtIndex:i] objectForKey:@"ID"]];
            [self initRequestDataWithTagID:tagStr];
        }
    }
}
@end
