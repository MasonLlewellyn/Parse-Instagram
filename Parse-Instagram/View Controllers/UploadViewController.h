//
//  UploadViewController.h
//  Parse-Instagram
//
//  Created by Mason Llewellyn on 7/9/20.
//  Copyright © 2020 Facebook University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@protocol UploadViewControllerDelegate
- (void)didPost;
@end

@interface UploadViewController : UIViewController
@property (nonatomic, weak) id<UploadViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
