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

/***** FAKE DATASOURCE *****/

//Useful date library
var moment = require('alloy/moment');

//Inicial fake conversation...
var messages = [{
	message : 'Welcome to Messages Titanium Module to the native JSQMessagesViewController.',
	sender : 'Arley',
	avatar : 'ARL',
	date : '2014-09-19T12:00:00.000'
}, {
	message : 'It is simple, elegant, and easy to use. There are super sweet default settings, but you can customize like crazy.',
	sender : 'Steve Wozniak',
	avatar : 'demo_avatar_woz'
}, {
	message : 'It even has data detectors. You can call me tonight. My cell number is 123-456-7890. My website is www.appcelerator.com.',
	sender : 'Jesse Squires',
	avatar : 'JSQ',
	date : '2014-09-19T12:05:00.000'
}, {
	message : 'Thanks Jesse Squires!',
	sender : 'Arley',
	avatar : 'ARL'
}, {
	message : 'Now with avatar image from URL',
	sender : 'Avatar',
	avatar : 'http://goo.gl/rsn18X',
	date : moment.utc().format("YYYY-MM-DDTHH:mm:ss.SSS")
}];

//Generate fake old messages...
for (var i = 0; i < 100; i++) {
	if (i % 2) {
		messages.unshift({
			message : 'Old message #' + i.toString(),
			sender : 'Arley',
			avatar : 'ARL'
		});
	} else {
		messages.unshift({
			message : 'Old message #' + i.toString(),
			sender : 'Jesse Squires',
			avatar : 'JSQ'
		});
	}
}

//Datasource paging control
var pageSize = 20;
var readMessages = 0;

//Init fake datasource
exports.init = function() {
	readMessages = 0;
}; 

//Return fake message from required index
exports.getMessageByIndex = function(idx) {
	return messages[messages.length - readMessages + idx];
};

//Return fake datasource info
exports.getMessagesData = function() {
	if (readMessages == 0) {
		if (messages.length > (readMessages + pageSize)) {
			readMessages += pageSize;
		} else {
			readMessages = messages.length;
		}
	}
	return {
		read : readMessages,
		total : messages.length
	};
};

//Push new message to the fake datasource
exports.pushMessage = function(message) {
	messages.push(message);
	readMessages += 1;
};

//Read old messages from fake datasource according to paging settings
//and return how many messages was read
exports.readNextPage = function() {
	var newMessages = 0;
	if (messages.length > (readMessages + pageSize)) {
		newMessages = pageSize;
	} else {
		newMessages = messages.length - readMessages;
	}
	readMessages += newMessages;
	return newMessages;
};