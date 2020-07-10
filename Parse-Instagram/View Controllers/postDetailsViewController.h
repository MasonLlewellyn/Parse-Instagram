//
//  postDetailsViewController.h
//  Parse-Instagram
//
//  Created by Mason Llewellyn on 7/10/20.
//  Copyright © 2020 Facebook University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface postDetailsViewController : UIViewController
@property (nonatomic, strong) Post *post;
@property (nonatomic, strong) UIImage *postImage;
@end

NS_ASSUME_NONNULL_END
