import mx.utils.Delegate;

import cinqetdemi.delay.OnEnterFrameBeacon;

/**
 * Implements a 'delayed for' action, that is, takes
 * a method and executes it with two arguments, index and num steps
 * and then calls the 'complete' function
 * @author Patrick Mineault - 5etdemi.com
 */
class cinqetdemi.delay.DelayedFor
{
	//The scope in which callbacks will be called
	private var scope : Object;
	//The function to call
	private var func : Function;
	//The number of steps in this for
	private var steps : Number;
	//A hook to catch onEnterFrames
	private var onTick : Function;
	//The current step in the delayed for
	private var step:Number = 0;

	private var satchel : Object;

	private var endFunc : Function;

	/**
	 * Create a delayed for
	 * @param the scope in which the callbacks will be called
	 * @param steps How many steps in the for
	 * @param func The function to call
	 * @param satchel An object of arguments to carry along
	 */
	function DelayedFor(scope:Object, steps:Number, func:Function, endFunc:Function)
	{
		this.scope = scope;
		this.func = func;
		this.endFunc = endFunc;
		this.steps = steps;
	}
	
	/**
	 * Start the provess
	 */
	public function start():Void
	{
		OnEnterFrameBeacon.getInstance().addListener(this);
		onTick = Delegate.create(this, advanceFor);
		advanceFor();
	}
	
	/**
	 * Advance our 'delayed for'
	 */
	private function advanceFor():Void
	{
		//Call the function with first argument current step, second argument
		//total number of steps
		func.apply(scope, new Array(step, steps));
		//Advance step
		step++;
		if(step >= steps)
		{
			//Clean up
			OnEnterFrameBeacon.getInstance().removeListener(this);
			//Call complete function
			endFunc.apply(scope, null);
		}
	}
	
	function cancel()
	{
		OnEnterFrameBeacon.getInstance().removeListener(this);
		step = steps;
	}
	
	/**
	 * Gets the done percentage
	 */
	public function getPercentage():Number
	{
		return Math.floor(step/steps*100);
	}
}