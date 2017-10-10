package com.balt.core.log
{
	import com.balt.log.Log;
	
	import flash.events.Event;
	
	public class LoggerEpstein extends LogAbstract implements ILog
	{
		private namespace ns = "com.balt.log";
		
		public function LoggerEpstein()
		{
			super();
		}
		
		override public function set level(value:String):void
		{
			switch( value )
			{
				case LEVEL_NONE:
					ns::Log.traceThreshold = ns::Log.NO_LOG;
					break;
				case LEVEL_ERROR:
					ns::Log.traceThreshold = ns::Log.ERROR;
					break;
				case LEVEL_WARN:
					ns::Log.traceThreshold = ns::Log.WARN;
					break;
				case LEVEL_INFO:
					ns::Log.traceThreshold = ns::Log.INFO;
					break;
				case LEVEL_DEBUG:
					ns::Log.traceThreshold = ns::Log.DEBUG;
					break;
				case LEVEL_ALL:
					ns::Log.traceThreshold = ns::Log.VERBOSE;
					break;			
			}
		}
		
		override public function debug( str:String ):void
		{
			ns::Log.traceMsg( str, ns::Log.DEBUG );
		}
		
		override public function info( str:String ):void
		{
			ns::Log.traceMsg( str, ns::Log.INFO );			
		}
		
		override public function warn( str:String ):void
		{
			ns::Log.traceMsg( str, ns::Log.ERROR );		
		}
		
		override public function error( str:String ):void
		{
			ns::Log.traceMsg( str, ns::Log.ERROR );			
		}
	}
}