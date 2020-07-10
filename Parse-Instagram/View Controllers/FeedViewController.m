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
#import "postDetailsViewController.h"
#import "AppDelegate.h"
#import "SceneDelegate.h"


@interface FeedViewController ()

@end

@implementation FeedViewController
NSString *HeaderViewIdentifier = @"TableViewHeaderView";

- (void)fetchPosts{
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    //[query whereKey:@"likesCount" greaterThan:@100];
    [query orderByDescending:@"createdAt"];
    query.limit = 20;
    
    // fetch data asynchronously
    __weak typeof(self) weakSelf = self;
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // do something with the array of object returned by the call
            weakSelf.postArray = posts;
            NSLog(@"Got posts %ld", weakSelf.postArray.count);
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    
        [weakSelf.tableView reloadData];
    }];
    
}

- (void)refreshPosts:(UIRefreshControl*)refreshControl{
    [self fetchPosts];
    [refreshControl endRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.title = @"Home";
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshPosts:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
    
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:HeaderViewIdentifier];
    [self fetchPosts];
}

- (IBAction)photoButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"feedToCompose" sender:self];
}

#pragma mark - UploadView
- (void)didPost{
    NSLog(@"delegate method called!");
    [self fetchPosts];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    self.navigationController.modalPresentationStyle = UIModalPresentationFullScreen;
    if ([sender isKindOfClass:[FeedViewController class]]){
        //Segue to details
        UploadViewController *uploadVC = [segue destinationViewController];
        uploadVC.delegate = self;
    }
    if([sender isKindOfClass:[PostCell class]]){
        //If a user has clicked on a cell and is sent to the details view
        PostCell *cell = sender;
        postDetailsViewController *postVC = [segue destinationViewController];
        postVC.post = cell.post;
        
    }
}


#pragma mark - TableView

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    Post *currPost = self.postArray[indexPath.item];
    PostCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"postCell"];
    
    [cell setupCell: currPost];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderViewIdentifier];
    
    Post *currPost = self.postArray[section];
    NSLog(@"Drawing Header for %d", section);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
    formatter.dateStyle = NSDateFormatterShortStyle;
    
    header.textLabel.text = [formatter stringFromDate:currPost.createdAt];
    
    return header;
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.postArray.count;
}

- (IBAction)logoutPressed:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        sceneDelegate.window.rootViewController = loginViewController;
    }];
    
    
}


@end
