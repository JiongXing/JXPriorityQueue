//
//  JXPriorityQueue.h
//  JXPriorityQueueDemo
//
//  Created by JiongXing on 2016/11/4.
//  Copyright © 2016年 JiongXing. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSComparisonResult(^JXPriorityQueueComparator)(id obj1, id obj2);

/// 二叉堆实现的优先队列，大顶堆。
@interface JXPriorityQueue : NSObject

/// 定义元素的比较逻辑
@property (nonatomic, copy) JXPriorityQueueComparator comparator;
/// 统计队列长度
@property (nonatomic, assign, readonly) NSInteger count;
/// 发生结点交换时回调
@property (nonatomic, copy) void (^didSwapCallBack)(NSInteger indexA, NSInteger indexB);
/// 发生剪枝时回调
@property (nonatomic, copy) void (^didCutCallBack)(NSInteger index);
/// 出列完成时回调
@property (nonatomic, copy) void (^didDeQueueCallBack)(NSInteger index);

/// 创建实例
+ (instancetype)queueWithComparator:(JXPriorityQueueComparator)comparator;

/// 创建实例
+ (instancetype)queueWithData:(NSArray *)data comparator:(JXPriorityQueueComparator)comparator;

/// 入列
- (void)enQueue:(id)element;

/// 出列
- (id)deQueue;

/// Debug:打印队列
- (void)logDataWithMessage:(NSString *)message;

/// 取整个队列数据
- (NSArray *)fetchData;

/// 清空整个队列
- (void)clearData;

@end


@interface JXPriorityQueue (Sort)

/// 堆排序，结果为升序。
- (void)sort;

@end
