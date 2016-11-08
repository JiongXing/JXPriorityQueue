//
//  JXPriorityQueue.m
//  JXPriorityQueueDemo
//
//  Created by JiongXing on 2016/11/4.
//  Copyright © 2016年 JiongXing. All rights reserved.
//

#import "JXPriorityQueue.h"

@interface JXPriorityQueue ()

/// 队列数据
@property (nonatomic, strong) NSMutableArray *data;
/// 尾元素位置
@property (nonatomic, assign, readonly) NSInteger tailIndex;

@end

#pragma mark - 队列
@implementation JXPriorityQueue

- (instancetype)init {
    if (self = [super init]) {
        self.data = [NSMutableArray array];
        // 第0位不使用，null占位
        [self.data addObject:[NSNull null]];
    }
    return self;
}

+ (instancetype)queueWithComparator:(JXPriorityQueueComparator)comparator {
    return [self queueWithData:nil comparator:comparator];
}

+ (instancetype)queueWithData:(NSArray *)data comparator:(JXPriorityQueueComparator)comparator {
    JXPriorityQueue *instance = [[JXPriorityQueue alloc] init];
    if (data) {
        [instance.data addObjectsFromArray:data];
    }
    instance.comparator = comparator;
    return instance;
}

- (NSInteger)count {
    return self.data.count - 1;
}

- (NSInteger)tailIndex {
    return self.data.count - 1;
}

- (void)enQueue:(id)element {
    // 添加到末尾
    [self.data addObject:element];
    
    // 上游元素以维持堆有序
    [self swimIndex:self.tailIndex];
}

- (id)deQueue {
    if (self.count == 0) {
        return nil;
    }
    // 取根元素
    id element = self.data[1];
    // 交换队首和队尾元素
    [self swapIndexA:1 indexB:self.tailIndex];
    [self.data removeLastObject];
    
    if (self.data.count > 1) {
        // 下沉刚刚交换上来的队尾元素，维持堆有序状态
        [self sinkIndex:1];
    }
    return element;
}

/// 交换元素
- (void)swapIndexA:(NSInteger)indexA indexB:(NSInteger)indexB {
    id temp = self.data[indexA];
    self.data[indexA] = self.data[indexB];
    self.data[indexB] = temp;
    
    if (self.didSwapCallBack) {
        self.didSwapCallBack(indexA - 1, indexB - 1);
    }
}

/// 上游，传入需要上游的元素位置，以及允许上游的最顶位置
- (void)swimIndex:(NSInteger)index {
    // parent的位置为本元素位置的1/2
    for (NSInteger parentIndex = index / 2; parentIndex >= 1; parentIndex /= 2) {
        // 上游条件是本元素大于parent，否则不上游
        if (self.comparator(self.data[index], self.data[parentIndex]) != NSOrderedDescending) {
            break;
        }
        // 上游本元素
        [self swapIndexA:index indexB:parentIndex];
        index = parentIndex;
    }
}

/// 下沉，传入需要下沉的元素位置，以及允许下沉的最底位置
- (void)sinkIndex:(NSInteger)index {
    // maxChildIndex指向最大的子结点，默认指向左子结点，左子结点的位置为本结点位置*2
    for (NSInteger maxChildIndex = index * 2; maxChildIndex <= self.tailIndex; maxChildIndex *= 2) {
        // 如果存在右子结点，并且左子结点比右子结点小
        if (maxChildIndex < self.tailIndex && (self.comparator(self.data[maxChildIndex], self.data[maxChildIndex + 1]) == NSOrderedAscending)) {
            // 指向右子结点
            ++ maxChildIndex;
        }
        // 下沉条件是本元素小于child，否则不下沉
        if (self.comparator(self.data[index], self.data[maxChildIndex]) != NSOrderedAscending) {
            break;
        }
        // 下沉本元素
        [self swapIndexA:index indexB:maxChildIndex];
        index = maxChildIndex;
    }
}

- (NSArray *)fetchData {
    return [self.data subarrayWithRange:NSMakeRange(1, self.tailIndex)];
}

- (void)clearData {
    [self.data removeAllObjects];
    [self.data addObject:[NSNull null]];
}

- (void)logDataWithMessage:(NSString *)message {
    NSMutableString *str = [NSMutableString string];
    [self.data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [str appendFormat:@"%@,", obj];
    }];
    NSLog(@"%@:%@", message, str);
}

@end

