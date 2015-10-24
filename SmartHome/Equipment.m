//
//  KCContact.m
//  SmartHome
//
//  Created by kimi on 15/10/20.
//  Copyright © 2015年 kimi. All rights reserved.
//

#import "Equipment.h"

@implementation Equipment
-(Equipment *)initWithName:(NSString *)name andStatus:(NSString *)status andData:(NSString *)data{
    if(self=[super init]){
        self.name = name;
        self.status = status;
        self.data = data;
    }
    return self;
}

-(NSString *)getName{
    return [NSString stringWithFormat:@"%@",_name];
}

+(Equipment *)initWithName:(NSString *)name andStatus:(NSString *)status andData:(NSString *)data{
    Equipment *equipment = [[Equipment alloc]initWithName:(NSString *)name andStatus:(NSString *)status andData:(NSString *)data];
    return equipment;
}

@end
