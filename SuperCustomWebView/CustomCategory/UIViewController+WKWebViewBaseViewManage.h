//
//  UIViewController+WKWebViewBaseViewManage.h
//  SuperCustomWebView
//
//  Created by 長内　幸太郎 on 2016/06/29.
//  Copyright © 2016年 長内　幸太郎. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKWebViewBaseView.h"

@interface UIViewController (WKWebViewBaseViewManage)

- (void)gosafariWithWKWebViewBaseView:(WKWebViewBaseView *)baseView
                        confirmDialog:(BOOL)confirm;

@end
