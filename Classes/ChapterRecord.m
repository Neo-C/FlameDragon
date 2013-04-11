//
//  ChapterRecord.m
//  FlameDragon
//
//  Created by sui toney on 12-3-11.
//  Copyright 2012 ms. All rights reserved.
//

#import "ChapterRecord.h"
#import "CreatureRecord.h"

@implementation ChapterRecord

@synthesize money;

-(id) initWithChapter:(int)l
{
	self = [super initWithChapter:l];
	friendRecords = [[NSMutableArray alloc] init];

	return self;
}

-(void) encodeWithCoder:(NSCoder *)coder {
	
	[coder encodeInt:chapterId forKey:@"chapterId"];
    [coder encodeInt:money forKey:@"money"];
	[coder encodeObject:friendRecords forKey:@"friendRecords"];
	
}

-(id) initWithCoder:(NSCoder *)coder {
	
    self = [super init];
    chapterId = [coder decodeIntForKey:@"chapterId"];
    money = [coder decodeIntForKey:@"money"];
	
	friendRecords = (NSMutableArray *)[[coder decodeObjectForKey:@"friendRecords"] retain];
	
    return self;
}

+(ChapterRecord *) emptyRecord
{
	ChapterRecord *record = [[ChapterRecord alloc] initWithChapter:0];
	return [record autorelease];
}

+(ChapterRecord *) sampleRecord
{
	ChapterRecord *record = [[ChapterRecord alloc] initWithChapter:2];
	
	record.money = 500;
	
	// CreatureRecord *creature = [[CreatureRecord alloc] initWithTestData];
	CreatureRecord *creature1 = [CreatureRecord friendSampleRecord:1];
	CreatureRecord *creature2 = [CreatureRecord friendSampleRecord:2];
	CreatureRecord *creature3 = [CreatureRecord friendSampleRecord:3];
	CreatureRecord *creature4 = [CreatureRecord friendSampleRecord:4];
	CreatureRecord *creature5 = [CreatureRecord friendSampleRecord:5];
	CreatureRecord *creature6 = [CreatureRecord friendSampleRecord:2];
	CreatureRecord *creature7 = [CreatureRecord friendSampleRecord:4];
	CreatureRecord *creature8 = [CreatureRecord friendSampleRecord:2];
	
	[[record friendRecords] addObject:creature1];
	[[record friendRecords] addObject:creature2];
	[[record friendRecords] addObject:creature3];
	[[record friendRecords] addObject:creature4];
	[[record friendRecords] addObject:creature5];
	[[record friendRecords] addObject:creature6];
	[[record friendRecords] addObject:creature7];
	[[record friendRecords] addObject:creature8];
	
	return [record autorelease];

}

+(ChapterRecord *) generateRecord:(int)chapter money:(int)m
{
	ChapterRecord *record = [[ChapterRecord alloc] initWithChapter:chapter];
	
	record.money = m;
	
	return [record autorelease];
}

-(NSMutableArray *) friendRecords
{
	return friendRecords;
}

-(CreatureRecord *) getCreatureThatCarriesItem:(int)itemId
{
    if (friendRecords == nil) {
        return nil;
    }
    
    for (CreatureRecord *record in friendRecords) {
        if ([record.data hasItem:itemId]) {
            return record;
        }
    }
    
    return nil;
}

-(void) dealloc
{
	[friendRecords release];
	
	[super dealloc];
}

@end
