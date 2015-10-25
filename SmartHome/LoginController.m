//
//  LoginController.m
//  SmartHome
//
//  Created by kimi on 15/10/15.
//  Copyright © 2015年 kimi. All rights reserved.
//

#import "LoginController.h"
#include "textFieldBackground.h"
#import "Client.h"
#import "ViewController.h"
#import "FirstViewController.h"
#import "SearchViewController.h"
#import "CheckBox.h"
#import "AppDelegate.h"

#include <sys/types.h>
#include <sys/socket.h>
#include <stdio.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <stdlib.h>
#include <netdb.h>
#include <sys/time.h>
#include <sys/select.h>
#include <errno.h>
#include <string.h>

@interface LoginController ()
<CheckBoxDelegate>

@property (nonatomic,strong) UILabel *lTitle;
@property (nonatomic,strong) UILabel *errorMsg;
@property (nonatomic,strong) UITextField *account;
@property (nonatomic,strong) UITextField *password;
@property (nonatomic,strong) UIButton *loginButton;
@property (nonatomic,strong) UIButton *searchButton;
@property (nonatomic,strong) UIImageView *imageView;
-(void)login:(UIButton *)btn;
-(void)search:(UIButton *)btn;
-(void)setNameAndPwd;
@end

bool isRememberPwd = false;
bool isAutoLogin = false;
int sockfd = -1;
int error = 0;
//int flag;
//char *flag = NULL;
char *duid;
int res = 0;
void * msg = NULL;

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //[self.view setBackgroundColor:[UIColor colorWithRed:66/255.0 green:97/255.0 blue:164/255.0 alpha:1]];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login.jpg"]];
    
    _lTitle=[[UILabel alloc] initWithFrame:CGRectMake(20, 100, self.view.frame.size.width-40, 50)];
    _lTitle.textColor=[UIColor whiteColor];
    _lTitle.layer.cornerRadius=5.0;
    _lTitle.textAlignment = NSTextAlignmentCenter;
    _lTitle.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:30];
    _lTitle.text=[NSString stringWithFormat:@"SmartHome"];
    _lTitle.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_lTitle];
    
    textFieldBackground *_background=[[textFieldBackground alloc] initWithFrame:CGRectMake(50, 220, self.view.frame.size.width-100, 60)];
    [_background setBackgroundColor:[UIColor whiteColor]];
    [[_background layer] setCornerRadius:5];
    [[_background layer] setMasksToBounds:YES];
    [self.view addSubview:_background];
    _account=[[UITextField alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-100, 30)];
    _account.backgroundColor=[UIColor clearColor];
    _account.layer.cornerRadius=5.0;
    _account.placeholder=[NSString stringWithFormat:@"网 关:"];
    _account.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_background addSubview:_account];
    
    _password=[[UITextField alloc] initWithFrame:CGRectMake(10, 30, self.view.frame.size.width-100, 30)];
    _password.backgroundColor=[UIColor clearColor];
    _password.layer.cornerRadius=5.0;
    _password.placeholder=[NSString stringWithFormat:@"密 码:"];
    _password.clearButtonMode = UITextFieldViewModeWhileEditing;
    _password.secureTextEntry = YES;
    [_background addSubview:_password];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef borderColorRef = CGColorCreate(colorSpace,(CGFloat[]){ 165, 165, 165, 1 });
    
    _loginButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_loginButton setFrame:CGRectMake(50, 310, self.view.frame.size.width/2-90, 25)];
    [_loginButton setTitle:@"进入网关" forState:UIControlStateNormal];
    [_loginButton setBackgroundColor:[UIColor colorWithRed:151/255.0 green:231/255.0 blue:97/255.0 alpha:1]];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _loginButton.layer.cornerRadius=5.0;
    _loginButton.layer.borderWidth = 1.5;
    _loginButton.layer.borderColor = borderColorRef;
    [_loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginButton];
    
    _searchButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_searchButton setFrame:CGRectMake(self.view.frame.size.width/2+40, 310, self.view.frame.size.width/2-90, 25)];
    [_searchButton setTitle:@"搜索网关" forState:UIControlStateNormal];
    [_searchButton setBackgroundColor:[UIColor colorWithRed:255/255.0 green:137/255.0 blue:3/255.0 alpha:1]];
    [_searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_searchButton addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    _searchButton.layer.borderWidth = 1.5;
    _searchButton.layer.borderColor = borderColorRef;
    _searchButton.layer.cornerRadius=5.0;
    [self.view addSubview:_searchButton];
    
    CheckBox *cbpass=[[CheckBox alloc] initWithText:@"记住密码" frame:CGRectMake(50, 350, 100, 50)];
    cbpass.delegate=self;
    [self.view addSubview:cbpass];
    
    CheckBox *cb=[[CheckBox alloc] initWithText:@"自动登录" frame:CGRectMake(self.view.frame.size.width/2+40, 350, 100, 50)];
    cb.delegate=self;
    [self.view addSubview:cb];
    
    _errorMsg=[[UILabel alloc] initWithFrame:CGRectMake(20, 400, self.view.frame.size.width-40, 20)];
    _errorMsg.textColor=[UIColor redColor];
    _errorMsg.layer.cornerRadius=5.0;
    _errorMsg.textAlignment = NSTextAlignmentCenter;
    _errorMsg.font = [UIFont fontWithName:@"Arial" size:10];
    _errorMsg.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_errorMsg];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self setNameAndPwd];
}

-(void) setNameAndPwd{
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    //获取完整路径
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"smarthome.plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    NSString *isRem = [data objectForKey:@ "isRememberPwd"];
    if([isRem  isEqual: @ "1"])
    {
        _account.text = [data objectForKey:@ "name"];
        _password.text = [data objectForKey:@ "password"];

    }
}


