//
//  WKWebViewBaseView.m
//  SuperCustomWebView
//
//  Created by 長内　幸太郎 on 2016/06/29.
//  Copyright © 2016年 長内　幸太郎. All rights reserved.
//

#import "WKWebViewBaseView.h"

const BOOL debug = YES;

@implementation WKWebViewBaseView {
    UIEdgeInsets contentInset;
}

#pragma mark -

// コードで追加したい場合
+ (instancetype)view {
    NSString *className = NSStringFromClass([self class]);
    return [[[NSBundle mainBundle] loadNibNamed:className owner:nil options:0] firstObject];
}


#pragma mark - setupWKWebView

// inset有り
- (void)setupWithInsets:(UIEdgeInsets)inset url:(NSURL *)url {
    contentInset = inset;
    
    [self setupWKWebViewDefault];
    [self setupObserver];
    
    //    [self setupAutoLayout];
    [self addSubview:self.wkWebView];
    
    if (url && url.absoluteString && url.absoluteString.length>0) {
        [self.wkWebView loadRequest:[NSURLRequest requestWithURL:url]];
    }
}

- (void)setupAndLoad:(NSURL *)url {
    [self setupWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) url:url];
}

// insetはゼロ
- (void)setupWKWebViewDefault {
    
    self.wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.wkWebView.navigationDelegate = self;
    self.wkWebView.allowsBackForwardNavigationGestures = YES;
}

#pragma mark - layout

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.wkWebView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    //???:ContentInsetがTopに挟まれることがあるため
    //FIXME:部分最適となっている、カスタマイズが必要かも
    self.wkWebView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)dealloc {
    [self removeObservers];
}

#pragma mark - observer

- (void)setupObserver {
    // 全部監視
    [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.wkWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    [self.wkWebView addObserver:self forKeyPath:@"loading" options:NSKeyValueObservingOptionNew context:nil];
    [self.wkWebView addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:nil];
    [self.wkWebView addObserver:self forKeyPath:@"canGoForward" options:NSKeyValueObservingOptionNew context:nil];
    
    [self log:@"[WKWebViewBaseView] observer start"];
}

- (void)removeObservers {
    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.wkWebView removeObserver:self forKeyPath:@"title"];
    [self.wkWebView removeObserver:self forKeyPath:@"loading"];
    [self.wkWebView removeObserver:self forKeyPath:@"canGoBack"];
    [self.wkWebView removeObserver:self forKeyPath:@"canGoForward"];
    
    [self log:@"[WKWebViewBaseView] observer stop"];
}

////FIXME:諦めたやつ
//- (void)setupAutoLayout {
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.wkWebView
//                                                     attribute:NSLayoutAttributeTop
//                                                     relatedBy:NSLayoutRelationEqual
//                                                        toItem:self
//                                                     attribute:NSLayoutAttributeTop
//                                                    multiplier:1.0
//                                                      constant:0]];
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.wkWebView
//                                                     attribute:NSLayoutAttributeLeft
//                                                     relatedBy:NSLayoutRelationEqual
//                                                        toItem:self
//                                                     attribute:NSLayoutAttributeLeft
//                                                    multiplier:1.0
//                                                      constant:0]];
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.wkWebView
//                                                     attribute:NSLayoutAttributeRight
//                                                     relatedBy:NSLayoutRelationEqual
//                                                        toItem:self
//                                                     attribute:NSLayoutAttributeRight
//                                                    multiplier:1.0
//                                                      constant:0]];
//    
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.wkWebView
//                                                     attribute:NSLayoutAttributeBottom
//                                                     relatedBy:NSLayoutRelationEqual
//                                                        toItem:self
//                                                     attribute:NSLayoutAttributeBottom
//                                                    multiplier:1.0
//                                                      constant:0]];
//}

