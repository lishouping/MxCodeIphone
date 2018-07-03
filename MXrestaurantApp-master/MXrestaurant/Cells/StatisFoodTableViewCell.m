//
//  StatisFoodTableViewCell.m
//  MXrestaurant
//
//  Created by lishouping on 2017/11/12.
//  Copyright © 2017年 lishouping. All rights reserved.
//

#import "StatisFoodTableViewCell.h"

@implementation StatisFoodTableViewCell
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
    self.vieNum = [[UIView alloc] initWithFrame:CGRectMake(10, 5, 30, 30)];
    [self.vieNum setBackgroundColor:[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1]];
    self.vieNum.layer.cornerRadius = 15;
    [self.contentView addSubview:self.vieNum];
    
    self.labNum = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [self.labNum setTextColor:[UIColor whiteColor]];
    [self.labNum setFont:[UIFont systemFontOfSize:12]];
    self.labNum.textAlignment = UITextAlignmentCenter;
    [self.vieNum addSubview:self.labNum];
    
    self.labFoodName = [[UILabel alloc] initWithFrame:CGRectMake(10+20+10+5, 5, kWidth/2-20, 30)];
    [self.labFoodName setFont:[UIFont systemFontOfSize:12]];
    [self.contentView addSubview:self.labFoodName];
    
    self.labStatisNum = [[UILabel alloc] initWithFrame:CGRectMake(kWidth/2-50, 5, kWidth/2/2, 30)];
    [self.labStatisNum setFont:[UIFont systemFontOfSize:12]];
    self.labStatisNum.textAlignment = UITextAlignmentCenter;
    [self.contentView addSubview:self.labStatisNum];
    
    self.labTotalPrice = [[UILabel alloc] initWithFrame:CGRectMake(kWidth-10-100, 5, 100, 30)];
    [self.labTotalPrice setFont:[UIFont systemFontOfSize:12]];
    self.labTotalPrice.textColor = [UIColor colorWithRed:221.0/255.0 green:107.0/255.0 blue:85.0/255.0 alpha:1];
    [self.contentView addSubview:self.labTotalPrice];
    
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
