//
//  NoServiceTableViewCell.m
//  MXrestaurant
//
//  Created by lishouping on 2017/11/7.
//  Copyright © 2017年 lishouping. All rights reserved.
//

#import "NoServiceTableViewCell.h"

@implementation NoServiceTableViewCell

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
    
    self.labServicePerson = [[UILabel alloc] initWithFrame:CGRectMake(10+100+5, 5, 100, 20)];
    self.labServicePerson.font = [UIFont systemFontOfSize:12];
    self.labServicePerson.text = @"服务员:小里";
    [self.contentView addSubview:self.labServicePerson];
    
    self.labCreateTime = [[UILabel alloc] initWithFrame:CGRectMake(10, 5+20, kWidth-10-10, 20)];
    self.labCreateTime.font = [UIFont systemFontOfSize:12];
    self.labCreateTime.text = @"创建时间:2017-12-12 22:20";
    [self.contentView addSubview:self.labCreateTime];
    
    self.labServiceTime = [[UILabel alloc] initWithFrame:CGRectMake(10, 5+20+20, kWidth-10-10, 20)];
    self.labServiceTime.font = [UIFont systemFontOfSize:12];
    self.labServiceTime.text = @"服务时间:2017-12-12 22:20";
    [self.contentView addSubview:self.labServiceTime];
    
    self.labServiceContent = [[UILabel alloc] initWithFrame:CGRectMake(10, 5+20+20+20, 200, 20)];
    self.labServiceContent.font = [UIFont systemFontOfSize:12];
    self.labServiceContent.text = @"服务内容:加水";
    [self.contentView addSubview:self.labServiceContent];
    
    self.labServiceState = [[UILabel alloc] initWithFrame:CGRectMake(kWidth/2+20, 5+20+20+20, 200, 20)];
    self.labServiceState.font = [UIFont systemFontOfSize:12];
     self.labServiceState.text = @"服务状态:已服务";
    [self.contentView addSubview:self.labServiceState];
    
    
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
