package com.balt.core.log
{
	import flash.events.IEventDispatcher;
	
	
	
	public interface ILog extends IEventDispatcher
	{
		function set level( value:String ):void
		
		function debug( str:String ):void
		
		function info( str:String ):void
		
		function warn( str:String ):void
		
		function error( str:String ):void
	}
}	