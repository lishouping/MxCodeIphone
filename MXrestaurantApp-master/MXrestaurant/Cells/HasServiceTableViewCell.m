//
//  HasServiceTableViewCell.m
//  MXrestaurant
//
//  Created by lishouping on 2017/11/7.
//  Copyright © 2017年 lishouping. All rights reserved.
//

#import "HasServiceTableViewCell.h"

@implementation HasServiceTableViewCell

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
    self.labTableNumber = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 20)];
    self.labTableNumber.font = [UIFont systemFontOfSize:12];
    self.labTableNumber.text = @"桌号:101";
    [self.contentView addSubview:self.labTableNumber];
    
    self.labServiceState = [[UILabel alloc] initWithFrame:CGRectMake(10+100+5, 5, 100, 20)];
    self.labServiceState.font = [UIFont systemFontOfSize:12];
    self.labServiceState.text = @"服务状态:已服务";
    [self.contentView addSubview:self.labServiceState];
    
    self.labSendServiceTime = [[UILabel alloc] initWithFrame:CGRectMake(10, 5+20, kWidth-10-10, 20)];
    self.labSendServiceTime.font = [UIFont systemFontOfSize:12];
    self.labSendServiceTime.text = @"服务时间:2017-12-12 22:20";
    [self.contentView addSubview:self.labSendServiceTime];
    
    self.labServiceContent = [[UILabel alloc] initWithFrame:CGRectMake(10, 5+20+20, 200, 20)];
    self.labServiceContent.font = [UIFont systemFontOfSize:12];
    self.labServiceContent.text = @"内容内容";
    [self.contentView addSubview:self.labServiceContent];
    
    self.btnServiceHander = [[UIButton alloc] initWithFrame:CGRectMake(kWidth-5-40, 10+5, 40, 30)];
    [self.btnServiceHander setTitle:@"处理" forState:UIControlStateNormal];
    self.btnServiceHander.font = [UIFont systemFontOfSize:14];
    [self.btnServiceHander setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnServiceHander setBackgroundColor:[UIColor colorWithRed:251.0/255.0 green:139.0/255.0 blue:57.0/255.0 alpha:1]];
    self.btnServiceHander.layer.cornerRadius = 3.0;
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
