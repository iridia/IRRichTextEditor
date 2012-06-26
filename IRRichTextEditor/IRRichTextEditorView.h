//
//  IRRichTextEditorView.h
//  IRRichTextEditor
//
//  Created by Evadne Wu on 6/26/12.
//  Copyright (c) 2012 Iridia Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IRRichTextEditorDocumentView;
@interface IRRichTextEditorView : UIView

@property (nonatomic, readonly, strong) IRRichTextEditorDocumentView *documentView;

@end
