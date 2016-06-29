//
//  UIViewController+WKWebViewBaseViewManage.m
//  SuperCustomWebView
//
//  Created by 長内　幸太郎 on 2016/06/29.
//  Copyright © 2016年 長内　幸太郎. All rights reserved.
//

#import "UIViewController+WKWebViewBaseViewManage.h"

@implementation UIViewController (WKWebViewBaseViewManage)

- (void)gosafariWithWKWebViewBaseView:(WKWebViewBaseView *)baseView
                        confirmDialog:(BOOL)confirm {
    
    if (![self checkUrl:baseView]) {
        //TODO:エラー
        return;
    }
    if (confirm) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@""
                                                                    message:@"safariに移動します"
                                                             preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"OK"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            [baseView goSafari];
                                                        }];
        // 確認せずにsafariを開きたい場合
//        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"今後、確認せず移動する"
//                                                         style:UIAlertActionStyleDefault
//                                                       handler:^(UIAlertAction * _Nonnull action) {
//                                                       }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"キャンセル"
                                                         style:UIAlertActionStyleCancel
                                                       handler:nil];
        [ac addAction:action1];
        [ac addAction:cancel];
        
        [self presentViewController:ac animated:YES completion:nil];
    }
    else {
        [baseView goSafari];
    }
}

// 空なのにsafari行ったら嫌だし
- (BOOL)checkUrl:(WKWebViewBaseView *)baseView {
    NSLog(@"%@",baseView.wkWebView.URL.absoluteString);
    if (baseView &&
        baseView.wkWebView.URL &&
        baseView.wkWebView.URL.absoluteString &&
        baseView.wkWebView.URL.absoluteString.length>0) {
        return YES;
    }
    else {
        return NO;
    }
}

@end
