//
//  ViewController.m
//  HMReachability
//
//  Created by humiao on 2019/7/14.
//  Copyright © 2019 humiao. All rights reserved.
//

#import "ViewController.h"
#import "HMReachability.h"

@interface ViewController ()
@property  (nonatomic, strong)HMReachability *hostReachability;

@property  (nonatomic, strong)HMReachability *routerReachability;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Reachability使用了通知，当网络状态发生变化时发送通知kReachabilityChangedNotification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appReachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    // 检测指定服务器是否可达
    NSString *remoteHostName = @"www.bing.com";
    self.hostReachability = [HMReachability reachabilityWithHostName:remoteHostName];
    [self.hostReachability startNotifier];
    // 检测默认路由是否可达
    self.routerReachability = [HMReachability reachabilityForInternetConnection];
    [self.routerReachability startNotifier];
}

/// 当网络状态发生变化时调用
- (void)appReachabilityChanged:(NSNotification *)notification{
    HMReachability *reach = [notification object];
    if([reach isKindOfClass:[HMReachability class]]){
        NetworkStatus status = [reach currentReachabilityStatus];
        // 两种检测:路由与服务器是否可达  三种状态:手机流量联网、WiFi联网、没有联网
        if (reach == self.routerReachability) {
            if (status == NotReachable) {
                NSLog(@"routerReachability NotReachable");
            } else if (status == ReachableViaWiFi) {
                NSLog(@"routerReachability ReachableViaWiFi");
            } else if (status == ReachableViaWWAN) {
                NSLog(@"routerReachability ReachableViaWWAN");
            }
        }
        if (reach == self.hostReachability) {
            NSLog(@"hostReachability");
            if ([reach currentReachabilityStatus] == NotReachable) {
                NSLog(@"hostReachability failed");
            } else if (status == ReachableViaWiFi) {
                NSLog(@"hostReachability ReachableViaWiFi");
            } else if (status == ReachableViaWWAN) {
                NSLog(@"hostReachability ReachableViaWWAN");
            }
        }
        
    }
}
/// 取消通知
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

@end
