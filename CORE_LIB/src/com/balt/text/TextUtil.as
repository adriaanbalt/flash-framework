// A collection of text and string utilities
// @author: bruce epstein
//
package com.balt.text
{
	import flash.net.URLVariables;
	
	public class TextUtil
	{
		public  static const EMPTY_STRING:String = "";
		public  static const SPACE:String = " ";
		public  static const SINGLE_QUOTE:String = "'";
		private static const NULL_AS_STRING:String = "null";			// Passed by ExternalInterface from javascript
		private static const UNDEFINED_AS_STRING:String = "undefined";	// Passed by ExternalInterface from javascript
		private static const FALSE_AS_STRING:String = "false";
		private static const TRUE_AS_STRING:String = "true";
		
		
		public function TextUtil()
		{
		}
		
		public static function quotes (inString:String):String {
			return SINGLE_QUOTE + inString + SINGLE_QUOTE;
		}
		
		public static function stringContains (inString:String, searchFor:String):Boolean {
			if (inString.indexOf(searchFor) >= 0) {
				return true;
			} else {
				return false;
			}
		}
		
		
		// Same as nullOrEmpty
		public static function undefinedOrEmpty (inString:String):Boolean {
			return (inString == null || stringIsEmpty(inString));
		}
		
		
		// This checks for the string results of conversions "null" and "undefined"
		public static function stringIsEmpty (inString:String):Boolean {
			// The external interface passes the empty string as "null"
			return (inString == EMPTY_STRING || inString == NULL_AS_STRING || inString == UNDEFINED_AS_STRING);
		}
		
		
		// Replace occurences of "findStr" with "replaceStr"	
		public static function replace(inStr:String, findStr:String, replaceStr:String) :String {
			if (inStr == null) {
				return inStr;
			} else {
				return inStr.split(findStr).join(replaceStr);
			}
		}
		
		// Returns the last character of a string, or returns all the characters
		// following an optional character (allowes you to, say, find an extension of a file after a "." character)
		public static function lastChar(inString:String, afterChar:String = null):String {
			if (afterChar == null) {
				return inString.charAt(inString.length-1);
			} else {
				return inString.substring(inString.lastIndexOf(afterChar)+1);
			}
		}
		
		
		// Returns the first character of a string
		public static function firstChar(inString:String):String {
			return inString.charAt(0);
		}
		
		
		// Returns a string without the first character (doesn't alter original string)
		public static function stripFirstChar(inString:String):String {
			return inString.substring(1, inString.length);;
		}
		
		
		// Returns a string without the last character (doesn't alter original string)
		public static function stripLastChar(inString:String):String {
			return inString.substring(0, inString.length -1);
		}
		
		
		// Same as stripLastChar, I think....
		public static function deleteLastChar (inString:String):String {
			return deleteCharAt(inString, inString.length-1);
		}
		
		// trimSpaces, stripSpaces, removeSpaces
		// Removes all spaces in a string (including internal ones) (doesn't alter original string)
		public static function stripSpaces (inString:String):String {
			return replace(inString, SPACE, EMPTY_STRING);
		}
		
		
		// Trims both leading and trailing spaces, but not internal ones (doesn't alter original string)
		public static function trimSpaces (inString:String):String {
			return trimLeadingSpaces(trimTrailingSpaces(inString));
		}
		
		
		// Trims trailing spaces from a string, but not leading ones (doesn't alter original string)
		public static function trimTrailingSpaces (inString:String):String {
			while (lastChar(inString) == SPACE) {
				inString = stripLastChar(inString);
			}
			return inString;
		}
		
		
		// Trims leading spaces from a string, but not trailing ones (doesn't alter original string)
		public static function trimLeadingSpaces (inString:String):String {
			while (firstChar(inString) == SPACE) {
				inString = stripFirstChar(inString);
			}
			return inString;
		}
		
		
		// Deletes single character at specified index, if possible (doesn't alter original string)
		public static function deleteCharAt (inString:String, index:int):String {
			if (index < 0 || index >= inString.length) {
				return inString;
			} else {
				return inString.substring(0, index) + inString.substring(index + 1 );
			}
		}
		
	
		// Converts the first character of string to capital letter and others to lowercase. Does work on multi-word strings.
		public static function toTitleCase( str:String ):String {
			return str.substr(0,1).toUpperCase() + str.substr(1).toLowerCase();
		}
	

		// Returns true if "fullString" begins with "beginsWith"
		public static function begins (fullString:String, beginsWith:String):Boolean {
			return (fullString.indexOf(beginsWith, 0)  == 0);
		}
		
		
		// Converts a string to a Boolean type in an intelligent way (useful for parsing XML)
		public static function convertToBoolean (inString:String):Boolean {
			if (TextUtil.undefinedOrEmpty(inString)) {
				return false;
			} else if (inString.toLowerCase() == FALSE_AS_STRING) {
				return false;
			} else if (inString.toLowerCase() == TRUE_AS_STRING) {
				// Strictly speaking, this isn't necessary, as string "true" would convert to Boolean true.
				return true;
			} else if (isNaN(Number(inString))) {
				return Boolean(inString);
			} else {
				return Boolean (Number(inString));
			}
		}
		
		
		// Converts from Boolean true/false to integer (one or zero)
		public static function convertFromBoolean (inBool:Boolean):int {
			if (inBool) {
				return 1;
			} else {
				return 0;
			}
		}
		
		
		// Decodes a string of name'value pairs into an object with properties (as I recall)
		public static function decode (rawString:String):URLVariables {
			var tmpObj:URLVariables = new URLVariables(rawString);
			return tmpObj;
		}
		

	}
}