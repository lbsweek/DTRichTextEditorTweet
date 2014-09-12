//
//  ViewController.m
//  DTAttributedTextViewDemo
//
//  Created by chenkai on 9/11/14.
//  Copyright (c) 2014 Chenkai. All rights reserved.
//

#import "ViewController.h"
#import <DTRichTextEditor/DTHTMLAttributedStringBuilder.h>
#import <DTRichTextEditor/DTCoreTextConstants.h>
#import <DTRichTextEditor/DTLinkButton.h>
#import <DTRichTextEditor/DTRichTextEditorView.h>
#import "RegexKitLite.h"
#import "NSString+URLEncoding.h"



//1. include DTRichTextEditor framework and include DTRichTextEditorView
//2. include RegexKitLite.h NSString+URLEncoding.h and change compile to support non-arc
//3. add libicu-core framework, coretext, libxml2, imageIO
//4.



@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"content" ofType:@"html"];
    NSData *htmlData = [NSData dataWithContentsOfFile:filePath];
    NSString* html =  [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
    html = [self parseText:html];
    htmlData = [html dataUsingEncoding:NSUTF8StringEncoding];
    
    //htmlData =   [@"ellentesque habitant morbi" dataUsingEncoding:NSUTF8StringEncoding];
    
    
    
    // Set our builder to use the default native font face and size
    NSDictionary *builderOptions = @{
                                     DTDefaultFontFamily: @"Helvetica",
                                     DTDefaultFontSize:  @17,
                                     };
    
    
    
    DTHTMLAttributedStringBuilder *stringBuilder = [[DTHTMLAttributedStringBuilder alloc] initWithHTML:htmlData
                                                                                               options:builderOptions
                                                                                    documentAttributes:nil];
    
    self.textView.defaultFontSize  = 30;
    self.textView.editable = NO;  //change by chenkai
    self.textView.attributedString = [stringBuilder generatedAttributedString];
    
    // Assign our delegate, this is required to handle link events
    self.textView.textDelegate = self;
    
    // Without this the text goes right up to the edge
    self.textView.contentInset = UIEdgeInsetsMake(6, 8, 8, 8);
}

#pragma mark - DTAttributedTextContentViewDelegate

- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView
                          viewForLink:(NSURL *)url
                           identifier:(NSString *)identifier
                                frame:(CGRect)frame
{
    DTLinkButton *linkButton = [[DTLinkButton alloc] initWithFrame:frame];
    //linkButton.
    //linkButton.backgroundColor = [UIColor yellowColor];
    [linkButton setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:1.0 green:1.0 blue:0 alpha:0.5]] forState:UIControlStateHighlighted];
    linkButton.URL = url;
    [linkButton addTarget:self action:@selector(linkButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return linkButton;
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - Events

- (IBAction)linkButtonClicked:(DTLinkButton *)sender
{
    NSURL* url = sender.URL;
    //[[UIApplication sharedApplication] openURL:url];
    NSString *urlStr = [url absoluteString];
    if ([urlStr hasPrefix:@"user"]) {
        NSString *user = [[url host] URLDecodedString];
        NSLog(@"%@",user);
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"username" message:urlStr delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
    }else if([urlStr  hasPrefix:@"http"]){
        NSString *http = [urlStr URLDecodedString];
        NSLog(@"%@",http);
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"url" message:urlStr delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
    }else if([urlStr hasPrefix:@"topic"]){
        NSString *topic = [[url host] URLDecodedString];
        NSLog(@"%@",topic);
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"topic" message:urlStr delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}


-(NSString*)parseText:(NSString*)text{
    
    NSString *relexStr = @"(@\\w+)|(#[\\w ]+#)|(http(s)?://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&=]*)?)";
    NSArray *strs = [text componentsMatchedByRegex:relexStr];
    NSString *replaceString = nil;
    for (NSString *str in strs) {
        if ([str hasPrefix:@"@"]) {
            //replaceString = [NSString stringWithFormat:@"<a href='user://%@'>%@</a>",[str  URLEncodedString],str];
            replaceString = [NSString stringWithFormat:@"<a href='user://%@'>%@</a>",str,str];
        }else if([str hasPrefix:@"http"]){
            //replaceString = str;
            //replaceString = [NSString stringWithFormat:@"<a href='%@'>%@</a>",[str  URLEncodedString],str];
            replaceString = [NSString stringWithFormat:@"<a href='%@'>%@</a>",str,str];
        }else if([str hasPrefix:@"#"]){
            //replaceString = [NSString stringWithFormat:@"<a href='topic://%@'>%@</a>",[str  URLEncodedString],str];
            replaceString = [NSString stringWithFormat:@"<a href='topic://%@'>%@</a>",str,str];
        }
        text = [text stringByReplacingOccurrencesOfString:str withString:replaceString];
    }
    return text;

}

@end
