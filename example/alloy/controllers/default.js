/**
 * Commercial : Copyright (c) 2014
 * ArlSoft Tecnologia <contato@arlsoft.com.br>
 *
 * All rights reserved.
 * This is proprietary software.
 * No warranty, explicit or implicit, provided.
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