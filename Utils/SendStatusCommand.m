//
//  SendStatusCommand.m
//  Somfy
//
//  Created by Sempercon on 5/5/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import "SendStatusCommand.h"
#import "TouchXML.h"
#import "Constants.h"

@implementation SendStatusCommand

@synthesize Parserdelegate;
@synthesize CommandString;


#pragma mark -
#pragma mark SEND COMMAND TO SERVER

-(BOOL) SendAPICommand :(NSString *) strCommand :(NSString *) postCommand :(id<ParserCallback>)delegate
{
	Parserdelegate = delegate;
	[Parserdelegate retain];
	CommandString = strCommand;
	
	//NSLog(@"SendStatusCommand = %@",postCommand);
	
    //Get SERVER URL FROM SETTINGS
	NSString *serverURLString=@"";
    // Get user preference in settings
    BOOL enabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"isDefaultServer"];
    if(enabled)
    {
        if (isLocal == 0)
            serverURLString = @"https://connect.somfytahoma.com/support/xml.php";
        else
            serverURLString = @"http://office.slamm.com:8080/support/xmltest.php";
    }
    else
        serverURLString = [[NSUserDefaults standardUserDefaults] stringForKey:@"ServerURL"];
	
	NSData *postData = [postCommand dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];  
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];  
	
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];  
    [request setURL:[NSURL URLWithString:serverURLString]];
	[request setHTTPMethod:@"POST"];  
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];  
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];  
	[request setHTTPBody:postData];
	
	
	NSURLConnection *conn=[[NSURLConnection alloc] initWithRequest:request delegate:self];  
	if (conn)  
	{  
		receivedData = [[NSMutableData data] retain]; 
		return YES;
	}  
	else  
	{  
		// inform the user that the download could not be made  
		return NO;
	}  
	
}

#pragma mark NSURLConnection delegate methods

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
	return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
		//if ([trustedHosts containsObject:challenge.protectionSpace.host])
		[challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
	
	[challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    /* This method is called when the server has determined that it has
	 enough information to create the NSURLResponse. It can be called
	 multiple times, for example in the case of a redirect, so each time
	 we reset the data. */
    [receivedData setLength:0];
}


- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    /* Append the new data to the received data. */
    [receivedData appendData:data];
}


- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[connection release];
	if (Parserdelegate != nil && [Parserdelegate respondsToSelector:@selector(commandFailed::)]) {
		[Parserdelegate commandFailed:@"BOX IS NOT CONNECTED" :error.localizedFailureReason];
	}
}


- (NSCachedURLResponse *) connection:(NSURLConnection *)connection 
				   willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
	/* this application does not use a NSURLCache disk or memory cache */
    return nil;
}


- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
	[connection release];
	[self parsetHttpResponse]; 
}

#pragma mark -
#pragma mark PARSE RESPONSE

