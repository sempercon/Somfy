//
//  SceneCustomCell.m
//  Somfy
//
//  Created by Sempercon on 5/13/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import "SceneCustomCell.h"


@implementation SceneCustomCell

@synthesize lblSceneName,lblActivated,btnSceneName;
@synthesize btnScene,btnActivated;
@synthesize delegate;
@synthesize imageIndicator,imgBg;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier 
{
    if (self = [super initWithStyle:UITableViewStylePlain reuseIdentifier:reuseIdentifier]) 
    {		
		imgBg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 300, 45)];
        imgBg.contentMode = UIViewContentModeScaleToFill;
        imgBg.clipsToBounds = YES;
		imgBg.autoresizingMask = UIViewAutoresizingNone;
        [self.contentView addSubview:imgBg];
		
		btnScene = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		btnScene.frame=CGRectMake(5, 5, 32, 33);
		[btnScene addTarget:self action:@selector(Onclick:)  forControlEvents:UIControlEventTouchUpInside];
		[self.contentView addSubview:btnScene];
		
		lblSceneName = [[[UILabel alloc]initWithFrame:CGRectMake(45, 7, 250, 30)]autorelease];
		lblSceneName.textColor=[UIColor colorWithRed:65/255 green:107/255 blue:121/255 alpha:1.0 ];
		lblSceneName.backgroundColor=[UIColor clearColor];
		lblSceneName.lineBreakMode= UILineBreakModeWordWrap;
		lblSceneName.contentMode = UIViewContentModeScaleToFill;
		lblSceneName.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
		lblSceneName.numberOfLines=0;
		[self.contentView addSubview:lblSceneName];
		
		btnSceneName = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		btnSceneName.frame=CGRectMake(45, 7, 250, 30);
		btnSceneName.backgroundColor=[UIColor clearColor];
		[btnSceneName addTarget:self action:@selector(Onclick:)  forControlEvents:UIControlEventTouchUpInside];
		[self.contentView addSubview:btnSceneName];
				
		btnActivated = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		btnActivated.frame=CGRectMake(160, 10, 125, 25);
		[btnActivated setBackgroundImage:[UIImage imageNamed:@"iP_Activated.png"] forState:UIControlStateNormal];
		
		[self.contentView addSubview:btnActivated];
		
		imageIndicator = [[UIImageView alloc]initWithFrame:CGRectMake(250, 25, 11, 11)];
        imageIndicator.contentMode = UIViewContentModeScaleToFill;
        imageIndicator.clipsToBounds = YES;
		imageIndicator.autoresizingMask = UIViewAutoresizingNone;
        [self.contentView addSubview:imageIndicator];

	}
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state.
}

-(void)Onclick:(id)sender
{
	if ([delegate respondsToSelector:@selector(ScenesSelected:)])
    {
        [delegate ScenesSelected:self];
    }
}


- (void)dealloc {
	[imgBg release];
	[imageIndicator release];
	[lblActivated release];
	[lblSceneName release];
	[delegate release];
	[btnScene release];
	[btnSceneName release];
	[btnActivated release];
    [super dealloc];
}


@end
