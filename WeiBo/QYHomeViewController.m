//
//  QYHomeViewController.m
//  WeiBo
//
//  Created by qingyun on 15-4-20.
//  Copyright (c) 2015年 hnqingyun.com. All rights reserved.
//

#import "QYHomeViewController.h"
#import "QYAccountModel.h"
#import "AFHTTPRequestOperationManager.h"
#import "QYStatusTableViewCell.h"
#import "QYStatusModel.h"
#import "QYUserModel.h"
#import "QYDataBaseEngine.h"
#import "QYTableViewFooterView.h"
#import "QYStatusDetailViewController.h"



@interface QYHomeViewController ()

@property (nonatomic, strong) NSArray *statusesArray;

@property (nonatomic, strong) QYStatusTableViewCell *prototypeCell;//用于计算cell高度

@property (nonatomic)BOOL isLock;//yes 加锁

@end

@implementation QYHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        self.title = @"发现";
        
        UIImage *image = [[UIImage imageNamed:@"12"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:image selectedImage:image];
        
        NSDictionary *att = @{NSFontAttributeName: [UIFont systemFontOfSize:17], NSForegroundColorAttributeName: [UIColor orangeColor]};
//
        [self.tabBarItem setTitleTextAttributes:att forState:UIControlStateNormal];
        
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //实现下拉刷新。UIRefreshControl
    
    //init
    UIRefreshControl *control = [[UIRefreshControl alloc] init];
    self.refreshControl = control;
    //添加触发事件
    [self.refreshControl addTarget:self action:@selector(reloadNew:) forControlEvents:UIControlEventValueChanged];
    
    
    
    //查询本地数据，先显示
    self.statusesArray = [QYDataBaseEngine statusArrayFromDataBase];
    
    //添加观察者，档登陆成功后请求最新的数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:kLoginSuccess object:nil];
    
    self.prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:@"statusCell"];
    
    //注册table footer view
    UINib *nib = [UINib nibWithNibName:@"QYStatusFooterView" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forHeaderFooterViewReuseIdentifier:@"QYTableViewFooterView"];
    
    //请求网络数据
    //默认锁打开的
    self.isLock = NO;
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//加载最新的status
-(void)reloadNew:(id)sender{
    //如果没锁
    if (!self.isLock) {
        //加锁
        self.isLock= YES;
    }else{
        return;
    }
    
    //获取access_token
    NSMutableDictionary *dic = [[QYAccountModel accountModel] requestParameters];
    //根据是否为空，是否可以请求
    if (!dic) {
        //放弃请求
        self.isLock = NO;
        [self.refreshControl endRefreshing];
        return;
    }
    
    if (self.statusesArray.count != 0) {
        //确定请求的最小的微博id
        [dic setObject:[self.statusesArray.firstObject status_id] forKey:@"since_id"];
    }
   
    
    
    //请求管理者
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"https://api.weibo.com/2/statuses/home_timeline.json" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //从返回的结果中，取出微博列表
        NSArray *status = responseObject[@"statuses"];
        
        NSMutableArray *statusModels = [NSMutableArray arrayWithCapacity:status.count];
        for (NSDictionary *statusInfo in status) {
            //        初始化model
            QYStatusModel *statusModel = [[QYStatusModel alloc] initWithDictionary:statusInfo];
            [statusModels addObject:statusModel];
        }
        
        //将原有的追加到新的数组中
        [statusModels addObjectsFromArray:self.statusesArray];
        
        self.statusesArray = statusModels;
        //停止下拉刷新
        [self.refreshControl endRefreshing];
        //更新UI
        [self.tableView reloadData];
        
        //持久化数据
        [QYDataBaseEngine saveStatusToDatabase:status];
        
        //解锁
        self.isLock = NO;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.isLock = NO;
        [self.refreshControl endRefreshing];
    }];
}

-(void)reloadMore{
    //上锁
    if (!self.isLock) {
        self.isLock = YES;
    }else{
        return;
    }
    
    //获取access_token
    NSMutableDictionary *dic = [[QYAccountModel accountModel] requestParameters];
    //根据是否为空，是否可以请求
    if (!dic) {
        return;
    }
    
    if (self.statusesArray.count != 0) {
        //确定请求的最大的微博id
        [dic setObject:[self.statusesArray.lastObject status_id] forKey:@"max_id"];
    }
    
    
    
    //请求管理者
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"https://api.weibo.com/2/statuses/home_timeline.json" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //从返回的结果中，取出微博列表
        NSArray *status = responseObject[@"statuses"];
        
        NSMutableArray *statusModels = [NSMutableArray arrayWithCapacity:status.count];
        for (NSDictionary *statusInfo in status) {
            //        初始化model
            QYStatusModel *statusModel = [[QYStatusModel alloc] initWithDictionary:statusInfo];
            [statusModels addObject:statusModel];
        }
        
        //追加到原有数组中
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.statusesArray];
        [array addObjectsFromArray:statusModels];
        self.statusesArray = array;
        //更新UI
        [self.tableView reloadData];
        
        //持久化数据
        [QYDataBaseEngine saveStatusToDatabase:status];
        //解锁
        self.isLock =NO;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.isLock = NO;
    }];

}

