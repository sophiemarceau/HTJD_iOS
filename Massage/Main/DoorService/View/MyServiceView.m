//
//  MyServiceView.m
//  Massage
//
//  Created by htjd_IOS on 15/12/8.
//  Copyright © 2015年 sophiemarceau_qu. All rights reserved.
//

#import "MyServiceView.h"
#import "UIImageView+WebCache.h"

@implementation MyServiceView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initView];
    }
    return self;
}


-(void)_initView{
    
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor redColor];
    [self addSubview:self.contentView];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth/2-15, 108.75f*AUTO_SIZE_SCALE_X)];
    [self.contentView addSubview:self.imageView ];
    
    self.titleLabel = [[UILabel  alloc] init];
    self.titleLabel.backgroundColor =[UIColor clearColor];
    self.titleLabel.textColor = BlackUIColorC5;
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.titleLabel ];
    
    self.AddressLabel = [[UILabel alloc] init];
    self.AddressLabel.textColor = C6UIColorGray;
    self.AddressLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.AddressLabel];
    
    self.PriceLabel = [[UILabel alloc] init];
    self.PriceLabel.textColor = RedUIColorC3;
    //    self.PriceLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.PriceLabel];
    
    self.remarkPriceLabel = [[UILabel alloc] init];
    self.remarkPriceLabel.textColor = UIColorFromRGB(0x9c9c9c);
    self.remarkPriceLabel.font = [UIFont systemFontOfSize:9];
    [self.contentView addSubview:self.remarkPriceLabel];
    
    self.markLabel = [[UILabel alloc] init];
    self.markLabel.textColor = C6UIColorGray;
    self.markLabel.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:self.markLabel];

}


