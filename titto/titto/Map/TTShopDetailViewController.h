//
//  TTShopDetailViewController.h
//  Map
//
//  Created by Paolo Ladisa on 3/28/13.
//  Copyright (c) 2013 Titto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTHeaderImageView.h"
#import <MessageUI/MessageUI.h>
#import "TTShopHoursManager.h"
#import "UAPush.h"


@interface TTShopDetailViewController : UIViewController<TTShopHoursManagerDelegate,MFMailComposeViewControllerDelegate,UIScrollViewDelegate,UIAlertViewDelegate>
{
    NSDictionary * _infoDict;

    IBOutlet TTHeaderImageView * headerImageView;

    IBOutlet UIScrollView * scrollView;

    IBOutlet UILabel * shadowLabel;
    IBOutlet UIView * contentView;

    IBOutlet UILabel * indirizzoLabel;
    IBOutlet UILabel * cittaLabel;

    IBOutlet UILabel * lunediLabel;
    IBOutlet UILabel * martediLabel;
    IBOutlet UILabel * mercolediLabel;
    IBOutlet UILabel * giovediLabel;
    IBOutlet UILabel * venerdiLabel;
    IBOutlet UILabel * sabatoLabel;
    IBOutlet UILabel * domenicaLabel;

    IBOutlet UIView * containerView;
    
    IBOutlet UILabel * orarioLunediLabel;
    IBOutlet UILabel * orarioMartediLabel;
    IBOutlet UILabel * orarioMercolediLabel;
    IBOutlet UILabel * orarioGiovediLabel;
    IBOutlet UILabel * orarioVenerdiLabel;
    IBOutlet UILabel * orarioSabatoLabel;
    IBOutlet UILabel * orarioDomenicaLabel;

    IBOutlet UILabel * emailLabel;
    IBOutlet UIButton * emailContentLabel;

    IBOutlet UIButton * predefinedButton;
    
    IBOutlet UILabel * noConnectionLabel;
    
    IBOutlet UIButton * starButton;
    IBOutlet UIImageView * nastrinoImageView;

    MFMailComposeViewController *mailer ;

    UIButton * backButton;
    
}

@property (nonatomic,strong)NSDictionary * infoDict;

-(IBAction)predefinedButtonAction:(id)sender;
-(IBAction)openMail:(id)sender;

-(IBAction)changeButtonStatus:(id)sender;

@end
