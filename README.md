# UIWebView下载资源（图片，音频，视频等）

### 接口函数

#### 加载链接

        - (void)loadUrlString:(NSString *)url;

#### 长按获取图片url

        - (void)saveImage:(void (^)(NSURL *url))saveImageCallback;

### 使用方法
#### 加载网页

        [self.webView loadUrlString:@"http://image.baidu.com/"];
        
####长按图片获取url

        [self.webView saveImage:^(NSURL *url) {
            //你要处理的事
        }];
