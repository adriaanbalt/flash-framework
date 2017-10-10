import mx.events.EventDispatcher;
import mx.remoting.Service;
import mx.utils.Delegate;
import mx.rpc.*;

import cinqetdemi.remoting.RemotingCall;
import cinqetdemi.remoting.RemotingService;
/**
 * @author Patrick
 */
class cinqetdemi.remoting.RemotingMethod 
{
	private var service : Service;
	public var methodName : String;
	
	private var dispatchEvent:Function;
	public var addEventListener:Function;
	public var removeEventListener:Function;

	private var defaultSettings : Object;
	
	function RemotingMethod(service:Service, methodName:String, defaultSettings:Object)
	{
		EventDispatcher.initialize(this);
		this.service = service;
		this.methodName = methodName;
		this.defaultSettings = defaultSettings;
	}
	
	function exec()
	{
		//there's so metadata attachedto this one
		var meta:Object = null;
		if(arguments.length == 5)
		{
			meta = arguments.pop();
		}
		if(meta == null)
		{
			meta = defaultSettings;
		}
		var args:Array = arguments.slice(0, 4);
		var rc:RemotingCall = new RemotingCall(service, methodName, args[0], args[1], args[2], args[3], meta);
		rc.exec();

		dispatchEvent({target:this, type:'call', args:rc.args, methodName:this.methodName});

		rc.faultHandler = Delegate.create(this, onFault);
		rc.resultHandler = Delegate.create(this, onResult);
		rc.busyHandler = Delegate.create(this, onBusy);
		rc.timeoutHandler = Delegate.create(this, onTimeout);
	}
	
	function onFault(rc:RemotingCall, fault:FaultEvent):Void
	{
		dispatchEvent({target:this, type:'fault', args:rc.args, methodName:this.methodName, fault:fault.fault});
	}
	
	function onResult(rc:RemotingCall, result:ResultEvent):Void
	{
		dispatchEvent({target:this, type:'result', args:rc.args, methodName:this.methodName, result:result.result});
	}
	
	function onBusy()
	{
		dispatchEvent({target:this, type:'busy'});
	}
	
	function onTimeout(rc:RemotingCall)
	{
		dispatchEvent({target:this, type:'timeout', methodName:this.methodName, args:rc.args});
	}
}