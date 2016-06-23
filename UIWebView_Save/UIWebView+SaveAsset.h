//
//  UIWebView+SaveAsset.h
//  UIWebView_Save
//
//  Created by 圈圈科技 on 16/6/23.
//  Copyright © 2016年 圈圈科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (SaveAsset)

/**
 *  加载链接
 *
 *  @param url 传入链接
 */
- (void)loadUrlString:(NSString *)url;

/**
 *  开启保存图片
 *
 *  @param saveAsset 保存回调
 */
- (void)saveImage:(void (^)(NSURL *url))saveImageCallback;

@end
