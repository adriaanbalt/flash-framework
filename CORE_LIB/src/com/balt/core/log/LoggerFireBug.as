package com.balt.core.log
{
	import com.balt.log.FireBugLogger;
	
	import flash.events.Event;
	
	public class LoggerFireBug extends LogAbstract implements ILog
	{
		public function LoggerFireBug()
		{
			super();
		}
		
		override public function set level(value:String):void
		{
			switch( value )
			{
				case LEVEL_NONE:
					FireBugLogger.setDebugLevel( FireBugLogger.DEBUG_LEVEL_NONE );
					FireBugLogger.enabled = false;
					break;
				case LEVEL_ERROR:
					FireBugLogger.setDebugLevel( FireBugLogger.DEBUG_LEVEL_LOW );
					FireBugLogger.enabled = true;
					break;
				case LEVEL_WARN:
					FireBugLogger.setDebugLevel( FireBugLogger.DEBUG_LEVEL_MEDIUM );
					FireBugLogger.enabled = true;
					break;
				case LEVEL_INFO:
					FireBugLogger.setDebugLevel( FireBugLogger.DEBUG_LEVEL_HIGH );
					FireBugLogger.enabled = true;
					break;
				case LEVEL_DEBUG:
					FireBugLogger.setDebugLevel( "" );
					FireBugLogger.enabled = true;
					break;
				case LEVEL_ALL:
					FireBugLogger.setDebugLevel( FireBugLogger.DEBUG_LEVEL_ALL );
					FireBugLogger.enabled = true;
					break;					
			}
		}
		
		override public function debug( str:String ):void
		{
			FireBugLogger.debug( str );
		}
		
		override public function info( str:String ):void
		{
			FireBugLogger.info( str );			
		}
		
		override public function warn( str:String ):void
		{
			FireBugLogger.warn( str );			
		}
		
		override public function error( str:String ):void
		{
			FireBugLogger.error( str );			
		}
	}
}