-(void)layoutSubviews{
    
    [super layoutSubviews];
    
//    [self.contentView addSubview:self.imageView];
//    [self.contentView addSubview:self.titleLabel];
////    [self.contentView addSubview:self.AddressLabel];
//    [self.contentView addSubview:self.Price1Label];
//    [self.contentView addSubview:self.PriceLabel];
//    [self.contentView addSubview:self.Price2Label];
//    [self.contentView addSubview:self.markStrLabel];
//    [self.contentView addSubview:self.markLabel];
//    [self addSubview:self.contentView];
//    
////    UIFont *font = [UIFont fontWithName:@"Arial" size:15];
////    CGSize size = CGSizeMake(320,2000);
//    
//    
//    CGSize  size1 = [self.Price1Label intrinsicContentSize];
//    self.Price1Label.frame = CGRectMake(10, self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height+12.0f*AUTO_SIZE_SCALE_X, size1.width, 12.0f*AUTO_SIZE_SCALE_X);
//
//    
//    NSString * moneyStr = @"";
//    int monetInt = [[self.dataDic objectForKey:@"minPrice"] intValue];
//    if (monetInt%100 == 0) {
//        monetInt = monetInt/100;
//        moneyStr = [NSString stringWithFormat:@"%d",monetInt];
//    }else{
//        float money = [[self.dataDic objectForKey:@"minPrice"] floatValue];
//        money = money/100.0;
//        moneyStr = [NSString stringWithFormat:@"%0.2f",money];
//    }
//    self.PriceLabel.text =moneyStr;
//    CGSize labelsize = [self.PriceLabel intrinsicContentSize];
//    self.PriceLabel.frame = CGRectMake(self.Price1Label.origin.x+self.Price1Label.frame.size.width, self.Price1Label.frame.origin.y-3*AUTO_SIZE_SCALE_X, labelsize.width, 15.0f*AUTO_SIZE_SCALE_X);
//    
//    CGSize  size2 = [self.Price2Label intrinsicContentSize];
//    self.Price2Label.frame = CGRectMake(self.PriceLabel.frame.origin.x+self.PriceLabel.frame.size.width, self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height+12.0f*AUTO_SIZE_SCALE_X, size2.width, 12.0f*AUTO_SIZE_SCALE_X);
//    
//
//
//    
//    NSString *markStr =[NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"score"]];
//    self.markLabel.text =markStr;
//    CGSize marksize = [self.markLabel intrinsicContentSize];
//    self.markLabel.frame = CGRectMake(self.markStrLabel.frame.origin.x-marksize.width-3.0f, self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height+12.0f*AUTO_SIZE_SCALE_X,marksize.width, 12.0f*AUTO_SIZE_SCALE_X);
//    
//    if ( [[NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"icon"]] isEqualToString:@""]) {
//        [self.imageView  setImage:[UIImage imageNamed:@"项目列表小图"]];
//    }else{
//        [self.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"icon"]]] placeholderImage:[UIImage imageNamed:@"项目列表小图"]];
//    }
//    
//    NSString * remarkPrice = @"";
//    
//    int temonetInt = [[self.dataDic objectForKey:@"marketPrice"] intValue];
//    if (temonetInt%100 == 0) {
//        temonetInt = temonetInt/100;
//        remarkPrice = [NSString stringWithFormat:@"%d",temonetInt];
//    }else{
//        float temoney = [[self.dataDic objectForKey:@"marketPrice"] floatValue];
//        temoney = temoney/100.0;
//        remarkPrice = [NSString stringWithFormat:@"%0.2f",temoney];
//    }
//    NSMutableAttributedString * attTemoneyStr  = [[NSMutableAttributedString alloc] initWithString:remarkPrice];
//    [attTemoneyStr addAttribute:NSFontAttributeName
//                          value:[UIFont systemFontOfSize:11 ]
//                          range:NSMakeRange(0, 0)];
//    [attTemoneyStr addAttribute:NSFontAttributeName
//                          value:[UIFont boldSystemFontOfSize:10 ]
//                          range:NSMakeRange( 0,remarkPrice.length-0)];
//    [attTemoneyStr addAttribute:NSForegroundColorAttributeName
//                          value:C6UIColorGray
//                          range:NSMakeRange(0, remarkPrice.length)];
//    [attTemoneyStr addAttribute:NSStrikethroughStyleAttributeName
//                          value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]
//                          range:NSMakeRange( 0, remarkPrice.length-0)];
//    self.remarkPriceLabel = [[UILabel alloc] init];
//    self.remarkPriceLabel.attributedText = attTemoneyStr;
//    CGSize remarkPriceLabelSize = [self.remarkPriceLabel intrinsicContentSize];
//    self.remarkPriceLabel.frame = CGRectMake(self.Price2Label.frame.origin.x+self.Price2Label.frame.size.width+10, self.PriceLabel.frame.origin.y, remarkPriceLabelSize.width+2, 15.0f*AUTO_SIZE_SCALE_X);
//    [self.contentView addSubview:self.remarkPriceLabel];
    
    //当前view
    if ([self.lie isEqualToString:@"0"]) {
        _contentView.frame =  CGRectMake(10, 10, kScreenWidth/2-15, (108.75f+88.0f)*AUTO_SIZE_SCALE_X-20) ;
    }
    else if ([self.lie isEqualToString:@"1"])
    {
        _contentView.frame =  CGRectMake(5, 10, kScreenWidth/2-15, (108.75f+88.0f)*AUTO_SIZE_SCALE_X-20) ;
    }
    _contentView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taped:)];
    [self.contentView addGestureRecognizer:tap];
    
    //图片
    if ( [[NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"icon"]] isEqualToString:@""]) {
        [self.imageView  setImage:[UIImage imageNamed:@"项目列表小图"]];
    }else{
        [self.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"icon"]]] placeholderImage:[UIImage imageNamed:@"项目列表小图"]];
    }
    
    //项目名称
    self.titleLabel.text = [NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"name"]];
    self.titleLabel.frame = CGRectMake(10, self.imageView.frame.origin.y+self.imageView.frame.size.height+12*AUTO_SIZE_SCALE_X, kScreenWidth/2-15-10.0, 14.0f*AUTO_SIZE_SCALE_X);
    
    //地址
