//
//  ServiceModel.h
//  MXrestaurant
//
//  Created by lishouping on 2017/11/7.
//  Copyright © 2017年 lishouping. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceModel : NSObject
@property(nonatomic,strong)NSString *service_id;
@property(nonatomic,strong)NSString *service_content;
@property(nonatomic,strong)NSString *status;
@property(nonatomic,strong)NSString *create_time;
@property(nonatomic,strong)NSString *receive_time;
@property(nonatomic,strong)NSString *table_name;
@property(nonatomic,strong)NSString *name;
@end
