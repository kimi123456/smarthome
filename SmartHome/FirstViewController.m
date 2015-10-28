//
//  FirstViewController.m
//  SmartHome
//
//  Created by kimi on 15/10/15.
//  Copyright © 2015年 kimi. All rights reserved.
//

#import "FirstViewController.h"
#import "Client.h"
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
#import "AppDelegate.h"
#import "Equipment.h"
#import "EquipmentGroup.h"

@interface FirstViewController ()<UITableViewDataSource>{
    UITableView *_tableView;
    NSMutableArray *_equipmentarrs;//设备模型
    NSMutableArray *_equipments;//设备模型
    NSIndexPath *_selectedIndexPath;//当前选中的组和行
}
@property (weak, nonatomic) IBOutlet UILabel *fire;

@end

int newsockfd;
NSString *eName;
NSString *eStatus;
NSString *eData;
<<<<<<< HEAD
NSString *eNum;
=======
>>>>>>> ae79e43653001f8ac6986a1165ed909548f3fd70
NSString *eGroupName;
int i = 0;


@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    newsockfd = delegate.sockfd;
    NSLog(@"sockfd: %d", newsockfd);
    
    dispatch_queue_t serialQueue=dispatch_queue_create("myThreadQueue1", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(serialQueue, ^{
        [self keep_alive];
    });

    _equipments=[[NSMutableArray alloc]init];
    /*
    [self initData];
    
    //创建一个分组样式的UITableView
    _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    //设置数据源，注意必须实现对应的UITableViewDataSource协议
    _tableView.dataSource=self;
    
    //设置代理
    _tableView.delegate=self;
    
    [self.view addSubview:_tableView];
    */
}

void split(char **arr, char *str, const char *del)
{
    char *s = strtok(str, del);
    
    while(s != NULL)
    {
        *arr++ = s;
        s = strtok(NULL, del);
    }
}


