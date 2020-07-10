//
//  UploadViewController.m
//  Parse-Instagram
//
//  Created by Mason Llewellyn on 7/9/20.
//  Copyright © 2020 Facebook University. All rights reserved.
//

#import "UploadViewController.h"
#import "Post.h"
@import Parse;

@interface UploadViewController ()

@end

@implementation UploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.photoImageView setImage:self.postImage];
    self.captionTextView.text = @"Place Caption Here";
}
- (IBAction)sharePressed:(id)sender {
    __weak typeof(self) weakSelf = self;
    [Post postUserImage:self.postImage withCaption:self.captionTextView.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
