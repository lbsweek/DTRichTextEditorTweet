//
//  ViewController.h
//  DTAttributedTextViewDemo
//
//  Created by chenkai on 9/11/14.
//  Copyright (c) 2014 Chenkai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import  <DTRichTextEditor/DTAttributedTextView.h>
#import <DTRichTextEditor/DTRichTextEditorView.h>

@interface ViewController : UIViewController <DTAttributedTextContentViewDelegate>

//@property (weak, nonatomic) IBOutlet DTAttributedTextView *textView;
@property (weak, nonatomic) IBOutlet DTRichTextEditorView *textView;


@end
