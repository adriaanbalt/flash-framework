package com.balt.core.location
{
	/**
	 * Action class for storeing pending action
	 */
	public class Action
	{
		private var obj:Object;
		private var func:Function;
		private var params:Array;
		
		public function Action( obj:Object, func:Function, param:Array )
		{
			this.obj = obj;
			this.func = func;
			this.params = param;
		}
		
		public function execute ( ):void {
			func.apply( obj, params );
		} 

	}
}