-(void) parsetHttpResponse
{
	int status;
	
	@try 
	{
		status = [self parseStatus];
	}
	@catch (NSException * e) 
	{
		if (Parserdelegate != nil && [Parserdelegate respondsToSelector:@selector(commandFailed::)]) 
		{
			[Parserdelegate commandFailed:@"Error in parsing" :@"Parsing the status failed"];
		}
	}
	
	
	if ( status == FE_FAILURE || status == FE_FAIL_RANGE  )
	{
		//For the failure fault, we are going to add the information for 
		//the fault
		
		if (Parserdelegate != nil && [Parserdelegate respondsToSelector:@selector(commandFailed::)]) 
		{
			[Parserdelegate commandFailed:@"General Failure" :@"General Failure"];
		}
	}
	//Handle the failures for the Add Device Response
	else if (status == FE_FAIL_DB )
	{
		//For the failure fault, we are going to add the information for 
		//the fault
		
		if (Parserdelegate != nil && [Parserdelegate respondsToSelector:@selector(commandFailed::)]) 
		{
			[Parserdelegate commandFailed:@"Failed on DB operation." :@"Failed to modify the controller database."];
		}
		
	}
	//Handle the failures for the Add Device Response
	else if (status == FE_FAIL_TIMEOUT )
	{
		//For the failure fault, we are going to add the information for 
		//the fault
		
		if (Parserdelegate != nil && [Parserdelegate respondsToSelector:@selector(commandFailed::)]) 
		{
			[Parserdelegate commandFailed:@"The add process timed out." :@"The add process for adding a device to the controller has timed out."];
		}
	}
	else if (status == FE_FAIL_ZW_BUSY )
	{
		//For the failure fault, we are going to add the information for 
		//the fault
		if (Parserdelegate != nil && [Parserdelegate respondsToSelector:@selector(commandFailed::)]) 
		{
			[Parserdelegate commandFailed:@"Z-Wave module is busy, could not issue command." :@"Z-Wave module is busy. Try running the process again."];
		}
		
	}
	else if (status == FE_FAIL_ZW)
	{
		//For the failure fault, we are going to add the information for 
		//the fault
		
		if (Parserdelegate != nil && [Parserdelegate respondsToSelector:@selector(commandFailed::)]) 
		{
			[Parserdelegate commandFailed:@"Failed on ZWave Operation. General Error." :@"Failed on ZWave Operation. General Error."];
		}
		
	}
	else if (status == FE_FAIL_CANCEL )
	{
		//For the failure fault, we are going to add the information for 
		//the fault
		
		if (Parserdelegate != nil && [Parserdelegate respondsToSelector:@selector(commandFailed::)]) 
		{
			[Parserdelegate commandFailed:@"The addition process was cancelled." :@"The addition process was cancelled."];
		}
	}
	else if (status == FE_FAIL_ZW_DEV_EXISTS )
	{
		//For the failure fault, we are going to add the information for 
		//the fault
		
		if (Parserdelegate != nil && [Parserdelegate respondsToSelector:@selector(commandFailed::)]) 
		{
			[Parserdelegate commandFailed:@"The device already exists in the network." :@"The device already exists in the network."];
		}
		
	}
	else if (status == FE_FAIL_TYPE )
	{
		//For the failure fault, we are going to add the information for 
		//the fault
		if (Parserdelegate != nil && [Parserdelegate respondsToSelector:@selector(commandFailed::)]) 
		{
			[Parserdelegate commandFailed:@"Could not start add mode. Z-Wave is busy." :@"The add process for adding a device to the controller has timed out."];
		}
		
	}
	else if (status == 554422)
	{
		//For the failure fault, we are going to add the information for 
		//the fault
		if (Parserdelegate != nil && [Parserdelegate respondsToSelector:@selector(commandFailed::)]) 
		{
			[Parserdelegate commandFailed:@"Authentication Failed" :@"Invalid username or password."];
		}
		
	}
	//No error returned from the controller, we can proceed with working with the data
	else if ( status == FE_SUCCESS || status == -11 || status == FE_ZW_COMPLETED )
	{
		@try 
		{
			if(CommandString == AUTHENTICATE_USER)
				[self parseData:@"sessionid"];
			else 
				[self parseData:@"instance"];
		}
		@catch (NSException * e) 
		{
			if (Parserdelegate != nil && [Parserdelegate respondsToSelector:@selector(commandFailed::)]) 
			{
				[Parserdelegate commandFailed:@"Error in parsing" :@"Parsing the instance failed"];
			}
		}
		
	}
    else if(status == FE_INVALID_SERVER_URL)
    {
        if (Parserdelegate != nil && [Parserdelegate respondsToSelector:@selector(commandFailed::)]) 
		{
			[Parserdelegate commandFailed:@"Error" :@"INVALID SERVER URL"];
		}
    }
}

