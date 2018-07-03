//
//  FoodClassTableViewCell.m
//  MXrestaurant
//
//  Created by lishouping on 2017/11/18.
//  Copyright © 2017年 lishouping. All rights reserved.
//

#import "FoodClassTableViewCell.h"

@implementation FoodClassTableViewCell
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
    self.contentView.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1];
    UIView *view = [UIView new];
    [self.contentView addSubview:view];
    [view zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.widthValue(kWidth);
        layout.heightValue(40);
    }];
 
    self.labClass = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, kWidth/3-5-5, 40)];
    [view addSubview:self.labClass];
    [self.labClass setFont:[UIFont systemFontOfSize:12]];
    self.labClass.textAlignment = UITextAlignmentCenter;

    
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
