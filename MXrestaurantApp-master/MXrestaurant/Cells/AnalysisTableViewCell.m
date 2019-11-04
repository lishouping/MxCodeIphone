//
//  AnalysisTableViewCell.m
//  MXrestaurant
//
//  Created by MX on 2019/10/22.
//  Copyright © 2019年 lishouping. All rights reserved.
//

#import "AnalysisTableViewCell.h"

@implementation AnalysisTableViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.tableInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, (kWidth-20-20)/3, 120)];
        [self.tableInfoView.layer setCornerRadius:5];
        self.tableInfoView.layer.borderWidth = 0.5;
        self.tableInfoView.layer.masksToBounds = YES;
        [self addSubview:self.tableInfoView];
        // 阴影颜色
        self.tableInfoView.layer.shadowColor = [UIColor grayColor].CGColor;
        // 阴影偏移，默认(0, -3)
        self.tableInfoView.layer.shadowOffset = CGSizeMake(0,0);
        // 阴影透明度，默认0
        self.tableInfoView.layer.shadowOpacity = 0.5;
        // 阴影半径，默认3
        self.tableInfoView.layer.shadowRadius = 5;
        self.imgeIcon = [[UIImageView alloc] initWithFrame:CGRectMake((kWidth-20-20)/3/2-15, 30, 30, 30)];
        [self.tableInfoView addSubview:self.imgeIcon];
        
        
        self.tabState = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, (kWidth-20-20)/3, 20)];
        self.tabState.textColor = [UIColor blackColor];
        self.tabState.textAlignment = NSTextAlignmentCenter;
        self.tabState.font = [UIFont systemFontOfSize:12];
        [self.tableInfoView addSubview:self.tabState];
        
        
    }
    return self;
}
@end
