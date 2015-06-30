//
//  QYsendStatusViewController.m
//  WeiBo
//
//  Created by qingyun on 15-5-11.
//  Copyright (c) 2015年 hnqingyun.com. All rights reserved.
//

#import "QYsendStatusViewController.h"
#import "AFNetworking.h"
#import "QYAccountModel.h"

@interface QYsendStatusViewController ()<UITextViewDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *placeholderlabel;
@property (weak, nonatomic) IBOutlet UIView *imageSuperView;

@property (nonatomic, strong)NSMutableArray *sendImages;//用户选择的图片


@end

@implementation QYsendStatusViewController

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
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //去掉tableView多余的线
//    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //重新布局选择的图片
    [self layoutImage:self.sendImages forView:self.tableView.tableFooterView];
    self.tableView.tableFooterView = self.tableView.tableFooterView;
}

#pragma mark - action

-(void)layoutImage:(NSArray *)images forView:(UIView *)view{
    //移除之前添加的所有图片
    NSArray *subViews = view.subviews;
    for (UIView *subView in subViews) {
        [subView removeFromSuperview];
    }
    
    //计算出整体需要的高度
    //计算图片显示的行数：
    NSInteger line = ceil((images.count + 1) / 3.f);
    
    NSInteger imageSuperViewHeight = line *90 + 5 * line;
    
    self.imageSuperView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, imageSuperViewHeight);
    
    //分别添加每一张图片
    
    for (int i = 0; i < images.count + 1; i++) {
        if (i < images.count) {
            UIImage *image = images[i];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i%3 * (90 + 5), (i / 3) * (90 + 5), 90, 90)];
            [imageView setImage:image];
            [view addSubview:imageView];
        }else{
            //在最后的位置添加一个button
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(i%3 * (90 + 5), (i / 3) * (90 + 5), 90, 90)];
            [button addTarget:self action:@selector(selectImage:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:@"+" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor grayColor]];
            [view addSubview:button];
        }
    }
}

-(void)selectImage:(id)sender{
    UIImagePickerController *imagepicker = [[UIImagePickerController alloc] init];
    imagepicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagepicker.delegate = self;
    [self presentViewController:imagepicker animated:YES completion:nil];
}

- (IBAction)dismiss:(id)sender {
}

- (IBAction)send:(id)sender {
    
    //将用户的输入发送给微博平台
    
    //用户的输入
    NSString *text = self.textView.text;
    
    //得到用户的登录信息
    
    NSMutableDictionary *dic = [[QYAccountModel accountModel] requestParameters];
    if (!dic) {
        return;
    }
    
    //添加用户输入的参数
    [dic setObject:text forKey:@"status"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    if (self.sendImages.count) {
        [manager POST:@"https://upload.api.weibo.com/2/statuses/upload.json" parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            NSData *data = UIImageJPEGRepresentation(self.sendImages[0], 0.5);
            [formData appendPartWithFileData:data name:@"pic" fileName:@"status" mimeType:@"image/jpeg"];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@", responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", operation.responseString);
        }];
    }else{
        [manager POST:@"https://api.weibo.com/2/statuses/update.json" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@", responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", operation.responseString);
        }];
    }
    
    
    
}

#pragma mark - text view delegate

-(void)textViewDidBeginEditing:(UITextView *)textView{
    self.placeholderlabel.hidden = YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    //如果用户没有输入文字信息，显示提示信息
    if (self.textView.text == nil || [self.textView.text isEqualToString:@""]) {
        self.placeholderlabel.hidden = NO;
    }
}

#pragma mark - image picker delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    if (!self.sendImages) {
        self.sendImages  = [NSMutableArray array];
    }
    [self.sendImages addObject:image];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
