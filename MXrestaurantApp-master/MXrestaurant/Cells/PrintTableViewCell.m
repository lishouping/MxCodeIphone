//
//  PrintTableViewCell.m
//  MXrestaurant
//
//  Created by MX on 2018/8/15.
//  Copyright © 2018年 lishouping. All rights reserved.
//

#import "PrintTableViewCell.h"

@implementation PrintTableViewCell
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
    
    self.labName = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, kWidth-15-15, 20)];
    self.labName.font = [UIFont systemFontOfSize:14];
    self.labName.text = @"桌号:101";
    [self.contentView addSubview:self.labName];
    
    
    self.labType = [[UILabel alloc] initWithFrame:CGRectMake(15, 5+20+5, (kWidth-15-15)/3, 20)];
    self.labType.font = [UIFont systemFontOfSize:12];
    self.labType.text = @"桌号:101";
    [self.contentView addSubview:self.labType];
    
    
    self.labNumber = [[UILabel alloc] initWithFrame:CGRectMake(15+(kWidth-15-15)/3, 5+20+5, (kWidth-15-15)/3+20, 20)];
    self.labNumber.font = [UIFont systemFontOfSize:12];
    self.labNumber.text = @"桌号:101";
    [self.contentView addSubview:self.labNumber];
    
    
    self.labNo = [[UILabel alloc] initWithFrame:CGRectMake(15+(kWidth-15-15)/3+(kWidth-15-15)/3+20, 5+20+5, (kWidth-15-15)/3, 20)];
    self.labNo.font = [UIFont systemFontOfSize:12];
    self.labNo.text = @"桌号:101";
    [self.contentView addSubview:self.labNo];
    
    
    
    
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
