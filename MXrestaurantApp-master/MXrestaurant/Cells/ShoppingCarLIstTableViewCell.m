//
//  ShoppingCarLIstTableViewCell.m
//  MXrestaurant
//
//  Created by lishouping on 2017/11/18.
//  Copyright © 2017年 lishouping. All rights reserved.
//

#import "ShoppingCarLIstTableViewCell.h"

@implementation ShoppingCarLIstTableViewCell
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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 40)];
    [self.contentView addSubview:view];
    
    self.labFoodName = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, kWidth/2, 20)];
    self.labFoodName.textColor = [UIColor blackColor];
    [self.labFoodName setFont:[UIFont systemFontOfSize:12]];
    [view addSubview:self.labFoodName];
    
    
    self.labFoodPrice = [[UILabel alloc] initWithFrame:CGRectMake(kWidth/2-10, 10, kWidth/2/4, 20)];
    self.labFoodPrice.textColor = [UIColor colorWithRed:255.0/255.0 green:62.0/255.0 blue:65.0/255.0 alpha:1];
    [self.labFoodPrice setFont:[UIFont systemFontOfSize:12]];
    [view addSubview:self.labFoodPrice];
    
    
    self.btnFreeFood = [[UIButton alloc] initWithFrame:CGRectMake(kWidth/2+(kWidth/2/4)+5+15, 8, 25, 25)];
    [self.btnFreeFood setImage:[UIImage imageNamed:@"icon_sub"] forState:UIControlStateNormal];
    [view addSubview:self.btnFreeFood];
    
    
    self.labFoodNum = [[UILabel alloc] initWithFrame:CGRectMake(kWidth/2+(kWidth/2/4)+(kWidth/2/4), 10, kWidth/2/4, 20)];
    self.labFoodNum.textColor = [UIColor blackColor];
    self.labFoodNum.textAlignment = UITextAlignmentCenter;
    [view addSubview:self.labFoodNum];
    
    self.btnAddFood = [[UIButton alloc] initWithFrame:CGRectMake(kWidth/2+(kWidth/2/4)+(kWidth/2/4)+(kWidth/2/4), 8, 25, 25)];
    [self.btnAddFood setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
    [view addSubview:self.btnAddFood];
    
    
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
