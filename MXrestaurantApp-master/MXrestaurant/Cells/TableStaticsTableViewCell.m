//
//  TableStaticsTableViewCell.m
//  MXrestaurant
//
//  Created by MX on 2019/10/24.
//  Copyright © 2019年 lishouping. All rights reserved.
//

#import "TableStaticsTableViewCell.h"

@implementation TableStaticsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self createView];
        
    }
    return self;
}
-(void)createView{
    self.footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 30)];
    [self.footView setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:self.footView];
    
    self.labFoodName = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, kWidth/4-20, 30)];
    [self.labFoodName setFont:[UIFont systemFontOfSize:12]];
    [self.footView addSubview:self.labFoodName];
    
    self.labOrderNumber = [[UILabel alloc] initWithFrame:CGRectMake(kWidth/4, 0, kWidth/4-20, 30)];
    self.labOrderNumber.textAlignment = UITextAlignmentCenter;
    [self.labOrderNumber setFont:[UIFont systemFontOfSize:12]];
    [self.footView addSubview:self.labOrderNumber];
    
    
    self.labStaNum = [[UILabel alloc] initWithFrame:CGRectMake((kWidth/4)*2-15, 0, kWidth/4, 30)];
    self.labStaNum.textAlignment = UITextAlignmentCenter;
    [self.labStaNum setFont:[UIFont systemFontOfSize:12]];
    [self.footView addSubview:self.labStaNum];
    
    
    self.labTotalPrice = [[UILabel alloc] initWithFrame:CGRectMake(kWidth-(kWidth/4), 0, kWidth/4, 30)];
    self.labTotalPrice.textColor = [UIColor colorWithRed:220.0/255.0 green:20.0/255.0 blue:60.0/255.0 alpha:1];
    self.labTotalPrice.textAlignment = UITextAlignmentCenter;
    [self.labTotalPrice setFont:[UIFont systemFontOfSize:12]];
    [self.footView addSubview:self.labTotalPrice];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
