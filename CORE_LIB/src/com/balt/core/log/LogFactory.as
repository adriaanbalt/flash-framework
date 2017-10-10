package com.balt.core.log
{
	import flash.events.EventDispatcher;
	import flash.utils.getDefinitionByName;
	
	public class LogFactory extends EventDispatcher
	{
		static public function getLogger( logger:* ):LogAbstract
		{
			var newLogger:LogAbstract;
			
			if( logger is LogAbstract) return logger;
			if( logger is Class )
			{
				try
				{
					newLogger = new logger();
				}
				catch( err:Error )
				{
					Log.error( "Invalid logger class " + logger + ". Default logger will be used." );
					return null;
				}
			}
			else
			{
				try
				{
					var loggerClass:Class = getDefinitionByName( logger as String ) as Class;
					newLogger = new loggerClass();
				}
				catch( err:Error )
				{
					Log.error( "Invalid logger class name '" + logger + "'. Default logger will be used." );
					return null;
				}
			}

			return newLogger;
		}
	}
}