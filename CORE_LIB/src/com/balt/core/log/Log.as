package com.balt.core.log
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	

	public class Log extends EventDispatcher
	{
		public static const LEVEL_NONE:String = "none";
		public static const LEVEL_ERROR:String = "error";
		public static const LEVEL_WARN:String = "warn";
		public static const LEVEL_INFO:String = "info";
		public static const LEVEL_DEBUG:String = "debug";
		public static const LEVEL_ALL:String = "all";		
		
		private static var _logger:LogAbstract;
		
		static public function set logger( logger:* ):void
		{
			_logger = LogFactory.getLogger( logger );
			
			_logger.LEVEL_NONE = LEVEL_NONE;
			_logger.LEVEL_ERROR = LEVEL_ERROR;
			_logger.LEVEL_WARN = LEVEL_WARN;
			_logger.LEVEL_INFO = LEVEL_INFO;
			_logger.LEVEL_DEBUG = LEVEL_DEBUG;
			_logger.LEVEL_ALL = LEVEL_ALL;															
		}
		
		static public function get logger():LogAbstract
		{
			if( !_logger ) trace( "<<< NO LOGGER SET >>>" );
			return _logger;
		}			

		static public function set level( value:String ):void
		{
			if( !_logger ) trace( "<<< NO LOGGER LEVELS AVAILABLE >>>" );
			else _logger.level = value;
		}
		
		static public function debug( ...traces ):void
		{
			if( !_logger ) trace( "*** DEBUG:", traces.join( " " ) );
			else _logger.debug( traces.join( " " ) );
		}
		
		static public function info( ...traces ):void
		{
			if( !_logger ) trace( "*** INFO:", traces.join( " " ) );
			else _logger.info( traces.join( " " ) );						
		}
		
		static public function warn( ...traces ):void
		{
			if( !_logger ) trace( "*** WARN:", traces.join( " " ) );
			else _logger.warn( traces.join( " " ) );							
		}
		
		static public function error( ...traces ):void
		{
			if( !_logger ) trace( "*** ERROR:", traces.join( " " ) );
			else _logger.error( traces.join( " " ) );							
		}	
	}
}