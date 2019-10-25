//
//  CityChangeViewController.m
//  Massage
//
//  Created by htjd_IOS on 15/10/19.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "CityChangeViewController.h"
#import "publicTableViewCell.h"
@interface CityChangeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * MytableView;
    NSMutableArray * cityArray;
    NSDictionary * cityListDic;
    NSMutableArray * sectionIndexTitlesArray;
    NSMutableArray * allArray;
    NSMutableArray * Aarray;
    NSMutableArray * Barray;
    NSMutableArray * Carray;
    NSMutableArray * Darray;
    NSMutableArray * Earray;
    NSMutableArray * Farray;
    NSMutableArray * Garray;
    NSMutableArray * Harray;
    NSMutableArray * Iarray;
    NSMutableArray * Jarray;
    NSMutableArray * Karray;
    NSMutableArray * Larray;
    NSMutableArray * Marray;
    NSMutableArray * Narray;
    NSMutableArray * Oarray;
    NSMutableArray * Parray;
    NSMutableArray * Qarray;
    NSMutableArray * Rarray;
    NSMutableArray * Sarray;
    NSMutableArray * Tarray;
    NSMutableArray * Uarray;
    NSMutableArray * Varray;
    NSMutableArray * Warray;
    NSMutableArray * Xarray;
    NSMutableArray * Yarray;
    NSMutableArray * Zarray;
    
    NSDictionary * selectCitydic;
}
@end

@implementation CityChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.titles = @"切换城市";
    
    cityArray = [[NSMutableArray alloc] initWithCapacity:0];
    allArray = [[NSMutableArray alloc] initWithCapacity:0];
    Aarray = [[NSMutableArray alloc] initWithCapacity:0];
    Barray = [[NSMutableArray alloc] initWithCapacity:0];
    Carray = [[NSMutableArray alloc] initWithCapacity:0];
    Darray = [[NSMutableArray alloc] initWithCapacity:0];
    Earray = [[NSMutableArray alloc] initWithCapacity:0];
    Farray = [[NSMutableArray alloc] initWithCapacity:0];
    Garray = [[NSMutableArray alloc] initWithCapacity:0];
    Harray = [[NSMutableArray alloc] initWithCapacity:0];
    Iarray = [[NSMutableArray alloc] initWithCapacity:0];
    Jarray = [[NSMutableArray alloc] initWithCapacity:0];
    Karray = [[NSMutableArray alloc] initWithCapacity:0];
    Larray = [[NSMutableArray alloc] initWithCapacity:0];
    Marray = [[NSMutableArray alloc] initWithCapacity:0];
    Narray = [[NSMutableArray alloc] initWithCapacity:0];
    Oarray = [[NSMutableArray alloc] initWithCapacity:0];
    Parray = [[NSMutableArray alloc] initWithCapacity:0];
    Qarray = [[NSMutableArray alloc] initWithCapacity:0];
    Rarray = [[NSMutableArray alloc] initWithCapacity:0];
    Sarray = [[NSMutableArray alloc] initWithCapacity:0];
    Tarray = [[NSMutableArray alloc] initWithCapacity:0];
    Uarray = [[NSMutableArray alloc] initWithCapacity:0];
    Varray = [[NSMutableArray alloc] initWithCapacity:0];
    Warray = [[NSMutableArray alloc] initWithCapacity:0];
    Xarray = [[NSMutableArray alloc] initWithCapacity:0];
    Yarray = [[NSMutableArray alloc] initWithCapacity:0];
    Zarray = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self showHudInView:self.view hint:@"正在加载"];
    //    NSDictionary * dic = @{
    //                           @"type":@"1",
    //                           };
    //查询城市列表
    [[RequestManager shareRequestManager] GetMyCityInfo:nil viewController:self successData:^(NSDictionary *result) {
        NSLog(@"result ------  %@",result);
        cityListDic = [NSDictionary dictionaryWithDictionary:result];
        cityArray =  [result objectForKey:@"cityList"] ;
        [self hideHud];
        [self initTableView];
        
    } failuer:^(NSError *error) {
        
    }];
    
    
    
    
}



