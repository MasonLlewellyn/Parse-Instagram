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

@interface UploadViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet PFImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UITextView *captionTextView;
@property (strong, nonatomic) UIImage *postImage;
@end

@implementation UploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.photoImageView setImage:self.postImage];
    self.captionTextView.text = @"Place Caption Here";
    
    [self selectImage];
    
    
}
- (IBAction)sharePressed:(id)sender {
    __weak typeof(self) weakSelf = self;
    [Post postUserImage:self.postImage withCaption:self.captionTextView.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded){
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
            //TODO: add a UploadViewController delegate method that is implemented in the feedViewController to refresh
            
            [self.delegate didPost];
        }
    }];
    
}
- (IBAction)cencelPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)selectImage{
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    //imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

#pragma mark - ImagePicker
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    //UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    CGSize sz = CGSizeMake(360, 360);
    
    [self resizeImage:editedImage withSize:sz];
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
    
    self.photoImageView.image = editedImage;
    self.postImage = editedImage;
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
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
