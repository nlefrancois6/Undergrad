//Name: Noah LeFrancois
//ID: 260706235
import java.time.format.DateTimeFormatter;  
import java.time.LocalDateTime;

public class CountdownDays {
	public static void main(String[] args) {
		displayCountdown(args[0]);
	}
	//Take string of date and range of characters desired, return substring
	public static String getSubstring(String in, int i, int j) {
		//Initialize output string
		String out = "";
		//Verify proper input and throw exception if improper
		if (j<i) {
			throw new IllegalArgumentException("The second number you input must be larger than the first");
		}
		while(i <= j) {
			//Append desired characters to output
			out += in.charAt(i);
			i++;
		}
		return out;
    }
	//Take string of date and return day value as int 0<=intday<=31
	public static int getDay(String date) {
		String strday = getSubstring(date, 0, 1);
		int intday = Integer.parseInt(strday);
		return intday;
	}
	//Take string of date and return month value as int 0<=intmonth<=12
	public static int getMonth(String date) {
		String strmonth = getSubstring(date, 3, 4);
		int intmonth = Integer.parseInt(strmonth);
		return intmonth;
	}
	//Take string of date and return year value as int
	public static int getYear(String date) {
		String stryear = getSubstring(date, 6, 9);
		int intyear = Integer.parseInt(stryear);
		return intyear;
	}
	//Determine if input year is a leap year, return true if leap year
	public static boolean isLeapYear(int year) {
		if(year%100 == 0) {
			if(year%400 == 0) {
				return true;
			}
			else {
				return false;
			}
		}
		else {
			if(year%4 == 0) {
				return true;
			}
			else {
				return false;
			}
		}
	}
	//Determine how many days are in the inputed month given the inputed year
	public static int getDaysInAMonth(int month, int year) {
		//Use switch to split cases into months w 31, 30 days and february; 
		//treat february for leap and non leap years
		switch(month) {
		case 1: case 3: case 5: case 7: case 8: case 10: case 12:
			return 31;
		case 4: case 6: case 9: case 11:
			return 30;
		case 2:
			if(isLeapYear(year) == true) {
			return 29;
			}
			else {
				return 28;
			}
		//Throw exception if a valid month isn't inputed
		default:
			throw new IllegalArgumentException("You must input a month between 1 and 12");
		}
	}
	//Check if due date is today or earlier and return true if so
	public static boolean dueDateHasPassed(String today, String dueDate) {
		if(getYear(today) == getYear(dueDate)) {
			if(getMonth(today) == getMonth(dueDate)) {
				if(getDay(today) < getDay(dueDate)) {
					return false;
				}
				else {
					return true;
				}
			}
			else if(getMonth(today) < getMonth(dueDate)){
				return false;
			}
			else {
				return true;
			}
		}
		else if(getYear(today) < getYear(dueDate)){
			return false;
		}
		else {
			return true;
		}
	}
	// the method returns a String representing the current date in the following format: dd/mm/yyyy
    // you can use it, but do NOT modify it!
    public static String getCurrentDate() {
        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy");  
        LocalDateTime now = LocalDateTime.now();  
        return dtf.format(now);
    }
    //Return the number of days before due date 
	public static int countDaysLeft(String today, String dueDate) {
		//Return 0 if the due date has passed
		if(dueDateHasPassed(today, dueDate) == true) {
			return 0;
		}
		//Initialize today's date and due date as ints, initialize count to return
		int year = getYear(today);
		int month = getMonth(today);
		int day = getDay(today);
		int dueYear = getYear(dueDate);
		int dueMonth = getMonth(dueDate);
		int dueDay = getDay(dueDate);
		int count = 0;
		//Increment from current month to due month if later than current month
		if(month < dueMonth) {
			//Remove number of days already elapsed this month
			count += (getDaysInAMonth(month,year)- day);
		}
		//Increment from current year to due year if later than current year
		while(year < dueYear) {
			while(month < 12) {
				count += getDaysInAMonth(month, year);
				month ++;
			}
			if(month == 12) {
				count += getDaysInAMonth(month, year);
				//Reset months at the end of every year
				month = 1;
			}
			year ++;
		}
		//If we have reached the due year, increment to the due month, 
		//then increment the days from the day to the due day
		if(year == dueYear) {
			while(month < dueMonth) {
				count+= getDaysInAMonth(month, year);
				month ++;
			}
			if(month == dueMonth) {
				count += dueDay- day;
			}
		}
		return count;
	}
	//Print the countdown using countDaysLeft, along with an 
	//encouraging message unless the due date has passed, in which 
	//case display a consolation message
	public static void displayCountdown(String dueDate){
		String today = getCurrentDate();
		System.out.println("Today is: " + today);
		System.out.println("Due date: " + dueDate);
		int countdown = countDaysLeft(today, dueDate);
		if (countdown > 0) {
			if(countdown == 1) {
				System.out.println("You have " + countdown + " day left. You can do it!");	
			}
			else {
				System.out.println("You have " + countdown + " days left. You can do it!");
			}
		}
		else {
			System.out.println("The due date has passed! :( Better luck next time!");
		}
	}
}