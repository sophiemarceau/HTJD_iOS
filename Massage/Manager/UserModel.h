//
//  UserModel.h
//  YouYiLian
//
//  Created by DevNiudun on 15/3/25.
//  Copyright (c) 2015年 niudun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
/*
 {
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
 */
/*
 {
 BuddyRequest = 1;
 }
 */

@interface UserModel : BaseModel

@property (nonatomic,copy)NSString *Age;
@property (nonatomic,strong) NSNumber *BuddyRequest;
@property (nonatomic,copy)NSString *AreaID;
@property (nonatomic,copy)NSString *Brithday;
@property (nonatomic,copy)NSString *CreateTime;
@property (nonatomic,copy)NSString *CreditPoint;
@property (nonatomic,copy)NSString *Gender;
@property (nonatomic,copy)NSString *JobID;
@property (nonatomic,copy)NSString *MyCoin;
@property (nonatomic,copy)NSString *NickName;
@property (nonatomic,copy)NSString *PhoneNumber;
@property (nonatomic,copy)NSString *SalaryID;
@property (nonatomic,strong)NSNumber *UID;
@property (nonatomic,copy)NSString *UserLevel;
@property (nonatomic,copy)NSString *UserPass;
@property (nonatomic,copy)NSString *UserPic;
@property (nonatomic,copy)NSString *hxPass;
@property (nonatomic,copy)NSString *hxUser;
@property (nonatomic,copy)NSString *signtext;


/*
  保存个人信息
 */
+ (BOOL)saveUserConfigInfo:(NSDictionary *)infoValue withKey:(NSString *)token;
/*
  得到用户信息
 */
+ (UserModel *)getUserConfigInfowithKey;

/*
  删除用户信息
 */
+ (void)deletUserInfo;

/*
  获取用户字典
 */
+ (NSDictionary *)getUseInfoDic;



@end
