package com.balt.util
{
	import flash.external.ExternalInterface;
	
	import mx.logging.ILogger;
	
	/**
	 * Class: FireBugLogger
	 * 
	 * This static class is use to pass debugging calls to the javascript console which includes FireBugLogger and the Safari Error Console.
	 * 				It may also be used in conjunction with flashTracer since it not only outputs a console call but also a trace call to the debug flash player.
	 * 
	 * 				Example:
	 * 				<code>
	 * 					FireBugLogger.enabled = true;
	 * 					FireBugLogger.setDebugLevel(FireBugLogger.DEBUG_LEVEL_ALL);
	 * 					FireBugLogger.error('ERROR HAS BEEN CALLED');
	 * 					FireBugLogger.log('LOG HAS BEEN CALLED');
	 * 				</code>
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author	Thaylin D. Burns
	 */
	public final class FireBugLogger extends Logger
	{
		public static var DEBUG_LEVEL_NONE:String = "none";
		public static var DEBUG_LEVEL_LOW:String = "low";
		public static var DEBUG_LEVEL_MEDIUM:String = "medium";
		public static var DEBUG_LEVEL_HIGH:String = "high";
		public static var DEBUG_LEVEL_ALL:String = "all";
		private static var _enabled:Boolean = false;
		private static var _debugLevel:Number = 5;
		
		
		private static var debugLevelArray:Array = [DEBUG_LEVEL_NONE, DEBUG_LEVEL_LOW, DEBUG_LEVEL_MEDIUM, DEBUG_LEVEL_HIGH,'', DEBUG_LEVEL_ALL]
		
		private static var debugFuncList:Array = ['', 'error', 'warn', 'info', 'debug', 'log']
		/**
		 * Sets enabled property for FireBugLogger 
		 * @param t
		 * 
		 */		
		public static function set enabled(t:Boolean):void{ _enabled = t; }
		
		public static function get enabled():Boolean{ return _enabled }
		/**
		 * Sets the debug level for the logger. See functions for examples of uses.
		 * 
		 * @default FireBugLogger.DEBUG_LEVEL_ALL 
		 * @param value
		 * 
		 */		
		public static function setDebugLevel(value:String):void
		{
			_debugLevel = debugLevelArray.indexOf(value)
			
		}
		/**
		 * Call log method to console. This method will only be called if debugLevel is set to DEBUG_LEVEL_ALL.
		 * @param s	Message to pass to console.
		 * 
		 */		
		public static function log(s:String):void  	{	if(enabled)call('log', s);  	}
		/**
		 * Call debug method to console. This method will only be called if debugLevel is set to DEBUG_LEVEL_ALL
		 * @param s	Message to pass to console.
		 * 
		 */	
		public static function debug(s:String):void	{	if(enabled)call('debug', s);	}
		/**
		 * Call info method to console. This method will only be called if debugLevel is set to DEBUG_LEVEL_HIGH or DEBUG_LEVEL_ALL
		 * @param s	Message to pass to console.
		 * 
		 */	
		public static function info(s:String):void 	{	if(enabled)call('info', s); 	}
		/**
		 * Call warn method to console. This method will only be called if debugLevel is set to DEBUG_LEVEL_MEDIUM, DEBUG_LEVEL_HIGH, or DEBUG_LEVEL_ALL
		 * @param s	Message to pass to console.
		 * 
		 */	
		public static function warn(s:String):void	{	if(enabled)call('warn', s); 	}
		/**
		 * Call error method to console This method will be called in all levels of debugLevel except DEBUG_LEVEL_NONE
		 * @param s	Message to pass to console.
		 * 
		 */	
		public static function error(s:String):void	{	call('error', s);	}
		/**
		 * Use this method to pass any special javascript methods you'd like to pass including the params to pass to it
		 * @param func
		 * @param param
		 * 
		 */		
		public static function specialFunc(func:String, param:String):void
		{
			if(enabled)ExternalInterface.call(func , param)
		}
		
		public function FireBugLogger(enforcer:SingletonEnforcer)
		{
			if(enforcer==null)throw new Error('ERROR IN '+this+' :: THIS CLASS IS A STATIC CLASS AND SHOULD NOT BE INSTANTIATED');
		}
		
		public function toString():String
		{
			return "[object FireBugLogger]";
		}
		
		private static function isLevelSet(value:String):Boolean
		{
			return (_debugLevel >= debugFuncList.indexOf(value))
		}
		
		private static function call(func:String, param:String):void{
			//Lets check if our debug level permission is set to this function. If so call our external interface and trace
			if(isLevelSet(func))
			{
				trace(func+' :: '+param);
				ExternalInterface.call("console."+func , 'FLASH DEV :: '+param);
			} 
		}
	}
}
class SingletonEnforcer{}
