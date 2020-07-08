//
//  FeedViewController.h
//  Parse-Instagram
//
//  Created by Mason Llewellyn on 7/7/20.
//  Copyright © 2020 Facebook University. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FeedViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) NSArray *postArray;
@end

NS_ASSUME_NONNULL_END
