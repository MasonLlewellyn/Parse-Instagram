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
#import "DateTools.h"
#import "PostCell.h"
#import "LoginViewController.h"
#import "UploadViewController.h"
#import "postDetailsViewController.h"
#import "AppDelegate.h"
#import "SceneDelegate.h"


@interface FeedViewController ()
@property (assign, nonatomic) BOOL isMoreDataLoading;
@property (assign, nonatomic) NSInteger loadedCount;
@end

@implementation FeedViewController
NSString *HeaderViewIdentifier = @"TableViewHeaderView";

- (void)fetchPosts:(NSInteger)skipCount{
    //Completely refreshes the table view
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    //[query whereKey:@"likesCount" greaterThan:@100];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    query.limit = 20;
    
    
    // fetch data asynchronously
    __weak typeof(self) weakSelf = self;
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // do something with the array of object returned by the call
            weakSelf.postArray = [NSMutableArray arrayWithArray:posts];
            NSLog(@"Got posts %ld", weakSelf.postArray.count);
            weakSelf.loadedCount = posts.count;
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    
        [weakSelf.tableView reloadData];
    }];
    
}

- (void)fetchMorePosts{
    //Fetches more posts for the tableView
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    //[query whereKey:@"likesCount" greaterThan:@100];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    query.limit = 20;
    query.skip = self.loadedCount;
    
    // fetch data asynchronously
    __weak typeof(self) weakSelf = self;
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // do something with the array of object returned by the call
            [weakSelf.postArray addObjectsFromArray:posts];
            NSLog(@"Got posts %ld", posts.count);
            weakSelf.loadedCount += posts.count;
            
            self.isMoreDataLoading = false;
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    
        [weakSelf.tableView reloadData];
    }];
}

- (void)refreshPosts:(UIRefreshControl*)refreshControl{
    self.loadedCount = 0;
    [self fetchPosts: self.loadedCount];
    [refreshControl endRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.title = @"Home";
    
    self.postArray = [NSMutableArray array];
    
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshPosts:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
    
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:HeaderViewIdentifier];
    
    self.loadedCount = 0;
    [self fetchPosts:self.loadedCount];
}

- (IBAction)photoButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"feedToCompose" sender:self];
}

#pragma mark - UploadView
- (void)didPost{
    NSLog(@"delegate method called!");
    self.loadedCount = 0;
    [self fetchPosts: self.loadedCount];
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
    Post *currPost = self.postArray[(indexPath.row + 1) * indexPath.section];
    PostCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"postCell"];
    
    [cell setupCell: currPost];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderViewIdentifier];
    
    Post *currPost = self.postArray[section];
    
    NSString *dateString = currPost.createdAt.shortTimeAgoSinceNow;//[formatter stringFromDate:currPost.createdAt];
    NSString *userString = currPost.author.username;//currPost[@"author"];
    NSString *headerString = [NSString stringWithFormat:@"%@ • %@", userString, dateString];
    
    header.textLabel.text = headerString;
    
    return header;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.postArray.count;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(!self.isMoreDataLoading){

        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
        
        
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
            self.isMoreDataLoading = true;
            NSLog(@"Reached bottom.  More data being loaded");
            [self fetchMorePosts];
        }
    }

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
