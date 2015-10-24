//
//  KCContactGroup.m
//  SmartHome
//
//  Created by kimi on 15/10/20.
//  Copyright © 2015年 kimi. All rights reserved.
//

#import "EquipmentGroup.h"

@implementation EquipmentGroup
-(EquipmentGroup *)initWithName:(NSString *)name andDetail:(NSString *)detail andEquipments:(NSMutableArray *)equipments{
    if (self = [super init]) {
        self.name = name;
        self.detail = detail;
        self.equipments = equipments;
    }
    return self;
}

+(EquipmentGroup *)initWithName:(NSString *)name andDetail:(NSString *)detail andEquipments:(NSMutableArray *)equipments{
    EquipmentGroup *group1=[[EquipmentGroup alloc]initWithName:name andDetail:detail andEquipments:equipments];
    return group1;
}
@end
