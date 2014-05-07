//
//  ViewController.m
//  IgaBall
//
//  Created by Korich on 4/24/14.
//  Copyright (c) 2014 IGR Software. All rights reserved.
//

#import "GameController.h"
#import "LoadingScene.h"
#import "GameScene.h"
#import "Constants.h"

@import iAd;
@import AVFoundation;
@import GameKit;

@interface GameController () <ADBannerViewDelegate, GKGameCenterControllerDelegate>

@property () AVAudioPlayer * backgroundMusicPlayer;
@property (weak) IBOutlet UIButton *btnFacebook;
@property (weak) IBOutlet UIButton *btnTwitter;
@property (weak) IBOutlet UIButton *btnSound;
@property (weak) IBOutlet UIButton *btnPlay;
@property (weak) IBOutlet UIButton *btnGameCenter;
@property (weak) IBOutlet ADBannerView *adBannerTop;
@property (weak) IBOutlet ADBannerView *adBannerBottom;

@property (assign) BOOL authenticated;

- (IBAction)onTouchFacebook:(id)sender;
- (IBAction)onTouchTwitter:(id)sender;
- (IBAction)onTouchSound:(id)sender;
- (IBAction)onTouchPlay:(id)sender;
- (IBAction)onTouchGameCenter:(id)sender;

@end

static NSString * const kUseSound = @"UseSound";

@implementation GameController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
	//Controlls
	[self hideAllControlls];
	
	//Sound
	NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
	BOOL useSound = [ud boolForKey:kUseSound];
	[self setupSoundButton:useSound];
	
	[self playMusic:@"main"];
	
    // Create and configure the scene.
    SKScene * scene = [[LoadingScene alloc] initWithSize:skView.bounds.size controller:self];
    scene.scaleMode = SKSceneScaleModeResizeFill;
    
    // Present the scene.
    [skView presentScene:scene];
    
    // Game Center
    self.authenticated = NO;
    [self authenticatePlayer];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)playMusic:(NSString *)name
{
	NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
	if (![ud objectForKey:kUseSound])
	{
		[ud setBool:YES forKey:kUseSound];
		[ud synchronize];
	}
	
	if (![ud boolForKey:kUseSound])
	{
		return;
	}
	
	dispatch_async(dispatch_get_main_queue(), ^{
		
		NSError *error;
		NSURL * backgroundMusicURL = [[NSBundle mainBundle] URLForResource:name withExtension:@"m4a"];
		self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
		self.backgroundMusicPlayer.numberOfLoops = -1;
		[self.backgroundMusicPlayer prepareToPlay];
		[self.backgroundMusicPlayer play];
	});
}

- (IBAction)onTouchFacebook:(id)sender
{
	
}

- (IBAction)onTouchTwitter:(id)sender
{
	
}

- (IBAction)onTouchSound:(id)sender
{
	NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
	BOOL useSound = ![ud boolForKey:kUseSound];
	[ud setBool:useSound forKey:kUseSound];
	[ud synchronize];
	
	if (!useSound)
	{
		[self.backgroundMusicPlayer stop];
	}
	else
	{
		[self playMusic:@"main"];
	}
	
	[self setupSoundButton:useSound];
}

- (IBAction)onTouchPlay:(id)sender
{
	[self hideAllControlls];
	
	SKView * skView = (SKView *)self.view;
	
	// Create and configure the scene.
    SKScene * scene = [[GameScene alloc] initWithSize:skView.bounds.size controller:self];
    scene.scaleMode = SKSceneScaleModeResizeFill;
    
    // Present the scene.
    [skView presentScene:scene];
	
	[self playMusic:@"game"];
}

- (IBAction)onTouchGameCenter:(id)sender
{
    [self showLeaderboard:kLeaderboardID];
}

- (void)setupSoundButton:(BOOL)useSound
{
	UIImage *img = [UIImage imageNamed:@"SoundOn"];
	if (!useSound)
	{
		img = [UIImage imageNamed:@"SoundOff"];
	}
	
	[self.btnSound setImage:img forState:UIControlStateNormal];
}

- (void)hideAllControlls
{
	[self.btnFacebook setHidden:YES];
	[self.btnTwitter setHidden:YES];
	[self.btnSound setHidden:YES];
	[self.btnPlay setHidden:YES];
    [self.btnGameCenter setHidden:YES];
	
	[self.adBannerTop setHidden:YES];
	[self.adBannerBottom setHidden:YES];
}

- (void)setupMainMenu
{
	[self.btnFacebook setHidden:NO];
	[self.btnTwitter setHidden:NO];
	[self.btnSound setHidden:NO];
	[self.btnPlay setHidden:NO];
	[self.btnGameCenter setHidden:NO];
    
	[self.adBannerTop setHidden:NO];
}

#pragma mark - iAD

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
	DBNSLog(@"%s", __func__);
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    DBNSLog(@"%s", __func__);
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    DBNSLog(@"%s", __func__);
	
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    DBNSLog(@"%s", __func__);
}

#pragma mark - Game Cetner

- (void) authenticatePlayer
{
	GKLocalPlayer *player = [GKLocalPlayer localPlayer];
    
    void (^authBlock)(UIViewController *, NSError *) = ^(UIViewController *viewController, NSError *error) {
        
        if (viewController)
        {
            [self presentViewController:viewController animated:YES completion:nil];
        }
        
        if ([[GKLocalPlayer localPlayer] isAuthenticated])
        {
            self.authenticated = YES;
        }
        
        if (error)
        {
            self.authenticated = NO;
        }
        
    };
    
    [player setAuthenticateHandler:authBlock];
}

#pragma mark - Leaderboard
- (void)reportScore:(long long)aScore forLeaderboard:(NSString*)leaderboardId
{
    if (self.authenticated)
    {
        GKScore* score = [[GKScore alloc] initWithLeaderboardIdentifier:leaderboardId];
        score.value = aScore;
        [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
            if (error) {
                // handle error
            }
        }];
    }
}

- (void)showLeaderboard:(NSString*)leaderboardId
{
    GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
    if (gameCenterController != nil)
    {
        gameCenterController.gameCenterDelegate = self;
        gameCenterController.viewState = GKGameCenterViewControllerStateLeaderboards;
        gameCenterController.leaderboardIdentifier = leaderboardId;
        
        [self presentViewController:gameCenterController animated:YES completion:nil];
    }
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
