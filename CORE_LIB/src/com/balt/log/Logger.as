package com.balt.log
{
	import flash.utils.getQualifiedClassName;
	
	public class Logger
	{
		public static function log ( str:String, obj:* = null ):void {
			var className:String = getQualifiedClassName(obj).split( "::" )[1];
			
			if ( obj != null ) { 
				trace ( "[" + className + "]" + " : " + str );
			} else {
				trace ( str );
			}
		}

	}
}