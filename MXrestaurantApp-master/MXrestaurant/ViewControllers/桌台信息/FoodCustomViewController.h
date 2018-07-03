//
//  FoodCustomViewController.h
//  MXrestaurant
//
//  Created by lishouping on 2017/11/18.
//  Copyright © 2017年 lishouping. All rights reserved.
//

#import "RootViewController.h"

@interface FoodCustomViewController : RootViewController
@property(nonatomic,strong)NSString *table_id;
@property(nonatomic,strong)NSString *table_name;
@property(nonatomic,strong)NSString *isinitres;//是否需要实时刷新
@property(nonatomic,strong)NSDictionary *dicdate;
@end
