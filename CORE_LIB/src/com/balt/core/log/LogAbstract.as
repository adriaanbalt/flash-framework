package com.balt.core.log
{
	import flash.events.Event;	
	import flash.events.EventDispatcher;
	
	

	public class LogAbstract extends EventDispatcher implements ILog
	{
		public var LEVEL_NONE:String;
		public var LEVEL_ERROR:String;
		public var LEVEL_WARN:String;
		public var LEVEL_INFO:String;
		public var LEVEL_DEBUG:String;
		public var LEVEL_ALL:String;
		
		public function LogAbstract():void{ }
		
		public function set level( value:String ):void{ }
		
		public function debug( str:String ):void{ }
		
		public function info( str:String ):void{ }
		
		public function warn( str:String ):void{ }
		
		public function error( str:String ):void{ }
	}
}