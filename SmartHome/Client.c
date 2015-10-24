//
//  Client.c
//  socket
//
//  Created by kimi on 15/7/21.
//  Copyright (c) 2015年 kimi. All rights reserved.
//

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
#include "Client.h"
#include "OC2C.h"

void sendMsg(int *sockfd, int *error, char* sendMsgs)
{
    char sendBuff[256] = {0,};
    //sprintf(sendBuff, "%d", 99);
    strcat(sendBuff, sendMsgs);
    long result;
    
    printf("[sendMsg]send msg to server: %s\n", sendBuff);
    if((result = send(*sockfd,sendBuff,255,0)) < 0)
    {
        *error = errno;
        printf("[sendMsg]send message failed, %s\n", strerror(errno));
        exit(EXIT_FAILURE);
    }
}

void recvMsg(int *sockfd, int *error, int *recvMsg)
{
    char recvBuff[256] = {0,};
    long result;
    
    if((result = read(*sockfd, recvBuff, 256)) < 0)
    {
        *error = errno;
        printf("[recvMsg]read message failed, %s\n", strerror(errno));
        exit(EXIT_FAILURE);
    }
    
    if(strlen(recvBuff) > 0)
    {
        *recvMsg = atoi(recvBuff);
        printf("[recvMsg]get msg from server: %d\n", *recvMsg);
    }
}

void *recvMsg2(int *sockfd)
{
    char recvBuff[256] = {0,};
    long result;
    int msg;
    
    if((result = read(*sockfd, recvBuff, 256)) < 0)
    {
        printf("[recvMsg2]read message failed, %s\n", strerror(errno));
        exit(EXIT_FAILURE);
    }
    
    if(strlen(recvBuff) > 0)
    {
        msg = atoi(recvBuff);
        printf("[recvMsg2]get msg from server: %d\n", msg);
    }
    
    return (void *)msg;
    //pthread_exit((void *)msg);
}

void disConnect(int *sockfd)
{
    if(close(*sockfd) < 0)
    {
        //*error = errno;
        printf("[disConnect]disConnect failed, %s\n", strerror(errno));
        exit(EXIT_FAILURE);
    }
    
    *sockfd = -1;
}

void keep_live(int *sockfd)
{
    fd_set rfds;
    struct timeval tv;
    int retval, maxfd = -1;
    long result;
    
    while(1)
    {
        FD_ZERO(&rfds);
        FD_SET(*sockfd, &rfds);
        maxfd = 0;

        if(*sockfd > maxfd)
        {
            maxfd = *sockfd;
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
            char sendBuff[256] = {0,};
            sprintf(sendBuff, "%d", 1);
            
            
            printf("[sendMsg]send msg to server: %s\n", sendBuff);
            if((result = send(*sockfd,sendBuff,255,0)) < 0)
            {
                printf("[sendMsg]send message failed, %s\n", strerror(errno));
                break;
            }
            continue;
        }
        else
        {
            if(FD_ISSET(*sockfd, &rfds))
            {
                char recvBuff[256] = {0,};
                
                if((result = read(*sockfd, recvBuff, 256)) <= 0)
                {
                    printf("[recvMsg]read message failed, %s\n", strerror(errno));
                    break;
                }
            }
            continue;
        }
    }

    disConnect(sockfd);
}


void connectServer(char* UUID, int *sockfd, int *flag, int *error)
{
    int len;
    struct sockaddr_in address;
    int result;
    
    char server_hostname[] = "tonyvanhawk.xicp.net";
    struct hostent* server_hostent;
    server_hostent = gethostbyname( server_hostname );

    if((*sockfd = socket(AF_INET, SOCK_STREAM, 0)) == -1)
    {
        *error = errno;
        printf("[connectServer]socket failed, %s\n", strerror(errno));
        return;
        //exit(EXIT_FAILURE);
    }

    memset(&address, 0, sizeof(address));
    
    address.sin_family = AF_INET;
    address.sin_port = htons(1080);
    address.sin_addr = *((struct in_addr *)server_hostent->h_addr);

    len = sizeof(address);
    
    if((result = connect(*sockfd, (struct sockaddr *)&address, len)) == -1)
    {
        *error = errno;
        printf("[connectServer]connect failed, %s\n", strerror(errno));
        return;
        //exit(EXIT_FAILURE);
    }
    
    if(*flag == 0)
    {
        sendMsg(sockfd, error, UUID);
        recvMsg(sockfd, error, flag);
    }
}

/*
int main()
{
    int sockfd = -1;
    int error = 0;
    int flag = 0;
    char *duid = "kimi123456";
    int res = 0;
    void * msg = NULL;

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
    
    while(msg != NULL)
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
}

*/
