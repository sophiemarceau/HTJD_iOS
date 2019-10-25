//
//  StoreCommentViewController.h
//  Massage
//
//  Created by 牛先 on 15/11/19.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "BaseViewController.h"

@interface StoreCommentViewController : BaseViewController <UITextViewDelegate>
@property (strong, nonatomic) NSString *orderID;
@property (assign, nonatomic) BOOL isFromFlashDeal;
@end
