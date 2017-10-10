
package com.balt.core.metrics
{
	import com.balt.net.GetURLQueue;

	public class Javascript
	{
			
		/**	@method execute
			@description
				This function is a replacement for executing javascript functions in flash by hand.<br>
				It's usefulness is three fold.<p>
				First, it takes care of formatting the javascript call properly<p>
				Second, it escapes out any extra quotes that might unknowingly be in a parameter 
					so the javascript doesn't accidentally break<p>
				Third, if it should become necessary in the future to queue up javascript calls, 
					this class can be enhanced to do it without having to redo all of the files in a site<br>
					
			@param PARAM
			@usage <code>Javascript.execute("alert", [ "How are you" ]);</code><br>
				<code>Javascript.execute("myFunction", [ "param1","param2","param3" ]);</code>
			@return void
		*/
		static public function execute(functionName:String, parameters_array:Array):void {
			var javascriptCall:String = formatParameters(functionName,parameters_array);
			GetURLQueue.getInstance().sendRequest(javascriptCall,"_self");
		}	
			
			
		/**
		 * Executes a sequence of javascript calls. All the calls are made on the same
		 * request.
		 * 
		 * @param functionArray an array of function objects.
		 * 
		 * @usage 	<code>var funcArr : Array = new Array;</code><br/>
		 *			<code>funcArr.push({name:"_hbSet", parameters: ["rf",referer]});</code><br/>
		 *			<code>funcArr.push({name:HBX_CAMPAIGN, parameters: [campaign,pageName, vcon]});</code><br/>
		 *			<code>Javascript.executeAll(funcArr);</code>
		 */
		static public function executeAll(functionArray:Array) : void {
			var javascriptCall : String = "";
			for (var i:int=0; i<functionArray.length; i++) {
				javascriptCall = formatParameters(functionArray[i].name,functionArray[i].parameters);
				GetURLQueue.getInstance().sendRequest(javascriptCall,"_self");
			}
		}
		
		static public function formatParameters(functionName:String, parameters_array:Array):String{
			var javascriptCall:String = "javascript:"+functionName+"(";
			var len:int = parameters_array.length;
			
			for(var i:int=0;i<len;i++) {
				javascriptCall += "'"+escape(String(parameters_array[i]))+"'";
				
				if (i < parameters_array.length-1) {
					javascriptCall += ",";
				}	
			}
				
			javascriptCall += ");";	
			
			return javascriptCall;
		}	
	}
}