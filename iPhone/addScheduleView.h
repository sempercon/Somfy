//
//  addScheduleView.h
//  Somfy
//
//  Created by Karuppiah Annamalai on 7/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendCommand.h"
#import "Constants.h"

@interface addScheduleView : UIViewController<ParserCallback>  {
	IBOutlet UITextField  *scheduleNameTextField;
	
	NSTimer			*scheduleTimerInfoTimer,*scheduleEventInfoTimer,*ProcessTimer;
	ProcessEnum		scheduleTimerInfoEnum,scheduleEventInfoEnum,scheduleEnum;
	int				g_objectIndex,scheduleIndex,addedScheduleId;
	NSMutableArray  *loginArray;
	
	IBOutlet UIImageView	*animateImageView;
	IBOutlet UIScrollView	*animationScrollView;
	UILabel					*animationTitle1,*animationTitle2;
	NSTimer					*openTimer,*closeTimer;
	int						yPosition;
}


@property(nonatomic,retain) UITextField		*scheduleNameTextField;
@property(nonatomic,retain) UIImageView		*animateImageView;
@property(nonatomic,retain) UIScrollView	*animationScrollView;


-(IBAction)Cancel:(id)sender;
-(IBAction)Next:(id)sender;
-(void)MoveToEditSchedule;
-(void)OpenWindow;

@end
