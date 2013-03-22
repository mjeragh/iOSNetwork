//
//  ViewController.m
//  NetworkTest
//
//  Created by Mohammad Jeragh on 3/20/13.
//  Copyright (c) 2013 Mohammad Jeragh. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property(nonatomic,strong) MatchmakingClient *matchmakingClient;
@property(nonatomic,strong) MatchmakingServer *matchmakingServer;
@property(nonatomic, strong) Network *network;
@property(nonatomic) BOOL isServer;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MatchmakingClientDelegate

- (void)matchmakingClient:(MatchmakingClient *)client serverBecameAvailable:(NSString *)peerID
{
	self.clientTextView.text = [self.clientTextView.text stringByAppendingString:[NSString stringWithFormat:@"Server %@ found\n",peerID]];
    [_matchmakingClient connectToServerWithPeerID:peerID];
    self.clientTextView.text = [self.clientTextView.text stringByAppendingString:[NSString stringWithFormat:@"Connecting to %@ ...\n",peerID]];
}

- (void)matchmakingClient:(MatchmakingClient *)client serverBecameUnavailable:(NSString *)peerID
{
	self.clientTextView.text = [self.clientTextView.text stringByAppendingString:[NSString stringWithFormat:@"Connection dropped from server %@\n",peerID]];
    [self stopClient];
}

-(void)matchmakingClient:(MatchmakingClient *)client didDisconnectFromServer:(NSString *)peerID{
    self.clientTextView.text = [self.clientTextView.text stringByAppendingString:[NSString stringWithFormat:@"Disconnected from server %@\n",peerID]];
    [self stopClient];
}

-(void)matchmakingClient:(MatchmakingClient *)client didConnectFromServer:(NSString *)peerID{
    self.clientTextView.text = [self.clientTextView.text stringByAppendingString:[NSString stringWithFormat:@"Connected to server %@\n",peerID]];
    self.network = [[Network alloc] init];
    self.network.delegate=self;
    self.network.session=_matchmakingClient.session;
    [_matchmakingClient.session setDataReceiveHandler:self.network withContext:nil];
    
}

-(void)matchmakingClientNoNetwork:(MatchmakingClient *)client{
    self.clientTextView.text = [self.clientTextView.text stringByAppendingString:@"Quit No reason\n"];
}

#pragma mark - MatchmakingServerDelegate

- (void)matchmakingServer:(MatchmakingServer *)server clientDidConnect:(NSString *)peerID
{
	self.serverTextView.text = [self.serverTextView.text stringByAppendingString:[NSString stringWithFormat:@"Client %@ connected\n",peerID]];
    self.network = [[Network alloc] init];
    self.network.delegate=self;
    self.network.session=_matchmakingServer.session;
    [_matchmakingServer.session setDataReceiveHandler:self.network withContext:nil];
    [self.network sendPacketSignInRequestTo:peerID];
}

- (void)matchmakingServer:(MatchmakingServer *)server clientDidDisconnect:(NSString *)peerID
{
	self.serverTextView.text = [self.serverTextView.text stringByAppendingString:[NSString stringWithFormat:@"Client %@ Disconnected\n",peerID]];
}

- (void)matchmakingServerSessionDidEnd:(MatchmakingServer *)server
{
    _matchmakingServer.delegate = nil;
	_matchmakingServer = nil;
	self.serverTextView.text = [self.serverTextView.text stringByAppendingString:@"Server ended session\n"];
}

- (void)matchmakingServerNoNetwork:(MatchmakingServer *)server
{
	self.serverTextView.text = [self.serverTextView.text stringByAppendingString:@"Server No Network\n"];
}

#pragma mark - GKSession Data Receive Handler

- (void)receiveData:(NSData *)data fromPeer:(NSString *)peerID inSession:(GKSession *)session context:(void *)context
{
#ifdef DEBUG
	NSLog(@"Game: receive data from peer: %@, data: %@, length: %d", peerID, data, [data length]);
#endif
    

}


- (IBAction)serverButton:(UIButton *)sender {
    if (_matchmakingServer == nil)
    {
        NSLog(@"%s",__PRETTY_FUNCTION__);
        _matchmakingServer = [[MatchmakingServer alloc] init];
        _matchmakingServer.delegate = self;
        _matchmakingServer.maxClients = 2;
        [_matchmakingServer startAcceptingConnectionsForSessionID:SESSION_ID];
       // [_matchmakingServer.session setDataReceiveHandler:self withContext:nil];
        [self.serverButton setTitle:@"Stop" forState:UIControlStateNormal];
        [self.clientButton setTitle:@"Start" forState:UIControlStateDisabled];
        self.clientButton.hidden=YES;
        self.serverLabel.text=_matchmakingServer.session.peerID;
        self.isServer=YES;
    }
    else{
        _matchmakingServer.delegate=nil;
        [_matchmakingServer stopAcceptingConnections];
        _matchmakingServer = nil;
        [self.serverButton setTitle:@"Start" forState:UIControlStateNormal];
        [self.clientButton setTitle:@"Start" forState:UIControlStateNormal];
        self.clientButton.hidden=NO;
        self.serverLabel.text=@"Server";
        self.serverTextView.text=@"";
    }

}

- (IBAction)clientButton:(UIButton *)sender {
    if (_matchmakingClient == nil)
	{
		_matchmakingClient = [[MatchmakingClient alloc] init];
        _matchmakingClient.delegate = self;
		[_matchmakingClient startSearchingForServersWithSessionID:SESSION_ID];
       // [_matchmakingClient.session setDataReceiveHandler:self withContext:nil];
        self.clientLabel.text = _matchmakingClient.session.peerID;
        [self.clientButton setTitle:@"Stop" forState:UIControlStateNormal];
        [self.serverButton setTitle:@"Start" forState:UIControlStateDisabled];
        self.serverButton.hidden=YES;
        self.isServer=NO;
	}else{
        
        [_matchmakingClient disconnectFromServer];
        [self stopClient];
            }

}

-(void)stopClient{
    _matchmakingClient.delegate=nil;
    _matchmakingClient = nil;
    [self.clientButton setTitle:@"Start" forState:UIControlStateNormal];
    [self.serverButton setTitle:@"Start" forState:UIControlStateNormal];
    self.serverButton.hidden=NO;
    self.clientLabel.text = @"Client";
    self.clientTextView.text=@"";
}

#pragma mark NetworkDelegate
-(void)appendStringToViewWith:(NSString *)text{
    if (self.isServer) {
        self.serverTextView.text = [self.serverTextView.text stringByAppendingString:text];
    }
    else
        self.clientTextView.text = [self.clientTextView.text stringByAppendingString:text];
}

@end
