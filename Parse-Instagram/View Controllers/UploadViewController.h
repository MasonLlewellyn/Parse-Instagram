//
//  UploadViewController.h
//  Parse-Instagram
//
//  Created by Mason Llewellyn on 7/9/20.
//  Copyright © 2020 Facebook University. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface UploadViewController : UIViewController <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet PFImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UITextView *captionTextView;
@property (strong, nonatomic) UIImage *postImage;

@end

NS_ASSUME_NONNULL_END
