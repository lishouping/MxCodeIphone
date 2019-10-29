//
//  OrderDealWithTableViewCell.m
//  MXrestaurant
//
//  Created by lishouping on 2017/11/20.
//  Copyright © 2017年 lishouping. All rights reserved.
//

#import "OrderDealWithTableViewCell.h"

@implementation OrderDealWithTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self makUI];
        
    }
    return self;
}
- (void)makUI{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 120)];
    headView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:headView];
    
    self.labServiceNumber = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, kWidth-10-10, 20)];
    self.labServiceNumber.font = [UIFont systemFontOfSize:12];
    [headView addSubview:self.labServiceNumber];
    
    self.labTableName = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 150, 20)];
    self.labTableName.font = [UIFont systemFontOfSize:12];
    [headView addSubview:self.labTableName];
    
    self.labEatchNumber = [[UILabel alloc] initWithFrame:CGRectMake(10+150+10, 30, 150, 20)];
    self.labEatchNumber.font = [UIFont systemFontOfSize:12];
    [headView addSubview:self.labEatchNumber];
    
    self.labOrderTime = [[UILabel alloc] initWithFrame:CGRectMake(10, 55, kWidth-10-10, 20)];
    self.labOrderTime.font = [UIFont systemFontOfSize:12];
    [headView addSubview:self.labOrderTime];
    
    self.btnSubOrder = [[UIButton alloc] initWithFrame:CGRectMake(kWidth-10-((kWidth-10-10-40)/2), 80, (kWidth-10-10-40)/2, 30)];
    [self.btnSubOrder setTitle:@"一键下单" forState:UIControlStateNormal];
    [self.btnSubOrder setFont:[UIFont systemFontOfSize:12]];
    [self.btnSubOrder setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnSubOrder setBackgroundColor:[UIColor colorWithRed:251.0/255.0 green:139.0/255.0 blue:57.0/255.0 alpha:1]];
    self.btnSubOrder.layer.cornerRadius = 5.0;
    [headView addSubview:self.btnSubOrder];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
