//
//  QYLoginViewController.m
//  WeiBo
//
//  Created by qingyun on 15-4-17.
//  Copyright (c) 2015年 hnqingyun.com. All rights reserved.
//

//请求授权
//重定向时，获取code
//code换取accesstoken

#import "QYLoginViewController.h"
#import "AFNetworking.h"
#import "QYAccountModel.h"

@interface QYLoginViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation QYLoginViewController
- (IBAction)dismiss:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

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
    
    //请求授权
    NSString *url = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=%@&redirect_uri=%@&response_type=code", kAppKey, kRedirectURI];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];
    
    
}

#pragma mark - webview delegate

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSURL *url = [request URL];
    NSString *urlString = [url absoluteString];
    //比较url以回调地址开头
    if ([urlString hasPrefix:kRedirectURI]) {
        //获取code
        NSArray *result = [urlString componentsSeparatedByString:@"code="];
        NSString *code = result.lastObject;
        
        //用code换取accesstoken
        
        NSDictionary *parameters = @{@"client_id":kAppKey,
                                     @"client_secret":kAppSecret,
                                     @"grant_type":@"authorization_code",
                                     @"code":code,
                                     @"redirect_uri":kRedirectURI};
        AFHTTPRequestOperationManager *manager= [AFHTTPRequestOperationManager manager];
        
//        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plan"];
        NSMutableSet *types = [NSMutableSet setWithSet:manager.responseSerializer.acceptableContentTypes];
        [types addObject:@"text/plain"];
        manager.responseSerializer.acceptableContentTypes = types;
        
        [manager POST:@"https://api.weibo.com/oauth2/access_token" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@", responseObject);
            
            //保存登陆成功后的信息
            [[QYAccountModel accountModel] loginSuccess:responseObject];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccess object:responseObject[kAccessToken]];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", error);
        }];
        
        
        
        
        
        
        return NO;
    }
    return YES;
    
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

@end