-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)onChangeDelegate:(CheckBox *)checkbox isCheck:(BOOL)isCheck{
    
    if([checkbox.text  isEqual: @"记住密码"])
    {
        if(isCheck)
        {
            isRememberPwd = true;
        }
        else
        {
            isRememberPwd = false;
        }
    }
    else
    {
        if(isCheck)
        {
            isAutoLogin = true;
        }
        else
        {
            isAutoLogin = false;
        }
    }
    
    //NSLog(@"pwd--text:%@,State:%@",checkbox.text,isCheck?@"YES":@"NO");
}

-(void)login:(UIButton *)btn{
    
    NSString *name = _account.text;
    NSString *pwd = _password.text;
    NSString *newString = [NSString stringWithFormat:@"%@%@",name,pwd];
    duid = [newString UTF8String];
    NSLog(@"duid: %s", duid);
    error = 0;
    //connectServer(duid, &sockfd, &flag, &error);
    //NSLog(@"flag: %s", *flag);

    int len;
    struct sockaddr_in address;
    long result;
    const char *emsg = NULL;
    
    char server_hostname[] = "tonyvanhawk.xicp.net";
    struct hostent* server_hostent;
    server_hostent = gethostbyname( server_hostname );
    
    if((sockfd = socket(AF_INET, SOCK_STREAM, 0)) == -1)
    {
        error = errno;
        printf("[connectServer]socket failed, %s\n", strerror(errno));
        const char *emsg = strerror(error);
        _errorMsg.text = [[NSString alloc] initWithCString:(const char*)emsg encoding:NSASCIIStringEncoding];
        return;
    }
    
    memset(&address, 0, sizeof(address));
    
    address.sin_family = AF_INET;
    address.sin_port = htons(1080);
    address.sin_addr = *((struct in_addr *)server_hostent->h_addr);
    
    len = sizeof(address);
    
    if((result = connect(sockfd, (struct sockaddr *)&address, len)) == -1)
    {
        error = errno;
        printf("[connectServer]connect failed, %s\n", strerror(errno));
        emsg = strerror(error);
        _errorMsg.text = [[NSString alloc] initWithCString:(const char*)emsg encoding:NSASCIIStringEncoding];
        return;
    }
    
    char sendBuff[256] = {0,};
    strcat(sendBuff, duid);

    printf("[sendMsg]send msg to server: %s\n", sendBuff);
    if((result = send(sockfd,sendBuff,255,0)) < 0)
    {
        error = errno;
        printf("[sendMsg]send message failed, %s\n", strerror(errno));
        emsg = strerror(error);
        _errorMsg.text = [[NSString alloc] initWithCString:(const char*)emsg encoding:NSASCIIStringEncoding];
        return;
    }
    
    char recvBuff[256] = {0,};
    if((result = read(sockfd, recvBuff, 256)) < 0)
    {
        error = errno;
        printf("[recvMsg]read message failed, %s\n", strerror(errno));
        emsg = strerror(error);
        _errorMsg.text = [[NSString alloc] initWithCString:(const char*)emsg encoding:NSASCIIStringEncoding];
        return;
    }

    if(error != 0)
    {
        emsg = strerror(error);
        _errorMsg.text = [[NSString alloc] initWithCString:(const char*)emsg encoding:NSASCIIStringEncoding];
    }
    else if(strcmp(recvBuff, "ok") == 0)
    {
        AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        delegate.sockfd=sockfd;
        NSLog(@"sockfd:%d", sockfd);
        NSLog(@"d.sockfd:%d", delegate.sockfd);
        
        NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        //获取完整路径
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"smarthome.plist"];
        NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        NSLog(@"%@", data);
        
        NSMutableDictionary *dictplist = [[NSMutableDictionary alloc] init];
        //设置属性值
        [dictplist setObject:_account.text forKey:@"name"];
        [dictplist setObject:_password.text forKey:@"password"];
        [dictplist setObject:@"0" forKey:@"isRememberPwd"];
        //写入文件
        [dictplist writeToFile:plistPath atomically:YES];
        
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"smarthome.plist"];
        NSMutableDictionary *applist = [[[NSMutableDictionary alloc]initWithContentsOfFile:path]mutableCopy];
        NSString *isRPwd = [applist objectForKey:@"isRememberPwd"];
        if(isRememberPwd)
        {
            isRPwd = @"1";
        }
        else
        {
            isRPwd = @ "0";
        }
        [applist setObject:isRPwd forKey:@"isRememberPwd"];
        [applist writeToFile:path atomically:YES];
        
        NSLog(@"%@", applist);
        
        //调用代理方法传参
        UITabBarController *viewValue=[[UITabBarController alloc]init];
        [viewValue setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        [viewValue setModalPresentationStyle:UIModalPresentationFullScreen];
        [self presentModalViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"tabbar"] animated:YES];
        //[self presentViewController:viewValue animated:YES completion:nil];
        //[self dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        //登录失败弹出提示信息
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"系统信息" message:@"用户名或密码错误，请重新输入！" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alertView show];
    }
}

-(void)search:(UIButton *)btn{
    FirstViewController *first = [self.storyboard instantiateViewControllerWithIdentifier:@"search"];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回登陆" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    [self.navigationController pushViewController:first animated:YES];
    first.title = @"当前网络";
    /*
    UITableViewController *sviewValue=[[UITableViewController alloc]init];
    [sviewValue setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [sviewValue setModalPresentationStyle:UIModalPresentationFullScreen];
    [self presentModalViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"tabbar"] animated:YES];
     */
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
