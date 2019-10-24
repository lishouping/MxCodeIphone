//
//  MemberTableViewCell.m
//  MXrestaurant
//
//  Created by MX on 2019/10/24.
//  Copyright © 2019年 lishouping. All rights reserved.
//

#import "MemberTableViewCell.h"

@implementation MemberTableViewCell

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
    self.memberNum = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, kWidth/2-40, 30)];
    self.memberNum.textAlignment = UITextAlignmentLeft;
    [self.memberNum setFont:[UIFont systemFontOfSize:12]];
    [self.contentView addSubview:self.memberNum];
    
    self.memberNewNum = [[UILabel alloc] initWithFrame:CGRectMake(kWidth/2-40, 0, kWidth/2, 30)];
    self.memberNewNum.textAlignment = UITextAlignmentRight;
    [self.memberNewNum setFont:[UIFont systemFontOfSize:12]];
    [self.contentView addSubview:self.memberNewNum];
  
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