-(void)parseData:(NSString *)strNode
{
	if([resultArray count]>0)
		[resultArray removeAllObjects];

	//Parse the receive the xml data 
	CXMLDocument* rssParser = [[[CXMLDocument alloc]initWithData:receivedData options:0 error:nil] retain];
	NSArray *itemResultNodes=NULL;
	NSString *xmlstring;
	
	itemResultNodes = [rssParser nodesForXPath:[@"//" stringByAppendingString:strNode] error:nil];
	if([itemResultNodes count]==0)
	{
		itemResultNodes=[[rssParser rootElement]elementsForName:strNode];
	}
	for (CXMLElement *resultElement in itemResultNodes) 
	{
		NSMutableDictionary *Dict=[[NSMutableDictionary alloc]init];
		for(int counter = 0; counter < [resultElement childCount]; counter++) {
			xmlstring=[[resultElement childAtIndex:counter] stringValue];
			if(xmlstring==nil)
				xmlstring=@"";
			[Dict setObject:xmlstring forKey:[[resultElement childAtIndex:counter] name]];
		}
		
		if(CommandString == GET_INFO||CommandString == GET_TIMERS)
			[Dict setObject:@"ScheduleTimerInfo" forKey:@"ScheduleInfoType"];
		else if(CommandString == EVENT_GET_INFO||CommandString == GET_EVENTS)
			[Dict setObject:@"ScheduleEventInfo" forKey:@"ScheduleInfoType"];
		
		[resultArray addObject:Dict];
		[Dict release];
	}
	
	[rssParser release];
	
	if (Parserdelegate != nil && [Parserdelegate respondsToSelector:@selector(commandCompleted:commandString:)]) {
		[Parserdelegate commandCompleted:resultArray commandString:CommandString];
	}
}

-(int)parseStatus
{
	int nStatus = 555;
	//Parse the receive the xml data 
	CXMLDocument* rssParser = [[[CXMLDocument alloc]initWithData:receivedData options:0 error:nil] retain];
	NSArray *itemResultNodes=NULL;
	NSString *xmlstring;
	
	
	//NSString *xml = [[NSString alloc]initWithData:receivedData encoding:NSUTF8StringEncoding];
	//NSLog(@"%@",xml);
	
	itemResultNodes = [rssParser nodesForXPath:@"//return" error:nil];
	if([itemResultNodes count]==0)
	{
		itemResultNodes=[[rssParser rootElement]elementsForName:@"return"];
	}
	for (CXMLElement *resultElement in itemResultNodes) 
	{
		NSMutableDictionary *Dict= [[NSMutableDictionary alloc]init];
		for(int counter = 0; counter < [resultElement childCount]; counter++) {
			xmlstring=[[resultElement childAtIndex:counter] stringValue];
			if(xmlstring==nil)
				xmlstring=@"";
			[Dict setObject:xmlstring forKey:[[resultElement childAtIndex:counter] name]];
		}
		
		if([CommandString isEqualToString:AUTHENTICATE_USER])
		{
			if([[Dict objectForKey:@"status"] isEqualToString:@"AUTHENTICATION_ERROR"])
				nStatus = 554422;
			else
				nStatus = [[Dict objectForKey:@"status"] intValue];
		}
		else
			nStatus = [[Dict objectForKey:@"status"] intValue];
		[Dict release];
	}	
	[rssParser release];
	
	return nStatus;
	
}



#pragma mark -
#pragma mark Initialization & Deallocation
static SendStatusCommand *sharedInstance = nil;

+(SendStatusCommand *)getSharedInstance {
	@synchronized(self) {
		if (sharedInstance == nil) {
			[[self alloc] init];
		}
	}
	
	return sharedInstance;
}

+(id)allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if (sharedInstance == nil) {
			sharedInstance = [super allocWithZone:zone];
			return sharedInstance;
		}
	}
	
	return nil;
}

-(id)copyWithZone:(NSZone *)zone {
	return self;
}

-(id)retain {
	return self;
}

-(unsigned)retainCount {
	return UINT_MAX;
}

-(void)release { }

-(id)autorelease {
	return self;
}

-(id) init {
	self = [super init];
	if (self != nil) {
		resultArray = [[NSMutableArray alloc] init];
	}
	return self;
}

-(void) dealloc {
	Parserdelegate = nil;
	[Parserdelegate release];
	[CommandString release];
	[resultArray release];
	[super dealloc];
}



@end
