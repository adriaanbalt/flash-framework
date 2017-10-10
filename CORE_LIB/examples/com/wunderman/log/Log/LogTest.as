package {
	// Example of how to use the Log class.
	import flash.display.Sprite;
	import com.balt.log.Log;
			
	public class LogTest extends Sprite
	{
		public function LogTest()
		{
			// This assumes there is a valid reference to the stage (LogTest much be on display list)
			Log.init(stage);
			Log.traceMsg ("Sample info", Log.INFO);
			Log.traceMsg ("Sample alert", Log.ALERT);
			Log.traceMsg ("Sample message", Log.ERROR);
			Log.traceThreshold = Log.WARN;
			Log.traceMsg ("Default priority is below the specified threshold, so this message won't appear in the output");
			Log.traceMsg ("This info messaage won't appear in the output because it is below the threshold", Log.INFO);
			Log.traceMsg ("This warning message will appear in the output because it meets the threshold", Log.WARN);
		}
	}
}
