//
//  TableModel.h
//  MXrestaurant
//
//  Created by MX on 2018/8/20.
//  Copyright © 2018年 lishouping. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableModel : NSObject
@property(nonatomic,strong)NSString *table_name;
@property(nonatomic,strong)NSString *table_status;
@property(nonatomic,strong)NSString *table_id;
@property(nonatomic,strong)NSString *create_time;
@property(nonatomic,strong)NSString *people_count;
@property(nonatomic,strong)NSString *area_id;
@property(nonatomic,strong)NSString *area_name;
@end
