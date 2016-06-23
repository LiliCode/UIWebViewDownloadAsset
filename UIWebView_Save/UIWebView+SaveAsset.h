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
 *  获取图片url
 *
 *  @param saveAsset 保存回调
 */
- (void)fetchImageUrl:(void (^)(NSURL *url))saveImageCallback;

/**
 *  图片保存成功调用 虚函数
 *
 *  @param image       图片
 *  @param error       错误详情
 *  @param contextInfo 上下文信息
 */
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;

@end
