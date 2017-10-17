//
//  ViewController.m
//  DataPersistence
//
//  Created by Arthur on 2017/10/17.
//  Copyright © 2017年 Arthur. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //1.plist文件，将字典写入沙河中
    NSDictionary *dic = @{@"name" : @"xujiapeng"};

    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"test.plist"];
    NSLog(@"%@",filePath);
    //写入沙河中
    [dic writeToFile:filePath atomically:YES];
    
    //读取沙河中
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSLog(@"%@",dict);
    
    
    //2.perference偏好设置
    //登录成功设置isLogin为YES
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogin"];
    //退出登录设置isLogin为NO
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogin"];
    
    //判断是否是第一次登录
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"isFirst"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isFirst"];
        NSLog(@"我以后不会出来了");
    }else {
        NSLog(@"第二次我出来了");
    }
    
    //3.NSKeyedArchiver归档、NSKeyedUnarchiver解档
    NSString *documentPath1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *filePath1 = [documentPath1 stringByAppendingPathComponent:@"test"];
    [NSKeyedArchiver archiveRootObject:@"test" toFile:filePath1];
    
    NSString *result = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath1];
    NSLog(@"%@",result);
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
