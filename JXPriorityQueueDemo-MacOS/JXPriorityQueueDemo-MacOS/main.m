//
//  main.m
//  JXPriorityQueueDemo-MacOS
//
//  Created by JiongXing on 2016/11/7.
//  Copyright © 2016年 JiongXing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXPriorityQueue.h"

void testQueue() {
    JXPriorityQueue *queue = [JXPriorityQueue queueWithComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
        NSInteger num1 = obj1.integerValue;
        NSInteger num2 = obj2.integerValue;
        if (num1 == num2) {
            return NSOrderedSame;
        }
        return num1 < num2 ? NSOrderedAscending : NSOrderedDescending;
    }];
    [queue logDataWithMessage:@"当前队列"];
    
    NSLog(@"---------------- 入列 -----------------");
    [queue enQueue:@50];[queue logDataWithMessage:@"enQueue"];
    [queue enQueue:@10];[queue logDataWithMessage:@"enQueue"];
    [queue enQueue:@90];[queue logDataWithMessage:@"enQueue"];
    [queue enQueue:@30];[queue logDataWithMessage:@"enQueue"];
    [queue enQueue:@70];[queue logDataWithMessage:@"enQueue"];
    [queue enQueue:@40];[queue logDataWithMessage:@"enQueue"];
    [queue enQueue:@80];[queue logDataWithMessage:@"enQueue"];
    [queue enQueue:@60];[queue logDataWithMessage:@"enQueue"];
    [queue enQueue:@20];[queue logDataWithMessage:@"enQueue"];
    
    NSLog(@"---------------- 出列 -----------------");
    [queue deQueue];[queue logDataWithMessage:@"deQueue"];
    [queue deQueue];[queue logDataWithMessage:@"deQueue"];
    [queue deQueue];[queue logDataWithMessage:@"deQueue"];
    [queue deQueue];[queue logDataWithMessage:@"deQueue"];
    [queue deQueue];[queue logDataWithMessage:@"deQueue"];
    [queue deQueue];[queue logDataWithMessage:@"deQueue"];
    [queue deQueue];[queue logDataWithMessage:@"deQueue"];
    [queue deQueue];[queue logDataWithMessage:@"deQueue"];
    [queue deQueue];[queue logDataWithMessage:@"deQueue"];
    [queue deQueue];[queue logDataWithMessage:@"deQueue"];
}

void testSort() {
    NSArray *data = @[@50, @10, @90, @30, @70, @40, @80, @60, @20];
    JXPriorityQueue *queue = [JXPriorityQueue queueWithData:data comparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
        NSInteger num1 = obj1.integerValue;
        NSInteger num2 = obj2.integerValue;
        if (num1 == num2) {
            return NSOrderedSame;
        }
        return num1 < num2 ? NSOrderedAscending : NSOrderedDescending;
    }];
    
    NSLog(@"---------------- 排序 -----------------");
    [queue logDataWithMessage:@"当前队列"];
    
    [queue sort];
    [queue logDataWithMessage:@"排序完成"];
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        testQueue();
        testSort();
    }
    return 0;
}
