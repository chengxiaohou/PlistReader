//
//  StoryboardVC.m
//  PlistReader
//
//  Created by 橙晓侯 on 2019/3/3.
//  Copyright © 2019 fengyi. All rights reserved.
//

#import "StoryboardVC.h"

@interface StoryboardVC ()

@end

@implementation StoryboardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self step1];
    
}

#pragma mark 步骤一
- (void)step1
{
    // 首先要在工程里放一个plist文件
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"code" ofType:@"plist"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    // 给key取得名字
    NSString *totalStr = dic[@"theStoryboardCode"];
    [self step2:[totalStr mutableCopy]];
}

#pragma mark 步骤二
- (void)step2:(NSMutableString *)code
{
    // 首先要在工程里放一个plist文件
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"code" ofType:@"plist"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    // 给key取得名字
    NSString *totalStr = dic[@"theKey"];
    NSArray *allLines = [totalStr componentsSeparatedByString:@"\n"];
    
    // 一整行的#define
    int i = 0;
    for (NSString *oneLine in allLines) {
        
        // 用空格分割成3份
        NSArray *threeWords = [oneLine componentsSeparatedByString:@" "];
        if (threeWords.count == 3)
        {
            NSString *oldString = threeWords[1];
            NSString *newString = threeWords[2];
            NSRange range = NSMakeRange(0, code.length);
            [code replaceOccurrencesOfString:oldString withString:newString options:NSBackwardsSearch range:range];
        }
        i++;
    }
    NSLog(@"CXHLog:\n\n\n\n%@", code);
    
    NSDictionary *writeDic = @{
                               @"NewStoryboardCode" : code
                               };
    [self creatNewFile:writeDic];
    
}

#pragma mark 写文件
- (void)creatNewFile:(NSDictionary *)dic
{
    //获取本地沙盒路径
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    //获取完整路径
    NSString *documentsPath = [path objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"MY_PropertyList.plist"];
    
    //写入文件
    [dic writeToFile:plistPath atomically:YES];
    
    NSLog(@"CXHLog:输出地址：%@", plistPath);// 用模拟器运行，在finder里面找
}


@end