#pragma mark - NSKeyValueObserving methods

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        [self log:@"[WKWebViewBaseView](Key) estimatedProgress"];

        // ex:プログレスバーを更新する
        // self.wkWebView.estimatedProgress * 100.0f
        // [self.navigationController setSGProgressPercentage:self.webView.estimatedProgress * 100.0f];
        
        if (self.changedEstimatedProgressBlock) {
            self.changedEstimatedProgressBlock(self.wkWebView.estimatedProgress);
        }
    }
    else if ([keyPath isEqualToString:@"title"]) {
        [self log:@"[WKWebViewBaseView](Key) title"];
        
        // titleが変更された
        // self.title = self.webView.title;
        
        if (self.changedTitleBlock) {
            self.changedTitleBlock(self.wkWebView.title);
        }
    }
    else if ([keyPath isEqualToString:@"loading"]) {
        [self log:@"[WKWebViewBaseView](Key) loading"];
        
        // load中かどうか
        // self.wkWebView.loading
        // [UIApplication sharedApplication].networkActivityIndicatorVisible = self.wkWebView.loading;
        
        // ex:リロードボタンと読み込み停止ボタンの有効・無効を切り替える
        // self.reloadButton.enabled = !self.wkWebView.loading;
        // self.stopButton.enabled = self.wkWebView.loading;
        
        if (self.changedLoadingBlock) {
            self.changedLoadingBlock(self.wkWebView.loading);
        }
    }
    else if ([keyPath isEqualToString:@"canGoBack"]) {
        [self log:@"[WKWebViewBaseView](Key) canGoBack"];
        
        // ex:「＜」ボタンの有効・無効を切り替える
        // self.backButton.enabled = self.wkWebView.canGoBack;
        
        if (self.changedCanGoBackBlock) {
            self.changedCanGoBackBlock(self.wkWebView.canGoBack);
        }
    }
    else if ([keyPath isEqualToString:@"canGoForward"]) {
        [self log:@"[WKWebViewBaseView](Key) canGoForward"];
        
        // ex:「＞」ボタンの有効・無効を切り替える
        // self.forwardButton.enabled = self.wkWebView.canGoForward;
        
        if (self.changedCanGoForwardBlock) {
            self.changedCanGoForwardBlock(self.wkWebView.canGoForward);
        }
    }
}


#pragma mark - Nav methods

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [self log:@"[WKWebViewBaseView](Nav) didStartProvisionalNavigation"];
    
    // ページの読み込み準備開始
    if (self.didStartProvisionalNavigationBlock) {
        self.didStartProvisionalNavigationBlock(navigation);
    }
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    [self log:@"[WKWebViewBaseView](Nav) didCommitNavigation"];
    [self log:@"    -ページ読み込み開始"];
    
    // ページが見つかり、読み込み開始
    if (self.didCommitNavigationBlock) {
        self.didCommitNavigationBlock(navigation);
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self log:@"[WKWebViewBaseView](Nav) didFinishNavigation"];
    [self log:@"    -ページ読み込み完了"];

    // ページの読み込み完了
    if (self.didFinishNavigationBlock) {
        self.didFinishNavigationBlock(navigation);
    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self log:@"[WKWebViewBaseView](Nav) didFailProvisionalNavigation"];
    [self log:@"    -ページ読み込み失敗"];
    
    // ページの読み込み失敗
    if (self.didFailProvisionalNavigationBlock) {
        self.didFailProvisionalNavigationBlock(navigation);
    }
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    [self log:@"[WKWebViewBaseView](Nav) didReceiveServerRedirectForProvisionalNavigation"];
    
    // 表示中にリダイレクト
    if (self.didReceiveServerRedirectForProvisionalNavigationBlock) {
        self.didReceiveServerRedirectForProvisionalNavigationBlock(navigation);
    }
}

