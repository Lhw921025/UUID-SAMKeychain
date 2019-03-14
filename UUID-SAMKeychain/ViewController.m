//
//  ViewController.m
//  UUID-SAMKeychain
//
//  Created by 刘红伟 on 2019/3/8.
//  Copyright © 2019 刘红伟. All rights reserved.
//

#import "ViewController.h"
#import <SAMKeychain.h>
#import <SAMKeychainQuery.h>
static NSString * const kKeychainService = @"daren.UUID-SAMKeychain";

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 100, 200, 40)];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"获取" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(20, 160, 200, 40)];
    btn1.backgroundColor = [UIColor redColor];
    [btn1 setTitle:@"新增" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];

    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(20, 220, 200, 40)];
    btn2.backgroundColor = [UIColor redColor];
    [btn2 setTitle:@"删除" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
}
- (void)click{
    NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];//获得本应用的bundle ID
    NSLog(@"bundle id = %@", bundleID);

    NSError *error = nil;
    [SAMKeychain passwordForService:kKeychainService account:bundleID error: &error];
    if([error code] == SAMKeychainErrorBadArguments){
        NSLog(@"无密码");
        [SAMKeychain setAccessibilityType:kSecAttrAccessibleWhenUnlockedThisDeviceOnly];//设置该密码的权限只有在手机解锁、此台设备才可获得。
        [SAMKeychain setPassword:[self getDeviceId] forService:bundleID account:bundleID];
    }
    else {
        NSLog(@"密码是 %@", [SAMKeychain passwordForService:kKeychainService account:bundleID]);
        
        NSLog(@"包含密钥链帐户的数组----%@",[SAMKeychain allAccounts]);
        
        NSLog(@"包含密钥链帐户的数组----%@",[SAMKeychain accountsForService:bundleID]);
        SAMKeychainQuery *sam = [[SAMKeychainQuery alloc] init];
        NSLog(@"获取与给定帐户、服务和访问组匹配的所有密钥链项----%@",[sam fetchAll:&error]);
    }
}
- (void)btnClick{
    NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];//获得本应用的bundle ID
    [SAMKeychain setPassword:[self getDeviceId] forService:kKeychainService account:bundleID];
}
- (void)buttonClick{
    NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];//获得本应用的bundle ID
    NSLog(@"bundle id = %@", bundleID);
    if ([SAMKeychain deletePasswordForService:kKeychainService account:bundleID]) {
        NSLog(@"删除成功");
    }

}
/**
 * 这个方法返回 UUID
 */
- (NSString *)getDeviceId {
    NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];//获得本应用的bundle ID
    // 读取设备号
    NSString *localDeviceId = [SAMKeychain passwordForService:kKeychainService account:bundleID];
    if (!localDeviceId) {
        // 如果没有UUID 则保存设备号
        CFUUIDRef deviceId = CFUUIDCreate(NULL);
        assert(deviceId != NULL);
        CFStringRef deviceIdStr = CFUUIDCreateString(NULL, deviceId);

        [SAMKeychain setAccessibilityType:kSecAttrAccessibleWhenUnlockedThisDeviceOnly];//设置该密码的权限只有在手机解锁、此台设备才可获得。
        [SAMKeychain setPassword:[NSString stringWithFormat:@"%@", deviceIdStr] forService:kKeychainService account:bundleID];

        localDeviceId = [NSString stringWithFormat:@"%@", deviceIdStr];
    }
    return localDeviceId;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
