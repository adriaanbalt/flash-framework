package com.balt.util
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;	

	/**
	 * @author Mathieu
	 */
	public class Waiter 
	{
		private var _timer : Timer ;
		private var _func : Function;

		public function Waiter(time : Number, func : Function)
		{
			_func = func;
			_timer = new Timer(time, 1);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			_timer.start();
		}

		private function onTimer(e : TimerEvent) : void
		{
			//trace(_func);
			_func.call();
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER, onTimer);
		}
		
		public function stop() : void
		{
			_timer.removeEventListener(TimerEvent.TIMER, onTimer);
			_timer.stop();
		}
		
		
	}
}
