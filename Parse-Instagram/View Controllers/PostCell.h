//
//  PostCell.h
//  Parse-Instagram
//
//  Created by Mason Llewellyn on 7/7/20.
//  Copyright © 2020 Facebook University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *postView;
@property (strong, nonatomic) Post *post;
@end

NS_ASSUME_NONNULL_END
