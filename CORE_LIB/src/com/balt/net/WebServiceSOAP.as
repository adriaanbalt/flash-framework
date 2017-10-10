<<<<<<< .mine
package com.balt.net {


=======
package com.balt.net
{
	import Namespace;
	import String;
	import XML;
	import trace;
>>>>>>> .r234
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;

	/**
	 * @author adriaan
	 */
	public class WebServiceSOAP extends EventDispatcher {

		public static var SERVICE_SUCCESS : String = "onSuccess";		
		public static var SERVICE_FAIL : String = "onFail";
		
		private var requestURL:String;
		public var returnXML:XML;
		
		private var urlLoader:URLLoader;
		
//		private var SOAPENV : Namespace = new Namespace("http://schemas.xmlsoap.org/soap/envelope/");
//		private var xsi : Namespace = new Namespace("http://www.w3.org/2001/XMLSchema-instance");
//		private var xsd : Namespace = new Namespace("http://www.w3.org/2001/XMLSchema");
		
		
		public function WebServiceSOAP() {}
		
//		URL http://www.bottegaveneta.com/webservices/store/storeservice.asmx
		
		public function loadService( $requestURL : String, $pid : String, $quantity : String, $size : String) : void {
			requestURL = $requestURL;

			var urlRequest:URLRequest = new URLRequest( requestURL );
			urlRequest.method=URLRequestMethod.POST;
			urlRequest.requestHeaders.push(new URLRequestHeader("Content-Type", "text/xml; charset=utf-8"));
			
			urlRequest.data = sendXML( $pid, $quantity, $size );
			urlLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.addEventListener("complete", success);
			urlLoader.addEventListener("ioerror", failure);
			urlLoader.load(urlRequest);
			
		}
		
		private function success(evt:Event) : void {
			trace("SERVICE SUCCESS");
			dispatchEvent( new Event( SERVICE_SUCCESS ));
		}
		
		private function failure(evt:Event) : void {
			trace("SERVICE FAIL");
			dispatchEvent( new Event( SERVICE_FAIL ));
		}
		
		private function sendXML( $pid : String, $quantity : String, $size : String ) : XML {
			
			var dataXML:XML =
			<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">
			<SOAP-ENV:Body>
				<AddBasketItemToBasket xmlns="http://tempuri.org/">
					<productId>{$pid}</productId>
					<quantity>{$quantity}</quantity>
					<size>{$size}</size>
				</AddBasketItemToBasket>
			</SOAP-ENV:Body>
			</SOAP-ENV:Envelope>
			;
			return dataXML;
		}
		
	}
}
		
		
//		<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">
//		<SOAP-ENV:Body>
//		<AddBasketItemToBasket xmlns="http://tempuri.org/">
//		<productId>
//		bbc6f06b-75d8-439b-8ae3-468a4f391fc3
//		</productId>
//		<quantity>
//		1
//		</quantity>
//		<size />
//		</AddBasketItemToBasket>
//		</SOAP-ENV:Body>
//		</SOAP-ENV:Envelope>
