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

/***** FAKE DATASOURCE FROM WEB API *****/

//Useful date library
var moment = require('alloy/moment');

//Inicial empty fake conversation...
var messages = [];

//Datasource paging control
var pageSize = 20;
var readMessages = 0;

//Web api ordering control
var loadInReverseOrder = true;

//Timestamp visibility control
var lastDate = false;

//Sample timestamp visibility role (item)
//Show timestamp only when date changes...
function fixDateVisibility() {
	lastDate = false;
	for (var i=0; i<messages.length; i++) {
		var message = messages[i];
		fixItemDateVisibility(message);
	}
}

//Sample timestamp visibility role (collection)
//Show timestamp only when date changes...
function fixItemDateVisibility(message) {
	var itemDate = message.date;
	if (itemDate) {
		if (!lastDate) {
			lastDate = itemDate;
		} else {
			if (itemDate.substring(0, 10) == lastDate.substring(0, 10)) {
				delete message.date;
			} else {
				lastDate = itemDate;
			}
		}
	}
}

//Init fake datasource
exports.init = function(chatId, cb) {
	//Init datasource variables
	messages = [];
	readMessages = 0;
	lastDate = false;	

	//Arguments validation
	if (!chatId) {
		cb({
			code : 1,
			message : 'No chatId found!'
		});
		return;
	}

	//Check Internet connection
	if (!Ti.Network.online) {
		cb({
			code : 2,
			message : 'No internet connection!'
		});
		return;
	}

	//Define http client
	var request = Ti.Network.createHTTPClient({
		enableKeepAlive : false,
		onload : function(e) {
			try {
				var statusCode = request.status;
				var responseText = request.responseText;

				//Check http statos codes
				if (statusCode == 200 || statusCode == 201) {
					//Parse response content
					var response = JSON.parse(responseText);
					//Check response content
					if (response.status == 'OK') {
						//Check response content
						if (response.messages) {

							//Revert received messages order
							var messageCollection = response.messages;
							if (loadInReverseOrder)
								messageCollection.reverse();
								
							//Convert web api messages to expected datasource attributes
							var newMessages = messageCollection.map(function(item) {
								
								//Check and convert timestamp format from unix
								var itemDate = item.timestamp ? moment.unix(item.timestamp) : false;
								if (itemDate && !itemDate.isValid())
									itemDate = false;
								if (!itemDate)
									itemDate = moment.utc();
									
								//New datasource message
								var message = {
									message : item.message,
									sender : item.user.name,
									avatar : item.user.pictures[0],
									date : itemDate.format("YYYY-MM-DDTHH:mm:ss.SSS")
								};
								
								//Add new message to the top of messages collection
								messages.unshift(message);
								return message;
							});
							
							//Apply timestamp visibility rules
							fixDateVisibility();

							//Update paging control variables
							if (readMessages < pageSize) {
								readMessagesCount = pageSize - readMessages;
							} else {
								readMessagesCount = pageSize;
							}
							if ((readMessagesCount + readMessages) > messages.length) {
								readMessagesCount = messages.length - readMessages;
							}
							readMessages += readMessagesCount;

							//Return successful request with new messages count
							cb(false, {
								newMessagesCount : newMessages.length,
								readMessagesCount : readMessagesCount
							});
						} else {
							//Return successful request without new messages
							cb(false, {
								newMessagesCount : 0,
								readMessagesCount : 0
							});
						}
					} else {
						//Return web api content error
						cb({
							code : 6,
							message : 'Webapi invalid response with status ' + response.status,
							detail : response
						});
					}
				} else {
					//Return unexpected web api http status
					cb({
						code : 5,
						message : 'Webapi internal error with code ' + statusCode,
						detail : request
					});
				}
			} catch (ex) {
				//Return unexpected error
				cb({
					code : 4,
					message : ex.message,
					detail : ex
				});
			}
		},
		onerror : function(e) {
			//Return unexpected error
			cb({
				code : 3,
				message : e.error,
				detail : e
			});
		}
	});

	//Get fake messages from apiary mock
	request.open('GET', 'http://private-bb9c4-messages6.apiary-mock.com/messages/' + chatId, true);
	//Fake header arguments
	request.setRequestHeader('AUTHORIZATION', '1234567890');
	request.setRequestHeader('Content-Type', 'application/json');
	//Start web api request
	request.send();
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
	message.date = moment.utc().format("YYYY-MM-DDTHH:mm:ss.SSS");
	
	fixItemDateVisibility(message);

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