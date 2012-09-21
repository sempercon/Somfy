//
//  SceneViewController.h
//  Somfy
//
//  Created by Sempercon on 4/22/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendCommand.h"
#import "Constants.h"
#import "SceneCustomCell.h"

@interface SceneViewController : UIViewController<ParserCallback,SceneCustomCellDelegate> {
	IBOutlet UITableView    *tableView;
	IBOutlet UIScrollView	*scrollView;
	BOOL   issceneSelect,isSceneEdit;
	int    g_selectedSceneId,g_selectedsceneIndex,SceneInfoId;
	NSMutableArray  *loginArray;
    IBOutlet UIButton *Logout;
}

@property(nonatomic,retain) UIButton *Logout;


@property(nonatomic,retain) UITableView			*tableView;
@property(nonatomic,retain) UIScrollView		*scrollView;

-(IBAction)LOGOUT:(id)sender;

@end
