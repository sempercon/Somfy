//
//  ScheduleCustomCell.h
//  Somfy
//
//  Created by Karuppiah Annamalai on 7/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScheduleCustomCell.h"

@class ScheduleCustomCell;

@protocol ScheduleCustomCellDelegate <NSObject>
-(void)ScheduleSelected:(ScheduleCustomCell*)cell;
@end


@interface ScheduleCustomCell : UITableViewCell {
	IBOutlet UIImageView *backgroundImg,*img;
	IBOutlet UILabel	 *lblScheduleName,*lblScheduleEnable;
	IBOutlet UIButton	 *arrowBtn;
	NSObject<ScheduleCustomCellDelegate> *delegate;
}

@property(nonatomic,retain) UIImageView *backgroundImg,*img;
@property(nonatomic,retain) UILabel	 *lblScheduleName,*lblScheduleEnable;
@property(nonatomic,retain) UIButton	 *arrowBtn;
@property(nonatomic,assign) NSObject<ScheduleCustomCellDelegate> *delegate;

@end
