//
//  KCContactGroup.h
//  SmartHome
//
//  Created by kimi on 15/10/20.
//  Copyright © 2015年 kimi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EquipmentGroup : NSObject
#pragma mark 组名
@property (nonatomic,copy) NSString *name;

#pragma mark 分组描述
@property (nonatomic,copy) NSString *detail;

#pragma mark 联系人
@property (nonatomic,strong) NSMutableArray *equipments;

#pragma mark 带参数个构造函数
-(EquipmentGroup *)initWithName:(NSString *)name andDetail:(NSString *)detail andEquipments:(NSMutableArray *)equipments;

#pragma mark 静态初始化方法
+(EquipmentGroup *)initWithName:(NSString *)name andDetail:(NSString *)detail andEquipments:(NSMutableArray *)equipments;
@end
