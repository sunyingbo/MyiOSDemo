//
//  ViewController.m
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/2/13.
//

#import "ViewController.h"
#import "MoveViewController.h"
#import "DeleteViewController.h"
#import "InsertViewController.h"
#import "SwipCellTestViewController.h"
#import "LinkageViewController.h"
#import "SecondListViewController.h"
#import "ContainerTableViewController.h"
#import "NSArrayTestViewController.h"
#import "UIWebViewController.h"
#import "CalenderTestViewController.h"
#import "UICollectionViewTestViewController.h"
#import <dlfcn.h>
#import <libkern/OSAtomic.h>

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray * array;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.array = [[NSMutableArray alloc] initWithObjects:@"cell 的移动", @"cell 的删除", @"cell 的添加", @"SwipeTableCell", @"TableView 的联动", @"二级列表", @"侧边栏", @"NSArray Test", @"UIWebView", @"日历读写", @"UICollectionView", nil];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
    
    [self btnClick];
}

// 多少分区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// 多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

// 每行显示内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // cell 重用机制
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = self.array[indexPath.row];
    return cell;
}

// 每行点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: {
            MoveViewController *moveVC = [[MoveViewController alloc] init];
            [self.navigationController pushViewController:moveVC animated:YES];
            break;
        }
        case 1: {
            DeleteViewController *deleteVC = [[DeleteViewController alloc] init];
            [self.navigationController pushViewController:deleteVC animated:YES];
            break;
        }
        case 2: {
            InsertViewController *insertVC = [[InsertViewController alloc] init];
            [self.navigationController pushViewController:insertVC animated:YES];
            break;
        }
        case 3: {
            SwipCellTestViewController *swipVC = [[SwipCellTestViewController alloc] init];
            [self.navigationController pushViewController:swipVC animated:YES];
            break;
        }
        case 4: {
            LinkageViewController *linkageVC = [[LinkageViewController alloc] init];
            [self.navigationController pushViewController:linkageVC animated:YES];
            break;
        }
        case 5: {
            SecondListViewController *secondListVC = [[SecondListViewController alloc] init];
            [self.navigationController pushViewController:secondListVC animated:YES];
            break;
        }
        case 6: {
            ContainerTableViewController *containerTableVC = [[ContainerTableViewController alloc] init];
            [self.navigationController pushViewController:containerTableVC animated:YES];
            break;
        }
        case 7: {
            NSArrayTestViewController *nsArrayTest = [[NSArrayTestViewController alloc] init];
            [self.navigationController pushViewController:nsArrayTest animated:YES];
            break;
        }
        case 8: {
            UIWebViewController *webViewTest = [[UIWebViewController alloc] init];
            [self.navigationController pushViewController:webViewTest animated:YES];
            break;
        }
        case 9: {
            CalenderTestViewController *calenderTest = [[CalenderTestViewController alloc] init];
            [self.navigationController pushViewController:calenderTest animated:YES];
            break;
        }
        case 10: {
            UICollectionViewTestViewController *uiCollectionViewTest = [[UICollectionViewTestViewController alloc] init];
            [self.navigationController pushViewController:uiCollectionViewTest animated:YES];
            break;
        }
        default:
            break;
    }
}

+ (void)load
{
    
}

- (void)btnClick
{
    block();
}

void(^block)(void) = ^(void) {
    
};

// 初始化原子队列
static OSQueueHead list = OS_ATOMIC_QUEUE_INIT;
// 定义节点结构体
typedef struct {
    void *pc; // 存下获取到的PC
    void *next; // 指向下一个节点
} YZDode;

// 添加处理c函数以及block前缀部分内容
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"yingbo3 ViewController touchesBegan ");
    [super touchesBegan:touches withEvent:event];
    NSMutableArray *arr = [NSMutableArray array];
    while (YES) {
        YZDode *node = OSAtomicDequeue(&list, offsetof(YZDode, next));
        // 退出机制
        if (node == NULL) { break; }
        // 获取函数信息
        Dl_info info;
        dladdr(node->pc, &info);
        NSString *sname = [NSString stringWithCString:info.dli_sname encoding:NSUTF8StringEncoding];

        // 处理c函数以及block前缀
        // 获取符号名称，如果不是+[和-[开头，视为函数或Block，前面加_
        BOOL isObjc = [sname hasPrefix:@"+["] || [sname hasPrefix:@"-["];
        // c函数及block需要在开头添加下划线
        sname = isObjc ? sname : [@"_" stringByAppendingString:sname];

        // 去重复
        if (![arr containsObject:sname]) {
            [arr insertObject:sname atIndex:0]; // 入栈
        }
        printf("yingbo3 %s \n", info.dli_sname);
    }
    
    // 去掉touchBegan方法(因为启动时，不会调用它)
    [arr removeObject:[NSString stringWithFormat:@"%s", __FUNCTION__]];
    NSLog(@"yingbo3 %@",arr);
    // 将数组合成字符串
    NSString *funcStr = [arr componentsJoinedByString:@"\n"];
    // 写入文件
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"link.order"];
    NSLog(@"yingbo3 path: %@", filePath);
    NSData *fileContents = [funcStr dataUsingEncoding:NSUTF8StringEncoding];
    [[NSFileManager defaultManager] createFileAtPath:filePath contents:fileContents attributes:nil];
}

void __sanitizer_cov_trace_pc_guard(uint32_t *guard)
{
//    if (!*guard) return;
//
    void *PC = __builtin_return_address(0);
    Dl_info info;
    dladdr(PC, &info);
//    printf("%s \n", info.dli_sname);
    //获取上一个函数的地址，通过这个地址就能拿到函数的符号名称
    /*
     - PC 当前函数返回上一个调用的地址
     - 0 当前这个函数地址，即当前函数的返回地址
     - 1 当前函数调用者的地址，即上一个函数的返回地址
     */
//    void *PC = __builtin_return_address(0);
    //创建结构体
    YZDode *node = malloc(sizeof(YZDode));
    *node = (YZDode){PC, NULL};
    //结构体入栈
    //offsetOf()计算出列尾  OSAtomicEnqueue()把node加入list尾巴
    OSAtomicEnqueue(&list, node, offsetof(YZDode, next));
}

void __sanitizer_cov_trace_pc_guard_init(uint32_t *start, uint32_t *stop)
{
    static uint64_t N;  // Counter for the guards.
    if (start == stop || *start) return;  // Initialize only once.
    printf("INIT: %p %p\n", start, stop);
    for (uint32_t *x = start; x < stop; x++)
        *x = ++N;  // Guards should start from 1.
}

@end