// まだベータ
//- (void)                    webView:(WKWebView *)webView
//  didReceiveAuthenticationChallenge:(nonnull NSURLAuthenticationChallenge *)challenge
//                  completionHandler:(nonnull void (^)(NSURLSessionAuthChallengeDisposition,
//                                                      NSURLCredential * _Nullable))completionHandler {
//    [self log:@"[WKWebViewBaseView](Nav) didReceiveAuthenticationChallenge"];
//    
//    
//    SecTrustRef secTrustRef = challenge.protectionSpace.serverTrust;
//    if (secTrustRef != NULL) {
//        NSLog(@"01   ");
//        SecTrustResultType result;
//        OSErr er = SecTrustEvaluate(secTrustRef, &result);
//        if (er != noErr) {
//            NSLog(@"02   ");
//            completionHandler(NSURLSessionAuthChallengeRejectProtectionSpace, nil);
//            return;
//        }
//        if (result == kSecTrustResultRecoverableTrustFailure) {
//            NSLog(@"03   ");
//
//            //信頼出来ない証明書
//            CFArrayRef secTrustProperties = SecTrustCopyProperties(secTrustRef);
//            NSArray *arr = CFBridgingRelease(secTrustProperties);
//            NSMutableString *errorStr = [NSMutableString string];
//            for (int i=0; i<arr.count; i++) {
//                NSDictionary *dic = [arr objectAtIndex:i];
//                if (i != 0 ) [errorStr appendString:@" "];
//                [errorStr appendString:(NSString*)dic[@"value"]];
//            }
//            
//            SecCertificateRef certRef = SecTrustGetCertificateAtIndex(secTrustRef, 0);
//            CFStringRef cfCertSummaryRef =  SecCertificateCopySubjectSummary(certRef);
//            NSString *certSummary = (NSString *)CFBridgingRelease(cfCertSummaryRef);
//            NSString *title = @"Cannot Verify Server Identity";
//            NSString *message = [NSString stringWithFormat:@"The identity of “%@” cannot be verified by %@. The certificate is from “%@”. \n%@", @"hostname", @"YOUR_APPNAME", certSummary, errorStr];
//            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
//            // キャンセルボタン
//            [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
//                                                                style:UIAlertActionStyleDefault
//                                                              handler:^(UIAlertAction *action) {
//                                                                  completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);}]
//             ];
//            // 続けるボタン
//            [alertController addAction:[UIAlertAction actionWithTitle:@"Continue" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//                NSURLCredential* credential = [NSURLCredential credentialForTrust:secTrustRef];
//                completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
//                
//            }]];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                //[_delegate presentViewController:alertController animated:YES completion:^{}];
//            });
//            
//            NSLog(@"04   ");
//
//            return;
//        }
//        NSURLCredential* credential = [NSURLCredential credentialForTrust:secTrustRef];
//        completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
//        
//        NSLog(@"05   ");
//
//        return;
//    }
//    NSLog(@"06   ");
//
//    completionHandler(NSURLSessionAuthChallengeRejectProtectionSpace, nil);
//}

#pragma mark - method

- (BOOL)goSafari {
    [[UIApplication sharedApplication] openURL:self.wkWebView.URL];
    return YES;
}

#pragma mark - DelegateMethod,Observe method 設定

// 全て一気に設定
- (void)setupMothodBlocksDidStartProvisionalNavigationBlock:(DidStartProvisionalNavigationBlock)didStartProvisionalNavigationBlock
                                   DidCommitNavigationBlock:(DidCommitNavigationBlock)didCommitNavigationBlock
                                   DidFinishNavigationBlock:(DidFinishNavigationBlock)didFinishNavigationBlock
                          DidFailProvisionalNavigationBlock:(DidFailProvisionalNavigationBlock)didFailProvisionalNavigationBlock
      DidReceiveServerRedirectForProvisionalNavigationBlock:(DidReceiveServerRedirectForProvisionalNavigationBlock)didReceiveServerRedirectForProvisionalNavigationBlock
                              ChangedEstimatedProgressBlock:(ChangedEstimatedProgressBlock)changedEstimatedProgressBlock
                                          ChangedTitleBlock:(ChangedTitleBlock)changedTitleBlock
                                        ChangedLoadingBlock:(ChangedLoadingBlock)changedLoadingBlock
                                      ChangedCanGoBackBlock:(ChangedCanGoBackBlock)changedCanGoBackBlock
                                   ChangedCanGoForwardBlock:(ChangedCanGoForwardBlock)changedCanGoForwardBlock
{
    
    self.didStartProvisionalNavigationBlock = didStartProvisionalNavigationBlock;
    self.didCommitNavigationBlock = didCommitNavigationBlock;
    self.didFinishNavigationBlock = didFinishNavigationBlock;
    self.didFailProvisionalNavigationBlock = didFailProvisionalNavigationBlock;
    self.didReceiveServerRedirectForProvisionalNavigationBlock = didReceiveServerRedirectForProvisionalNavigationBlock;
    self.changedEstimatedProgressBlock = changedEstimatedProgressBlock;
    self.changedTitleBlock = changedTitleBlock;
    self.changedLoadingBlock = changedLoadingBlock;
    self.changedCanGoBackBlock = changedCanGoBackBlock;
    self.changedCanGoForwardBlock = changedCanGoForwardBlock;
    
}

#pragma mark - action


#pragma mark - debug log

- (void)log:(NSString *)str {
    if (debug) {
        NSLog(@"%@",str);
    }
}

@end
