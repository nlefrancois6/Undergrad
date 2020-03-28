//Fill in your name and student number
//Name: Noah LeFrancois
//Student Number: 260706235

public class CoinMachine {

	public static void main(String[] args) {
		if(args.length < 2) {
            System.out.println("You need to enter two arguments to this program. Try typing 'run CoinMachine 400 215' in Dr. Java, or 'java VendingMachine 400 215' on the command line.");
            return;
        } 
        int cash = getInputInteger(args[0]);
        int price = getInputInteger(args[1]);
        
        //========================
        //Enter your code below
        //Display Amount Received and Cost
        System.out.println("Amount Received: " + cash);
        System.out.println("Cost of the Item: " + price);
        //Calculate Change required and display the value
        int change = cash - price;
        System.out.println("Required Change: " + change);
        //Determine number of each coin needed, starting with the largest coin
        int toonies = change/200;
        int loonies = (change-(200*toonies))/100;
        int quarters = (change -(200*toonies)-(100*loonies))/25;
        int dimes = (change -(200*toonies)-(100*loonies)-(25*quarters))/10;
        int nickels = (change -(200*toonies)-(100*loonies)-(25*quarters)-(10*dimes))/5;
        //Print the coins to be returned as change
        System.out.println("Change:");
        System.out.println("Toonies x " + toonies);
        System.out.println("Loonies x " + loonies);
        System.out.println("Quarters x " + quarters);
        System.out.println("Dimes x " + dimes);
        System.out.println("Nickels x " + nickels);
        
        //Enter your code above
        //========================

	}
	 public static int getInputInteger(String arg) {
	        try
	        {
	            return Integer.parseInt(arg);
	        } catch(NumberFormatException e) {
	            System.out.println("ERROR: " + e.getMessage() + " This argument must be an integer!");
	        }
	        
	        //error, return 0
	        return 0;
	    }
}
