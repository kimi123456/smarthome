//
//  textFieldBackground.m
//  SmartHome
//
//  Created by kimi on 15/10/15.
//  Copyright © 2015年 kimi. All rights reserved.
//

#import "textFieldBackground.h"

@implementation textFieldBackground

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawRect:(CGRect)rect {
    CGContextRef context= UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context,0.2);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 5, 30);
    CGContextAddLineToPoint(context, self.frame.size.width-5, 30);
    CGContextClosePath(context);
    [[UIColor grayColor] setStroke];
    CGContextStrokePath(context);
    
}

@end

