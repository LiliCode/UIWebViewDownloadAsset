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

@end

@implementation UIWebView (SaveAsset)

static char *saveAssetCallbackKey = "saveAssetCallbackKey";

- (void)setSaveAssetCallback:(void (^)(NSURL *))saveAssetCallback
{
    objc_setAssociatedObject(self, &saveAssetCallbackKey, saveAssetCallback, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(NSURL *))saveAssetCallback
{
    return objc_getAssociatedObject(self, &saveAssetCallbackKey);
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

- (void)saveImage:(void (^)(NSURL *))saveImageCallback
{
    //设置长按手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    longPress.delegate = self;
    [self addGestureRecognizer:longPress];
    
    self.saveAssetCallback = ^(NSURL *url){
        if(saveImageCallback)
        {
            saveImageCallback(url);
        }
    };
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
    
    [self download:urlToSave];
}

/**
 *  下载资源
 *
 *  @param url 图片链接
 */
- (void)download:(NSString *)url
{
    if(self.saveAssetCallback)
    {
        //回调
        self.saveAssetCallback([NSURL URLWithString:url]);
    }
}

//开启多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


@end




