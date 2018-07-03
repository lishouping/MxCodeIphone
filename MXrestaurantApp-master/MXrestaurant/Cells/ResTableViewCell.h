//
//  ResTableViewCell.h
//  MXrestaurant
//
//  Created by lishouping on 2017/11/25.
//  Copyright © 2017年 lishouping. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel *labTableNumber;
@property(nonatomic,strong)UILabel *labServicePerson;
@property(nonatomic,strong)UILabel *labCreateTime;
@property(nonatomic,strong)UILabel *labServiceTime;
@property(nonatomic,strong)UILabel *labServiceContent;
@property(nonatomic,strong)UILabel *labServiceState;
@property(nonatomic,strong)UIButton *btnServiceHander;
@end
