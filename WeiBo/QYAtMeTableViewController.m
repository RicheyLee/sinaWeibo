//
//  QYAtMeTableViewController.m
//  WeiBo
//
//  Created by qingyun on 15-5-8.
//  Copyright (c) 2015年 hnqingyun.com. All rights reserved.
//

#import "QYAtMeTableViewController.h"
#import "AFNetworking.h"
#import "QYAccountModel.h"
#import "QYStatusModel.h"
#import "QYMessageTableViewCell.h"

@interface QYAtMeTableViewController ()

@property (nonatomic, strong)QYMessageTableViewCell *protypeCell;

@property (nonatomic, strong)NSMutableArray *statusArray;

@end

@implementation QYAtMeTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.protypeCell = [self.tableView dequeueReusableCellWithIdentifier:@"QYMessageTableViewCell"];
    
    //请求数据
    [self loadAtMeData];
    
    
}

//请求数据方法
-(void)loadAtMeData{
    //获取访问令牌
    NSMutableDictionary *praps = [[QYAccountModel accountModel] requestParameters];
    if (!praps)
    {
        //没有登录信息
        return;
    }
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"https://api.weibo.com/2/statuses/mentions.json" parameters:praps success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //取出所有微博的数数组
        NSArray *statusInfoArray = responseObject[@"statuses"];
        //转化为model并且保存
        NSMutableArray *modelsArray = [NSMutableArray array];
        for (NSDictionary *info in statusInfoArray) {
            QYStatusModel *model = [[QYStatusModel alloc] initWithDictionary:info];
            [modelsArray addObject:model];
        }
        
        //设置数据源
        self.statusArray = modelsArray;
        //跟新UI
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.statusArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QYMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QYMessageTableViewCell" forIndexPath:indexPath];
    
    
    
    // Configure the cell...
    [cell setStatusModel:self.statusArray[indexPath.row]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    QYMessageTableViewCell *cell = self.protypeCell;
    return [cell cellHeightWithStatus:self.statusArray[indexPath.row]];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
