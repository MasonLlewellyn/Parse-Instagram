//
//  postDetailsViewController.m
//  Parse-Instagram
//
//  Created by Mason Llewellyn on 7/10/20.
//  Copyright © 2020 Facebook University. All rights reserved.
//

#import "postDetailsViewController.h"
#import "DateTools.h"

@interface postDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *createdLabel;
@property (weak, nonatomic) IBOutlet PFImageView *photoImageView;

@property (weak, nonatomic) IBOutlet UILabel *captionLabel;


@end

@implementation postDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    
}

- (void)setupView{
    self.photoImageView.file = self.post[@"image"];
    //self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.photoImageView loadInBackground];
    NSLog(@"%@", self.post[@"caption"]);
    
    NSDate *createDate = self.post[@"createdAt"];
    NSDate *dt = [NSDate date];
    
    
    NSTimeInterval refTime = -86400;
    NSTimeInterval sinceCreated = [createDate timeIntervalSinceDate:dt];
    
    if (sinceCreated >= refTime){
        self.createdLabel.text = createDate.shortTimeAgoSinceNow;
    }
    else{
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
        formatter.dateStyle = NSDateFormatterShortStyle;
        
        self.createdLabel.text = [formatter stringFromDate:createDate];
    }
    
    self.captionLabel.text = self.post[@"caption"];
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
