//
//  ViewController.m
//  JS_OCTest
//
//  Created by Yang on 2017/6/8.
//  Copyright © 2017年 Yang. All rights reserved.
//

#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
@protocol JSObjcDelegate <JSExport>///JSExport协议，oc和js的通信协议。
//如果实现协议这边的方法必须和web端的JS里面的方法名称（调用的方法名：self.XXXX 的样式）保持一致才有效,所以一定要保持一致！！！！！！
- (void)callCamera;

- (void)share:(NSString *)shareString;

- (void)test;
@end
@interface ViewController ()<UIWebViewDelegate,JSObjcDelegate>

@property (nonatomic,strong) JSContext *jsContext;//JavaScript的执行环境

@property (nonatomic,strong) UIWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    NSURL *pathUrl = [[NSBundle mainBundle] URLForResource:@"index" withExtension:@"html"];
    
    [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:pathUrl] ];
    
    [self.view addSubview:self.webView];
    
    self.webView.delegate = self;
    
}
#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //通过webView的valueForKeyPath获取的，其路径为documentView.webView.mainFrame.javaScriptContext,就可以获取到JS的context
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //把 self 赋值给JS规定好的所有者。这里的JS里面的所有者是Yang  ---》 通配方法创建
    self.jsContext[@"Yang"] = self;
    //关联打印异常信息
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        context.exception = exception;
        NSLog(@"异常信息是%@",exception);
    };
}
#pragma mark -
- (void)callCamera
{
    NSLog(@"callCamera");
    JSValue *picCallBack = self.jsContext[@"picCallback"];//JSValue则可以说是JavaScript和Object-C之间互换的桥梁
    [picCallBack callWithArguments:@[@"Hellow World"]];
}
- (void)share:(NSString *)shareString
{
    JSValue *shareCallback = self.jsContext[@"shareCallback"];
    [shareCallback callWithArguments:nil];
}
-(void)test{
    NSLog(@"test");
    JSValue * testValue = self.jsContext[@"TestYang"];//把js中的方法提取给相应的JSValue
    [testValue callWithArguments:nil];//执行，并传递相应的参数
}

@end
