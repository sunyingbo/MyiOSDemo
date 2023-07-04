//
//  DeleteViewController.m
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/2/24.
//

#import "DeleteViewController.h"

@interface DeleteViewController ()

@property (nonatomic, strong)  NSMutableArray * array;

@end

@implementation DeleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"可删除 cell";
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.array = [[NSMutableArray alloc] initWithObjects:@"数据1", @"数据2", @"数据3", @"数据4", @"数据5", @"数据6", @"数据7", @"数据8", @"数据9", nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cell1 = @"cell1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell1];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cell1];
    }
    cell.textLabel.text = self.array[indexPath.row];
    cell.detailTextLabel.text = @"副标题";
    return  cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [self.array removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [self.array removeObjectsInRange:NSMakeRange(indexPath.row + 1, 2)];
        NSMutableArray *deleteIndexPaths = [NSMutableArray arrayWithCapacity:10];
        [deleteIndexPaths addObject:[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section]];
        [deleteIndexPaths addObject:[NSIndexPath indexPathForRow:indexPath.row + 2 inSection:indexPath.section]];
        [tableView deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:UITableViewRowAnimationFade];
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
