import mx.events.EventDispatcher;
import mx.remoting.debug.NetDebug;
import mx.utils.Delegate;
import mx.remoting.Service;

import cinqetdemi.remoting.RemotingMethod;

/**
 * cinqetdemi.remoting.RemotingService is a tiny layer designed to run on top of 
 * Remoting that adds a few useful functions to mx.remoting.Service. RemotingService
 * works well with amfphp but can work with any other Remoting implementation, ColdFusion,
 * Fluorine, OpenAMF, etc.
 * 
 * Notable features:
 * 
 *   * Timeout and retry on failure. If a packet gets lost, or there's a temporary
 *     hickup, oftentimes the solution is simply to send the call again. RemotingService
 *     does this automatically. Timeout time and number of retries are customizable   
 *     per call.
 *   * Argument remembering. In addition to the standard ResultEvent and FaultEvent,
 *     callbacks receive the original arguments sent to Remoting as an array in the second 
 *     parameter. This is useful in larger applications where you may call the same method lots
 *     of times and the results are out of context. For example, if you call 
 *     service.getCategory(id), you'll get back that id as a parameter in your callback
 *   * Events. In addition to standard callbacks, RemoteService dispatches system events. 
 *     Among those: result, fault (like global callbacks)
 *                  authFault (will catch authentication failures in the upcoming AMFPHP 1.2
 *                  timeout, when a call has timed out
 *                  busy, when a call has been taking more than 750 ms, which is the 
 *                        the perfect time to show a loading bar
 *                  clear, when busy has been called and the call returns, you will want to hide
 *                         the loading bar at that point
 *   * Pass by ref callbacks. Contrarily to PendingCall which uses two strings for callbacks,
 *     RemotingService uses two references for callbacks, which get checked by the compiler
 *     and saves you from the usual typo.
 * 
 * Usage example:
 * 
 * import cinqetdemi.remoting.RemotingService;
 * service = new RemotingService('http://localhost/amfphp/gateway.php', 'MyService');
 * //Retrieve category 5 in ascending order
 * service.getCategory([5, 'ASC'], this, handleGetCategory, handleFault);
 * 
 * function handleGetCategory(re:ResultEvent, args:Array)
 * {
 *      NetDebug.trace(re.result);
 *      NetDebug.trace(args);
 * }
 * 
 * function handleFault(fe:FaultEvent, args:Array)
 * {
 *      NetDebug.trace(fe.fault);
 * }
 * 
 * As for the events:
 * 
 * service.addEventListener('timeout', this);
 * service.addEventListener('busy', this);
 * service.addEventListener('clear', this);
 * 
 * function timeout()
 * {
 *      trace('Man, that sucks');
 * }
 * 
 * function busy()
 * {
 *      trace('I should really show a progress bar right about now');
 * }
 * 
 * function clear()
 * {
 *      trace('I should really hide that progress bar now');
 * }
 * 
 * By default, it will retry 3 times and wait 5 seconds each time
 * If you want to override this on a per-call basis, use the 5th argument when you call a 
 * method:
 * 
 * service.payByCreditCard(['my-credit-card-no'], null, null, null, {maxAttempts:1, timeout:20});
 * 
 * If you want to use authentication, just use service.setCredentials(user, pass);
 * 
 * The {maxAttempts:1, timeout:20} object is conveniently available as the constant:
 * RemotingService.NO_RETRY
 *
 * @author Patrick Mineault
 *         http://www.5etdemi.com
 *         http://www.5etdemi.com/blog
 *         http://www.amfphp.org
 *
 * Copyright (c) 2006 Patrick Mineault
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

/**
 * Dispatched when a result has returned
 */
[Event("result")]

/**
 * Dispatched when a generic fault has occurred
 */
[Event("fault")]

/**
* Dispatched when an authentication error has occured
*/
[Event("authFault")]

/**
* Dispatched when timeout has occured
*/
[Event("timeout")]

/**
* Dispatched when having been waiting on a call for a certain number of milliseconds
*/
[Event("busy")]

/**
* Dispatched when all calls have returned after busy has been called
*/
[Event("clear")]



