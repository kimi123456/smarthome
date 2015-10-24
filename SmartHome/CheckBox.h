//
//  CheckBox.h
//  SmartHome
//
//  Created by kimi on 15/10/17.
//  Copyright © 2015年 kimi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CheckBoxDelegate;
@interface CheckBox : UIView
@property(nonatomic,retain)NSString *text;
@property(nonatomic,assign)BOOL checked;
@property(nonatomic,retain) id<CheckBoxDelegate> delegate;
-(id)initWithText:(NSString *)text frame:(CGRect)frame;
@end

@protocol CheckBoxDelegate<NSObject>
-(void)onChangeDelegate:(CheckBox *)checkbox isCheck:(BOOL)isCheck;
@end


