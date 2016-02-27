# Messages Module

## Description

Elegant, simple and powerful messages view module for iOS based on JSQMessagesViewController from Jesse Squires.

## Accessing the Messages Module

To access this module from JavaScript, you would do the following:

    var messages = require("br.com.arlsoft.messages").createView();

The messages variable is a reference to the Messages View object.

## Accessing the Messages Module with Alloy

Include the module tag in your view as following:

	<Module id="messages" module="br.com.arlsoft.messages" method="createView" />

The $.messages variable is a reference to the Messages View object.

## Reference

The module works with default settings and requires only some few lines of code to get it to work.

### Required Settings

    //User sender name or nick name
    //Required with no default
    $.messages.sender (String)

### Datasource

    var moment = require('alloy/moment');
    
    //Datasource delegate to get message data from a specified index
    $.messages.messageDataForIndex = function(data) {
    	//Expect a return object with following properties
    	return {
    		//text message
    		message : 'Message at index #'+data.index,
    		//message owner identifying incoming or outgoing messages
    		sender : (i % 2) ? $.messages.sender : '',
    		//png image name from assets, web url to png image or text (initials)
    		avatar : (i % 2) ? 'ARL' : 'JSQ',
    		//optional timestamp with following format
    		date : moment.utc().format("YYYY-MM-DDTHH:mm:ss.SSS");
    	};
    };
    
    //Datasource delegate to get the total message count
    $.messages.messageDataCount = function() {
    	//Expect a return integer message count
    	return 20;
    };

## Usage

See example and issue history at following GitHub repo:  
https://github.com/arleyandrada/Messages

## Author

ArlSoft Tecnologia  
contato@arlsoft.com.br

## License

Commercial : Copyright (c) 2014

All rights reserved.  
This is proprietary software.  
No warranty, explicit or implicit, provided.