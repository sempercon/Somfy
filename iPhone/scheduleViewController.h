//
//  scheduleViewController.h
//  Somfy
//
//  Created by Sempercon on 4/24/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendCommand.h"
#import "Constants.h"
#import "ScheduleCustomCell.h"

@interface scheduleViewController : UIViewController<ParserCallback,ScheduleCustomCellDelegate> {
	IBOutlet UITableView	*tableView;
	IBOutlet UIScrollView	*scrollView;
	IBOutlet UIView		 *addScheduleSubView;
	IBOutlet UITextField *addScheduleTextField;
	NSTimer			*scheduleTimerInfoTimer,*scheduleEventInfoTimer,*ProcessTimer;
	ProcessEnum		scheduleTimerInfoEnum,scheduleEventInfoEnum,scheduleEnum;
	int g_objectIndex,enableorDisableIndex;
	NSString *strInfoType;
	NSMutableArray  *loginArray;
    IBOutlet UIButton *Logout;
}

@property(nonatomic,retain) UIButton *Logout;


@property(nonatomic,retain) UITableView		*tableView;
@property(nonatomic,retain) UIScrollView	*scrollView;
@property(nonatomic,retain) UIView			*addScheduleSubView;
@property(nonatomic,retain) UITextField		*addScheduleTextField;

-(IBAction)ADD:(id)sender;
-(IBAction)ADDScheduleCreate:(id)sender;
-(IBAction)ADDScheduleCancel:(id)sender;

-(IBAction)LOGOUT:(id)sender;

@end
