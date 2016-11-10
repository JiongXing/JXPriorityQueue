详情查看这篇[完全二叉树、优先队列与堆排序](http://www.jianshu.com/p/9a456d1b59b5)

# 完全二叉树、优先队列与堆排序

> 如果仅从名称上来看，这三者似乎没有任何关系。而实际上借助完全二叉树，我们可以实现优先队列，也可以实现一种叫堆排序的算法。

本文的目标是要做出优先队列和堆排序两个Demo。
- 完全二叉树
- 优先队列
- 堆排序

# 完全二叉树
**完全二叉树**的定义是建立在**满二叉树**定义的基础上的，而**满二叉树**又是建立在**二叉树**的基础上的。

> 大致了解一下概念

1、**树**是一对多的数据结构，从一个根结点开始，生长出它的子结点，而每一个子结点又生长出各自的子结点，成为**子树**。如果某个结点不再生长出子结点了，它就成为**叶子**。
2、**二叉树**每个结点最多只有两棵子树，而且左右子树是有顺序的，不可颠倒。

![满二叉树](http://upload-images.jianshu.io/upload_images/2419179-6cbe7fd1618f3784.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

3、**满二叉树**的所有分支结点都既有左子树又有右子树，并且所有叶子都在同一层。满二叉树看起来的感觉很完美，没有任何缺失。

![完全二叉树](http://upload-images.jianshu.io/upload_images/2419179-efb0615e72c2607e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

4、**完全二叉树**不一定是满的，但它自上而下，自左而右来看的话，是连续没有缺失的。
- 对一棵具有n个结点的二叉树按层序编号，如果编号为`i (1 <= i <= n)`的结点与同样深度的满二叉树中编号为`i`的结点在二叉树中位置完全相同，则这棵二叉树称为完全二叉树。

> 性质

完全二叉树有好几条性质，其中有一条在本文中需要用到：

![二叉树性质.png](http://upload-images.jianshu.io/upload_images/2419179-d1e969413a8f6826.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

对于一棵有`n`个结点的完全二叉树，对其结点按层序编号，从上到下，从左到右，对任一结点`i (1 = i <= n)`有：
1. 如果`i = 1`，则结点`i`是二叉树的根，无父结点；如果`i > 1`，则其父结点的位置是`⌊i / 2⌋`（向下取整）。
2. 如果`2i > n`，则结点`i`无左孩子（结点`i`为叶子结点）；否则其左孩子是结点`2i`。
3. 如果`2i + 1 > n`，则结点`i`无右孩子；否则其右孩子是结点`2i + 1`。

> 存储结构

得益于二叉树的严格定义，我们只需要把完全二叉树按层序遍历依次把结点存入一维数组中，其数组下标就能够体现出父子结点关系来（数组第0位不使用）。

![存储进一维数组](http://upload-images.jianshu.io/upload_images/2419179-4b82337770e7b022.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

# 优先队列 (Priority Queue)
完全二叉树的概念大致了解后，下面进入正题，看看如何把它用起来。
- 普通的队列是一种先进先出的数据结构，元素在队列尾追加，而从队列头删除。
- 在优先队列中，元素被赋予优先级。当访问元素时，具有最高优先级的元素最先删除。优先队列具有最高级先出的行为特征。

> 为什么使用完全二叉树来实现优先队列？

优先队列按数据结构的不同有几种实现方式：

![优先队列时间复杂度](http://upload-images.jianshu.io/upload_images/2419179-f2fa406d40e9cad2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

1. 有序数组。每次入队操作时都对数组重新排序，把入队元素放在合适位置，维持数组有序；每次出队操作只需删除数组第一位即可，因第一位总是优先值最大的元素，应被最先删除（降序排列的情况下）。
2. 无序数组。每次入队操作直接追加在数组末尾；每次出队操作需要遍历整个数组来寻找最大优先值。
3. 完全二叉树(堆)。假如我们能保证二叉树的每一个父结点的优先值都大于或者等于它的两个子结点，那么在整棵树看来，顶部根结点必定就是优先值最大的。这样的树结构可以称为堆有序，并且因为最大值在根部，也称为大顶堆。
在每次出队操作时，只需要把根结点出队即可，然后重新调整二叉树恢复堆有序；在每次入队操作时把元素追加到末尾，同样调整二叉树恢复堆有序。

![堆有序，大顶堆](http://upload-images.jianshu.io/upload_images/2419179-4a9817e05047d0a5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

综合了入队和出队两个操作来看，使用完全二叉树来实现的优先队列在时间效率上是最高的。

> 队列的操作

一个队列应该提供两个关键的方法：入队列和出队列。
```objc
typedef NSComparisonResult(^JXPriorityQueueComparator)(id obj1, id obj2);

@interface JXPriorityQueue : NSObject

/// 定义元素的比较逻辑
@property (nonatomic, copy) JXPriorityQueueComparator comparator;

/// 入列
- (void)enQueue:(id)element;

/// 出列
- (id)deQueue;

@end
```

> 入列

入列总的来说分为两步：
1. 把元素加入进来
2. 然后上游元素到合适的位置

![EnQueue](http://upload-images.jianshu.io/upload_images/2419179-0c9e61549c9657f4.gif?imageMogr2/auto-orient/strip)

```objc
- (void)enQueue:(id)element {
    // 添加到末尾
    [self.data addObject:element];
    
    // 上游元素以维持堆有序
    [self swimIndex:self.tailIndex];
}

/// 上游，传入需要上游的元素位置，以及允许上游的最顶位置
- (void)swimIndex:(NSInteger)index {
    // 暂存需要上游的元素
    id temp = self.data[index];
    
    // parent的位置为本元素位置的1/2
    for (NSInteger parentIndex = index / 2; parentIndex >= 1; parentIndex /= 2) {
        // 上游条件是本元素大于parent，否则不上游
        if (self.comparator(temp, self.data[parentIndex]) != NSOrderedDescending) {
            break;
        }
        // 把parent拉下来
        self.data[index] = self.data[parentIndex];
        // 上游本元素
        index = parentIndex;
    }
    // 本元素进入目标位置
    self.data[index] = temp;
}
```

这里关键在于如何上游元素：
1. 在元素加入进来后，与其父结点比较，假如大于父结点，则把元素上游到父结点的位置。
2. 在上游到父结点位置后，再和当前所处结点的父结点比较，如果大于父结点，继续上游。
3. 重复，直到整棵树调整成为大顶堆。

> 出列

把优先值最大的元素(根结点)出列，可分为如下步骤：
1. 交换首尾两个元素的位置，这样尾元素将会成为根结点，堆有序被打破。
2. 剪掉被交换到末尾的原根元素
3. 把交换到根结点的元素下沉到合适位置，重新调整为大顶堆
4. 返回被剪出的元素，即为需要出列的最大优先值元素

![DeQueue](http://upload-images.jianshu.io/upload_images/2419179-ec93018f58d24737.gif?imageMogr2/auto-orient/strip)

```objc
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
}

/// 下沉，传入需要下沉的元素位置，以及允许下沉的最底位置
- (void)sinkIndex:(NSInteger)index {
    // 暂存需要下沉的元素
    id temp = self.data[index];
    
    // maxChildIndex指向最大的子结点，默认指向左子结点，左子结点的位置为本结点位置*2
    for (NSInteger maxChildIndex = index * 2; maxChildIndex <= self.tailIndex; maxChildIndex *= 2) {
        // 如果存在右子结点，并且左子结点比右子结点小
        if (maxChildIndex < self.tailIndex && (self.comparator(self.data[maxChildIndex], self.data[maxChildIndex + 1]) == NSOrderedAscending)) {
            // 指向右子结点
            ++ maxChildIndex;
        }
        // 下沉条件是本元素小于child，否则不下沉
        if (self.comparator(temp, self.data[maxChildIndex]) != NSOrderedAscending) {
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
```

这里关键在于如何把剪枝后的树重新调整为大顶堆，在下沉方法中：
1. 将其左右两个子结点比较一下，找出值最大的那个子结点。
2. 与最大子结点比较，如果自己比最大子结点还要大，或者等于最大子结点，则无须下沉；如果比子结点小，则为了调整为大顶堆，自己就需要下沉到子结点的位置。
3. 在进入到子结点位置后，再和当前所处结点的子结点比较，如果小于子结点，继续下沉。
4. 重复，直到整棵树调整成为大顶堆。

# 堆排序 (Heap Sort)

堆排序是对简单选择排序的一种改进，改进后的效果非常明显。选择排序的时间复杂度是`n²`，堆排序是`nlog₂n`。

![堆排序效率](http://upload-images.jianshu.io/upload_images/2419179-ced6d60c4e8aa5d9.gif?imageMogr2/auto-orient/strip)

堆排序总的来说分为两个步骤：
1. 构造大顶堆。从下往上、从右到左，把每个非终结点（即叶子结点）当作根结点，将其和其子树调整成大顶堆。
2. 对大顶堆进行排序。这一步骤和优先队列的出列操作是非常相似的，都是不断地把大顶堆根结点交换到末尾位置，然后剪掉，再把这样剪枝后的树重新调整成大顶堆以找出下一个最大值，放在根结点，继续进行新一轮剪枝。
这是一个不断选择最大值，依次排列起来的过程。

> NSMutableArray+JXHeapSort.h

```objc
typedef NSComparisonResult(^JXSortComparator)(id obj1, id obj2);
typedef void(^JXSortExchangeCallback)(id obj1, id obj2);
typedef void(^JXSortCutCallback)(id obj, NSInteger index);

@interface NSMutableArray (JXHeapSort)

// 堆排序
- (void)jx_heapSortUsingComparator:(JXSortComparator)comparator didExchange:(JXSortExchangeCallback)exchangeCallback didCut:(JXSortCutCallback)cutCallback;

@end
```

> NSMutableArray+JXHeapSort.m

```objc
@implementation NSMutableArray (JXHeapSort)

/// 堆排序
- (void)jx_heapSortUsingComparator:(JXSortComparator)comparator didExchange:(JXSortExchangeCallback)exchangeCallback didCut:(JXSortCutCallback)cutCallback {
    // 排序过程中不使用第0位
    [self insertObject:[NSNull null] atIndex:0];
    
    // 构造大顶堆
    // 遍历所有非终结点，把以它们为根结点的子树调整成大顶堆
    // 最后一个非终结点位置在本队列长度的一半处
    for (NSInteger index = self.count / 2; index > 0; index --) {
        // 根结点下沉到合适位置
        [self sinkIndex:index bottomIndex:self.count - 1 usingComparator:comparator didExchange:exchangeCallback];
    }
    
    // 完全排序
    // 从整棵二叉树开始，逐渐剪枝
    for (NSInteger index = self.count - 1; index > 1; index --) {
        // 每次把根结点放在列尾，下一次循环时将会剪掉
        [self jx_exchangeWithIndexA:1 indexB:index didExchange:exchangeCallback];
        if (cutCallback) {
            cutCallback(self[index], index - 1);
        }
        // 下沉根结点，重新调整为大顶堆
        [self sinkIndex:1 bottomIndex:index - 1 usingComparator:comparator didExchange:exchangeCallback];
    }
    
    // 排序完成后删除占位元素
    [self removeObjectAtIndex:0];
}

/// 下沉，传入需要下沉的元素位置，以及允许下沉的最底位置
- (void)sinkIndex:(NSInteger)index bottomIndex:(NSInteger)bottomIndex usingComparator:(JXSortComparator)comparator didExchange:(JXSortExchangeCallback)exchangeCallback {
    for (NSInteger maxChildIndex = index * 2; maxChildIndex <= bottomIndex; maxChildIndex *= 2) {
        // 如果存在右子结点，并且左子结点比右子结点小
        if (maxChildIndex < bottomIndex && (comparator(self[maxChildIndex], self[maxChildIndex + 1]) == NSOrderedAscending)) {
            // 指向右子结点
            ++ maxChildIndex;
        }
        // 如果最大的子结点元素小于本元素，则本元素不必下沉了
        if (comparator(self[maxChildIndex], self[index]) == NSOrderedAscending) {
            break;
        }
        // 否则
        // 把最大子结点元素上游到本元素位置
        [self jx_exchangeWithIndexA:index indexB:maxChildIndex didExchange:exchangeCallback];
        // 标记本元素需要下沉的目标位置，为最大子结点原位置
        index = maxChildIndex;
    }
}

/// 交换两个元素
- (void)jx_exchangeWithIndexA:(NSInteger)indexA indexB:(NSInteger)indexB didExchange:(JXSortExchangeCallback)exchangeCallback {
    id temp = self[indexA];
    self[indexA] = self[indexB];
    self[indexB] = temp;
    
    if (exchangeCallback) {
        exchangeCallback(temp, self[indexA]);
    }
}

@end
```

![堆排序](http://upload-images.jianshu.io/upload_images/2419179-2b7b593eaac8d6e4.gif?imageMogr2/auto-orient/strip)

在Demo中，`nodeArray`是一个`UILabel`数组：
```objc
@property (nonatomic, strong) NSMutableArray<UILabel *> *nodeArray;
```

对这个数组进行排序，并借助信号量在线程间通信，控制排序速度：
```objc
dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
// 定时发出信号，以允许继续交换
NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.6 repeats:YES block:^(NSTimer * _Nonnull timer) {
    dispatch_semaphore_signal(sema);
}];

[self.nodeArray jx_heapSortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
    // 比较两个结点
    return [self compareWithNodeA:obj1 nodeB:obj2];
} didExchange:^(id obj1, id obj2) {
    // 交换两结点
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    [self exchangeNodeA:obj1 nodeB:obj2];
} didCut:^(id obj, NSInteger index) {
    // 剪枝
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    [self cutNode:obj index:index];
}];
```  

对于UI更具体的实现方法阐述，可参考另一篇文章：[《图形化排序算法比较：快速排序、插入排序、选择排序、冒泡排序》](http://www.jianshu.com/p/70619984fbc6)

# 源码
优先队列：[JXPriorityQueue](https://github.com/JiongXing/JXPriorityQueue)
堆排序：[JXHeapSort](https://github.com/JiongXing/JXHeapSort)
排序算法比较 : [JXSort](https://github.com/JiongXing/JXSort)
