/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2010 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiUIView.h"
#import "TdCalendarView.h"
#import "ComTiCalendarModule.h"

@interface ComTiCalendarView : TiUIView <CalendarViewDelegate> {
	NSMutableDictionary *events;
@private
	UIView *cal;
	KrollFunction *eventsSelectedFunction;
}

@property (nonatomic,readwrite,retain) NSMutableDictionary *events;
@property (nonatomic,readwrite,assign) KrollFunction *eventsSelectedFunction;


-(NSDate *)dateWithNoTime:(NSDate *)dateTime;

@end
