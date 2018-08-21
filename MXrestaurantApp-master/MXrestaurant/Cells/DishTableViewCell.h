//
//  DishTableViewCell.h
//  MXrestaurant
//
//  Created by MX on 2018/8/21.
//  Copyright © 2018年 lishouping. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DishTableViewCell : UITableViewCell
@property(nonatomic,strong)UIView *vieNum;
@property(nonatomic,strong)UILabel *labNum;
@property(nonatomic,strong)UILabel *labName;
@property(nonatomic,strong)UILabel *labStatus;
@property(nonatomic,strong)UILabel *labCreateTime;
@end
