//
//  FDWindow.m
//  FlameDragon
//
//  Created by sui toney on 11-12-21.
//  Copyright 2011 ms. All rights reserved.
//

#import "FDWindow.h"


@implementation FDWindow


+(CGSize) winSize
{
	return [[CCDirector sharedDirector] winSize];
}

+(CGPoint) downCenter
{
	CGSize winSize = [self winSize];
	return CGPointMake(winSize.width / 2, winSize.height / 4);
}

+(CGPoint) downLeft
{
	CGSize winSize = [self winSize];
	return CGPointMake(winSize.width / 4, winSize.height / 4);
}

+(CGPoint) downRight
{
	CGSize winSize = [self winSize];
	return CGPointMake(winSize.width / 1.3, winSize.height / 4);
}

+(CGPoint) upCenter
{
	CGSize winSize = [self winSize];
	return CGPointMake(winSize.width / 2, winSize.height / 1.3);
}

+(CGPoint) screenCenter
{
	CGSize winSize = [self winSize];
	return CGPointMake(winSize.width / 2, winSize.height / 2);
}

+(CGPoint) showBoxPosition
{
	CGSize winSize = [self winSize];
	return CGPointMake(winSize.width / 2, winSize.height * 0.28);
}

+(CGPoint) showBoxDatoPosition
{
	CGSize winSize = [self winSize];
	return CGPointMake(winSize.width * 0.15, winSize.height * 0.72);
}

+(CGPoint) showBoxDetailPosition
{
	CGSize winSize = [self winSize];
	return CGPointMake(winSize.width * 0.64, winSize.height * 0.72);
}

+(CGPoint) titleButtonStart
{
	CGSize winSize = [self winSize];
	return CGPointMake(winSize.width * 0.2, winSize.height * 0.13);	
}

+(CGPoint) titleButtonLoad
{
	CGSize winSize = [self winSize];
	return CGPointMake(winSize.width * 0.5, winSize.height * 0.13);	
}

+(CGPoint) titleButtonContinue
{
	CGSize winSize = [self winSize];
	return CGPointMake(winSize.width * 0.8, winSize.height * 0.13);	
}

+(CGPoint) villageLocation:(int)position villageImageId:(int)villageImageId
{
	CGSize winSize = [self winSize];
	
	switch (villageImageId) {
		case 1:
			switch (position) {
				case 0:
					return CGPointMake(winSize.width * 0.24, winSize.height * 0.10);
				case 1:
					return CGPointMake(winSize.width * 0.52, winSize.height * 0.25);
				case 2:
					return CGPointMake(winSize.width * 0.6, winSize.height * 0.58);
				case 3:
					return CGPointMake(winSize.width * 0.15, winSize.height * 0.7);
				case 4:
					return CGPointMake(winSize.width * 0.2, winSize.height * 0.4);
				case 5:
					return CGPointMake(winSize.width * 0.08, winSize.height * 0.85);
				default:
					return CGPointMake(0, 0);	
			}
			break;
		case 2:
			switch (position) {
				case 0:
					return CGPointMake(winSize.width * 0.24, winSize.height * 0.10);
				case 1:
					return CGPointMake(winSize.width * 0.55, winSize.height * 0.25);
				case 2:
					return CGPointMake(winSize.width * 0.8, winSize.height * 0.75);
				case 3:
					return CGPointMake(winSize.width * 0.25, winSize.height * 0.77);
				case 4:
					return CGPointMake(winSize.width * 0.2, winSize.height * 0.27);
				case 5:
					return CGPointMake(winSize.width * 0.5, winSize.height * 0.85);
				default:
					return CGPointMake(0, 0);	
			}
		case 3:
			switch (position) {
				case 0:
					return CGPointMake(winSize.width * 0.24, winSize.height * 0.10);
				case 1:
					return CGPointMake(winSize.width * 0.52, winSize.height * 0.25);
				case 2:
					return CGPointMake(winSize.width * 0.76, winSize.height * 0.55);
				case 3:
					return CGPointMake(winSize.width * 0.35, winSize.height * 0.75);
				case 4:
					return CGPointMake(winSize.width * 0.2, winSize.height * 0.4);
				case 5:
					return CGPointMake(winSize.width * 0.68, winSize.height * 0.85);
				default:
					return CGPointMake(0, 0);
			}
			break;
		default:
			break;
	}
	
	return CGPointMake(0, 0);
}

+(CGPoint) secretIndicatorPosition:(int)villageImageId
{
	switch (villageImageId) {
		case 1:
			return CGPointMake(12.5, 193);
		case 2:
			return CGPointMake(287.5, 81.5);
		case 3:
            return CGPointMake(108, 115);
        default:
    		break;
	}
	
	return CGPointMake(0, 0);
}

+(CGPoint) villageLeftButton
{
	return CGPointMake(40, 40);
}

+(CGPoint) villageRightButton
{
	return CGPointMake([self winSize].width - 40, 40);
}

+(CGPoint) chapterRecordShowLocation:(int)recordIndex
{
	return CGPointMake([self winSize].width * 0.3, 62 - recordIndex * 18);
}

+(CGPoint) showShoppingDialogPosition
{
	return CGPointMake(0, 0);
//
}

+(CGPoint) shoppingMessageLocation
{
	return CGPointMake(20, 60);
}

+(CGPoint) shoppingMessageLocation2
{
	return CGPointMake(20, 35);
}

+(CGPoint) villageLabelLocation
{
	return CGPointMake([self winSize].width * 0.9, [self winSize].height * 0.1);
}

+(CGPoint) fightingTaiPosition
{
	return CGPointMake([self winSize].width * 0.7, [self winSize].height * 0.2);
}

+(CGPoint) fightingFriendBarPosition
{
	return CGPointMake([self winSize].width * 0.7, [self winSize].height * 0.85);
}

+(CGPoint) fightingEnemyBarPosition
{
	return CGPointMake([self winSize].width * 0.25, [self winSize].height * 0.1);
}

+(CGRect) leftWindow
{
	return CGRectMake(0, 0, [self winSize].width / 2, [self winSize].height);
}

+(CGRect) rightWindow
{
	return CGRectMake([self winSize].width / 2, 0, [self winSize].width, [self winSize].height);
}

+(CGPoint) moneyBarLocation
{
	return CGPointMake(8, 145);
}

@end