-(void)initTableView
{
    MytableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight, self.view.frame.size.width, self.view.frame.size.height-kNavHeight) style:UITableViewStyleGrouped];
    MytableView.delegate = self;
    MytableView.dataSource = self;
    MytableView.rowHeight = 35;
    MytableView.showsVerticalScrollIndicator = NO; //不显示竖向滚动条
    MytableView.sectionIndexColor = BlackUIColorC5;
    MytableView.sectionIndexBackgroundColor = [UIColor whiteColor];
    
    sectionIndexTitlesArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self.view addSubview:MytableView];
    
    
    for (NSDictionary * dic in cityArray) {
        NSString * s =@"";
        if ([dic objectForKey:@"cityName"]) {
           s = [self firstCharactor:[dic objectForKey:@"cityName"]];
        }
        if ([s isEqualToString:@"A"]) {
            [Aarray addObject:dic];
        }
        else if([s isEqualToString:@"B"]) {
            [Barray addObject:dic];
        }
        else if([s isEqualToString:@"C"]) {
            [Carray addObject:dic];
        }
        else if([s isEqualToString:@"D"]) {
            [Darray addObject:dic];
        }
        else if([s isEqualToString:@"E"]) {
            [Earray addObject:dic];
        }
        else if([s isEqualToString:@"F"]) {
            [Farray addObject:dic];
        }
        else if([s isEqualToString:@"G"]) {
            [Garray addObject:dic];
        }
        else if([s isEqualToString:@"H"]) {
            [Harray addObject:dic];
        }
        else if([s isEqualToString:@"I"]) {
            [Iarray addObject:dic];
        }
        else if([s isEqualToString:@"J"]) {
            [Jarray addObject:dic];
        }
        else if([s isEqualToString:@"K"]) {
            [Karray addObject:dic];
        }
        else if([s isEqualToString:@"L"]) {
            [Larray addObject:dic];
        }
        else if([s isEqualToString:@"M"]) {
            [Marray addObject:dic];
        }
        else if([s isEqualToString:@"N"]) {
            [Narray addObject:dic];
        }
        else if([s isEqualToString:@"O"]) {
            [Oarray addObject:dic];
        }
        else if([s isEqualToString:@"P"]) {
            [Parray addObject:dic];
        }
        else if([s isEqualToString:@"Q"]) {
            [Qarray addObject:dic];
        }
        else if([s isEqualToString:@"R"]) {
            [Rarray addObject:dic];
        }
        else if([s isEqualToString:@"S"]) {
            [Sarray addObject:dic];
        }
        else if([s isEqualToString:@"T"]) {
            [Tarray addObject:dic];
        }
        else if([s isEqualToString:@"U"]) {
            [Uarray addObject:dic];
        }
        else if([s isEqualToString:@"V"]) {
            [Varray addObject:dic];
        }
        else if([s isEqualToString:@"W"]) {
            [Warray addObject:dic];
        }
        else if([s isEqualToString:@"X"]) {
            [Xarray addObject:dic];
        }
        else if([s isEqualToString:@"Y"]) {
            [Yarray addObject:dic];
        }
        else if([s isEqualToString:@"Z"]) {
            [Zarray addObject:dic];
        }
    }
    if (Aarray.count!=0) {
        [allArray addObject:Aarray];
        [sectionIndexTitlesArray addObject:[NSString stringWithFormat:@"%c",'A']];
    }
    if (Barray.count!=0) {
        [allArray addObject:Barray];
        [sectionIndexTitlesArray addObject:[NSString stringWithFormat:@"%c",'B']];
    }
    if (Carray.count!=0) {
        [allArray addObject:Carray];
        [sectionIndexTitlesArray addObject:[NSString stringWithFormat:@"%c",'C']];
    }
    if (Darray.count!=0) {
        [allArray addObject:Darray];
        [sectionIndexTitlesArray addObject:[NSString stringWithFormat:@"%c",'D']];
    }
    if (Earray.count!=0) {
        [allArray addObject:Earray];
        [sectionIndexTitlesArray addObject:[NSString stringWithFormat:@"%c",'E']];
    }
    if (Farray.count!=0) {
        [allArray addObject:Farray];
        [sectionIndexTitlesArray addObject:[NSString stringWithFormat:@"%c",'F']];
    }
    if (Garray.count!=0) {
        [allArray addObject:Garray];
        [sectionIndexTitlesArray addObject:[NSString stringWithFormat:@"%c",'G']];
    }
    if (Harray.count!=0) {
        [allArray addObject:Harray];
        [sectionIndexTitlesArray addObject:[NSString stringWithFormat:@"%c",'H']];
    }
    if (Iarray.count!=0) {
        [allArray addObject:Iarray];
        [sectionIndexTitlesArray addObject:[NSString stringWithFormat:@"%c",'I']];
    }
    if (Jarray.count!=0) {
        [allArray addObject:Jarray];
        [sectionIndexTitlesArray addObject:[NSString stringWithFormat:@"%c",'J']];
    }
    if (Karray.count!=0) {
        [allArray addObject:Karray];
        [sectionIndexTitlesArray addObject:[NSString stringWithFormat:@"%c",'K']];
    }
    if (Larray.count!=0) {
        [allArray addObject:Larray];
        [sectionIndexTitlesArray addObject:[NSString stringWithFormat:@"%c",'L']];
    }
    if (Marray.count!=0) {
        [allArray addObject:Marray];
        [sectionIndexTitlesArray addObject:[NSString stringWithFormat:@"%c",'M']];
    }
    if (Narray.count!=0) {
        [allArray addObject:Narray];
        [sectionIndexTitlesArray addObject:[NSString stringWithFormat:@"%c",'N']];
    }
    if (Oarray.count!=0) {
        [allArray addObject:Oarray];
        [sectionIndexTitlesArray addObject:[NSString stringWithFormat:@"%c",'O']];
    }
    if (Parray.count!=0) {
        [allArray addObject:Parray];
        [sectionIndexTitlesArray addObject:[NSString stringWithFormat:@"%c",'P']];
    }
    if (Qarray.count!=0) {
        [allArray addObject:Qarray];
        [sectionIndexTitlesArray addObject:[NSString stringWithFormat:@"%c",'Q']];
    }
    if (Rarray.count!=0) {
        [allArray addObject:Rarray];
        [sectionIndexTitlesArray addObject:[NSString stringWithFormat:@"%c",'R']];
    }
    if (Sarray.count!=0) {
        [allArray addObject:Sarray];
        [sectionIndexTitlesArray addObject:[NSString stringWithFormat:@"%c",'S']];
    }
    if (Tarray.count!=0) {
        [allArray addObject:Tarray];
        [sectionIndexTitlesArray addObject:[NSString stringWithFormat:@"%c",'T']];
    }
    if (Uarray.count!=0) {
        [allArray addObject:Uarray];
        [sectionIndexTitlesArray addObject:[NSString stringWithFormat:@"%c",'U']];
    }
    if (Varray.count!=0) {
        [allArray addObject:Varray];
        [sectionIndexTitlesArray addObject:[NSString stringWithFormat:@"%c",'V']];
    }
    if (Warray.count!=0) {
        [allArray addObject:Warray];
        [sectionIndexTitlesArray addObject:[NSString stringWithFormat:@"%c",'W']];
    }
    if (Xarray.count!=0) {
        [allArray addObject:Xarray];
        [sectionIndexTitlesArray addObject:[NSString stringWithFormat:@"%c",'X']];
    }
    if (Yarray.count!=0) {
        [allArray addObject:Yarray];
        [sectionIndexTitlesArray addObject:[NSString stringWithFormat:@"%c",'Y']];
    }
    if (Zarray.count!=0) {
        [allArray addObject:Zarray];
        [sectionIndexTitlesArray addObject:[NSString stringWithFormat:@"%c",'Z']];
    }
    
}

