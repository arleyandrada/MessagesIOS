/**
 * Commercial : Copyright (c) 2014
 * ArlSoft Tecnologia <contato@arlsoft.com.br>
 *
 * All rights reserved.
 * This is proprietary software.
 * No warranty, explicit or implicit, provided.
 */
var args = arguments[0] || {};

/***** FULL CUSTOMIZED SAMPLE *****/

//Useful date library
var moment = require('alloy/moment');

//Fake datasource from web api
var dataSource = require('webapi');
dataSource.init(args.chatId, function(error, data) {
	//Handle datasource callback
	if (error) {
		//Show error and details
		alert('Error Code '+error.code+'\n\n'+error.message);
		try {
			Ti.API.info('Error Details : '+JSON.stringify(error.detail));
		} catch (ex) {
			Ti.API.info('Error Details : '+error.detail);
		}
	} else {
		//Check new read messages count
		if (data.newMessagesCount <= 0) {
			Ti.API.info('No messages found.');
		} else {
			Ti.API.info(data.newMessagesCount+' new messages loaded.');
		}
		//Update message view after load earlier messages from datasource
		$.chatModule.finishLoadEarlierMessages(data.readMessagesCount);
	}
});

//Required settings
$.chatModule.sender = args.sender;

//Optional default value to incoming and outgoing avatar
//Use png image name from assets, web url to png image or text (initials)
if (args.defaultIncomingAvatar) {
	$.chatModule.defaultIncomingAvatar = args.defaultIncomingAvatar;
}
if (args.defaultOutgoingAvatar) {
	$.chatModule.defaultOutgoingAvatar = args.defaultOutgoingAvatar;
}

//Change to loading avatar (when loading avatar from web url)
//Use png image name from assets or text
//Default : "..."
$.chatModule.loadingAvatar = '...';

//Change to "unable to load" avatar (when loading avatar from web url)
//Use png image name from assets or text
//Default : "X"
$.chatModule.unableToLoadAvatar = 'X';

//Change to enable or disable sound to sent or received messages
//Default : true
$.chatModule.playMessageSentSound = true;
$.chatModule.playMessageReceivedSound = true;

//Control to input bar visibility
$.chatModule.showInputBar = true;

//Control to send button visibility in input bar
$.chatModule.showSendButton = false;

//Control to accessory button visibility and state in input bar
$.chatModule.showAccessoryButton = true;
$.chatModule.accessoryButtonEnabled = true;

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
		avatar : $.chatModule.defaultOutgoingAvatar,
		date : moment.utc().format("YYYY-MM-DDTHH:mm:ss.SSS")
	});
	//Update message view after changed datasource (sending)
	$.chatModule.finishSendingMessage();
});

//Accessory button pressed event
$.chatModule.addEventListener('accessoryPressed', function() {
	alert('Accessory button pressed!');
});

//Load earlier messages button pressed event
$.chatModule.addEventListener('tappedLoadEarlier', function() {
	//Read earlier messages from datasource
	var newMessagesCount = dataSource.readNextPage();
	//Update message view after new messages read from datasource history
	$.chatModule.finishLoadEarlierMessages(newMessagesCount);
});

//Tapped avatar event
$.chatModule.addEventListener('tappedAvatar', function(data) {
	Ti.API.info('!!!!! tappedAvatar = ' + data.index);

	//Get message data
	var message = dataSource.getMessageByIndex(data.index);

	//Check avatar loading state (to web url avatar)
	if (data.loaded) {
		Ti.API.info('!!!!! avatar ' + message.avatar + ' already loaded.');
	} else if (data.loading) {
		Ti.API.info('!!!!! avatar ' + message.avatar + ' is loading...');
	} else {
		//Try to reload avatar image from web url
		$.chatModule.reloadAvatar(message.avatar);
	}
});

//Tapped bubble event
$.chatModule.addEventListener('tappedBubble', function(data) {
	Ti.API.info('!!!!! tappedBubble = ' + data.index);
});

//Tapped cell event
$.chatModule.addEventListener('tappedCell', function(data) {
	Ti.API.info('!!!!! tappedCell = ' + data.index);
});

