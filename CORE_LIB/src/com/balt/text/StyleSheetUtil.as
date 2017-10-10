package com.balt.text {
	import com.adobe.utils.StringUtil;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.StyleSheet;
	import flash.text.TextFormat;	
	 
	/**
	 * @version 1.1 add getTextStyle to return cascaded style sheet.
	 */
	public class StyleSheetUtil extends EventDispatcher {

		public static const LOADED:String = "cssLoaded";
		public static const ERROR:String = "cssError";		

		private var cssLoader : URLLoader;
		
		private var _css:Object;
		private var _common:Object;
		private var _custom:Object;
		private var _styles : StyleSheet;
		private var _class_map : Object =	{fontFamily:"font",fontSize:"size",textSize:"size",textColor:"color"};
		private var isRoot:RegExp = /^body$/i;
		
		/**
		 * get full selector including curly brace
		 * example - p, span {
		 * example - a:link{
		 * example - #body { 
		 * example - .primarybutton { 
		 */
		private var selectorExp:RegExp = /(.+[{])/g;
			
		/**
		 * get just name portion of selector
		 * example - p
		 * example - span (in following with the selector example p, span { 2 objects are created containing the same values)
		 * example - a:link  
		 * example - body
		 * example - primarybutton
		 *  
		 */
		//var classNameExp:RegExp = /[\.|\#][a-zA-Z\d\s]+[{]/g;
		//var classNameExp:RegExp = /.[a-zA-Z\d\s]+[{]/g;
		//private var classNameExp:RegExp = /([\.]{0,1}[a-zA-Z\d\s:#\-\!\_]{1,}[^\s])/g;
		private var classNameExp:RegExp = /^[\.]{0,1}[a-zA-Z\d\s:#\-\!\_\.]+/g;
		private var commonExp:RegExp = /(^[a-zA-Z\d\s]+[:|,][a-zA-Z\d\s]+)/g;
		
		/**
		 * get the properties of css class
		 * example - text-offset-left: 4;
		 * note: styles with dashes will be converted to camelCase 
		 */
		private var propExp:RegExp = /([a-zA-Z\-]+[:])([\d\sa-zA-Z#\.\-\,]+[;])/g;
		
		public function StyleSheetUtil(url:String = null){
			
			if(url!=null){
				load(url);
			}
		}

		/**
		 * load css file
		 */
		public function load(css_url:String):void{
			cssLoader = new URLLoader();
			var cssRequest : URLRequest = new URLRequest(css_url);
			cssLoader.addEventListener(Event.COMPLETE, cssHandler);
			cssLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			cssLoader.load(cssRequest);
		}
		
		private function ioErrorHandler(io:IOErrorEvent):void{
			//clean up
			cssLoader.removeEventListener(Event.COMPLETE, cssHandler);
			cssLoader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			cssLoader = null;
			dispatchEvent(new Event(StyleSheetUtil.ERROR));
		}
		
		private function cssHandler(e : Event) : void {
			_styles = new StyleSheet();
			_styles = rewriteCSS(cssLoader.data.toString());
			
			_css = parseCSS(cssLoader.data);
			//clean up
			cssLoader.removeEventListener(Event.COMPLETE, cssHandler);
			cssLoader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			cssLoader = null;
			dispatchEvent(new Event(StyleSheetUtil.LOADED));
		}
		public function parseCSS(css:String):Object{
			var classes:Array = getClasses(css,classNameExp);
			_common = getCSSObjects(getClasses(css, /^[a-z\d\s:,]+/gim));
			_custom = getCSSObjects(getClasses(css, /^[#|.][a-zA-Z\d\s]+/gim));
			return getCSSObjects(classes);
		}
		public function rewriteCSS(css:String):StyleSheet {
			var classes:Array = getClasses(css,classNameExp);
			var ss:StyleSheet = new StyleSheet();
			var objs:Object = new Object();
			var delim_classes:Array;
			var master:String;
			var sub:String;
			for(var i:uint = 0; i<classes.length; i++) {
				var preExp:RegExp = /(^[#]|[\s])/gim;
				classes[i].className = StringUtil.trim(String(classes[i].className)).replace(preExp,".");
				classes[i].className = StringUtil.trim(String(classes[i].className)).replace("..",".");
				delim_classes = camelcase(String(classes[i].className)).split(",");
				for(var j:uint = 0; j<delim_classes.length; j++){
					delim_classes[j] = StringUtil.trim(delim_classes[j]);
					objs[delim_classes[j]] = parseClass(classes[i]);
					ss.setStyle(delim_classes[j], objs[delim_classes[j]]);
				}
			}
			return ss;
		}
		/**
		 * return full css object representing the stylesheet
		 */
		public function get css():Object{
			return _css;
		}
		/**
		 * This will return a css style object by name
		 * If you are searching for a custom class it will also look to see if it should inherit any properties from common properties like h1,h2,p,etc...
		 * @param name class you wish to find
		 */
		public function getStyle(name:String):Object{
			var css_class:Object;
			var check_common : Boolean = false;
			if(_custom[name]){
				css_class = _custom[name];
				check_common = true;
			}else if(_common[name]){
				css_class = _common[name];
				check_common = false;
			}else{
				css_class = null;
			}
			if(check_common){
				for(var i:String in css_class){
					if(i!=null){
						if(_common[i]){
							css_class[i] = mergeClass(css_class[i],_common[i]);
						}
					}
				}
			}
			return css_class;
		}
		
		private function mergeClass(c1:Object,c2:Object):Object{
			for(var j:String in c2){
				c1[j] = c2[j];
			}
			return c1;
		}
		
		private function getCSSObjects(classes:Array):Object{
			var objs:Object = new Object();
			var delim_classes:Array;
			var subExp:RegExp = /([\s])/g;
			var master:String;
			var sub:String;
			for(var i:uint = 0; i<classes.length; i++) {
				var preExp:RegExp = /^[#|.]/gim;
				classes[i].className = StringUtil.trim(String(classes[i].className)).replace(preExp,"");
				delim_classes = camelcase(String(classes[i].className)).split(",");
				for(var j:uint = 0; j<delim_classes.length; j++){
					delim_classes[j] = StringUtil.trim(delim_classes[j]);
					if(delim_classes[j].match(subExp)[0]!=undefined){
						var sub_index:int = (delim_classes[j].indexOf(delim_classes[j].match(subExp)[0]));
						master = delim_classes[j].substr(0,sub_index);
						sub = delim_classes[j].substr(sub_index+1,delim_classes[j].length);
						if(!objs[master]){
							objs[master] = new Object();
						}
						objs[master][sub] = parseClass(classes[i]);
					}else{
						objs[delim_classes[j]] = parseClass(classes[i]);
					}
				}
			}
			return objs;
		}
		
		private function parseClass(css:Object):Object{
			var temp:Array = (css.classValue.match(propExp));
			var props:Object = new Object();
			for(var i:Number = 0; i<temp.length; i++){
				var style:String = temp[i].split(":")[0];
				var value:String = temp[i].split(":")[1];
				value = value.split(";")[0];
				value = StringUtil.trim(value);
				props[camelcase(style)] = value;
			}
			return props;
		}
		
		private function camelcase(stylename:String):String{
			var temp:Array = stylename.split("-");
			for (var i:int = 1; i < temp.length; i++ ){
				temp[i] = (temp[i].substr(0,1).toUpperCase()) + (temp[i].substr(1));
			}
			return temp.join("");
		}
		
		private function getClasses(str:String,useExp:RegExp):Array{
			var classes:Array = new Array();
			var match:Object = selectorExp.exec(str);
			var spot:Number;
			var cssClass:String;
			while (match!=null){
				spot = str.indexOf(match[1]);
				cssClass = str.substring(spot,str.indexOf("}",str.indexOf(match[1]))+1);
				spot = str.indexOf("}",str.indexOf(match[1]))+1;
				if(match[1].match(useExp)[0]){
					classes.push({className:match[1].match(useExp), classValue:cssClass});
				}
				match = selectorExp.exec(str);
			}
			return classes;
		}
		
		/**
		 *  suport to cascade.
		 *  @description rewrite css to inherite there parent tag, all tag will inherited root tag, which is "body" in this class.
		 *  example - p.menu will get inherite p tag style sheet.
		 *  example - .menu.title will get interite .menu tag but will change name
		 * 			  of style sheet as .menu.title since as3 css doesn't support white space.
		 */ 
		public function getTextStyle():StyleSheet {
			var name_array: Array = _styles.styleNames;
			var len: Number = name_array.length;
			var item: Object;
				
			for( var i: int = 0; i < len; i++ )
			{
				item = _styles.getStyle( name_array[ i ] );
				 _styles.setStyle(name_array[i], cascadeStylesheet( _styles, name_array[ i ]));
			}
			return _styles;
		}
		
		private function cascadeStylesheet(p_ss:StyleSheet, p_tag:String):Object {
			var ss:StyleSheet = p_ss;
			var obj:Object = ss.getStyle(p_tag);
			var parentsObj:Object = new Object();
			
			if(isRoot.test(p_tag)) {
				return obj;
			}else {
				var regex:RegExp = /[\.]{0,1}[a-zA-Z\d\-\_]+/g;
				var arr:Array = p_tag.match(regex);
				//var arr:Array = p_tag.split(notfirstDotRegex);
				var parentsTag:String="";
				if(arr.length > 1) {
					for (var j:int=0; j<arr.length-1; j++) {
						if(j != 0 && String(arr[j]).charAt() != ".") parentsTag += ".";
						parentsTag += arr[j];
					}
				}else {
					parentsTag = "body";
				}
				parentsObj = cascadeStylesheet(ss, parentsTag);
				
				for(var parentsProp:String in parentsObj) {
					if(!isPropThereInThisTag(parentsProp)){
						obj[parentsProp] = parentsObj[parentsProp];
					}
				}
			}
			
			function isPropThereInThisTag(p_prop:String):Boolean {
				for(var prop:String in obj) {
					if(prop == p_prop) {
						return true
					}
				}
				return false;
			}
			
			return obj; 
		}
	}
}
