//
//  ViewController.m
//  SuperCustomWebView
//
//  Created by 長内　幸太郎 on 2016/06/29.
//  Copyright © 2016年 長内　幸太郎. All rights reserved.
//

#import "ViewController.h"
#import "WKWebViewBaseView.h"
#import "UIViewController+WKWebViewBaseViewManage.h"

@interface ViewController ()

@end

@implementation ViewController {
    
    __weak IBOutlet WKWebViewBaseView *wkWebViewBaseView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [wkWebViewBaseView setupAndLoad:[NSURL URLWithString:@"https://google.com"]];
    
    [wkWebViewBaseView setupMothodBlocksDidStartProvisionalNavigationBlock:^(WKNavigation *navigation) {
        
    } DidCommitNavigationBlock:^(WKNavigation *navigation) {
        
    } DidFinishNavigationBlock:^(WKNavigation *navigation) {
        
    } DidFailProvisionalNavigationBlock:^(WKNavigation *navigation) {
        [self gosafariWithWKWebViewBaseView:wkWebViewBaseView confirmDialog:YES];
    } DidReceiveServerRedirectForProvisionalNavigationBlock:^(WKNavigation *navigation) {
        
    } ChangedEstimatedProgressBlock:^(double estimatedProgress) {
        
    } ChangedTitleBlock:^(NSString *title) {
        
    } ChangedLoadingBlock:^(BOOL loading) {
        
    } ChangedCanGoBackBlock:^(BOOL canGoBack) {
        
    } ChangedCanGoForwardBlock:^(BOOL canGoForward) {
        
    }];
}

@end
