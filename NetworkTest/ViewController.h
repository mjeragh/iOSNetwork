//
//  ViewController.h
//  NetworkTest
//
//  Created by Mohammad Jeragh on 3/20/13.
//  Copyright (c) 2013 Mohammad Jeragh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MatchmakingClient.h"
#import "MatchmakingServer.h"
#import "Network.h"

@interface ViewController : UIViewController<UITextViewDelegate,MatchmakingClientDelegate,MatchmakingServerDelegate,GKSessionDelegate,NetworkDelegate>

@property (weak, nonatomic) IBOutlet UIButton *serverButton;
@property (weak, nonatomic) IBOutlet UIButton *clientButton;

- (IBAction)serverButton:(UIButton *)sender;

- (IBAction)clientButton:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextView *serverTextView;
@property (weak, nonatomic) IBOutlet UITextView *clientTextView;
@property (weak, nonatomic) IBOutlet UILabel *serverLabel;
@property (weak, nonatomic) IBOutlet UILabel *clientLabel;

@end
