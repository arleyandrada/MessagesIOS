/**
 * Commercial : Copyright (c) 2014
 * ArlSoft Tecnologia <contato@arlsoft.com.br>
 * 
 * All rights reserved.
 * This is proprietary software.
 * No warranty, explicit or implicit, provided.
 */

/***** MINIMAL SAMPLE *****/

//Useful date library
var moment = require('alloy/moment');

//Create a new messsages view
var messages = require('br.com.arlsoft.messages').createView();

//Required settings
messages.sender = 'Arley';

//Fake datasource
var dataSource = [];
for (var i = 0; i < 20; i++) {
	dataSource.push({
		//text message
		message : 'Message at index #'+i,
		//message owner identifying incoming or outgoing messages
		sender : (i % 2) ? messages.sender : 'Jesse',
		//png image name from assets, web url to png image or text (initials)
		avatar : (i % 2) ? 'ARL' : 'JSQ',
		//optional timestamp with following format
		date : moment.utc().format("YYYY-MM-DDTHH:mm:ss.SSS")
	});
}

//Datasource delegate to get message data from a specified index
messages.messageDataForIndex = function(data) {
	//Return message from datasource by index
	return dataSource[data.index];
};

//Datasource delegate to get the total message count
messages.messageDataCount = function() {
	//Expect a return integer message count
	return dataSource.length;
};

//Send message button pressed event
messages.addEventListener('sendPressed', function(data) {
	//Add new message to datasource
	dataSource.push({
		message : data.message,
		sender : messages.sender,
		avatar : 'ARL',
		date : moment.utc().format("YYYY-MM-DDTHH:mm:ss.SSS")
	});
	//Update message view after changed datasource
	messages.finishSendingMessage();
});

//Create a new window
var win = Ti.UI.createWindow({
    backgroundColor: 'white'
});

//Add the messages view as a window child
win.add(messages);

//Open window with message view
win.open();