//    if ([self.dataDic objectForKey:@"storeName"]!=NULL &&[self.dataDic objectForKey:@"storeName"]!=nil && ![[self.dataDic objectForKey:@"storeName"] isEqualToString:@""]){
//        self.AddressLabel.text = [NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"storeName"]];
//    }
//    else{
//        self.AddressLabel.text = [NSString stringWithFormat:@"%@",@"华佗驾到自营"];
//    }
    self.AddressLabel.frame = CGRectMake(10, self.titleLabel.frame.size.height+self.titleLabel.frame.origin.y, kScreenWidth/2-15-10.0f, 0);
    
    //价格
    NSString * moneyStr = @"";
    int monetInt = [[self.dataDic objectForKey:@"minPrice"] intValue];
    if (monetInt%100 == 0) {
        monetInt = monetInt/100;
        moneyStr = [NSString stringWithFormat:@"¥ %d",monetInt];
    }else{
        float money = [[self.dataDic objectForKey:@"minPrice"] floatValue];
        money = money/100.0;
        moneyStr = [NSString stringWithFormat:@"¥ %0.2f",money];
    }
    NSMutableAttributedString * attmoneyStrStr;
    if ([[ NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"isLevel"] ] isEqualToString:@"0"]){
        attmoneyStrStr = [[NSMutableAttributedString alloc] initWithString:moneyStr];
        [attmoneyStrStr addAttribute:NSFontAttributeName
                               value:[UIFont systemFontOfSize:9 ]
                               range:NSMakeRange(0, 1)];
        [attmoneyStrStr addAttribute:NSFontAttributeName
                               value:[UIFont boldSystemFontOfSize:12 ]
                               range:NSMakeRange( 1,moneyStr.length-1)];
        //        [attmoneyStrStr addAttribute:NSFontAttributeName
        //                               value:[UIFont systemFontOfSize:9 ]
        //                               range:NSMakeRange(moneyStr.length-1, 1)];
        [attmoneyStrStr addAttribute:NSForegroundColorAttributeName
                               value:RedUIColorC3
                               range:NSMakeRange(0, moneyStr.length)];
        
    }else{
        moneyStr = [NSString stringWithFormat:@"%@ 起",moneyStr];
        attmoneyStrStr = [[NSMutableAttributedString alloc] initWithString:moneyStr];
        [attmoneyStrStr addAttribute:NSFontAttributeName
                               value:[UIFont systemFontOfSize:9 ]
                               range:NSMakeRange(0, 1)];
        [attmoneyStrStr addAttribute:NSFontAttributeName
                               value:[UIFont boldSystemFontOfSize:12 ]
                               range:NSMakeRange( 1,moneyStr.length-1)];
        [attmoneyStrStr addAttribute:NSFontAttributeName
                               value:[UIFont systemFontOfSize:9 ]
                               range:NSMakeRange(moneyStr.length-1, 1)];
        [attmoneyStrStr addAttribute:NSForegroundColorAttributeName
                               value:RedUIColorC3
                               range:NSMakeRange(0, moneyStr.length)];
        
    }
    self.PriceLabel.attributedText = attmoneyStrStr;
    CGSize priceLabelSize = [self.PriceLabel intrinsicContentSize];
    self.PriceLabel.frame = CGRectMake(10, self.AddressLabel.frame.size.height+self.AddressLabel.frame.origin.y+12*AUTO_SIZE_SCALE_X, priceLabelSize.width, 12*AUTO_SIZE_SCALE_X);
    
    //    [attmoneyStrStr addAttribute:NSStrikethroughStyleAttributeName
    //                          value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]
    //                          range:NSMakeRange( 0, moneyStr.length-0)];
    
    //市场价
    NSString * remarkPrice = @"";
    int temonetInt = [[self.dataDic objectForKey:@"marketPrice"] intValue];
    if (temonetInt%100 == 0) {
        temonetInt = temonetInt/100;
        remarkPrice = [NSString stringWithFormat:@"%d ",temonetInt];
    }else{
        float temoney = [[self.dataDic objectForKey:@"marketPrice"] floatValue];
        temoney = temoney/100.0;
        remarkPrice = [NSString stringWithFormat:@"%0.2f ",temoney];
    }
    NSMutableAttributedString * attTemoneyStr  = [[NSMutableAttributedString alloc] initWithString:remarkPrice];
    [attTemoneyStr addAttribute:NSFontAttributeName
                          value:[UIFont boldSystemFontOfSize:9]
                          range:NSMakeRange( 0,remarkPrice.length)];
    [attTemoneyStr addAttribute:NSForegroundColorAttributeName
                          value:C6UIColorGray
                          range:NSMakeRange(0, remarkPrice.length)];
    [attTemoneyStr addAttribute:NSStrikethroughStyleAttributeName
                          value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]
                          range:NSMakeRange( 0, remarkPrice.length)];
    self.remarkPriceLabel.attributedText = attTemoneyStr;
    CGSize remarkPriceLabelSize = [self.remarkPriceLabel intrinsicContentSize];
    self.remarkPriceLabel.frame = CGRectMake(self.PriceLabel.frame.origin.x+self.PriceLabel.frame.size.width+6, self.PriceLabel.frame.origin.y+self.PriceLabel.frame.size.height-9.5*AUTO_SIZE_SCALE_X, remarkPriceLabelSize.width, 9*AUTO_SIZE_SCALE_X);
    
    //分数
    self.markLabel.text = [NSString stringWithFormat:@"%@ 分",[self.dataDic objectForKey:@"score"]];
    CGSize scoreSize = [self.markLabel intrinsicContentSize];
    self.markLabel.frame = CGRectMake(self.contentView.frame.size.width-scoreSize.width-10, self.PriceLabel.frame.origin.y+self.PriceLabel.frame.size.height-10.5*AUTO_SIZE_SCALE_X, scoreSize.width, 10*AUTO_SIZE_SCALE_X);

}
-(void)taped:(UITapGestureRecognizer *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gotoServiceDetailController" object:self.dataDic];
}

