//
//  UILabel+StringFrame.m
//  YouYiLian
//
//  Created by DevNiudun on 15/5/13.
//  Copyright (c) 2015年 niudun. All rights reserved.
//


#import "UILabel+StringFrame.h"

@implementation UILabel (StringFrame)

- (CGSize)boundingRectWithSize:(CGSize)size
{
    NSDictionary *attribute = @{NSFontAttributeName: self.font};
    
    CGSize retSize = [self.text boundingRectWithSize:size
                                             options:NSStringDrawingTruncatesLastVisibleLine |
                                                     NSStringDrawingUsesLineFragmentOrigin |
                                                     NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil].size;
    
    return retSize;
}


@end