//Begin editing event to input text (focus)
$.chatModule.addEventListener('textBeginEditing', function(data) {
	//Show send button at input bar
	$.chatModule.showSendButton = true;
	//Disable accessory button at input bar
	$.chatModule.accessoryButtonEnabled = false;
});

//Text changed event to input text
$.chatModule.addEventListener('textDidChange', function(data) {
	//Check input text content
	if (data.message == 'Hello') {
		//Change input text content
		$.chatModule.inputText = 'Hello World!';
	}
});

//End editing event to input text (blur)
$.chatModule.addEventListener('textEndEditing', function(data) {
	//Hide send button at input bar
	$.chatModule.showSendButton = false;
	//Enable accessory button at input bar
	$.chatModule.accessoryButtonEnabled = true;
});

//Advanced customizations (individual message customizations)
//Set this callback method to create special avatar customizations...
//Return one or more custom properties from a specified index
$.chatModule.cellAvatarCustomization = function(data) {
	//Get message data
	var message = dataSource.getMessageByIndex(data.index);
	//Check data to enable customization
	if (message.echo) {
		//Return customization properties
		return {
			//Avatar cell customization...
			//showAvatar
			avatarSize : 20
			//avatarOverlay
			//textAvatarBackgroundColor
			//textAvatarColor
			//textAvatarFont
		};
	}
	//Return no customization
	return null;
};

//Advanced customizations (individual message customizations)
//Set this callback method to create special timestamp customizations...
//Return one or more custom properties from a specified index
$.chatModule.cellTimestampCustomization = function(data) {
	//Get message data
	var message = dataSource.getMessageByIndex(data.index);
	//Check data to enable customization
	if (message.echo) {
		//Return customization properties
		return {
			//Timestamp cell customization...
			//showTimestamp
			//timestampHeight
			timestampColor : '#800000'
			//timestampFont
			//timestampPrefixFont
			//timestampContent (string)
			//timestampPrefixContent (string)
		};
	}
	//Return no customization
	return null;
};

//Advanced customizations (individual message customizations)
//Set this callback method to create special sender name customizations...
//Return one or more custom properties from a specified index
$.chatModule.cellSenderNameCustomization = function(data) {
	//Get message data
	var message = dataSource.getMessageByIndex(data.index);
	//Check data to enable customization
	if (message.echo) {
		//Return customization properties
		return {
			//Sender name cell customization...
			//showSenderName
			//senderNameHeight
			senderNameColor : '#e00000'
			//senderNameFont
			//senderNameContent (string)
		};
	}
	//Return no customization
	return null;
};

//Advanced customizations (individual message customizations)
//Set this callback method to create special bubble customizations...
//Return one or more custom properties from a specified index
$.chatModule.cellBubbleCustomization = function(data) {
	//Get message data
	var message = dataSource.getMessageByIndex(data.index);
	//Check data to enable customization
	if (message.echo) {
		//Return customization properties
		return {
			//Bubble cell customization...
			//showBubbles
			//bubbleKind
			bubbleColor : '#ff8080'
			//textColor
			//textAlignment
			//bubbleFont
		};
	}
	//Return no customization
	return null;
};

//Simulate a received message from a button click
function btnReceiveClick(e) {
	//Ger datasource info
	var data = dataSource.getMessagesData();
	if (data && data.read > 0) {
		//Get last read message from datasource
		var message = dataSource.getMessageByIndex(data.read -1);
		//Check if is a valid and "not echo" message 
		if (message && !message.echo) {
			//Scroll message view to bottom
			$.chatModule.scrollToBottomAnimated(true);
			//Add new message to datasource
			dataSource.pushMessage({
				echo : true,
				message : message.message.split('').reverse().join(''),
				avatar : 'demo_avatar_jobs',
				date : moment.utc().format("YYYY-MM-DDTHH:mm:ss.SSS")
			});
			//Update message view after changed datasource (receiving)
			$.chatModule.finishReceivingMessage();
		}
	}
}
