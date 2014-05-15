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
#import "MainMenuScene.h"
#import "GameOverScene.h"
#import "InfoScene.h"

@import iAd;
@import AVFoundation;
@import GameKit;
@import Social;

@interface GameController () <ADBannerViewDelegate, GKGameCenterControllerDelegate>

@property () AVAudioPlayer * backgroundMusicPlayer;
@property (weak) IBOutlet UIButton *btnFacebook;
@property (weak) IBOutlet UIButton *btnTwitter;
@property (weak) IBOutlet UIButton *btnSound;
@property (weak) IBOutlet UIButton *btnPlay;
@property (weak) IBOutlet UIButton *btnGameCenter;
@property (weak) IBOutlet UIButton *btnInfo;
@property (weak) IBOutlet ADBannerView *adBannerTop;
@property (weak) IBOutlet ADBannerView *adBannerBottom;
@property (weak) IBOutlet UIView *gameOverView;

@property (assign) BOOL authenticated;

- (IBAction)onTouchFacebook:(id)sender;
- (IBAction)onTouchTwitter:(id)sender;
- (IBAction)onTouchSound:(id)sender;
- (IBAction)onTouchPlay:(id)sender;
- (IBAction)onTouchGameCenter:(id)sender;
- (IBAction)onTouchInfo:(id)sender;

- (IBAction)onTouchStopGame:(id)sender;
- (IBAction)onTouchTryAgain:(id)sender;
- (IBAction)onTouchShareScoreToFacebook:(id)sender;
- (IBAction)onTouchShareScoreToTwitter:(id)sender;

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
    
    self.score = 0;
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

#pragma mark - Actions

- (IBAction)onTouchFacebook:(id)sender
{
	NSString *msg = @"I foung excellent game IgaBall, You can find it in iTunes Store: http://igrsoft.com";
    [self shareText:msg forServiceType:SLServiceTypeTwitter];
}

- (IBAction)onTouchTwitter:(id)sender
{
	NSString *msg = @"I foung excellent game IgaBall, You can find it in iTunes Store: http://igrsoft.com";
    [self shareText:msg forServiceType:SLServiceTypeTwitter];
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
    self.score = 0;
    
	[self hideAllControlls];
	
    // Create and configure the scene.
    SKView * skView = (SKView *)self.view;
    SKTransition *reveal = [SKTransition fadeWithDuration:0.5];
    SKScene * scene = [[GameScene alloc] initWithSize:skView.bounds.size controller:self];
    [skView presentScene:scene transition:reveal];
    	
	[self playMusic:@"game"];
    [self.adBannerBottom setHidden:NO];
}

- (IBAction)onTouchGameCenter:(id)sender
{
    [self showLeaderboard:kLeaderboardID];
}

- (IBAction)onTouchStopGame:(id)sender
{
    [self setupMainMenu];
}

- (IBAction)onTouchTryAgain:(id)sender
{
    [self onTouchPlay:sender];
}

- (IBAction)onTouchShareScoreToFacebook:(id)sender
{
    NSString *msg = [NSString stringWithFormat:@"My Score in IgaBall is %@! How mach can you get http://igrsoft.com", @(self.score)];
    [self shareText:msg forServiceType:SLServiceTypeFacebook];
}

- (IBAction)onTouchShareScoreToTwitter:(id)sender
{
    NSString *msg = [NSString stringWithFormat:@"My Score in IgaBall is %@! How mach can you get http://igrsoft.com", @(self.score)];
    [self shareText:msg forServiceType:SLServiceTypeTwitter];
}

- (IBAction)onTouchInfo:(id)sender
{
    [self hideAllControlls];
    
    SKView * skView = (SKView *)self.view;
    SKTransition *reveal = [SKTransition fadeWithDuration:0.5];
    SKScene * scene = [[InfoScene alloc] initWithSize:skView.bounds.size controller:self];
    [skView presentScene:scene transition:reveal];
}

#pragma mark - Sound

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

#pragma mark - Social

- (void)shareText:(NSString *)text forServiceType:(NSString *)serviceType
{
    SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:serviceType];
    
    [tweetSheet setInitialText:text];
    [self presentViewController:tweetSheet animated:YES completion:nil];
}

#pragma mark - Controlls

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
	[self.btnInfo setHidden:YES];
    
	[self.adBannerTop setHidden:YES];
	[self.adBannerBottom setHidden:YES];
    
    [self.gameOverView setHidden:YES];
}

#pragma mark - Scenes

- (void)setupMainMenu
{
    SKView * skView = (SKView *)self.view;
    SKTransition *reveal = [SKTransition fadeWithDuration:0.5];
    SKScene * scene = [[MainMenuScene alloc] initWithSize:skView.bounds.size controller:self];
    [skView presentScene:scene transition:reveal];
    
    [self hideAllControlls];
    
	[self.btnFacebook setHidden:NO];
	[self.btnTwitter setHidden:NO];
	[self.btnSound setHidden:NO];
	[self.btnPlay setHidden:NO];
	[self.btnGameCenter setHidden:NO];
    [self.btnInfo setHidden:NO];
    
	[self.adBannerTop setHidden:NO];
}

- (void)setupGameOver
{
    SKView * skView = (SKView *)self.view;
    SKTransition *reveal = [SKTransition fadeWithDuration:0.5];
    SKScene * scene = [[GameOverScene alloc] initWithSize:skView.bounds.size controller:self score:self.score];
    [skView presentScene:scene transition:reveal];
    
    [self playMusic:@"main"];
    
    [self hideAllControlls];
    
	[self.gameOverView setHidden:NO];
    [self.adBannerTop setHidden:NO];
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
