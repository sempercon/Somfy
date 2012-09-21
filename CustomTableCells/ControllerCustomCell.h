//
//  ControllerCustomCell.h
//  Somfy
//
//  Created by Sempercon on 7/29/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ControllerCustomCell : UITableViewCell {
	IBOutlet UILabel *lblControllerName;
	IBOutlet UIImageView *imgBg;
}
@property(nonatomic,retain) UILabel *lblControllerName;
@property(nonatomic,retain) UIImageView *imgBg;

@end
