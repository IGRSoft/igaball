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

@property (assign) BOOL reShowLeaderboard;
@property (assign, readwrite) NSInteger score;

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
const CGFloat fadeDuration = 0.5;


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
    
	BOOL useSound = [ud objectForKey:kUseSound] ? [ud boolForKey:kUseSound] : YES;
	[self setupSoundButton:useSound];
	
    // Create and configure the scene.
    SKScene * scene = [[LoadingScene alloc] initWithSize:skView.bounds.size gameController:self];
    scene.scaleMode = SKSceneScaleModeResizeFill;
    
    // Present the scene.
    SKTransition *reveal = [SKTransition fadeWithDuration:fadeDuration];
    [skView presentScene:scene transition:reveal];
    
    // Game Center
    self.reShowLeaderboard = NO;
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
    SKScene * scene = [[GameScene alloc] initWithSize:skView.bounds.size gameController:self];
    
    SKTransition *reveal = [SKTransition fadeWithDuration:fadeDuration];
    [skView presentScene:scene transition:reveal];
    	
	[self playMusic:@"game"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(fadeDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.adBannerBottom setHidden:NO];
    });
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
    SKScene * scene = [[InfoScene alloc] initWithSize:skView.bounds.size gameController:self];
    
    SKTransition *reveal = [SKTransition fadeWithDuration:fadeDuration];
    [skView presentScene:scene transition:reveal];
}

#pragma mark - Sound
- (void)playMusic:(NSString *)aName
{
    [self playMusic:aName loopCount:-1];
}

- (void)playMusic:(NSString *)aName loopCount:(NSInteger)aLoopCount
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
	
    NSURL *backgroundMusicURL = [[NSBundle mainBundle] URLForResource:aName withExtension:@"m4a"];
    if ([self.backgroundMusicPlayer.url isEqual:backgroundMusicURL])
    {
        return;
    }
    
	dispatch_async(dispatch_get_main_queue(), ^{
		
		NSError *error;
		
		self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
		self.backgroundMusicPlayer.numberOfLoops = aLoopCount;
		[self.backgroundMusicPlayer prepareToPlay];
		[self.backgroundMusicPlayer play];
	});
}

#pragma mark - Social

- (void)shareText:(NSString *)aText forServiceType:(NSString *)aServiceType
{
    SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:aServiceType];
    
    [tweetSheet setInitialText:aText];
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
    [self hideAllControlls];
    
    SKView * skView = (SKView *)self.view;
    SKScene * scene = [[MainMenuScene alloc] initWithSize:skView.bounds.size gameController:self];

    SKTransition *reveal = [SKTransition fadeWithDuration:fadeDuration];
    [skView presentScene:scene transition:reveal];
    
    [self playMusic:@"main"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(fadeDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.btnFacebook setHidden:NO];
        [self.btnTwitter setHidden:NO];
        [self.btnSound setHidden:NO];
        [self.btnPlay setHidden:NO];
        [self.btnGameCenter setHidden:NO];
        [self.btnInfo setHidden:NO];
        
        [self.adBannerTop setHidden:NO];
    });
}

- (void)setupGameOverWithScore:(NSInteger)aScore
{
    [self hideAllControlls];
    
    _score = aScore;
    
    SKView * skView = (SKView *)self.view;
    SKScene * scene = [[GameOverScene alloc] initWithSize:skView.bounds.size gameController:self];
    
    SKTransition *reveal = [SKTransition fadeWithDuration:fadeDuration];
    [skView presentScene:scene transition:reveal];
    
    [self playMusic:@"gameover" loopCount:0];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(fadeDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.gameOverView setHidden:NO];
        [self.adBannerTop setHidden:NO];
    });
    
    [self reportScore:_score forLeaderboard:kLeaderboardID];
}

#pragma mark - Game Cetner

- (void)authenticatePlayer
{
    __weak GameController *weakSelf = self;
	GKLocalPlayer *player = [GKLocalPlayer localPlayer];
    
    void (^authBlock)(UIViewController *, NSError *) = ^(UIViewController *viewController, NSError *error) {
        
        if (viewController)
        {
            [weakSelf presentViewController:viewController animated:YES completion:nil];
        }
        
        if ([[GKLocalPlayer localPlayer] isAuthenticated])
        {
            if (weakSelf.reShowLeaderboard)
            {
                [weakSelf showLeaderboard:kLeaderboardID];
            }
            
            weakSelf.reShowLeaderboard = NO;
            
        }
    };
    
    [player setAuthenticateHandler:authBlock];
}

#pragma mark - Leaderboard

- (void)reportScore:(NSInteger)aScore forLeaderboard:(NSString*)aLeaderboardId
{
    if ([[GKLocalPlayer localPlayer] isAuthenticated] && aScore > 0)
    {
        GKScore* score = [[GKScore alloc] initWithLeaderboardIdentifier:aLeaderboardId];
        score.value = aScore;
        [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
            if (error)
            {
                // handle error
            }
        }];
    }
}

- (void)showLeaderboard:(NSString*)aLeaderboardId
{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    if (!localPlayer.isAuthenticated)
    {
        self.reShowLeaderboard = YES;
        [self authenticatePlayer];
    }
    else
    {
        GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
        if (gameCenterController != nil)
        {
            gameCenterController.gameCenterDelegate = self;
            gameCenterController.viewState = GKGameCenterViewControllerStateLeaderboards;
            gameCenterController.leaderboardIdentifier = aLeaderboardId;
            
            [self presentViewController:gameCenterController animated:YES completion:nil];
        }
    }
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)aGameCenterViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (self.reShowLeaderboard)
    {
        [self showLeaderboard:kLeaderboardID];
    }
    
    self.reShowLeaderboard = NO;
}

#pragma mark - AD
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{

}

@end
