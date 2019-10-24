//
//  TableStaticsTableViewCell.h
//  MXrestaurant
//
//  Created by MX on 2019/10/24.
//  Copyright © 2019年 lishouping. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableStaticsTableViewCell : UITableViewCell
@property(nonatomic,strong) UIView *footView;
@property(nonatomic,strong) UILabel *labFoodName;
@property(nonatomic,strong) UILabel *labOrderNumber;
@property(nonatomic,strong) UILabel *labStaNum;
@property(nonatomic,strong) UILabel *labTotalPrice;
@end
