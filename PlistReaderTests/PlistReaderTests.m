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

@end

@implementation PlistReaderTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}


- (void)testPerformanceExample {
    
    [self measureBlock:^{
        
//        ViewController *vc = [ViewController new];
//        [vc test];
//        NSLog(@"CXHLog:%@", vc);
//        [vc initNameData];
        
    }];
}

- (void)test1 {
    NSLog(@"CXHLog:1");
}

- (void)test2 {
    ViewController *vc = [ViewController new];
    [vc test];
    NSLog(@"CXHLog:2");

}

- (void)test3 {
    NSLog(@"CXHLog:3");
}

@end
