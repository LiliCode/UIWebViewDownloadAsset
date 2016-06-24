//
//  UIWebView+SaveAsset.m
//  UIWebView_Save
//
//  Created by 圈圈科技 on 16/6/23.
//  Copyright © 2016年 圈圈科技. All rights reserved.
//

#import "UIWebView+SaveAsset.h"
#import "UIAlertView+Extesion.h"
#import <objc/runtime.h>

@interface UIWebView ()<UIGestureRecognizerDelegate>
@property (copy, nonatomic) void (^saveAssetCallback)(NSURL *url);
@property (strong , nonatomic) UILongPressGestureRecognizer *longPress;

@end

@implementation UIWebView (SaveAsset)

static char *saveAssetCallbackKey = "saveAssetCallbackKey";
static char *longPressKey = "longPressKey";

- (void)setSaveAssetCallback:(void (^)(NSURL *))saveAssetCallback
{
    objc_setAssociatedObject(self, &saveAssetCallbackKey, saveAssetCallback, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(NSURL *))saveAssetCallback
{
    return objc_getAssociatedObject(self, &saveAssetCallbackKey);
}

- (void)setLongPress:(UILongPressGestureRecognizer *)longPress
{
    objc_setAssociatedObject(self, &longPressKey, longPress, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILongPressGestureRecognizer *)longPress
{
    return objc_getAssociatedObject(self, &longPressKey);
}

- (void)grLongPress
{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        self.longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
        self.longPress.delegate = self;
    });
}

- (void)addLongPress
{
    [self grLongPress];
    BOOL isAddGr = NO;
    for (UIGestureRecognizer *gr in self.gestureRecognizers)
    {
        if ([gr isEqual:self.longPress])
        {
            isAddGr = YES;  //已添加
            break;
        }
    }
    
    if (!isAddGr)
    {
        [self addGestureRecognizer:self.longPress];
    }
}

- (void)loadUrlString:(NSString *)url
{
    NSAssert(url, @"url不能为空!");
    NSString *urlString = url;
    if(![url hasPrefix:@"http://"] && ![url hasPrefix:@"https://"])
    {
        urlString = [@"http://" stringByAppendingString:url];
    }
    
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    [self loadRequest:request];
}


- (void)fetchImageUrl:(void (^)(NSURL *))saveImageCallback
{
    //设置长按手势
    [self addLongPress];
    
    if(saveImageCallback)
    {
        self.saveAssetCallback = ^(NSURL *url){
            saveImageCallback(url);
        };
    }
}

- (void)longPressAction:(UILongPressGestureRecognizer *)recognizer
{
    //只在长按手势开始的时候才去获取图片的url
    if (recognizer.state != UIGestureRecognizerStateBegan)
    {
        return;
    }
    
    //获取点击位置
    CGPoint touchPoint = [recognizer locationInView:self];
    //获取src属性
    NSString *js = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", touchPoint.x, touchPoint.y];
    //执行js函数
    NSString *urlToSave = [self stringByEvaluatingJavaScriptFromString:js];
    
    if (urlToSave.length == 0)
    {
        [UIAlertView message:@"不能获取该图片!"];
        return;
    }
    
    [self passUrl:urlToSave];
}

/**
 *  下载资源
 *
 *  @param url 图片链接
 */
- (void)passUrl:(NSString *)url
{
    if(self.saveAssetCallback)
    {
        //回调
        self.saveAssetCallback([NSURL URLWithString:url]);
    }
    else
    {
        //直接保存图片
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"保存图片" message:url preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *save = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self downloadImage:[NSURL URLWithString:url]];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:save];
        [alert addAction:cancel];
        [(UIViewController *)self.delegate presentViewController:alert animated:YES completion:nil];
    }
}

//开启多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)downloadImage:(NSURL *)url
{
    //网络活动指示器可见
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSURLSessionDownloadTask *downloadTask = [[NSURLSession sharedSession] downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //取消活动指示器
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        //获取图片
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }];
    
    //开始下载
    [downloadTask resume];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if(error)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"保存失败" message:error.description delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    else
    {
        [UIAlertView message:@"图片已保存至相册"];
    }
}


@end




