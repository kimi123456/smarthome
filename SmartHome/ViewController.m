//
//  ViewController.m
//  SmartHome
//
//  Created by kimi on 15/10/10.
//  Copyright © 2015年 kimi. All rights reserved.
//

#import "ViewController.h"
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
#include <pthread.h>


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *fire;
@end

/*
int sockfd = -1;
int error = 0;
int flag = 0;
char *duid = "kimi123456";
int res = 0;
void * msg = NULL;
*/
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //connectServer(duid, &sockfd, &flag, &error);
    /*
    dispatch_queue_t serialQueue=dispatch_queue_create("myThreadQueue1", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(serialQueue, ^{
        [self keep_live1];
    });
     */
}
/*
-(void)callFire{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
    
}

-(void)connectSev1{
    connectServer(duid, &sockfd, &flag, &error);
};

-(void)keep_live1{
    keep_live(&sockfd);
};

-(void)disConnect1{
    disConnect(&sockfd);
};

- (IBAction)Connect:(id)sender {
    
    dispatch_queue_t serialQueue=dispatch_queue_create("myThreadQueue2", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t main_queue= dispatch_get_main_queue();
    
    dispatch_async(serialQueue, ^{
       
    char recvBuff[256] = {0,};
    int result;
    int msg;
        
    while(1)
    {

        if((result = read(sockfd, recvBuff, 256)) < 0)
        {
            printf("[recvMsg2]read message failed, %s\n", strerror(errno));
            exit(EXIT_FAILURE);
        }
        
        if(strlen(recvBuff) > 0)
        {
            msg = atoi(recvBuff);
            printf("[recvMsg2]get msg from server: %d\n", msg);
        }
        if(msg == 9999)
        {
            dispatch_sync(main_queue, ^{
                NSLog(@"Fire!");
                self.fire.text = @ "Fire!";
            });
            
        }
        else
        {
            dispatch_sync(main_queue, ^{
                NSLog(@"No Fire!");
                self.fire.text = @ "No Fire!";
            });
        }
    }
        
        //[self recvMsg1];
        /*
        int res = recvMsg3(&sockfd);
        if(res == 9999)
        {
            dispatch_sync(main_queue, ^{
                    NSLog(@"Fire!");
                    self.fire.text = @ "Fire!";
            });

        }
        else
        {
            dispatch_sync(main_queue, ^{
                NSLog(@"No Fire!");
                self.fire.text = @ "No Fire!";
            });
        }*/
    //});
    
    
    
    
    /*
    connectServer(duid, &sockfd, &flag, &error);
    printf("%d, %d, %d.\n", sockfd, flag, error);
    
    pthread_t thread[2];
    res = pthread_create(&thread[0], NULL, (void *)keep_live, &sockfd);
    if(res != 0)
    {
        printf("Thread1 create failed!");
    }
    
    res = pthread_create(&thread[1], NULL, (void *)recvMsg2, &sockfd);
    if(res != 0)
    {
        printf("Thread2 create failed!");
    }
    pthread_join(thread[1], &msg);
    
    if((int)msg == 9999)
    {
        self.fire.text = @ "Fire!";
    }
    
    if(msg != NULL)
    {
        printf("msg: %d. \n", (int)msg);
        msg = NULL;
        
        pthread_t p;
        res = pthread_create(&p, NULL, (void *)recvMsg2, &sockfd);
        if(res != 0)
        {
            printf("thread create failed!");
        }
        pthread_join(p, &msg);
    }
    
    pthread_exit(NULL);
     */

//}



/*
- (IBAction)disconnect:(id)sender {
    disConnect(&sockfd);
}*/
@end
