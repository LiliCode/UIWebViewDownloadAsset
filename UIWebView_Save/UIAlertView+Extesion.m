//
//  UIAlertView+Extesion.m
//  UIWebView_Save
//
//  Created by 李立 on 16/6/23.
//  Copyright © 2016年 圈圈科技. All rights reserved.
//

#import "UIAlertView+Extesion.h"

@implementation UIAlertView (Extesion)

+ (void)message:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}


@end
