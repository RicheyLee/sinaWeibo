//
//  QYStatusDetailViewController.m
//  WeiBo
//
//  Created by qingyun on 15-5-7.
//  Copyright (c) 2015年 hnqingyun.com. All rights reserved.
//

#import "QYStatusDetailViewController.h"
#import "QYStatusModel.h"
#import "QYStatusTableViewCell.h"
#import "QYDetailSectionView.h"
#import "QYAccountModel.h"
#import "AFNetworking.h"
#import "QYCommentModel.h"
#import "QYCommentTableViewCell.h"


@interface QYStatusDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)QYDetailSectionView *sectionView;//用作section1的headerView;

@property (nonatomic, strong)NSMutableArray *commentDataArray;//评论的数据

@property (nonatomic, strong)NSMutableArray *reSTatusArray;//转发的数据


@end

@implementation QYStatusDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"微博正文";
    
    self.sectionView = [[[NSBundle mainBundle] loadNibNamed:@"QYDetailSectionView" owner:nil options:nil]
        objectAtIndex:0];
    
    [self.sectionView.reStatus addTarget:self action:@selector(reStatus:) forControlEvents:UIControlEventTouchUpInside];
    [self.sectionView.comments addTarget:self action:@selector(comments:) forControlEvents:UIControlEventTouchUpInside];
    [self.sectionView.star addTarget:self action:@selector(star:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.navigationController.navigationBar.translucent = NO;
    
    [self loadCommentData:nil];
    self.type = kcomments;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action

-(void)reStatus:(id)sender{
    //点击转发
    [self.sectionView.reStatus setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.sectionView.reStatus.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [self.sectionView.comments setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.sectionView.comments.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self.sectionView.star setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.sectionView.star.titleLabel setFont:[UIFont systemFontOfSize:15]];
    
    [UIView animateWithDuration:.3f animations:^{
        CGPoint center = self.sectionView.selectIndex.center;
        center.x = self.sectionView.reStatus.center.x;
        
        self.sectionView.selectIndex.center = center;
    }];
    
    //请求数据
    [self loadDataReStatus:sender];
    //设置显示的数据的表示
    self.type = kreStatus;
}

-(void)comments:(id)sender{
    [self.sectionView.reStatus setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.sectionView.comments setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.sectionView.star setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self loadCommentData:sender];
    self.type = kcomments;
    [UIView animateWithDuration:.3f animations:^{
        CGPoint center = self.sectionView.selectIndex.center;
        center.x = self.sectionView.comments.center.x;
        
        self.sectionView.selectIndex.center = center;
    }];
}

-(void)star:(id)sender{
    [self.sectionView.reStatus setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.sectionView.comments setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.sectionView.star setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

-(void)loadCommentData:(id)sender{
    //请求评论数据
    
    //获取请求的令牌
    NSMutableDictionary *pramras = [[QYAccountModel accountModel] requestParameters];
    if (!pramras) {
        return;
    }
    [pramras setObject:self.status.status_id forKey:@"id"];
    
    NSString *urlString = @"https://api.weibo.com/2/comments/show.json";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:pramras success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //取出评论列别
        NSArray *commentsArray = responseObject[@"comments"];
        NSMutableArray *commentModelArray = [NSMutableArray arrayWithCapacity:commentsArray.count];
        for (NSDictionary *info in commentsArray) {
            //将每条评论转化为model
            QYCommentModel *comment = [[QYCommentModel alloc] initCommentWithInfo:info];
            [commentModelArray addObject:comment];
        }
        //保存作为数据源
        self.commentDataArray = commentModelArray;
        
        //更新UI
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)loadDataReStatus:(id)sender{
    //请求的转发的数据
    
    
}

#pragma mark - table view datasource delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        switch (self.type) {
            case kreStatus:
            {
                //tableView 显示转发的内容
                return self.reSTatusArray.count; 
            }
                break;
            case kcomments:
            {
                //tableView 显示的评论的内容
                return self.commentDataArray.count;
                break;
            }
                
            default:
                break;
        }
        
    }
    
    return 0;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        QYStatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"statusCell" forIndexPath:indexPath];
        //绑定cell上的内容
        QYStatusModel *status = self.status;
        
        //将statusmodel绑定到cell上
        [cell setStatusModel:status];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        switch (self.type) {
            case kreStatus:
            {
                //转发显示的内容
            }
                break;
            case kcomments:{
                //绑定model，评论
                QYCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell" forIndexPath:indexPath];
                QYCommentModel *comment = self.commentDataArray[indexPath.row];
                [cell setCommentModel:comment];
                return cell;
            }
                break;
                
            default:
                break;
        }
        
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0) {
        QYStatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"statusCell"];
        
        //取出要显示的数据
        QYStatusModel *model = self.status;
        //    [cell setStatusModel:model];
        //
        //    //根据绑定的内容，以及约束，预估出需要的size
        //    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        //
        //    return size.height + 1;
        
        //    通过cell计算cell显示需要的高度
        return [cell cellHeight4StatusModel:model];
    }else{
        switch (self.type) {
            case kreStatus:
            {
                //显示转发cell需要的高度
            }
                break;
            case kcomments:
            {
                //显示评论需要的高度
                QYCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];
                //要计算的model
                QYCommentModel *comment = self.commentDataArray[indexPath.row];
                [cell setCommentModel:comment];
                //计算出根据内容显示的区域
                CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
                return size.height + 1;
            }
                
            default:
                break;
        }
        
    }
    return 0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return .5;
    }else{
        return self.sectionView.frame.size.height;
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }else{
        return self.sectionView;
    }
}

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
