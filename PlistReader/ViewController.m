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
@property (weak, nonatomic) IBOutlet UITextField *subTF;
@property (weak, nonatomic) IBOutlet UITextView *leftTV;
@property (weak, nonatomic) IBOutlet UITextView *rightTV;
/** 造词库 */
@property (strong, nonatomic) NSMutableArray *words;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

//- (void)test {
//    [self initNameData];
//}
- (IBAction)onBegin:(id)sender {
    
    [self begin];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:1];
}

#pragma mark 执行
- (void)begin
{
    [self initNameData];
    /**
    
     // 首先要在工程里放一个plist文件
     NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"code" ofType:@"plist"];
     NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
     // 给key取得名字
     NSString *totalStr = dic[@"theKey"];
     
     */
    
    NSString *totalStr = _leftTV.text;
    NSString *newTotalString = @"";
    NSArray *allLines = [totalStr componentsSeparatedByString:@"\n"];
    // 新版本 3行才定义一个宏
    if (allLines.count/3 > _words.count) {
        NSLog(@"CXHLog:⚠️⚠️⚠️词库不足：%ld > %ld", allLines.count, _words.count);
    }
    // 取宏定义的每一行文字
    int i = 0;
    for (NSString *oneLine in allLines) {
        
        // ---------- 将关键行用空格分割成3份 ----------
        NSArray *threeWords = [oneLine componentsSeparatedByString:@" "];
        NSInteger lastIndex = threeWords.count-1;
        if ([oneLine containsString:@"#define"]) {
            NSString *newLine;
            // 词库充足
            if (i < _words.count) {
                // 给第3节重新造词
                NSString *thirdWord = [NSString stringWithFormat:@"%@", _words[i]];
                // 造词后index自增
                [self readyForNext];
                //_______________________________________________________________________________________________________________
                
                // 使用自造词拼接
                if (1) {
                    newLine = [NSString stringWithFormat:@"%@ %@ %@\n",threeWords[lastIndex-2], threeWords[lastIndex-1], thirdWord];
                }
                // 只修改函数名的前缀
                else
                {
                    newLine = [NSString stringWithFormat:@"%@ %@ MH_%@\n",threeWords[lastIndex-2], threeWords[lastIndex-1], threeWords[lastIndex-1]];
                }
            }
            // 拼接文件内容
            newTotalString = [newTotalString stringByAppendingString:newLine];
            i++;
            // NSLog(@"CXHLog:生成结果预览：%@", newLine);
        }
        // 原封不动保留的行
        else if ([oneLine containsString:@"#ifndef"] || [oneLine containsString:@"#endif"])
        {
            newTotalString = [newTotalString stringByAppendingString:[NSString stringWithFormat:@"%@\n",oneLine]];// 拼接
        }
        else
        {
            NSLog(@"CXHLog:混入了奇怪的东西%@", threeWords);
        }
        
    }
    
    /**
     // 以前用的写文件的方式
     NSDictionary *writeDic = @{
     @"newKey" : newTotalString
     };
     [self creatNewFile:writeDic];
     */
    
    _rightTV.text = newTotalString;
}


#pragma mark 初始化造词数据
- (void)initNameData
{
    // 动词+形容词+名词+名词，4组词语依次混搭，如：查询 新 用户 信息
//    NSArray *list1 = @[@"request", @"delete", @"creat", @"update", @"show", @"query", @"search", @"make", @"refresh", @"get", @"save", @"download", @"reset", @"load", @"send", @"modify", @"bind", @"unbind", @"add", @"batch", @"init", @"config", @"parse", @"find"];
//    NSArray *list2 = @[@"", @"New", @"Old", @"Temp", @"Some", @"The", @"Full", @"Total", @"All", @"Free", @"Vip", @"Hot", @"Online", @"Offline"];
//    NSArray *list3 = @[@"User", @"Device", @"Group", @"Member", @"Family", @"IPC", @"DoorLock", @"CenterControl", @"DoorBell", @"SmartDoor", @"Sensor", @"Friend"];
//    NSArray *list4 = @[@"Info", @"Status", @"Attribute", @"Data", @"ID", @"TypeID", @"Token", @"List", @"Dic", @"Config", @"Name"];
    NSString *sub = _subTF.text;
    
    NSArray *list1 = @[@"request", @"delete", @"creat", @"update", @"show", @"query", @"search", @"make", @"refresh", @"get", @"save", @"download", @"reset", @"load", @"send", @"modify", @"bind", @"unbind", @"add", @"batch", @"init", @"config", @"parse", @"find"];
    NSArray *list2 = @[@"", @"New", @"Old", @"Temp", @"Some", @"The", @"Full", @"Total", @"All", @"Free", @"Vip", @"Hot", @"Online", @"Offline"];
    NSArray *list3 = @[@"User", @"Device", @"Group", @"Member", @"Friend", @"Goods", @"Payment", @"Cache", @"Order"];
    NSArray *list4 = @[@"Info", @"Status", @"Attribute", @"Data", @"ID", @"TypeID", @"Token", @"List", @"Dic", @"Config", @"Name"];
    
    NSMutableArray *tempList = [NSMutableArray new];
    for (NSString *str in list1) {
        NSString *newStr = [NSString stringWithFormat:@"%@_%@",sub, str];
        [tempList addObject:newStr];
    }
    list1 = tempList;
    
    _totalList = @[list1, list2, list3, list4];
    _indexList = [@[@0, @0, @0, @0] mutableCopy];
    _words = [@[] mutableCopy];
    
    // 生成词库
    NSMutableArray *tempArr = [@[] mutableCopy];
    while (!_notEnoughWords) {
        
        [tempArr addObject:[self makeName]];
        [self readyForNext];
    }
    
    NSLog(@"CXHLog:词库总数 %ld", tempArr.count);
    
    NSLog(@"CXHLog:乱序排列中...");
    // 打乱顺序
    while (tempArr.count > 0) {
        NSInteger count = tempArr.count - 1;
        int random = count == 0 ? 0 : arc4random()%(count);// 剩下最后一个则取0，其余随机
        NSString *word = tempArr[random];
        [_words addObject:word];
        [tempArr removeObject:word];
    }
}

#pragma mark 累加\进位
- (void)readyForNext
{
    if (self.notEnoughWords == YES) return;
    
//    NSLog(@"\n");
    __block BOOL j = 1;
    [_indexList enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger i, BOOL * _Nonnull stop) {
       
        // 单组序号
        NSInteger index = [self.indexList[i] integerValue];
        // 单组进制数
        NSInteger count = [self.totalList[i] count] - 1;
        
//        NSLog(@"%ld: %ld/%ld", i, index, (long)count);
        // 执行进位
        if (j == 1) {
            // 消耗一次进位
            j = 0;
            //=========== 累加 ===========
            self.indexList[i] = @(index + 1);
            //=========== 计算下次进位情况 ===========
            // 非第0位，下次需进位
            if (i != 0 && index == count)
            {
                j = 1;
                self.indexList[i] = @(0);// 进位归零
            }
            // 第0位进位则结束
            else if (i == 0 && index == count)
            {
                NSLog(@"CXHLog:结束===================");
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
//        NSLog(@"造");
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
        return @"词库不足";
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
    
    NSLog(@"CXHLog:输出地址：\n\n%@", plistPath);// 用模拟器运行，在finder里面找
}


@end
