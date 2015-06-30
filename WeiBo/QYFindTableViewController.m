//
//  QYFindTableViewController.m
//  WeiBo
//
//  Created by qingyun on 15-4-20.
//  Copyright (c) 2015年 hnqingyun.com. All rights reserved.
//

#import "QYFindTableViewController.h"
#import "QYAccountModel.h"
#import "AFNetworking/AFNetworking.h"
#import "QYStatusModel.h"
#import "QYStatusTableViewCell.h"
#import "QYTableViewFooterView.h"


@interface QYFindTableViewController ()

@property (nonatomic, strong)UITableViewController *staticVC;

@property (nonatomic, strong)NSArray *statusesArray;
@property (nonatomic, strong)QYStatusTableViewCell *prototypeCell;

@end

@implementation QYFindTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //初始化staticTableViewVC
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    self.staticVC = [story instantiateViewControllerWithIdentifier:@"staticTableView"];
    
    [self.view addSubview:self.staticVC.tableView];
    
    self.prototypeCell = [self.statusTableView dequeueReusableCellWithIdentifier:@"statusCell"];
    
    //注册table footer view
    UINib *nib = [UINib nibWithNibName:@"QYStatusFooterView" bundle:[NSBundle mainBundle]];
    [self.statusTableView registerNib:nib forHeaderFooterViewReuseIdentifier:@"QYTableViewFooterView"];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //切换显示具体哪个tableView
//    判断是否登录
    if ([[QYAccountModel accountModel] isLogin]) {
        self.staticVC.tableView.hidden = NO;
        self.statusTableView.hidden = YES;
        self.navigationItem.rightBarButtonItem = nil;
    }else{
        self.navigationItem.rightBarButtonItem = self.loginButtoon;
        self.staticVC.tableView.hidden = YES;
        self.statusTableView.hidden = NO;
        [self loadData];
        
        
    }
    
    
    
}

-(void)loadData{
   
    //获取access_token
    NSDictionary *dic = @{kAccess_token : @"2.00VPdxcC0DbNqv85d4302ee463TCtC"};
    //请求管理者
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"https://api.weibo.com/2/statuses/public_timeline.json" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSLog(@"%@",responseObject);
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
        [self.statusTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action

- (IBAction)login:(id)sender {
    
}


#pragma mark - Table view data source

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
//    [footerView.reStatus addTarget:self action:@selector(reStatus:) forControlEvents:UIControlEventTouchUpInside];
//    [footerView.reStatus setTag:section];
//    [footerView.comments addTarget:self action:@selector(comments:) forControlEvents:UIControlEventTouchUpInside];
//    [footerView.star addTarget:self action:@selector(star:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    return footerView;
}

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    if ([segue.identifier isEqualToString:@"statusDetail"]) {
//        //点击cell触发的事件
//        
//        //找到所处位置
//        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
//        NSLog(@"%ld", indexPath.section);
//        
//        //将要展示详情的微博
//        QYStatusModel *selectStatus = self.statusesArray[indexPath.section];
//        
//        //目标控制器
//        QYStatusDetailViewController *detail = segue.destinationViewController;
//        detail.status = selectStatus;
//        detail.hidesBottomBarWhenPushed = YES;
//    }
//    
//    
//}

@end
