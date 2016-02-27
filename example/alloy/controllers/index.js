/**
 * Commercial : Copyright (c) 2014
 * ArlSoft Tecnologia <contato@arlsoft.com.br>
 * 
 * All rights reserved.
 * This is proprietary software.
 * No warranty, explicit or implicit, provided.
 */

//Show a window with full customized messages view
function btnStartCustomClick(e) {
    var chat = Alloy.createController('custom', {
    	chatId : 123,
    	sender : 'Arley',
    	defaultIncomingAvatar : 'JSQ',
    	defaultOutgoingAvatar : 'ARL'
    }).getView();
    $.navMain.openWindow(chat);
}

//Show a window with default messages view
function btnStartDefaultClick(e) {
    var chat = Alloy.createController('default', {
    	sender : 'Arley'
    }).getView();
    $.navMain.openWindow(chat);
}

//Show main window
$.navMain.open();