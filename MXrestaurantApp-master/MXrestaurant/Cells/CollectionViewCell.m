//
//  CollectionViewCell.m
//  MarkSmallShop_AP
//
//  Created by Lishouping-macmini on 15/4/8.
//  Copyright (c) 2015年 lishp. All rights reserved.
//

#import "CollectionViewCell.h"


@implementation CollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
      
        self.tableInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, (kWidth-20-20*3)/4, 50)];
        [self.tableInfoView.layer setCornerRadius:5];
        self.tableInfoView.layer.borderWidth = 0.5;
         self.tableInfoView.layer.masksToBounds = YES;
        [self addSubview:self.tableInfoView];
        
        self.tableNum = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, (kWidth-20-20*3)/4-20, 20)];
        self.tableNum.textColor = [UIColor whiteColor];
        self.tableNum.font = [UIFont systemFontOfSize:12];
        [self.tableInfoView addSubview:self.tableNum];
        
        self.tabState = [[UILabel alloc]initWithFrame:CGRectMake(0, 20+10, (kWidth-20-20*3)/4, 20)];
        self.tabState.textColor = [UIColor whiteColor];
        self.tabState.textAlignment = NSTextAlignmentCenter;
        self.tabState.font = [UIFont systemFontOfSize:12];
        [self.tableInfoView addSubview:self.tabState];
        
        
    }
    return self;
}
@end
