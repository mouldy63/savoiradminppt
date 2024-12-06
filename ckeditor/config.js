/*
Copyright (c) 2003-2010, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

CKEDITOR.editorConfig = function( config )
{
    config.toolbar = 'MyToolbar';

    config.toolbar_MyToolbar =
    [
		['Source','-' ],
        ['Print','Cut','Copy','Paste','PasteText','PasteFromWord','-','Scayt'],
        ['Undo','Redo','-','Find','Replace','-','SelectAll','RemoveFormat'],
        ['Table','HorizontalRule','SpecialChar','PageBreak'],
        '/',
      /*  ['Styles','Format'],*/
	     ['Link','Unlink','Anchor'],
        ['Bold','Italic','Strike'],
        ['NumberedList','BulletedList','-','Outdent','Indent','Blockquote'],
        ['Maximize','-']
    ];
};
CKEDITOR.on('instanceReady', function(ev)
    {
        var tags = ['p', 'ol', 'ul', 'li', 'h1', 'h2', 'h3', 'h4', 'h5']; // etc.

        for (var key in tags) {
            ev.editor.dataProcessor.writer.setRules(tags[key],
                {
                    indent : false,
                    breakBeforeOpen : true,
                    breakAfterOpen : false,
                    breakBeforeClose : false,
                    breakAfterClose : true
                });
        }
    });

CKEDITOR.replace( 'editor2' );