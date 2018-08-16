//
//  TableAreaTableViewCell.m
//  MXrestaurant
//
//  Created by MX on 2018/8/16.
//  Copyright © 2018年 lishouping. All rights reserved.
//

#import "TableAreaTableViewCell.h"

@implementation TableAreaTableViewCell
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
    
    self.labAreaName = [[UILabel alloc] initWithFrame:CGRectMake(10+20+10+5, 5, kWidth/2-20, 30)];
    [self.labAreaName setFont:[UIFont systemFontOfSize:12]];
    [self.contentView addSubview:self.labAreaName];
    
    self.labCreateTime = [[UILabel alloc] initWithFrame:CGRectMake(kWidth/2, 5, kWidth/2, 30)];
    [self.labCreateTime setFont:[UIFont systemFontOfSize:12]];
    self.labCreateTime.textAlignment = UITextAlignmentCenter;
    [self.contentView addSubview:self.labCreateTime];

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
