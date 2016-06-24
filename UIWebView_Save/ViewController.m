//
//  ViewController.m
//  UIWebView_Save
//
//  Created by 圈圈科技 on 16/6/23.
//  Copyright © 2016年 圈圈科技. All rights reserved.
//

#import "ViewController.h"
#import "UIWebView+DownloadAsset.h"

@interface ViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.webView loadUrlString:@"http://www.baidu.com/"];
    
#if 0
    __weak typeof(self) weakSelf = self;
    [self.webView fetchImageUrl:^(NSURL *url) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"保存图片" message:[url absoluteString] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *save = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf downloadUrl:url];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:save];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }];
#else
    [self.webView fetchImageUrl:nil];
#endif
}


- (void)downloadUrl:(NSURL *)url
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 2), ^{
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    });
}

//保存完调用
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if(error)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"保存失败" message:error.description delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"图片已保存至相册" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}

- (IBAction)goback:(UIBarButtonItem *)sender
{
    if([self.webView canGoBack])
    {
        [self.webView goBack];
    }
    else
    {
        NSLog(@"没有上一页了!");
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    
}

@end