dynamic class cinqetdemi.remoting.RemotingService
{	
	public static var NO_RETRY:Object = {maxAttempts:1, timeout:20000};
	public static var BUSY_TIME:Number = 750;
	
	public var gatewayUrl:String;
	public var serviceName:String;
	public var service:Service;

	/**
	 * Events are result, fault, authFault, timeout, busy, clear
	 */
	public var addEventListener:Function;
	public var removeEventListener:Function;
	public var dispatchEvent:Function;
	
	private var pendingCalls:Number = 0;
	private var hasBeenBusy:Boolean = false;
	private var defaultSettings:Object;
	
	/**
	* Constructor
	* @param gatewayUrl The location of the gateway
	* @param serviceName The service name
	*/
	function RemotingService(gatewayUrl:String, serviceName:String, defaultSettings:Object)
	{
		EventDispatcher.initialize(this);
		
		this.gatewayUrl = gatewayUrl;
		this.serviceName = serviceName;
		this.defaultSettings = defaultSettings;
		init();
	}
	
	/**
	* Initiate remoting service, making the new Service appropriately
	*/
	private function init()
	{
		NetDebug.initialize();
		
		service = new Service(gatewayUrl, null, serviceName);
	}
	
	/**
	 * set credentials on connection
	 * @param user The username
	 * @param password The password
	 */
	public function setCredentials(user:String, pass:String):Void
	{
		service.connection.setCredentials(user, pass);
	}
	
	/** 
	* Resolve remoting calls
	* 
	* @arg array arguments The argument to pass to the remote service
	* @arg function callback The callback to call on return;
	* 
	*/
	public function __resolve(p_methodName:String):Function
	{
		//Immediately kill mixin of death
		if(p_methodName.indexOf('Handler') != -1 || p_methodName.indexOf('__q_') != -1 )
		{
			return null;
		}
		
		var rm:RemotingMethod = new RemotingMethod(service, p_methodName, defaultSettings);
		
		rm.addEventListener('busy', Delegate.create(this, handleBusy));
		rm.addEventListener('result', Delegate.create(this, handleResult));
		rm.addEventListener('fault', Delegate.create(this, handleFault));
		rm.addEventListener('timeout', Delegate.create(this, handleTimeout));
		rm.addEventListener('call', Delegate.create(this, handleCall));
		
		this[p_methodName] = Delegate.create(rm, rm.exec);
		
		return this[p_methodName];
	}
	
	/**
	 * Bubble
	 */
	function handleBusy(eventObj:Object):Void
	{
		trace('In handle busy');
		hasBeenBusy = true;
		dispatchEvent({type:'busy', target:this});
	}
	
	/**
	 * Bubble
	 */
	private function handleResult(eventObj:Object):Void
	{
		removePendingCall();
		dispatchEvent({type:'result', target:this, result:eventObj.result, args:eventObj.args, methodName:eventObj.methodName});
	}
	
	/**
	 * Bubble
	 */
	function handleTimeout(eventObj:Object):Void
	{
		removePendingCall();
		dispatchEvent({type:'timeout', target:this, args:eventObj.args, methodName:eventObj.methodName});
	}
	
	/**
	* Handles a generic remoting error
	*/
	private function handleFault(eventObj:Object)
	{
		removePendingCall();
		
		NetDebug.trace(eventObj);
		
		if(eventObj.fault.faultcode == 'AMFPHP_AUTH_MISMATCH')
		{
			dispatchEvent({type:'authFault', target:this, fault:eventObj.fault, methodName:eventObj.methodName, args:eventObj.args});
		}
		else
		{
			dispatchEvent({type:'fault', target:this, fault:eventObj.fault, methodName:eventObj.methodName, args:eventObj.args});
		}
	}
	
	/**
	 * Count the pending calls
	 */
	function handleCall(eventObj:Object)
	{
		pendingCalls += 1;
	}
	
	/**
	 * Remove a pending call and if there are none, remind everyone that we are not busy anymore
	 */
	private function removePendingCall()
	{
		pendingCalls -= 1;
		if(pendingCalls == 0 && hasBeenBusy)
		{
			hasBeenBusy = false;
			dispatchEvent({type:'clear', target:this});
		}
	}
}