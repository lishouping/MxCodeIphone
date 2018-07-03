//
//  FoodListTableViewCell.h
//  MXrestaurant
//
//  Created by lishouping on 2017/11/18.
//  Copyright © 2017年 lishouping. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodListTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel *labFoodName;
@property(nonatomic,strong)UILabel *labFoodPrice;
@property(nonatomic,strong)UIButton *btnAddFood;
@property(nonatomic,strong)UIButton *btnExtSelect;
@end
