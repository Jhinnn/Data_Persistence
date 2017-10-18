//
//  ViewController.m
//  DataPersistence
//
//  Created by Arthur on 2017/10/17.
//  Copyright © 2017年 Arthur. All rights reserved.
//

#import "ViewController.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
@interface ViewController ()

@end

@implementation ViewController {
    
}

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
    
    
    //4.sqlite
    NSString *documentPath2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *filePath2 = [documentPath2 stringByAppendingPathComponent:@"test.sqlite"];
    
    FMDatabase *db = [FMDatabase databaseWithPath:filePath2];
    if (db.open) {
        
        //create table if not exists t_student (id integer pirmary key autoincrement, name text, age integer)
        BOOL success = [db executeUpdate:@"create table if not exists t_person (id integer primary key autoincrement, name text, age integer)"];
        if (success) {
            NSLog(@"创建表成功！");
        }else {
            NSLog(@"创建表失败");
        }
    }else {
        NSLog(@"打开失败");
    }
    
    //"insert into t_person (name, age) value(?,?)",@"jack",@17
    [db executeUpdate:@"insert into t_person(name,age) values(?,?)",@"jack",@17];

    [db executeUpdate:@"update t_person set name = 'xujiapeng' where age = 17"];
    
    
    FMResultSet *set  = [db executeQuery:@"select id,name,age from t_person"];
    while (set.next) {
        int id = [set intForColumnIndex:0];
        NSString *name = [set stringForColumnIndex:1];
        int age = [set intForColumnIndex:2];
        
        NSLog(@"%d,%@,%d",id,name,age);
        
    }
    
    //drop table if exists t_person
    [db executeUpdate:@"delete from t_person where name = 'xujiapeng'"];
    
    FMResultSet *set1  = [db executeQuery:@"select id,name,age from t_person"];
    while (set1.next) {
        int id = [set1 intForColumnIndex:0];
        NSString *name = [set1 stringForColumnIndex:1];
        int age = [set1 intForColumnIndex:2];
        
        NSLog(@"%d,%@,%d",id,name,age);
        
    }
    
    //FMDatabase是线程不安全的，当FMDB数据存储想要使用多线程的时候，FMDatabaseQueue就派上用场了。
    [self FMDBdatabaseQueueFunction];
    
}

- (void)FMDBdatabaseQueueFunction {
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *path = [documentPath stringByAppendingPathComponent:@"student.sqlite"];
    
    FMDatabaseQueue *dbQueue = [FMDatabaseQueue databaseQueueWithPath:path];
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"create table if not exists t_student (id integer primary key autoincrement, name text, age integer)"];
        [db executeQuery:@"insert into t_student(name,age) values(?,?)",@"xujiapeng",@26];
        [db executeQuery:@"insert into t_student(name,age) values(?,?)",@"yangdan",@25];
        
        FMResultSet *set = [db executeQuery:@"select id,name,age from t_student"];
        while (set.next) {
            int id = [set intForColumnIndex:0];
            NSString *name = [set stringForColumnIndex:1];
            int age = [set intForColumnIndex:2];
            NSLog(@"------%d, %@, %d",id,name,age);
        }
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
