//
//  PostCell.m
//  Parse-Instagram
//
//  Created by Mason Llewellyn on 7/7/20.
//  Copyright © 2020 Facebook University. All rights reserved.
//

#import "PostCell.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void) setupCell:(Post *)currPost{
    [self setPost:currPost];
    self.postCaption.text = currPost[@"caption"];
}

- (void)setPost:(Post *)post {
    _post = post;
    self.photoImageView.file = post[@"image"];
    //self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.photoImageView loadInBackground];
}

@end
