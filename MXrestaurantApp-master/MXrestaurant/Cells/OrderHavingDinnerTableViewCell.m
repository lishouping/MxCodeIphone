//
//  OrderHavingDinnerTableViewCell.m
//  MXrestaurant
//
//  Created by lishouping on 2017/11/21.
//  Copyright © 2017年 lishouping. All rights reserved.
//

#import "OrderHavingDinnerTableViewCell.h"

@implementation OrderHavingDinnerTableViewCell
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
    
    self.labTableName = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, kWidth/3, 20)];
    self.labTableName.font = [UIFont systemFontOfSize:12];
    [headView addSubview:self.labTableName];
    
    self.labEatchNumber = [[UILabel alloc] initWithFrame:CGRectMake(kWidth/3, 30, kWidth/3, 20)];
    self.labEatchNumber.font = [UIFont systemFontOfSize:12];
    [headView addSubview:self.labEatchNumber];
    
    self.labWriter = [[UILabel alloc] initWithFrame:CGRectMake(kWidth/3*2, 30,kWidth/3, 20)];
    self.labWriter.font = [UIFont systemFontOfSize:12];
    [headView addSubview:self.labWriter];
    

    self.labOrderTime = [[UILabel alloc] initWithFrame:CGRectMake(10, 55, kWidth-10-10, 20)];
    self.labOrderTime.font = [UIFont systemFontOfSize:12];
    [headView addSubview:self.labOrderTime];
    
    self.btnAddFood = [[UIButton alloc] initWithFrame:CGRectMake(10, 80, (kWidth-10-10-40)/2, 30)];
    [self.btnAddFood setTitle:@"加菜" forState:UIControlStateNormal];
    [self.btnAddFood setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnAddFood setFont:[UIFont systemFontOfSize:12]];
    [self.btnAddFood setBackgroundColor:[UIColor colorWithRed:79.0/255.0 green:145.0/255.0 blue:244.0/255.0 alpha:1]];
    self.btnAddFood.layer.cornerRadius = 5.0;
    [headView addSubview:self.btnAddFood];
    
    
    self.btnSubOrder = [[UIButton alloc] initWithFrame:CGRectMake(kWidth-10-((kWidth-10-10-40)/2), 80, (kWidth-10-10-40)/2, 30)];
    [self.btnSubOrder setTitle:@"结账" forState:UIControlStateNormal];
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
