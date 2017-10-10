package com.balt.util {

	public class DateUtil {
		
		
		public static function getDaysInMonth($month:uint, $year:int = -1):uint {
			if ($year == -1) {
				$year = new Date().fullYear;
			}
			
			if ($month == 11) {
				return new Date($year, 0, 0).date;
			}
			
			return new Date($year, $month + 1, 0).date;
		}
		
	}
	
}