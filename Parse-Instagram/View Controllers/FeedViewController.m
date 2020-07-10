//
//  FeedViewController.m
//  Parse-Instagram
//
//  Created by Mason Llewellyn on 7/7/20.
//  Copyright © 2020 Facebook University. All rights reserved.
//

#import "FeedViewController.h"
#import <Parse/Parse.h>
#import "Post.h"
#import "PostCell.h"
#import "LoginViewController.h"
#import "UploadViewController.h"
#import "AppDelegate.h"

@interface FeedViewController ()

@end

@implementation FeedViewController


- (void)fetchPosts{
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    //[query whereKey:@"likesCount" greaterThan:@100];
    query.limit = 20;
    
    // fetch data asynchronously
    __weak typeof(self) weakSelf = self;
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // do something with the array of object returned by the call
            weakSelf.postArray = posts;
            NSLog(@"Got posts %ld", weakSelf.postArray.count);
            //NSLog(weakSelf.postArray);
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    
        [weakSelf.tableView reloadData];
    }];
    
    ;
    
}

- (void)refreshPosts:(UIRefreshControl*)refreshControl{
    [self fetchPosts];
    [refreshControl endRefreshing];
}

- (void) viewWillAppear:(BOOL)animated{
    NSLog(@"View Appearing!");
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //self.tableView.rowHeight = 200;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshPosts:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
    
    [self fetchPosts];
}

- (IBAction)photoButtonPressed:(id)sender {
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
    
    //[self resizeImage:editedImage withSize:sz];
    // Do something with the images (based on your use case)
    /*__weak typeof(self) weakSelf = self;
    [Post postUserImage:editedImage withCaption:@"" withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) NSLog(@"Posted image");
        
        [weakSelf refreshPosts];
    }];*/
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self performSegueWithIdentifier:@"feedToCompose" sender:editedImage];
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    self.navigationController.modalPresentationStyle = UIModalPresentationFullScreen;
    if([sender isKindOfClass:[UIImage class]]){
        //We are segueing to the the Compose View
        UINavigationController *controlr = [segue destinationViewController];
        UploadViewController *upCtr = [controlr viewControllers][0];
        upCtr.postImage = (UIImage*)sender;
    }
    else if([sender isKindOfClass:[PostCell class]]){
        PostCell *cell = sender;
        
    }
}


#pragma mark - TableView

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSLog(@"Another One");
    Post *currPost = self.postArray[indexPath.item];
    PostCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"postCell"];
    
    [cell setupCell: currPost];
    if (cell == nil){
        NSLog(@"Young rich and tasteless");
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.postArray.count;
}

- (IBAction)logoutPressed:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        appDelegate.window.rootViewController = loginViewController;
    }];
    
}


@end
