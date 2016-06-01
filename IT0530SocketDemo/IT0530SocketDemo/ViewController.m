//
//  ViewController.m
//  IT0530SocketDemo
//
//  Created by student on 16/5/30.
//  Copyright © 2016年 许. All rights reserved.
//

#import "ViewController.h"

//1.1首先要导入要使用的通信asyncSocket中默认是TCP
#import "AsyncSocket.h"

//1.2因为socket 通信需要通信双发，即C/S C只要知道了S的IP和端口号，就能通信
#define HOST_IP @"127.0.0.1"
#define HOST_PORT 8888

//大小端 服务器
/**
 *  大端：较高的有效字节存放在内存较低的存储器地址中，较低的有效字节存放在内存较高的存储器的地址中
 *  小端：低的就在低的，高的就在高的
 */

//苹果是采用  小段模式

//1.3增加回调协议 也就是AsyncCocketDelegate
@interface ViewController ()<AsyncSocketDelegate>{
  //1.4声明一个asyncSocket 对象用于与S通信
  AsyncSocket  *_clientSocket;
  
}

//1.5创建连接
- (void)connectS:(NSString *)hostIP Port:(int)hostPort;


@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  //1.6
  UIButton *connect = [UIButton buttonWithType:UIButtonTypeCustom];
  connect.frame = CGRectMake(100, 100, 100, 100);
  [connect addTarget:self action:@selector(connectEvent) forControlEvents:UIControlEventTouchUpInside];
  connect.backgroundColor = [UIColor redColor];
  [self.view addSubview:connect];
  
  
  UIButton *send = [UIButton buttonWithType:UIButtonTypeCustom];
  send.frame = CGRectMake(100, 300, 100, 100);
  [send addTarget:self action:@selector(sendEvent) forControlEvents:UIControlEventTouchUpInside];
  send.backgroundColor = [UIColor redColor];
  [self.view addSubview:send];
}
//1.7 建立连接
- (void)connectEvent {
  [self connectS:HOST_IP Port:HOST_PORT];
}
//1.7.1
- (void)connectS:(NSString *)hostIP Port:(int)hostPort {
  if (!_clientSocket) {//如果没有socket
    _clientSocket = [[AsyncSocket alloc] initWithDelegate:self];
    //1.7.3联机
    NSError *error = nil;
    BOOL ret = [_clientSocket connectToHost:hostIP onPort:hostPort withTimeout:20 error:&error];
    if (ret) {//通了
      NSLog(@"Connect OK");
    }else{//不通
      NSLog(@"error : %@",error.localizedDescription);
    }
  }else{//有socket
    //等 等 有消息 只去读
    [_clientSocket readDataWithTimeout:-1 tag:0];
  }
}
//1.8 发消息
- (void)sendEvent {
  //首先要判断 有没有socket
  if (!_clientSocket) {
    
    return;
  }
  NSString *string = @"中国 Hello World";
  NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
  //发数据
  [_clientSocket writeData:data withTimeout:-0 tag:0];
}
- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - AsyncSocket Delegate
//1.9
//连接成功之后 客户端进入接收模式
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port {
  [sock readDataWithTimeout:-1 tag:0];
}

//已经断开连接
- (void)onSocketDidDisconnect:(AsyncSocket *)sock {
  _clientSocket = nil;
}

//将要断开连接
- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err {
  NSLog(@"error : %@",err.localizedDescription);
}

//收到数据并解析
- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
  NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
  NSLog(@"接收到的数据 : %@",str);
  [sock readDataWithTimeout:-1 tag:0];
}

@end











