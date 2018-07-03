//
//  FoodListTableViewCell.m
//  MXrestaurant
//
//  Created by lishouping on 2017/11/18.
//  Copyright © 2017年 lishouping. All rights reserved.
//

#import "FoodListTableViewCell.h"

@implementation FoodListTableViewCell
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
    
    self.labFoodName = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, kWidth/3, 30)];
    self.labFoodName.textColor = [UIColor blackColor];
    [self.labFoodName setFont:[UIFont systemFontOfSize:12]];
    [view addSubview:self.labFoodName];
    
    
    self.labFoodPrice = [[UILabel alloc] initWithFrame:CGRectMake(kWidth/3+10, 5, 50, 30)];
    self.labFoodPrice.textColor = [UIColor colorWithRed:255.0/255.0 green:62.0/255.0 blue:65.0/255.0 alpha:1];
    [self.labFoodPrice setFont:[UIFont systemFontOfSize:12]];
    [view addSubview:self.labFoodPrice];
    
    
    self.btnAddFood = [[UIButton alloc] initWithFrame:CGRectMake(kWidth/3+20+(kWidth/3/2), 8, 25, 25)];
    [self.btnAddFood setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
    [view addSubview:self.btnAddFood];
    
    self.btnExtSelect = [[UIButton alloc] initWithFrame:CGRectMake(kWidth/3+5+(kWidth/3/2)-10, 8, 50, 25)];
    [self.btnExtSelect setTitle:@"选规格" forState:UIControlStateNormal];
    [self.btnExtSelect setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnExtSelect setBackgroundColor:[UIColor colorWithRed:251.0/255.0 green:139.0/255.0 blue:57.0/255.0 alpha:1]];
    self.btnExtSelect.layer.cornerRadius = 5.0;
    self.btnExtSelect.font = [UIFont systemFontOfSize:12];
    [view addSubview:self.btnExtSelect];
    self.btnExtSelect.hidden = YES;
    

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
