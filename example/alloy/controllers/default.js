/**
 * MIT License
 * Copyright (c) 2014-present
 * ArlSoft Tecnologia <contato@arlsoft.com.br>
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to
 * deal in the Software without restriction, including without limitation the
 * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
 * sell copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */

var args = arguments[0] || {};

/***** DEFAULT SAMPLE *****/

//Useful date library
var moment = require('alloy/moment');

//Fake datasource
var dataSource = require('data');
dataSource.init();

//Required settings
$.chatModule.sender = args.sender;

//Datasource delegate to get message data from a specified index
$.chatModule.messageDataForIndex = function(data) {
	//Return message from datasource by index
	return dataSource.getMessageByIndex(data.index);
};

//Datasource delegate to get the total message count
$.chatModule.messageDataCount = function() {
	//Get datasource info
	var data = dataSource.getMessagesData();
	//Control load earlier messsages button visibility
	$.chatModule.showLoadEarlierMessagesHeader = data.read < data.total;
	//Return read (visible) messages count
	return data.read;
};

//Send message button pressed event
$.chatModule.addEventListener('sendPressed', function(data) {
	//Add new message to datasource
	dataSource.pushMessage({
		message : data.message,
		sender : $.chatModule.sender,
		avatar : 'ARL',
		date : moment.utc().format("YYYY-MM-DDTHH:mm:ss.SSS")
	});
	//Update message view after changed datasource (sending)
	$.chatModule.finishSendingMessage();
});

//Load earlier messages button pressed event
$.chatModule.addEventListener('tappedLoadEarlier', function() {
	//Read earlier messages from datasource
	var newMessagesCount = dataSource.readNextPage();
	//Update message view after new messages read from datasource history
	$.chatModule.finishLoadEarlierMessages(newMessagesCount);
});

//Simulate a received message from a button click
function btnReceiveClick(e) {
	$.chatModule.scrollToBottomAnimated(true);
	dataSource.pushMessage({
		message : 'Oh no! There\'s no typing indicator yet!',
		avatar : 'demo_avatar_jobs'
	});
	$.chatModule.finishReceivingMessage();
}