-(void) keep_alive{
    
    dispatch_queue_t serialQueue=dispatch_queue_create("myThreadQueue2", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t main_queue= dispatch_get_main_queue();
    
    dispatch_async(serialQueue, ^{
    fd_set rfds;
    struct timeval tv;
    int retval, maxfd = -1;
    long result;
        
    while(1)
    {
        FD_ZERO(&rfds);
        FD_SET(newsockfd, &rfds);
        maxfd = 0;
        
        if(newsockfd > maxfd)
        {
            maxfd = newsockfd;
        }
        tv.tv_sec = 5;
        tv.tv_usec = 0;
        
        retval = select(maxfd+1, &rfds, NULL, NULL, &tv);
        if(retval == -1)
        {
            printf("[keep_live]select failed, %s\n", strerror(errno));
            break;
        }
        else if(retval == 0)
        {
            //心跳协议发送
            char* request = (char*)malloc(4);
            unsigned int data[1];
            data[0] = (0x1 << 30) | (0x1 << 24);
            memmove(request, data, 4);
            
            printf("[sendMsg]send msg to server: %s\n", request);
            if((result = send(newsockfd,request,4,0)) < 0)
            {
                printf("[sendMsg]send message failed, %s\n", strerror(errno));
                break;
            }
            free(request);
            /*
            char sendBuff[256] = {0,};
            sprintf(sendBuff, "%d", 1);
            int result;
            
            printf("[sendMsg]send msg to server: %s\n", sendBuff);
            if((result = send(newsockfd,sendBuff,255,0)) < 0)
            {
                printf("[sendMsg]send message failed, %s\n", strerror(errno));
                break;
            }
             */
            continue;
        }
        else
        {
            if(FD_ISSET(newsockfd, &rfds))
            {
                char recvBuff[256] = {0,};
                if((result = read(newsockfd, recvBuff, 256)) <= 0)
                {
                    printf("[keep_alive]read message failed, %s\n", strerror(errno));
                    break;
                }
                printf("[keep_alive]read message %s \n", recvBuff);
                
<<<<<<< HEAD
                
                unsigned int head = 0;
                memmove(&head, recvBuff, 4);
                unsigned int type = head >> 24;
                printf("[keep_live] %d \n", type);

                //心跳响应
                if(type == 0x1)
                {
                    char *data = recvBuff + 4;
                    char* subData = (char*)malloc(4);
                    memmove(subData, data, 4);
                    if(strcmp(subData, "0x0") == 0)
                    {
                        printf("[keep_alive]recv server msg! \n");
                        free(subData);
                        continue;
                    }
                    else
                    {
                        printf("[keep_alive]please check the network!");
                    }
                }
                
                //设备列表
                if(type == 0x3)
                {
                    char *data = recvBuff + 4;
                    char* subData = (char*)malloc(4);
                    memmove(subData, data, 4);
                    printf("[keep_live]0x3 --> isFailed: %s \n", subData);
                    if(strcmp(subData, "0x0") == 0)
                    {
                        printf("[keep_live]Get equipment successfully! \n");
                        eGroupName = @"智能设备";
                        data += 4;
                        memmove(subData, data, 4);
                        printf("[keep_live]0x3-->name: %s \n", subData);
                        eName = [[NSString alloc] initWithCString:(const char*)subData encoding:NSASCIIStringEncoding];
                        data += 4;
                        memmove(subData, data, 4);
                        printf("[keep_live]0x3-->num: %s \n", subData);
                        eNum = [[NSString alloc] initWithCString:(const char*)subData encoding:NSASCIIStringEncoding];
                        
                        if([eName isEqual: @"0x1"])
                        {
                            eName = [NSString stringWithFormat:@"开关%@",eNum];
                            eStatus = @"1";
                        }
                        if([eName isEqual: @"0x2"])
                        {
                            eName = [NSString stringWithFormat:@"温湿度计%@",eNum];
                            eStatus = @"0";
                        }
                        if([eName isEqual: @"0x3"])
                        {
                            eName = [NSString stringWithFormat:@"可燃气体报警器%@",eNum];
                            eStatus = @"0";
                        }
                        if([eName isEqual: @"0x4"])
                        {
                            eName = [NSString stringWithFormat:@"人体感应器%@",eNum];
                            eStatus = @"0";
                        }

                        data += 4;
                        memmove(subData, data, 4);
                        printf("[keep_live]0x3-->data: %s \n", subData);
                        eData = [[NSString alloc] initWithCString:(const char*)subData encoding:NSASCIIStringEncoding];
                        
                        i++;
                        _equipmentarrs=[[NSMutableArray alloc]init];
                        Equipment *i=[Equipment initWithName:eName andStatus:eStatus andData:eData];
                        [_equipments addObject:i];
                        
                        dispatch_sync(main_queue, ^{
                            
                            [self initData];
                            
                            //创建一个分组样式的UITableView
                            _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
                            
                            //设置数据源，注意必须实现对应的UITableViewDataSource协议
                            _tableView.dataSource = self;
                            
                            //设置代理
                            _tableView.delegate = self;
                            
                            [self.view addSubview:_tableView];
                        });
                        
                        free(subData);
                    }
                    else
                    {
                        printf("[keep_live]Get equipment failed: %s \n",recvBuff);
                    }
                }
                
                /*
=======
>>>>>>> ae79e43653001f8ac6986a1165ed909548f3fd70
                char *arr[4];
                char *del = ",";
                split(arr, recvBuff, del);
                if(strcmp(arr[0], "equipment") == 0)
                {
                    i++;
                    eGroupName = @"智能装备";
                    eName = [[NSString alloc] initWithCString:(const char*)arr[1] encoding:NSASCIIStringEncoding];
                    if([eName isEqual: @"1"])
                    {
                        eName = [NSString stringWithFormat:@"温湿度检测%d",i];
                    }
                    if([eName isEqual: @"2"])
                    {
                        eName = [NSString stringWithFormat:@"烟雾报警器%d",i];
                    }
                    eStatus = [[NSString alloc] initWithCString:(const char*)arr[2] encoding:NSASCIIStringEncoding];
                    eData = [[NSString alloc] initWithCString:(const char*)arr[3] encoding:NSASCIIStringEncoding];
                    _equipmentarrs=[[NSMutableArray alloc]init];
                    Equipment *i=[Equipment initWithName:eName andStatus:eStatus andData:eData];
                    [_equipments addObject:i];
                    
<<<<<<< HEAD
=======
                    dispatch_sync(main_queue, ^{
                        
                        [self initData];
                        
                        //创建一个分组样式的UITableView
                        _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
                        
                        //设置数据源，注意必须实现对应的UITableViewDataSource协议
                        _tableView.dataSource = self;
                        
                        //设置代理
                        _tableView.delegate = self;
                        
                        [self.view addSubview:_tableView];
                    });
                }
                
                if(strcmp(recvBuff, "9999") == 0)
                {
>>>>>>> ae79e43653001f8ac6986a1165ed909548f3fd70
                    dispatch_sync(main_queue, ^{
                        
                        [self initData];
                        
                        //创建一个分组样式的UITableView
                        _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
                        
                        //设置数据源，注意必须实现对应的UITableViewDataSource协议
                        _tableView.dataSource = self;
                        
                        //设置代理
                        _tableView.delegate = self;
                        
                        [self.view addSubview:_tableView];
                    });
                }*/
            }
            continue;
        }
    }
    
    disConnect(&newsockfd);
    });
}

#pragma mark 加载数据
-(void)initData{
    EquipmentGroup *group1=[EquipmentGroup initWithName:eGroupName andDetail:@"" andEquipments:_equipments];
    [_equipmentarrs addObject:group1];

    /*
    Equipment *equipment1=[Equipment initWithName:@"房间温湿度" andStatus:@"0" andData:@"温度20，湿度20"];
    Equipment *equipment2=[Equipment initWithName:@"客厅温湿度" andStatus:@"0" andData:@""];
    EquipmentGroup *group1=[EquipmentGroup initWithName:@"温湿度感应器" andDetail:@"" andEquipments:[NSMutableArray arrayWithObjects:equipment1,equipment2, nil]];
    [_equipmentarrs addObject:group1];
    
    Equipment *equipment3=[Equipment initWithName:@"客厅报警器" andStatus:@"1" andData:@"开"];
    Equipment *equipment4=[Equipment initWithName:@"房间报警器" andStatus:@"1" andData:@"开"];
    Equipment *equipment5=[Equipment initWithName:@"厨房报警器" andStatus:@"1" andData:@"关"];
    EquipmentGroup *group2=[EquipmentGroup initWithName:@"烟雾报警器" andDetail:@"" andEquipments:[NSMutableArray arrayWithObjects:equipment3,equipment4,equipment5, nil]];
    [_equipmentarrs addObject:group2];
    
    
    Equipment *equipment6=[Equipment initWithName:@"客厅灯" andStatus:@"1" andData:@"关"];
    Equipment *equipment7=[Equipment initWithName:@"房间灯" andStatus:@"1" andData:@"开"];
    Equipment *equipment8=[Equipment initWithName:@"厨房灯" andStatus:@"1" andData:@"开"];
    EquipmentGroup *group3=[EquipmentGroup initWithName:@"烟雾报警器" andDetail:@"" andEquipments:[NSMutableArray arrayWithObjects:equipment6,equipment7,equipment8, nil]];
    [_equipmentarrs addObject:group3];
    */
}


#pragma mark - 数据源方法
#pragma mark 返回分组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSLog(@"计算分组数");
    return _equipmentarrs.count;
}

