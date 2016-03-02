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