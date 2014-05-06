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

@import iAd;
@import AVFoundation;

@interface GameController () <ADBannerViewDelegate>

@property (nonatomic) AVAudioPlayer * backgroundMusicPlayer;
@property (weak, nonatomic) IBOutlet UIButton *btnFacebook;
@property (weak, nonatomic) IBOutlet UIButton *btnTwitter;
@property (weak, nonatomic) IBOutlet UIButton *btnSound;
@property (weak, nonatomic) IBOutlet UIButton *btnPlay;
@property (weak, nonatomic) IBOutlet ADBannerView *adBannerTop;
@property (weak, nonatomic) IBOutlet ADBannerView *adBannerBottom;

- (IBAction)onTouchFacebook:(id)sender;
- (IBAction)onTouchTwitter:(id)sender;
- (IBAction)onTouchSound:(id)sender;
- (IBAction)onTouchPlay:(id)sender;

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

- (void)setupSoundButton:(BOOL)useSound
{
    BOOL isIPhone = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone;
    
    NSString *imgName = [NSString stringWithFormat:@"SoundOn%@", isIPhone ? @"-iPhone" : @""];
	UIImage *img = [UIImage imageNamed:imgName];
	if (!useSound)
	{
        imgName = [NSString stringWithFormat:@"SoundOff%@", isIPhone ? @"-iPhone" : @""];
		img = [UIImage imageNamed:imgName];
	}
	
	[self.btnSound setImage:img forState:UIControlStateNormal];
}

- (void)hideAllControlls
{
	[self.btnFacebook setHidden:YES];
	[self.btnTwitter setHidden:YES];
	[self.btnSound setHidden:YES];
	[self.btnPlay setHidden:YES];
	
	[self.adBannerTop setHidden:YES];
	[self.adBannerBottom setHidden:YES];
}

- (void)setupMainMenu
{
	[self.btnFacebook setHidden:NO];
	[self.btnTwitter setHidden:NO];
	[self.btnSound setHidden:NO];
	[self.btnPlay setHidden:NO];
	
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

@end