#pragma mark 返回每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"计算每组(组%i)行数",section);
    EquipmentGroup *group1=_equipmentarrs[section];
    return group1.equipments.count;
}

#pragma mark返回每行的单元格
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSIndexPath是一个对象，记录了组和行信息
    NSLog(@"生成单元格(组：%i,行%i)",indexPath.section,indexPath.row);
    
    
    EquipmentGroup *group=_equipmentarrs[indexPath.section];
    Equipment *equipment=group.equipments[indexPath.row];
    

    //由于此方法调用十分频繁，cell的标示声明成静态变量有利于性能优化
    static NSString *cellIdentifier=@"UITableViewCellIdentifierKey1";
    static NSString *cellIdentifierForFirstRow=@"UITableViewCellIdentifierKeyWithSwitch";
    //首先根据标示去缓存池取
    UITableViewCell *cell;
    if ([equipment.status  isEqual: @"1"]) {
        cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifierForFirstRow];
    }else{
        cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    //如果缓存池没有取到则重新创建并放到缓存池中
    if(!cell){
        if ([equipment.status  isEqual: @"1"]) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifierForFirstRow];
            UISwitch *sw=[[UISwitch alloc]init];
            
            if([equipment.data isEqual: @"On"]){
                [sw setOn:YES animated:YES];
            }
            else{
                [sw setOn:NO animated:YES];
            }
            sw.tag = (indexPath.section * 1000 +indexPath.row);
            [sw addTarget:self action:@selector(switchValueChange:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView=sw;
            
        }else{
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
            cell.accessoryType=UITableViewCellAccessoryDetailButton;
        }
    }
    
    //if(indexPath.row==0){
    //    ((UISwitch *)cell.accessoryView).tag=indexPath.section;
    //}
    
    
    cell.textLabel.text=[equipment getName];
    cell.detailTextLabel.text = equipment.data;
    NSLog(@"cell:%@",cell);
    
    return cell;}

