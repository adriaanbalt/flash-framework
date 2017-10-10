import mx.remoting.PendingCall;
import mx.rpc.*;
import mx.utils.Delegate;

import cinqetdemi.remoting.RemotingService;
import mx.remoting.Service;

/**
 * RemotingCall does not use EventDispatcher for performance reasons
 * 
 * @author Patrick
 */
class cinqetdemi.remoting.RemotingCall 
{
	public var methodName:String;
	public var args:Array;
	
	private var service:Service;
	private var resultCb:Function;
	private var faultCb:Function;
	
	private var pc:PendingCall;
	private var attempt:Number = 0;
	
	private var timeout:Number = 5000;
	private var maxAttempts:Number = 3;
	
	private var timeoutInt:Number;
	private var busyInt:Number;
	
	public var faultHandler:Function;
	public var resultHandler:Function;
	public var busyHandler:Function;
	public var timeoutHandler:Function;
	
	private var completed:Boolean = false;
	
	private var meta:Object;

	function RemotingCall(service:Service, methodName:String, args:Array, scope, resultCb:Function, faultCb:Function, meta:Object)
	{
		this.service = service;
		this.methodName = methodName;
		this.args = args;
		this.resultCb = Delegate.create(scope, resultCb);
		this.faultCb = Delegate.create(scope, faultCb);
		this.meta = meta;
		
		if(meta.timeout != null)
		{
			timeout = meta.timeout;
		}
		if(meta.maxAttempts != null)
		{
			maxAttempts = meta.maxAttempts;
		}
	}
	
	function exec():Void
	{
		pc = this.service[methodName].apply(this, args);
		pc.responder = new RelayResponder(this, "onResult", "onFault");
		if(attempt == 0)
		{
			busyInt = setInterval(Delegate.create(this, onBusy), RemotingService.BUSY_TIME);
			timeoutInt = setInterval(Delegate.create(this, onTimeout), timeout);
		}
		attempt++;
	}
	
	function onBusy(re:ResultEvent):Void
	{
		clearInterval(busyInt);
		busyHandler();
	}
	
	function onResult(re:ResultEvent):Void
	{
		if(!completed)
		{
			clearInterval(timeoutInt);
			clearInterval(busyInt);
			
			resultHandler(this, re);
			
			resultCb.apply(this, [re, args]);
			completed = true;
		}
	}
	
	function onFault(fe:FaultEvent):Void
	{
		if(!completed)
		{
			clearInterval(timeoutInt);
			clearInterval(busyInt);
			
			faultCb.apply(this, [fe, args]);
			
			faultHandler(this, fe);
			completed = true;
		}
	}
	
	function onTimeout():Void
	{
		clearInterval(busyInt);
		
		if(attempt >= maxAttempts)
		{
			clearInterval(timeoutInt);
			
			//End
			var fe = new FaultEvent(new Fault('TIMEOUT', methodName + ' timed out', "", ""));
			faultCb.apply(this, [fe, args]);
			
			timeoutHandler(this);
		}
		else
		{
			//Retry
			exec();
		}
	}
}