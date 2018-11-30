//
//  ViewController.m
//  PlistReader
//
//  Created by fengyi on 2018/11/30.
//  Copyright © 2018 fengyi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNameData];
    
    // 首先要在工程里放一个plist文件
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"code" ofType:@"plist"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    // 给key取得名字
    NSString *totalStr = dic[@"theKey"];
    NSString *newTotalString = @"";
    NSArray *allLines = [totalStr componentsSeparatedByString:@"\n"];

    // 一整行的#define
    int i = 0;
    for (NSString *oneLine in allLines) {
        
        // 用空格分割成3份
        NSArray *threeWords = [oneLine componentsSeparatedByString:@" "];
        if (threeWords.count == 3) {
            // 给第3节重新造词
            NSString *thirdWord = [NSString stringWithFormat:@"%@",[self makeName]];
            // 拼接3部分
            NSString *newLine = [NSString stringWithFormat:@"%@ %@ %@\n",threeWords[0], threeWords[1], thirdWord];
            // 拼接文件内容
            newTotalString = [newTotalString stringByAppendingString:newLine];
        }
        else
        {
            NSLog(@"CXHLog:混入了奇怪的东西%@", threeWords);
        }
        
        i++;
    }
    NSLog(@"CXHLog:%@", newTotalString);
    
    NSDictionary *writeDic = @{
                          @"newKey" : newTotalString
                          };
    [self creatNewFile:writeDic];
}

NSArray *_list1;
NSArray *_list2;
NSArray *_list3;
NSArray *_list4;
NSArray *_totalList;
NSMutableArray *_indexList;

#pragma mark 初始化造词数据
- (void)initNameData
{
    
    // 动词 形容词 名词 名词 4组词语依次混搭，如：查询 新 用户 信息
    _list1 = @[@"request", @"delete", @"creat"];
    _list2 = @[@"", @"new", @"old", @"temp"];
    _list3 = @[@"user", @"device", @"group"];
    _list4 = @[@"info", @"status", @"attribute"];
    
    _totalList = @[_list1, _list2, _list3, _list4];
    _indexList = [@[@0, @0, @0, @0] mutableCopy];
}

#pragma mark 判断词穷+进位
- (BOOL)notEnoughWords
{
    __block BOOL notEnoughWords = 1;
    [_indexList enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger i, BOOL * _Nonnull stop) {
        
            int index = [obj intValue];
            // 没用完
            if (index < [_totalList[i] count])
            {
                notEnoughWords = 0;
                _indexList[i] = @(index + 1);
            }
            // 一组词已用完一轮
            else
            {
                // 进位
                if (![obj isEqual:[_indexList firstObject]])
                {
                    NSNumber *forword = _indexList[i-1];
                    forword = @([forword integerValue] + 1);
                    obj = @0;
                    
                    NSLog(@"CXHLog:检查进位是否成功%@", _indexList);
                }
                // 当第一组词也用完了，就词穷了
                else
                {
                    notEnoughWords = 1;
                }
            }
    }];
    return notEnoughWords;
}

#pragma mark 取名造词
- (NSString *)makeName
{
    if (![self notEnoughWords])
    {
        // 依次
        NSMutableString *mStr = [@"" mutableCopy];
        int i = 0;
        for (NSArray *list in _totalList) {
            int n = [_indexList[i] intValue];
            // 第i组的第n个词
            NSString *str = [list objectAtIndex:n];
            [mStr appendString:str];// 拼接造词
            i++;
        }
        return mStr;
    }
    else
    {
        NSLog(@"CXHLog:词穷了");
        return @"词穷了";
    }
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