//获取拼音首字母(传入汉字字符串, 返回大写拼音首字母)
- (NSString *)firstCharactor:(NSString *)aString
{
    NSLog(@"aString %@",aString);
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    NSString *pinYin = [str capitalizedString];
    //获取并返回首字母
    return [pinYin substringToIndex:1];
}


#pragma mark UITableViewDelegate UITableViewDataSource
//返回索引数组
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return sectionIndexTitlesArray;
}
//响应点击索引时的委托方法
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSInteger count = 0;
    
    NSLog(@"%@-%ld",title,(long)index);
    
    for(NSString *character in sectionIndexTitlesArray)
    {
        if([character isEqualToString:title])
        {
            return count;
        }
        count ++;
    }
    return 0;
    
}
//返回每个索引的内容
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [sectionIndexTitlesArray objectAtIndex:section];
}
//设置Header高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0;
}
//设置Footer高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
//返回Sections number
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [sectionIndexTitlesArray count];
}
//返回Rows number
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[allArray objectAtIndex:section] count];
}
//选中cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSLog(@"点击了第%ld行",(long)indexPath.section);
    NSString * cityCode =  [[[allArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"cityCode"];
    NSString * cityName =  [[[allArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"cityName"];
    NSString * openStatus =  [[[allArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"openStatus"];
    NSLog(@"cityCode -- %@",cityCode);
    NSLog(@"cityName -- %@",cityName);
    NSLog(@"openStatus -- %@",openStatus);
    //    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    //    [userDefaults setObject:cityCode forKey:@"cityCode"];
    //    [userDefaults setObject:cityName forKey:@"cityName"];
    //    [userDefaults setObject:openStatus forKey:@"openStatus"];
    //    [userDefaults synchronize];
    
    selectCitydic = [NSDictionary dictionaryWithDictionary: [[allArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] ];
    //
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"chooseCity" object:dic];
    //
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"test" object:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
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
    //    CGFloat xPos = 5;
    //    UIView *view = [[UIView alloc] initWithFrame:CGrect(xPos - SINGLE_LINE_ADJUST_OFFSET, 0, SINGLE_LINE_WIDTH, 100)];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20, 35)];
    label.text = [[[allArray objectAtIndex:indexPath.section ] objectAtIndex:indexPath.row] objectForKey:@"cityName"];
    [cell addSubview:label];
    
    return cell;
}

-(void)returnCityInfo:(ReturnChangeCityInfoBlock)block
{
    self.returnChangeCityInfoBlock = block;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    if (self.returnChangeCityInfoBlock != nil) {
        self.returnChangeCityInfoBlock(selectCitydic);
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

