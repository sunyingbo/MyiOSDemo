//
//  MoveViewController.m
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/2/24.
//

#import "MoveViewController.h"

@interface MoveViewController ()

@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation MoveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"可移动 cell";
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.array = [[NSMutableArray alloc] initWithObjects:@"a", @"b", @"c", @"h", @"d", @"ds", @"sd", @"fd", @"gdd", @"ad", nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        if (indexPath.row == 0) {
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(12, 0, cell.contentView.frame.size.width + 50, cell.contentView.frame.size.height)];
            textField.keyboardType = UIKeyboardTypeDefault;
            textField.returnKeyType = UIReturnKeyDone;
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [cell.contentView addSubview:textField];
        }
    }
    cell.textLabel.text = self.array[indexPath.row];
    return cell;
}

///　对当前行设置编辑模式，删除、插入或者不可编辑。
/// UITableViewCellEditingStyleDelete
/// UITableViewCellEditingStyleInsert
/// UITableViewCellEditingStyleNone
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

//通知委托在编辑模式下是否需要对表视图指定行进行缩进，NO 为关闭缩进
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//移动行之后调用的方法，可以在里面设置表视图数据 list 的一些操作
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    id object = [self.array objectAtIndex:sourceIndexPath.row];
    
    [self.array removeObjectAtIndex:sourceIndexPath.row];
    [self.array insertObject:object atIndex:destinationIndexPath.row];
}

@end
