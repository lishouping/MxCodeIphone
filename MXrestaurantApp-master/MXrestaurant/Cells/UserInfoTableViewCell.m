//
//  UserInfoTableViewCell.m
//  MXrestaurant
//
//  Created by lishouping on 2017/11/12.
//  Copyright © 2017年 lishouping. All rights reserved.
//

#import "UserInfoTableViewCell.h"

@implementation UserInfoTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self makeUI];
        
    }
    return self;
}
- (void)makeUI{
    self.imginfo = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    [self.contentView addSubview:self.imginfo];
    
    self.labtitle = [[UILabel alloc] initWithFrame:CGRectMake(10+20+10, 10, 200, 20)];
    [self.labtitle setFont:[UIFont systemFontOfSize:12]];
    [self.contentView addSubview:self.labtitle];
    
    self.imgarrow = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth-10-20, 10, 20, 20)];
    [self.imgarrow setImage:[UIImage imageNamed:@"icon_tip"]];
    [self.contentView addSubview:self.imgarrow];
    

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
