# UIWebView下载资源（图片，音频，视频等）
===============
### 接口函数

#### 加载链接

       /**
        *  加载链接
        *
        *  @param url 传入链接
        */
        - (void)loadUrlString:(NSString *)url;

#### 长按获取图片url

       /**
        *  获取长按图片的链接
        *
        *  @param saveAsset 保存回调
        */
        - (void)fetchImageUrl:(void (^)(NSURL *url))saveImageCallback;

### 使用方法
#### 加载网页

        [self.webView loadUrlString:@"http://image.baidu.com/"];
        
####长按图片获取url

        [self.webView fetchImageUrl:^(NSURL *url) {
            //你要处理的事
        }];
        
####直接保存图片

       [self.webView fetchImageUrl:nil];
