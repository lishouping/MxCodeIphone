//
//  OrderModel.h
//  MXrestaurant
//
//  Created by lishouping on 2017/11/20.
//  Copyright © 2017年 lishouping. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderModel : NSObject
@property(nonatomic,strong)NSString *table_id;
@property(nonatomic,strong)NSString *order_id;
@property(nonatomic,strong)NSString *order_num;
@property(nonatomic,strong)NSString *order_time;
@property(nonatomic,strong)NSString *status;
@property(nonatomic,strong)NSString *table_name;
@property(nonatomic,strong)NSString *people_count;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *payment;
@end
