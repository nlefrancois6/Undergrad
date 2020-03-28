import java.util.Random;

public class Sheep {
	//Initialize variables
	private String name;
	private int age;
	private boolean hasWool;
	//Create a Random number generator for use in shear()
	private static Random numberGenerator = new Random(123);
	
	
	public static void main(String[] args) {
		
	}

	//Take name and age inputs to initialize a Sheep object
	public Sheep(String sheepName, int sheepAge) {
		name = sheepName;
		age = sheepAge;
		//Initialize Sheep with wool so it can be sheared
		hasWool = true;
	}
	
	//Take no inputs and return the Sheep's name
	public String getName() {
		return name;
	}
	
	
	//Take no inputs and return the Sheep's age
	public int getAge() {
		return age;
	}
	
	//Take no inputs and return the amount of wool sheared from a Sheep (in pounds) if it has wool
	
	public double shear() {
		//Initialize wool variable
		double wool = 0.0;
		//If the sheep has wool
		if(hasWool==true) {
			//Generate random amount of wool between 6.0 and 10.0 pounds
			wool = (4.0*numberGenerator.nextDouble())+6.0;
			//Change hasWool so that the Sheep no longer has wool
			hasWool = false;
		}
		
		return wool;
	}
}
