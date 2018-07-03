//
//  HasServiceTableViewCell.h
//  MXrestaurant
//
//  Created by lishouping on 2017/11/7.
//  Copyright © 2017年 lishouping. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HasServiceTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel *labTableNumber;
@property(nonatomic,strong)UILabel *labServiceState;
@property(nonatomic,strong)UILabel *labSendServiceTime;
@property(nonatomic,strong)UILabel *labServiceContent;
@property(nonatomic,strong)UIButton *btnServiceHander;
@end
