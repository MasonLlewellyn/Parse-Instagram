//
//  FeedViewController.h
//  Parse-Instagram
//
//  Created by Mason Llewellyn on 7/7/20.
//  Copyright © 2020 Facebook University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UploadViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FeedViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UploadViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *postArray;
@end

NS_ASSUME_NONNULL_END
