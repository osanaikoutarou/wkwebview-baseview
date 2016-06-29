//
//  WKWebViewBaseView.h
//  SuperCustomWebView
//
//  Created by 長内　幸太郎 on 2016/06/29.
//  Copyright © 2016年 長内　幸太郎. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

typedef void (^DidStartProvisionalNavigationBlock)(WKNavigation *navigation);
typedef void (^DidCommitNavigationBlock)(WKNavigation *navigation);
typedef void (^DidFinishNavigationBlock)(WKNavigation *navigation);
typedef void (^DidFailProvisionalNavigationBlock)(WKNavigation *navigation);
typedef void (^DidReceiveServerRedirectForProvisionalNavigationBlock)(WKNavigation *navigation);

typedef void (^ChangedEstimatedProgressBlock)(double estimatedProgress);
typedef void (^ChangedTitleBlock)(NSString *title);
typedef void (^ChangedLoadingBlock)(BOOL loading);
typedef void (^ChangedCanGoBackBlock)(BOOL canGoBack);
typedef void (^ChangedCanGoForwardBlock)(BOOL canGoForward);

@interface WKWebViewBaseView : UIView <WKNavigationDelegate>

@property (nonatomic) WKWebView *wkWebView;

#pragma mark - blokcs

@property (nonatomic,copy) DidStartProvisionalNavigationBlock didStartProvisionalNavigationBlock;
@property (nonatomic,copy) DidCommitNavigationBlock didCommitNavigationBlock;
@property (nonatomic,copy) DidFinishNavigationBlock didFinishNavigationBlock;
@property (nonatomic,copy) DidFailProvisionalNavigationBlock didFailProvisionalNavigationBlock;
@property (nonatomic,copy) DidReceiveServerRedirectForProvisionalNavigationBlock didReceiveServerRedirectForProvisionalNavigationBlock;

@property (nonatomic,copy) ChangedEstimatedProgressBlock changedEstimatedProgressBlock;
@property (nonatomic,copy) ChangedTitleBlock changedTitleBlock;
@property (nonatomic,copy) ChangedLoadingBlock changedLoadingBlock;
@property (nonatomic,copy) ChangedCanGoBackBlock changedCanGoBackBlock;
@property (nonatomic,copy) ChangedCanGoForwardBlock changedCanGoForwardBlock;


#pragma mark - blocks setup

// call in viewDidLoad
- (void)setupAndLoad:(NSURL *)url;
- (void)setupWithInsets:(UIEdgeInsets)inset url:(NSURL *)url;

// call if need
- (void)setupMothodBlocksDidStartProvisionalNavigationBlock:(DidStartProvisionalNavigationBlock)didStartProvisionalNavigationBlock
                                   DidCommitNavigationBlock:(DidCommitNavigationBlock)didCommitNavigationBlock
                                   DidFinishNavigationBlock:(DidFinishNavigationBlock)didFinishNavigationBlock
                          DidFailProvisionalNavigationBlock:(DidFailProvisionalNavigationBlock)didFailProvisionalNavigationBlock
      DidReceiveServerRedirectForProvisionalNavigationBlock:(DidReceiveServerRedirectForProvisionalNavigationBlock)didReceiveServerRedirectForProvisionalNavigationBlock
                              ChangedEstimatedProgressBlock:(ChangedEstimatedProgressBlock)changedEstimatedProgressBlock
                                          ChangedTitleBlock:(ChangedTitleBlock)changedTitleBlock
                                        ChangedLoadingBlock:(ChangedLoadingBlock)changedLoadingBlock
                                      ChangedCanGoBackBlock:(ChangedCanGoBackBlock)changedCanGoBackBlock
                                   ChangedCanGoForwardBlock:(ChangedCanGoForwardBlock)changedCanGoForwardBlock;

// after dialog
// 特にDidFailProvisionalNavigationBlock内で呼ぶと良い
- (BOOL)goSafari;

@end