//-(UIViewController *)viewController
//{
//    UIResponder *next = self.nextResponder;
//    do {
//        if ([next isKindOfClass:[UIViewController class]]) {
//            return (UIViewController *)next;
//        }
//        next = next.nextResponder;
//    } while (next != nil);
//    return nil;
//}
//
//-(UIView *)contentView{
//    if(!_contentView){
////        _contentView = [[UIView alloc] initWithFrame:CGRectMake(5, 10, kScreenWidth/2-10, (108.75f+88.0f-20*AUTO_SIZE_SCALE_X)*AUTO_SIZE_SCALE_X)];
//        
//        if ([self.lie isEqualToString:@"0"]) {
//            _contentView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth/2-15, (108.75f+88.0f)*AUTO_SIZE_SCALE_X-20)];
//        }
//        else if ([self.lie isEqualToString:@"1"])
//        {
//            _contentView = [[UIView alloc] initWithFrame:CGRectMake(5, 10, kScreenWidth/2-15, (108.75f+88.0f)*AUTO_SIZE_SCALE_X-20)];
//        }
//
//        _contentView.backgroundColor = [UIColor whiteColor];
//        
//        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taped:)];
//        [self.contentView addGestureRecognizer:tap];
//    }
//    return _contentView;
//}
//
//-(UIImageView *)imageView{
//    if (!_imageView) {
//        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth/2-15, 108.75f*AUTO_SIZE_SCALE_X)];
//        _imageView.backgroundColor = [UIColor yellowColor];
//        
//    }
//    return _imageView;
//}
//
//-(UILabel *)titleLabel{
//    if (!_titleLabel) {
//        _titleLabel = [CommentMethod createLabelWithFont:14 Text:[NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"name"]]];
//        
//        self.titleLabel.frame = CGRectMake(10, self.imageView.frame.origin.y+self.imageView.frame.size.height+12*AUTO_SIZE_SCALE_X, kScreenWidth/2-15-10.0f, 14.0f*AUTO_SIZE_SCALE_X)
//        ;
//        _titleLabel.backgroundColor =[UIColor clearColor];
//        
//        _titleLabel.textColor = BlackUIColorC5;
//    }
//    return _titleLabel;
//}
//
//-(UILabel *)Price1Label{
//    if (!_Price1Label) {
////        _Price1Label = [CommentMethod createLabelWithFont:11 Text:@"¥"];
//        _Price1Label = [[UILabel alloc] init];;
//        _Price1Label.text = @"¥";
//        _Price1Label.textColor = RedUIColorC3;
//        _Price1Label.font = [UIFont systemFontOfSize:11];
//        
//    }
//    return _Price1Label;
//}
//
//-(UILabel *)PriceLabel{
//    if (!_PriceLabel) {
////        _PriceLabel = [CommentMethod createLabelWithFont:15 Text:@""];
////        _PriceLabel.font=[UIFont boldSystemFontOfSize:15];
//        _PriceLabel = [[UILabel alloc] init];;
//        _PriceLabel.font = [UIFont boldSystemFontOfSize:15];
//        _PriceLabel.textColor = RedUIColorC3;
//        
//        [_PriceLabel setNumberOfLines:0];
//        
//    }
//    return _PriceLabel;
//}
//
//-(UILabel *)Price2Label{
//    if (!_Price2Label) {
//        
////        _Price2Label = [CommentMethod createLabelWithFont:11 Text:@"起"];
//        _Price2Label = [[UILabel alloc] init];;
//        _Price2Label.font = [UIFont systemFontOfSize:11];
//        if ([[ NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"isLevel"] ] isEqualToString:@"0"]) {
//            _Price2Label.text = @"";
//        }else if ([[ NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"isLevel"] ] isEqualToString:@"1"])
//        {
//            _Price2Label.text = @"起";
//        }
//        
//
//        _Price2Label.textColor = RedUIColorC3;
//        
//        
//    }
//    return _Price2Label;
//}
//
//-(UILabel *)markStrLabel{
//    if (!_markStrLabel) {
//        _markStrLabel = [CommentMethod createLabelWithFont:11 Text:@"分"];
//        _markStrLabel.textColor = C6UIColorGray;
//        
//        _markStrLabel.frame = CGRectMake(self.contentView.frame.size.width-10-10.0f*AUTO_SIZE_SCALE_X, self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height+12.0f*AUTO_SIZE_SCALE_X, 10.0f*AUTO_SIZE_SCALE_X, 12.0f*AUTO_SIZE_SCALE_X);
//        
//        
//    }
//    return _markStrLabel;
//}
//
//-(UILabel *)markLabel{
//    if (!_markLabel) {
//        _markLabel = [CommentMethod createLabelWithFont:11 Text:@""];
//        _markLabel.textColor = C6UIColorGray;
//        
//        [_markLabel setNumberOfLines:0];
//    }
//    return _markLabel;
//}

-(void)setData:(NSString *)data{
    if (_data!=data) {
        _data =data;
    }
    [self setNeedsLayout];
}

-(void)setDataDic:(NSDictionary *)dataDic{
    if (_dataDic!=dataDic) {
        _dataDic =dataDic;
    }
    [self setNeedsLayout];
}

@end
