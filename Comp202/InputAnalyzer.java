//Fill in your name and student number
//Name: Noah LeFrancois
//Student Number: 260706235

public class InputAnalyzer {
    public static void main(String args[]) {
        if(args.length < 3) {
            System.out.println("You need to enter three arguments to this program. Try typing 'run InputAnalyzer 2.5 8 9' in Dr. Java, or 'java InputAnalyzer 2.5 8 9' on the command line.");
            return;
        } 
        double a = getInputDouble(args[0]);
        double b = getInputDouble(args[1]);
        double c = getInputDouble(args[2]);
        
        //========================
        //Enter your code below
        //1: Whether or not a,b,c are all non-negative numbers
        boolean isNonNeg;
        //Will return True if a AND b AND c are >=0, else will return False
        isNonNeg = a>=0 && b>=0 && c>=0;
        //Print the result
        System.out.println("The numbers " + a +", " + b + ", and " + c + " are all non-negative: " + isNonNeg);
        
        //2:Whether or not at least one between a,b,c is an odd number
        boolean oneIsOdd;
        //Will return True if the absolute value of a OR b OR c has a remainder of 1 when divided by 2, else will return False
        oneIsOdd = Math.abs(a)%2 == 1 || Math.abs(b)%2 == 1 || Math.abs(c)%2 == 1;
        //Print the result
        System.out.println("At least one between " + a +", " + b + ", and " + c + " is odd: " + oneIsOdd);
        
        //3:Whether or not the values were entered in strictly decreasing order
        boolean decrease;
        //Will return true if a>b>c, else will return False
        decrease = b<a && c<b ;
        //Print the result
        System.out.println("The numbers " + a +", " + b + ", and " + c + " are in strictly decreasing order: " + decrease);
        
        //4: Whether or not a,b,c are all non-negative numbers or are in strictly decreasing order
        boolean nonNegORDec;
        //Will return True if either input is True, returns False if neither is True
        nonNegORDec = isNonNeg || decrease;
        //Print the result
        System.out.println("The numbers " + a +", " + b + ", and " + c + " are either all non-negative or in a strictly decreasing order: " + nonNegORDec);
        
        //5: Whether or not a,b,c are all non-negative and none of them is odd
        boolean nonNegANDnotOdd;
        //Will return true if isNonNeg is True AND oneIsOdd is False, else returns False
        nonNegANDnotOdd = isNonNeg && !oneIsOdd;
        //Print the result
        System.out.println("The numbers " + a +", " + b + ", and " + c + " are all non-negative numbers and none of them is odd: " + nonNegANDnotOdd);
        
        //Enter your code above
        //========================
    }
    
    public static double getInputDouble(String arg)
    {
        try
        {
            return Double.parseDouble(arg);
        } catch(NumberFormatException e) {
            System.out.println("ERROR: " + e.getMessage() + " This argument must be a number!");
        }
        
        //error, return 0
        return 0;
    }
}