//
//  GCHelper.h
//  RPSIphoneOnly
//
//  Created by student student on 11/02/2012.
//  Copyright (c) 2012 UoP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>



// Modify @interface line to support protocols as follows
@interface GCHelper : NSObject 
<GKTurnBasedMatchmakerViewControllerDelegate>{
    
    // New instance variable
    UIViewController *presentingViewController;
    
    
    
    BOOL gameCenterAvailable;
    BOOL userAuthenticated;
}

@property (retain) GKTurnBasedMatch * currentMatch;

+ (GCHelper *)sharedInstance;
- (void)authenticateLocalUser;

// New method
- (void)findMatchWithMinPlayers:(int)minPlayers 
                     maxPlayers:(int)maxPlayers 
                 viewController:(UIViewController *)viewController;

@end