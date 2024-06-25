/*
Copyright (c) 2003-2010, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

CKEDITOR.editorConfig = function( config )
{
    config.toolbar = 'MyToolbar';

    config.toolbar_MyToolbar =
    [
        ['Cut','Copy','Paste','PasteText','PasteFromWord','-','Scayt'],
        ['Undo','Redo','-','Find','Replace','-','SelectAll','RemoveFormat'],
        ['Table','HorizontalRule','SpecialChar','PageBreak'],
        '/',
      /*  ['Styles','Format'],*/
        ['Bold','Italic','Strike'],
        ['NumberedList','BulletedList','-','Outdent','Indent','Blockquote'],
        ['Maximize','-']
    ];
};

CKEDITOR.replace( 'editor2' );