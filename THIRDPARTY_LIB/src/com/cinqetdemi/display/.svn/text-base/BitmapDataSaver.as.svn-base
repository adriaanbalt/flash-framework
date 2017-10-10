import mx.events.EventDispatcher;
import mx.rpc.ResultEvent;
import mx.utils.Delegate;

import cinqetdemi.display.BitmapDataExporter;
import cinqetdemi.remoting.RemotingService;

import flash.display.BitmapData;
/**
 * BitmapDataSaver saves a BitmapData instance to a remote server
 * Use it like this:
 * 
import cinqetdemi.display.*;
import mx.utils.Delegate;
import flash.display.*;

//The location of amfphp
var amfphpUrl = 'http://localhost/amfphp/gateway.php';
//The service name
var serviceName = 'BitmapDataSaver';
//The bitDepth, acceptable values are 12, 24, and 32 (transparent)
var bitDepth = 12;
//The bitmap data instance to export
var bmp:BitmapData = BitmapData.loadBitmap("myBitmap");

//Create a saver and set up event listeners
var saver:BitmapDataSaver = new BitmapDataSaver(amfphpUrl, serviceName);
saver.addEventListener('progress', Delegate.create(this, onProgress));
saver.addEventListener('complete', Delegate.create(this, onComplete));
saver.addEventListener('retrieve', Delegate.create(this, onRetrieve));
//Change the blocksize (number of bytes sent to the server per call) if necessary
//saver.blocksize = 50000;
//Start the export process

saver.export(bmp, bitDepth);

function onProgress(eventObj:Object)
{
	trace('Percent complete: ' + eventObj.complete);
	switch(eventObj.status)
	{
		case 'export':
			trace("Exporting data");
			break;
		case 'getid':
			trace("Getting bitmap id");
			break;
		case 'send':
			trace("Sending data");
			break;
		case 'save':
			trace("Saving data");
			break;
	}
}

function onComplete(eventObj:Object)
{
	trace('Image save is complete');
	//Right now, the image is in png format. Compress the image and get the link
	//First parameter is jpg, gif, or png
	//Second parameter is quality, for jpg only
	saver.retrieveCompressed('jpg', 80);
}

function onRetrieve(eventObj:Object)
{
	trace('The image has been compressed and the link retrieved');
	trace(eventObj.link);
}

 * @author Patrick
 */
class cinqetdemi.display.BitmapDataSaver 
{
	private var dispatchEvent:Function;
	public var addEventListener:Function;
	public var removeEventListener:Function;

	private var bmpx : BitmapDataExporter;
	private var gatewayUrl : String;
	private var serviceName : String;

	private var service : RemotingService;

	private var bitmapId : String;

	private var exported : Boolean;
	private var _blocksize:Number = 50000;

	private var bmp : BitmapData;

	private var step : Number;

	private var steps : Number;

	private var cancelled : Boolean = false;
	
	private var bitDepth:Number;
	
	/**
	* Create a new BitmapDataSaver instance
	* @param	gatewayUrl The url of the amfphp gateway
	* @param	serviceName The service name of the bitmap saver service
	*/
	function BitmapDataSaver(gatewayUrl:String, serviceName:String)
	{
		this.gatewayUrl = gatewayUrl;
		this.serviceName = serviceName;
		EventDispatcher.initialize(this);
	}
	
	/**
	 * Export now to png
	 * @param bmp The BitmapData instance to export
	 * @param depth Either 12, 24 or 32
	 */
	function export(bmp:BitmapData, bitDepth:Number)
	{
		cancelled = false;
		exported = false;
		bitmapId = null;
		
		this.bitDepth = bitDepth == null ? 24 : bitDepth;
		
		this.bmp = bmp.clone();
		
		var numSteps = Math.ceil(bmp.width*bmp.height/2500);

		bmpx = new BitmapDataExporter(bmp, numSteps, bitDepth);
		bmpx.addEventListener('progress', Delegate.create(this, onExportProgress));
		bmpx.addEventListener('complete', Delegate.create(this, onExportComplete));
		bmpx.export();
		
		service = new RemotingService(gatewayUrl, serviceName, RemotingService.NO_RETRY);
		service.getBitmapId([bitDepth, bmp.width, bmp.height], this, onGetBitmapId);
	}
	
	function cancel():Void
	{
		if(bitmapId == null)
		{
			bmpx.cancel();
		}
		else if(!exported)
		{
			bmpx.cancel();
		}
		else
		{
			step = steps;
		}
		this.bmp.dispose();
		cancelled = true;
	}
	
	function onExportProgress(evtObj:Object):Void
	{
		dispatchEvent({status:'export', type:'progress', complete:evtObj.complete/evtObj.total*25});
	}
	
	function onExportComplete()
	{
		trace('In onExportComplete');
		exported = true;
		if(!cancelled)
		{
			if(bitmapId != null)
			{
				startSave();
			}
			else
			{
				dispatchEvent({status:'getid', type:'progress', complete:25});
			}
		}
	}
	
	function onGetBitmapId(re:ResultEvent)
	{
		trace('in onGetBitmapId');
		trace(re.result);
		bitmapId = String(re.result);
		if(!cancelled)
		{
			if(exported)
			{
				startSave();
			}
		}
	}
	
	function startSave():Void
	{
		trace('In startSave');
		//Start saving the bitmap
		var bytes:String = bmpx.getCompressedData();
		steps = Math.ceil(bytes.length/blocksize);
		step = 0;
		sendImagePart();
		dispatchEvent({status:'send', type:'progress', complete:30});
	}
	
	function sendImagePart()
	{
		var bytes:String = bmpx.getCompressedData();
		var sc:Number = bmpx.getSplitCondition();
		var bytes2:String = bytes.substring(Math.round(step/steps*bytes.length/sc)*sc, Math.round((step + 1)/steps*bytes.length/sc)*sc);
		service.saveImagePart([bitmapId, bytes2], this, onSendImagePart);
	}
	
	function onSendImagePart()
	{
		trace('in onSendImagePart');
		step++;
		dispatchEvent({status:'send', type:'progress', complete:30+65*step/steps});
		if(!cancelled)
		{
			if(step < steps)
			{
				sendImagePart();
			}
			else
			{
				//Done
				this.bmp.dispose();
				dispatchEvent({status:'save', type:'progress', complete:100});
				service.endSaveImage([bitmapId], this, onEndSaveImage);
			}
		}
	}
	
	function onEndSaveImage()
	{
		if(!cancelled)
		{
			dispatchEvent({type:'complete', target:this});
		}
	}
	
	/**
	* Retrieve a saved image in a compressed format
	* @param	format  One of gif, png or jpg
	* @param	quality The jpg quality, if relevant
	*/
	function retrieveCompressed(format, quality):Void
	{
		service.retrieveCompressed([bitmapId, format, quality], this, onRetrieveCompressed);
	}
	
	function onRetrieveCompressed(re)
	{
		trace('in onRetrieveCompressed');
		dispatchEvent({target:this, type:'retrieve', link:re.result});
	}
	
	/**
	* Overrides the default blocksize of 50k
	*/
	function set blocksize(val:Number)
	{
		_blocksize = val;
	}
	
	function get blocksize()
	{
		return _blocksize;
	}
}