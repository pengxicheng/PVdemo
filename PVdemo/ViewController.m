//
//  ViewController.m
//  PVdemo
//
//  Created by hengfu on 16/2/25.
//  Copyright © 2016年 hengfu. All rights reserved.
//

#import "ViewController.h"
#import "FullViewController.h"
#import "FMGVideoPlayView.h"
#import "CFDanmakuView.h"
@interface ViewController ()<CFDanmakuDelegate,FMGVideoPlayViewDelegate>
//播放器
@property (nonatomic, strong) FMGVideoPlayView * fmVideoPlayer;
/* 全屏控制器 */
@property (nonatomic, strong) FullViewController *fullVc;

//播放按钮
@property(nonatomic,strong)UIButton *playButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"彭喜成播放器";
    self.view.backgroundColor = [UIColor grayColor];
    self.fmVideoPlayer = [FMGVideoPlayView videoPlayView];//创建播放器；
    self.fmVideoPlayer.delegate = self;
    [self.playButton setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 懒加载代码
- (FullViewController *)fullVc
{
    if (_fullVc == nil) {
        _fullVc = [[FullViewController alloc] init];
    }
    return _fullVc;
}

#pragma mark delegate FMGVideoPlayViewDelegate 全屏切换
- (void)videoplayViewSwitchOrientation:(BOOL)isFull{
    if (isFull) {
        [self.navigationController presentViewController:self.fullVc animated:NO completion:^{
            [self.fullVc.view addSubview:self.fmVideoPlayer];
            _fmVideoPlayer.center = self.fullVc.view.center;
            
            [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                _fmVideoPlayer.frame = self.fullVc.view.bounds;
                self.fmVideoPlayer.danmakuView.frame = self.fmVideoPlayer.frame;
                
            } completion:nil];
        }];
    } else {
        [self.fullVc dismissViewControllerAnimated:NO completion:^{
            [self.view addSubview:_fmVideoPlayer];
            _fmVideoPlayer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width*0.5625);
            _fmVideoPlayer.center = self.view.center;
        }];
    }
    
}


// 根据点击的Cell控制播放器的位置
- (void)playButtonAction:(UIButton *)sender{

    //[_fmVideoPlayer setUrlString:@"http://mkres.oss-cn-hangzhou.aliyuncs.com/ap/151113/huaxuyin_app.mp4"];
    
    [_fmVideoPlayer setUrlString:@"http://flv2.bn.netease.com/videolib3/1602/25/MeKTg3467/SD/MeKTg3467-mobile.mp4"];
//    _fmVideoPlayer.frame = CGRectMake(0, 275*(sender.tag - 100) + CGRectGetWidth([UIScreen mainScreen].bounds)/5 + 50  , CGRectGetWidth([UIScreen mainScreen].bounds), (self.view.frame.size.width-20)/2);
    //_fmVideoPlayer.frame = CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.width-20)/2);
    _fmVideoPlayer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width*0.5625);
    _fmVideoPlayer.center = self.view.center;
    [self.view addSubview:_fmVideoPlayer];
    _fmVideoPlayer.contrainerViewController = self;
    [_fmVideoPlayer.player play];
    [_fmVideoPlayer showToolView:NO];
    _fmVideoPlayer.playOrPauseBtn.selected = YES;
    _fmVideoPlayer.hidden = NO;
    // 指定一个作为播放的控制器
    //_fmVideoPlayer.danmakuView.delegate = self;
}

- (UIButton *)playButton{
    if (_playButton == nil) {
        self.playButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.playButton.frame = CGRectMake(0, 0, 50, 50);
        self.playButton.center = self.view.center;
        //        self.playButton.backgroundColor = [UIColor yellowColor];
        [self.view addSubview:_playButton];
        [self.playButton addTarget:self action:@selector(playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _playButton;
}

#pragma mark - 弹幕代理方法
- (NSTimeInterval)danmakuViewGetPlayTime:(CFDanmakuView *)danmakuView
{
    if(_fmVideoPlayer.progressSlider.value == 1.0) [_fmVideoPlayer.danmakuView stop]
        ;
    return _fmVideoPlayer.progressSlider.value*120.0;
}

- (BOOL)danmakuViewIsBuffering:(CFDanmakuView *)danmakuView
{
    return NO;
}
@end
