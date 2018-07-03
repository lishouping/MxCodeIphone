//
//  GoodInfoTableViewCell.m
//  MXrestaurant
//
//  Created by lishouping on 2017/11/19.
//  Copyright © 2017年 lishouping. All rights reserved.
//

#import "GoodInfoTableViewCell.h"

@implementation GoodInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
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
    UIView *goodsview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 40)];
    goodsview.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:goodsview];
    
    self.goodname = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, kWidth/2, 20)];
    self.goodname.text = @"菜品信息";
    [self.goodname setFont:[UIFont systemFontOfSize:12]];
    [goodsview addSubview:self.goodname];
    
    self.goodprice = [[UILabel alloc] initWithFrame:CGRectMake(kWidth/2+5, 10, kWidth/2/3, 20)];
    self.goodprice.text = @"单价";
    [self.goodprice setFont:[UIFont systemFontOfSize:12]];
    [goodsview addSubview:self.goodprice];
    
    self.goodnum = [[UILabel alloc] initWithFrame:CGRectMake(kWidth/2/3+kWidth/2, 10, kWidth/2, 20)];
    self.goodnum.text = @"数量";
    [self.goodnum setFont:[UIFont systemFontOfSize:12]];
    [goodsview addSubview:self.goodnum];
    
    self.goodtotalprice = [[UILabel alloc] initWithFrame:CGRectMake(kWidth/2/3+kWidth/2/3+kWidth/2, 10, kWidth/2, 20)];
    self.goodtotalprice.text = @"价格";
    [self.goodtotalprice setFont:[UIFont systemFontOfSize:12]];
    self.goodtotalprice.textColor = [UIColor colorWithRed:220.0/255.0 green:20.0/255.0 blue:60.0/255.0 alpha:1];
    [goodsview addSubview:self.goodtotalprice];    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

