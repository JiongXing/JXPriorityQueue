//
//  JXPriorityQueue.m
//  JXPriorityQueueDemo
//
//  Created by JiongXing on 2016/11/4.
//  Copyright © 2016年 JiongXing. All rights reserved.
//

#import "JXPriorityQueue.h"

@interface JXPriorityQueue ()

@property (nonatomic, strong) NSMutableArray *data;

@end

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
    JXPriorityQueue *instance = [[JXPriorityQueue alloc] init];
    instance.comparator = comparator;
    return instance;
}

- (void)enQueue:(id)element {
    // 添加到末尾
    [self.data addObject:element];
    
    // 上游元素以维持堆有序
    [self swim:self.data.count - 1];
}

- (id)deQueue {
    if (self.count == 0) {
        return nil;
    }
    // 取根元素
    id element = self.data[1];
    // 交换队首和队尾元素
    [self swapIndexA:1 indexB:self.data.count - 1];
    [self.data removeLastObject];
    
    // 下沉刚刚交换上来的队尾元素，维持堆有序状态
    [self sink:1];
    return element;
}

- (NSInteger)count {
    return self.data.count - 1;
}

/// 交换元素
- (void)swapIndexA:(NSInteger)indexA indexB:(NSInteger)indexB {
    id temp = self.data[indexA];
    self.data[indexA] = self.data[indexB];
    self.data[indexB] = temp;
}

/// 某个元素是否小于另一个元素
- (BOOL)isElement:(id)element lessThan:(id)otherElement {
    return self.comparator(element, otherElement) == NSOrderedAscending;
}

/// 上游，传入需要上游的元素位置
- (void)swim:(NSInteger)index {
    // 暂存需要上游的元素
    id temp = self.data[index];
    
    // parent的位置为本元素位置的1/2
    for (NSInteger parentIndex = index / 2; parentIndex > 0; parentIndex /= 2) {
        // 如果parent比本元素还小
        if ([self isElement:self.data[parentIndex] lessThan:temp]) {
            // 把parent拉下来
            self.data[index] = self.data[parentIndex];
            // 标记本元素需要上游的目标位置，为parent原位置
            index = parentIndex;
        }
        else {
            // 不必上游了
            break;
        }
    }
    // 本元素进入目标位置
    self.data[index] = temp;
}

/// 下沉，传入需要下沉的元素位置
- (void)sink:(NSInteger)index {
    // 暂存需要下沉的元素
    id temp = self.data[index];
    // 队尾元素位置
    NSInteger tailIndex = self.data.count - 1;
    
    // maxChildIndex指向最大的子结点，默认指向左子结点，左子结点的位置为本结点位置*2
    for (NSInteger maxChildIndex = index * 2; maxChildIndex <= tailIndex; maxChildIndex *= 2) {
        // 如果存在右子结点，并且左子结点比右子结点小
        if (maxChildIndex < tailIndex && [self isElement:self.data[maxChildIndex] lessThan:self.data[maxChildIndex + 1]]) {
            // 指向右子结点
            ++ maxChildIndex;
        }
        // 如果最大的子结点元素还没有本元素大，则本元素不必下沉了
        if ([self isElement:self.data[maxChildIndex] lessThan:temp]) {
            break;
        }
        // 否则
        // 把最大子结点元素上游到本元素位置
        self.data[index] = self.data[maxChildIndex];
        // 标记本元素需要下沉的目标位置，为最大子结点原位置
        index = maxChildIndex;
    }
    // 本元素进入目标位置
    self.data[index] = temp;
}

- (void)logDataWithMessage:(NSString *)message {
    NSMutableString *str = [NSMutableString string];
    [self.data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [str appendFormat:@"%@,", obj];
    }];
    NSLog(@"%@:%@", message, str);
}

@end
