//
//  ViewController.m
//  PlistReader
//
//  Created by fengyi on 2018/11/30.
//  Copyright © 2018 fengyi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) NSArray *totalList;
@property (strong, nonatomic) NSMutableArray *indexList;
@property (assign, nonatomic) BOOL notEnoughWords;
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
            // 造词后index自增
            [self add];
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

#pragma mark 初始化造词数据
- (void)initNameData
{
    // 动词 形容词 名词 名词 4组词语依次混搭，如：查询 新 用户 信息
    NSArray *list1 = @[@"yw_request", @"yw_delete", @"yw_creat", @"yw_update", @"yw_show", @"yw_query", @"yw_search", @"yw_make", @"yw_refresh"];
    NSArray *list2 = @[@"", @"New", @"Old", @"Temp", @"Some", @"the"];
    NSArray *list3 = @[@"User", @"Device", @"Group", @"Member", @"Family", @"IPC", @"DoorLock", @"CenterControl"];
    NSArray *list4 = @[@"Info", @"Status", @"Attribute", @"Data"];
    
    _totalList = @[list1, list2, list3, list4];
    _indexList = [@[@0, @0, @0, @0] mutableCopy];
}

#pragma mark 累加\进位
- (void)add
{
    __block BOOL j = 1;
    [_indexList enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger i, BOOL * _Nonnull stop) {
       
        // 单组序号
        NSInteger index = [self.indexList[i] integerValue];
        // 单组总数
        NSInteger count = [self.totalList[i] count];
//        NSLog(@"第%ld组 序号：%ld", i, index);
        if (j == 1) {
            // 消耗一次进位
            j = 0;
            //=========== 累加 ===========
            // 第0位只累加不循环
            if (i == 0) {
                self.indexList[i] = @(index + 1);
            }
            // 其余位在count范围内循环累加
            else
            {
                self.indexList[i] = @((index + 1) % count);
            }
            
            //=========== 进位 ===========
            // 正常进位
            if (i != 0 && index == 0)
            {
                j = 1;
            }
            // 第0位进位则结束
            else if (i == 0 && index == count - 1)
            {
                self.notEnoughWords = YES;
                *stop = YES;
            }
        }
    }];
}

#pragma mark 取名造词
- (NSString *)makeName
{
    if (!self.notEnoughWords)
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
//        NSLog(@"CXHLog:词穷了");
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
