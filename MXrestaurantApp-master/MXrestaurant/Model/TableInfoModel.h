//
//  TableInfoModel.h
//  MXrestaurant
//
//  Created by lishouping on 2017/11/5.
//  Copyright © 2017年 lishouping. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableInfoModel : NSObject
@property(nonatomic,strong)NSString *table_name;
@property(nonatomic,strong)NSString *table_status;
@property(nonatomic,strong)NSString *table_id;
@property(nonatomic,strong)NSArray *book_list;
@property(nonatomic,strong)NSString *orderstate;
@property(nonatomic,strong)NSString *order_num;

@end
