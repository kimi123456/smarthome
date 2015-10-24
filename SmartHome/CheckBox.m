//
//  CheckBox.m
//  SmartHome
//
//  Created by kimi on 15/10/17.
//  Copyright © 2015年 kimi. All rights reserved.
//

#import "CheckBox.h"

@interface CheckBox()
@property(nonatomic,retain)UIImage *onImage;
@property(nonatomic,retain)UIImage *offImage;
@end

@implementation CheckBox

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
/*
-(void)dealloc{
[_text release];
[_delegate release];
[_onImage release];
[_offImage release];
[super dealloc];
}
*/

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(id)initWithText:(NSString *)text frame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        _text=text;
        self.backgroundColor=[UIColor clearColor];
        self.onImage=[UIImage imageNamed:@"cb_on.png"];
        self.offImage=[UIImage imageNamed:@"cb_off.png"];
    }
    
    return self;
}

-(void)setChecked:(BOOL)checked{
    _checked=checked;
    if([self.delegate  respondsToSelector:@selector(onChangeDelegate:isCheck:)]){
        [self.delegate onChangeDelegate:self isCheck:_checked];
    }
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect{
    UIImage *image=self.checked?self.onImage:self.offImage;
    [image drawAtPoint:CGPointMake(0, 0)];
    UIFont *font=[UIFont systemFontOfSize:12.0f];
    [[UIColor whiteColor] set];
    [self.text drawAtPoint:CGPointMake(30, 3) withFont:font];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    self.checked=!self.checked;
}




@end
