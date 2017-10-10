package com.balt.core.asset.css
{
	import flash.events.IEventDispatcher;
	import flash.net.URLRequest;
	import flash.text.StyleSheet;
	import flash.text.TextFormat;
	
	public interface IStylesManager extends IEventDispatcher
	{
		function getTextFormat(style:String):TextFormat;
		function getStylesheet():StyleSheet;
		function load(urlRequest:URLRequest):void;
	}
}