//
//  clientCommentListViewController.h
//  Massage
//
//  Created by 屈小波 on 15/11/26.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "BaseViewController.h"

@interface clientCommentListViewController : BaseViewController
@property (nonatomic,strong) NSString *ID;//ID(门店，项目，技师 id  用type区分)
@property (nonatomic,strong) NSString *type;//类型 0 是门店，1是 项目，是技师
@end