-(void)loadData{
    //模拟从网络请求数据
    //获取文件路径
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"statues" ofType:nil];
//    
//    NSString *statusdString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//    //转化为二进制数据
//    NSData *statusData = [statusdString dataUsingEncoding:NSUTF8StringEncoding];
//    //解析位json对象
//    NSDictionary *statusDic = [NSJSONSerialization JSONObjectWithData:statusData options:0 error:nil];
//    
//    //从返回的结果中，取出微博列表
//    NSArray *status = statusDic[@"statuses"];
//    
//    //可变数组，保存创建的model
//    NSMutableArray *statusModels = [NSMutableArray arrayWithCapacity:status.count];
//    for (NSDictionary *statusInfo in status) {
////        初始化model
//        QYStatusModel *statusModel = [[QYStatusModel alloc] initWithDictionary:statusInfo];
//        [statusModels addObject:statusModel];
//    }
//    
//    self.statusesArray = statusModels;
//    //更新UI
//    [self.tableView reloadData];
//
//    //保存到数据库
//    [QYDataBaseEngine saveStatusToDatabase:status];
//    
//    
//    return;
    
    
    //上锁
    if (!self.isLock) {
        self.isLock = YES;
    }else{
        return;
    }
    //获取access_token
    NSMutableDictionary *dic = [[QYAccountModel accountModel] requestParameters];
    //根据是否为空，是否可以请求
    if (!dic) {
        return;
    }
    //请求管理者
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"https://api.weibo.com/2/statuses/home_timeline.json" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //从返回的结果中，取出微博列表
        NSArray *status = responseObject[@"statuses"];
        
        NSMutableArray *statusModels = [NSMutableArray arrayWithCapacity:status.count];
        for (NSDictionary *statusInfo in status) {
            //        初始化model
            QYStatusModel *statusModel = [[QYStatusModel alloc] initWithDictionary:statusInfo];
            [statusModels addObject:statusModel];
        }
        
        self.statusesArray = statusModels;
        //更新UI
        [self.tableView reloadData];
        [QYDataBaseEngine saveStatusToDatabase:status];
        //解锁
        self.isLock = NO;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.isLock = NO;
    }];
    
}

#pragma mark - action

-(void)reStatus:(id)sender{
    NSLog(@"%ld", [sender tag]);
}

-(void)comments:(id)sender{
    
}

-(void)star:(id)sender{
}


#pragma mark - table View data source delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //根据section区分微博
    return self.statusesArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QYStatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"statusCell" forIndexPath:indexPath];
    //绑定cell上的内容
    QYStatusModel *status = self.statusesArray[indexPath.section];

    //将statusmodel绑定到cell上
    [cell setStatusModel:status];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //根据将要显示的cell，判断剩余的未刷新的cell个数
    int count =  self.statusesArray.count - (indexPath.section + 1);
    if (count == 5) {
        //满足加载更多的条件
        [self reloadMore];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    QYStatusTableViewCell *cell = self.prototypeCell;
    
    //取出要显示的数据
    QYStatusModel *model = self.statusesArray[indexPath.section];
//    [cell setStatusModel:model];
//    
//    //根据绑定的内容，以及约束，预估出需要的size
//    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
//    
//    return size.height + 1;
    
//    通过cell计算cell显示需要的高度
    return [cell cellHeight4StatusModel:model];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 30.f;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    QYTableViewFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"QYTableViewFooterView"];
    
    //绑定内容
    [footerView setStatusModel:[self.statusesArray objectAtIndex:section]];
    
    //对按钮绑定事件
    [footerView.reStatus addTarget:self action:@selector(reStatus:) forControlEvents:UIControlEventTouchUpInside];
    [footerView.reStatus setTag:section];
    [footerView.comments addTarget:self action:@selector(comments:) forControlEvents:UIControlEventTouchUpInside];
    [footerView.star addTarget:self action:@selector(star:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    return footerView;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"statusDetail"]) {
        //点击cell触发的事件
        
        //找到所处位置
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        NSLog(@"%ld", indexPath.section);
        
        //将要展示详情的微博
        QYStatusModel *selectStatus = self.statusesArray[indexPath.section];
        
        //目标控制器
        QYStatusDetailViewController *detail = segue.destinationViewController;
        detail.status = selectStatus;
        detail.hidesBottomBarWhenPushed = YES;
    }
    
    
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    //取消选择
////    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NSLog(@"%ld", indexPath.section);
//    
//    //将要展示详情的微博
//    QYStatusModel *selectStatus = self.statusesArray[indexPath.section];
//    
//    QYStatusDetailViewController *detailVC= [[QYStatusDetailViewController alloc] init];
//    detailVC.status = selectStatus;
//    [self.navigationController pushViewController:detailVC animated:YES];
//    
//}

@end
