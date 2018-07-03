//
//  ResTableViewCell.m
//  MXrestaurant
//
//  Created by lishouping on 2017/11/25.
//  Copyright © 2017年 lishouping. All rights reserved.
//

#import "ResTableViewCell.h"

@implementation ResTableViewCell
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
    self.labTableNumber = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, kWidth, 20)];
    self.labTableNumber.text = @"需求时间";
    [self.labTableNumber setFont:[UIFont systemFontOfSize:12]];
    [self.contentView addSubview:self.labTableNumber];
    
    self.labCreateTime = [[UILabel alloc] initWithFrame:CGRectMake(10, 5+20, kWidth-10-10/2, 20)];
    self.labCreateTime.text = @"预定人";
    [self.labCreateTime setFont:[UIFont systemFontOfSize:12]];
    [self.contentView addSubview:self.labCreateTime];
    
    self.labServiceTime = [[UILabel alloc] initWithFrame:CGRectMake(kWidth/2-40, 5+20, kWidth/2+20, 20)];
    self.labServiceTime.text = @"联系电话";
    [self.labServiceTime setFont:[UIFont systemFontOfSize:12]];
    [self.contentView addSubview:self.labServiceTime];
    
    self.labServiceContent = [[UILabel alloc] initWithFrame:CGRectMake(10, 5+20+20, kWidth-10-10/2, 20)];
    self.labServiceContent.text = @"餐桌名称";
    [self.labServiceContent setFont:[UIFont systemFontOfSize:12]];
    [self.contentView addSubview:self.labServiceContent];
    
    self.labServiceState = [[UILabel alloc] initWithFrame:CGRectMake(kWidth/2-40, 5+20+20, kWidth/2+20, 20)];
    self.labServiceState.text = @"用餐人数";
    [self.labServiceState setFont:[UIFont systemFontOfSize:12]];
    [self.contentView addSubview:self.labServiceState];
    
    self.btnServiceHander = [[UIButton alloc] initWithFrame:CGRectMake(kWidth-20-20-100-20, 5+20+20+20, 100, 30)];
    [self.btnServiceHander setTitle:@"去点餐" forState:UIControlStateNormal];
    [self.btnServiceHander setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnServiceHander setBackgroundColor:[UIColor colorWithRed:251.0/255.0 green:139.0/255.0 blue:57.0/255.0 alpha:1]];
    self.btnServiceHander.layer.cornerRadius = 3.0;
    [self.btnServiceHander setFont:[UIFont systemFontOfSize:14]];
    [self.contentView addSubview:self.btnServiceHander];
    
    
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
