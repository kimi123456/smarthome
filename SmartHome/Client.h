//
//  Client.h
//  SmartHome
//
//  Created by kimi on 15/10/10.
//  Copyright © 2015年 kimi. All rights reserved.
//

#ifndef Client_h
#define Client_h

void sendMsg(int *sockfd, int *error, char* sendMsgs);
void recvMsg(int *sockfd, int *error, int *recvMsg);

void *recvMsg2(int *sockfd);
int recvMsg3(int *sockfd);
void connectServer(char* UUID, int *sockfd, int *flag, int *error);

void disConnect(int *sockfd);
void keep_live(int *sockfd);

#endif /* Client_h */
