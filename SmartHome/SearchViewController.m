//
//  SearchViewController.m
//  SmartHome
//
//  Created by kimi on 15/10/16.
//  Copyright © 2015年 kimi. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()
@property (nonatomic,strong) UIButton *backButton;
@property (nonatomic,strong) UIImageView *imageView;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login.jpg"]];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
