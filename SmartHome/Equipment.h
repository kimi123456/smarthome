//
//  KCContact.h
//  SmartHome
//
//  Created by kimi on 15/10/20.
//  Copyright © 2015年 kimi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Equipment : NSObject
#pragma mark 设备名称
@property (nonatomic,copy) NSString *name;
#pragma mark 状态
@property (nonatomic,copy) NSString *status;
#pragma mark 数据
@property (nonatomic,copy) NSString *data;

#pragma mark 带参数的构造函数
-(Equipment *)initWithName:(NSString *)name andStatus:(NSString *)status andData:(NSString *)data;

#pragma mark 取得名称
-(Equipment *)getName;


#pragma mark 带参数的静态对象初始化方法
+(Equipment *)initWithName:(NSString *)name andStatus:(NSString *)status andData:(NSString *)data;
@end
