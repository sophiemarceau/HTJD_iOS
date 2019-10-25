//
//  UserModel.m
//  YouYiLian
//
//  Created by DevNiudun on 15/3/25.
//  Copyright (c) 2015年 niudun. All rights reserved.
//

#import "UserModel.h"

/*
 Data =     {
    UserInfo =         {
            Age = "<null>";
            AreaID = 0;
            Brithday = "2012-1-2";
            CreateTime = 1426841644000;
            CreditPoint = "<null>";
            Gender = 1;
            JobID = 0;
            MyCoin = 0;
            NickName = xx;
            PhoneNumber = 18511777810;
            SalaryID = 8000000;
            UID = 3;
            UserLevel = "<null>";
            UserPass = 2565924li;
            UserPic = nil;
            hxPass = 1234456;
            hxUser = mgjtfhyfutzd361;
            signtext = "\U00e4\U00b8\U00aa\U00e6\U0080\U00a7\U00e7\U00ad\U00be\U00e5\U0090\U008d";
    };
    token = "MywxODUxMTc3NzgxMCxtZ2p0Zmh5ZnV0emQzNjEsMjAxNS0wNC0wMiAxMTozOTo0Nw==";
 }; */



@implementation UserModel

+ (BOOL)saveUserConfigInfo:(NSDictionary *)infoValue withKey:(NSString *)token
{
    if (!infoValue) {
        return NO;
    }
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"Data"];
    [userDefaults synchronize];
    
    NSMutableDictionary * userConfigInfo = [[NSMutableDictionary alloc]init];
    [userConfigInfo setObject:infoValue forKey:@"UserInfo"];
    [userConfigInfo setObject:token forKey:@"token"];
    
    NSData * infoData = [NSKeyedArchiver archivedDataWithRootObject:userConfigInfo];
    [userDefaults setObject:infoData forKey:@"Data"];
    [userDefaults synchronize];
    return YES;
}


+ (UserModel *)getUserConfigInfowithKey
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSData * infoData = [userDefaults objectForKey:@"Data"];
    NSDictionary * value = [NSKeyedUnarchiver unarchiveObjectWithData:infoData];
    if (value != nil) {
        if (noIsKindOfNusll(value, @"token") && noIsKindOfNusll(value, @"UserInfo")) {
            NSString *token = [value objectForKey:@"token"];
            [RequestManager shareRequestManager].token = token;
            
            NSDictionary *userInfo = [value objectForKey:@"UserInfo"];
            [RequestManager shareRequestManager].userModel = [[UserModel alloc]initWithDataDic:userInfo];
            UserModel *user = [[UserModel alloc]initWithDataDic:userInfo];
            return user;
        }
    }
    return nil;
}

+ (NSDictionary *)getUseInfoDic
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSData * infoData = [userDefaults objectForKey:@"Data"];
    NSDictionary * value = [NSKeyedUnarchiver unarchiveObjectWithData:infoData];
    if (value != nil) {
        if (noIsKindOfNusll(value, @"token") && noIsKindOfNusll(value, @"UserInfo")) {
            NSDictionary *userInfo = [value objectForKey:@"UserInfo"];
            return userInfo;
        }
    }
    return nil;
}



//删除数据
+ (void)deletUserInfo
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"Data"];
    [userDefaults synchronize];
    
    [RequestManager shareRequestManager].token = nil;
    [RequestManager shareRequestManager].userModel = nil;
}




@end
