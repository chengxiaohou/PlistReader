//
//  PlistReaderTests.m
//  PlistReaderTests
//
//  Created by fengyi on 2018/11/30.
//  Copyright © 2018 fengyi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ViewController.h"


@interface PlistReaderTests : XCTestCase

@property (assign, nonatomic) int index;

@end

@implementation PlistReaderTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    NSLog(@"CXHLog:+++++++ setUp");
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    NSLog(@"CXHLog:------- tearDown");
}


- (void)testPerformanceExample {
    
    [self measureBlock:^{
        
//        ViewController *vc = [ViewController new];
//        [vc test];
//        NSLog(@"CXHLog:%@", vc);
//        [vc initNameData];
        
    }];
}

- (void)testA {
    NSLog(@"CXHLog:A %d", _index);
    _index = 1;
    NSLog(@"CXHLog:A %d", _index);
}

- (void)testB {
//    ViewController *vc = [ViewController new];
//    [vc test];
    NSLog(@"CXHLog:B %d", _index);
    _index = 2;
    NSLog(@"CXHLog:B %d", _index);

}

- (void)testC {
    NSLog(@"CXHLog:C %d", _index);
    _index = 3;
    NSLog(@"CXHLog:C %d", _index);
}

@end
