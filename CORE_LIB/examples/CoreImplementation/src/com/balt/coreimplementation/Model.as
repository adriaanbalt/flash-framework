package com.balt.coreimplementation
{
	import flash.events.EventDispatcher;
	
	public class Model extends EventDispatcher
	{
		public var compiledFromFlex:Boolean;
		
		private static var _instance:Model;
		
		public function Model( $pvt:PrivateClass )
		{
			super();
			if( _instance != null ) throw new Error( "*** Error: Model already initialised." );
			if( _instance == null ) _instance = this;
		}
		
		public static function getInstance():Model
		{
			if ( _instance == null ) _instance = new Model( new PrivateClass() );
			return _instance;
		}
	}
}

class PrivateClass
{
	public function PrivateClass(){ }
}