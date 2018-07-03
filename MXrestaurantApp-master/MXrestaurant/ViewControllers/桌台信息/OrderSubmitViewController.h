//
//  OrderSubmitViewController.h
//  MXrestaurant
//
//  Created by lishouping on 2017/11/19.
//  Copyright © 2017年 lishouping. All rights reserved.
//

#import "RootViewController.h"

@interface OrderSubmitViewController : RootViewController
@property(nonatomic,strong)NSString *cart_id;
@property(nonatomic,strong)NSString *table_id;
@property(nonatomic,strong)NSString *table_name;
@property(nonatomic,strong)NSDictionary *dicdate;
@end