#pragma mark 返回每组头标题名称
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSLog(@"生成组（组%i）名称",section);
    EquipmentGroup *group=_equipmentarrs[section];
    return group.name;
}

#pragma mark 返回每组尾部说明
-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    NSLog(@"生成尾部（组%i）详情",section);
    EquipmentGroup *group=_equipmentarrs[section];
    return group.detail;
}

/*
#pragma mark 返回每组标题索引
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    NSLog(@"生成组索引");
    NSMutableArray *indexs=[[NSMutableArray alloc]init];
    for(EquipmentGroup *group in _equipmentarrs){
        [indexs addObject:group.name];
    }
    return indexs;
}
*/

#pragma mark - 代理方法
#pragma mark 设置分组标题内容高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==0){
        return 30;
    }
    return 40;
}

#pragma mark 设置每行高度（每行高度可以不一样）
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma mark 设置尾部说明内容高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

#pragma mark 点击行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _selectedIndexPath=indexPath;
    EquipmentGroup *group=_equipmentarrs[indexPath.section];
    Equipment *equipment=group.equipments[indexPath.row];
    
    //创建弹出窗口
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"System Info" message:[equipment getName] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alert.alertViewStyle=UIAlertViewStylePlainTextInput; //设置窗口内容样式
    UITextField *textField= [alert textFieldAtIndex:0]; //取得文本框
    textField.text=equipment.name; //设置文本框内容
    [alert show]; //显示窗口
}

#pragma mark 窗口的代理方法，用户保存数据
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //当点击了第二个按钮（OK）
    if (buttonIndex==1) {
        UITextField *textField= [alertView textFieldAtIndex:0];
        //修改模型数据
        EquipmentGroup *group=_equipmentarrs[_selectedIndexPath.section];
        Equipment *equipment=group.equipments[_selectedIndexPath.row];
        equipment.name=textField.text;
        //刷新表格
        NSArray *indexPaths=@[_selectedIndexPath];//需要局部刷新的单元格的组、行
        [_tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationLeft];//后面的参数代表更新时的动画
    }
}

#pragma mark 重写状态样式方法
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark 切换开关转化事件
-(void)switchValueChange:(UISwitch *)sw{
    NSLog(@"section:%i,switch:%i",sw.tag, sw.on);
    int section = sw.tag/1000;
    int row = sw.tag%1000;
    EquipmentGroup *group=_equipmentarrs[section];
    Equipment *equipment=group.equipments[row];
    if(sw.on)
    {
        equipment.data = @"On";
        //[sw setOn:YES animated:YES];
    }
    else
    {
        equipment.data = @"Off";
        //[sw setOn:NO animated:YES];
    }
    
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:(sw.tag%1000) inSection:(sw.tag/1000)];
    UITableViewCell *cell = [self tableView:_tableView cellForRowAtIndexPath:indexpath];
    //cell.detailTextLabel.text = @"1";
    
    NSLog(@"%d, %d", (sw.tag%1000), (sw.tag/1000));
    NSArray *index = @[indexpath];
    
    [_tableView reloadRowsAtIndexPaths:index withRowAnimation:UITableViewRowAnimationLeft];
    sw.tag = (section*1000 + row);
    NSLog(@"%@", equipment.data);
    
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
