
public class Farm {
	//Initialize variables
	private Sheep[] sheep;
	private Dog dog;
	private String name;
	
	public static void main(String[] args) {
	
	}

	//Take name, Dog, and array of Sheep to initialize variables
	public Farm(String farmName, Dog farmDog, Sheep[] sheepArray) {
		name = farmName;
		dog = farmDog;
		sheep = new Sheep[sheepArray.length];
		for(int i=0; i<sheepArray.length; i++) {
			sheep[i] = sheepArray[i];
		}
		//Throw exception if there are too many Sheep for the Dog to herd
		if(sheepArray.length > dog.herd()) {
			throw new IllegalArgumentException("Maximum number of sheep for this dog is " + dog.herd() + ". Received " + sheepArray.length + " sheep.");
		}
	}
	
	//Take no inputs and return the Farm's name
	public String getName() {
		return name;
	}
	
	//Take no inputs and return the number of Sheep on the Farm
	public int getNumSheep() {
		int numSheep = sheep.length;
		return numSheep;
	}

	//Print the name of the Farm, Dog, and the names and ages of all Sheep
	public void printFarm() {
		System.out.println("Farm: " + getName() + " Dog: " + dog.getName());
		for(int i=0; i<getNumSheep(); i++) {
			System.out.println(sheep[i].getName() + " " + sheep[i].getAge());
		}
	}
	
	//Take no input and return the amount of wool acquired by shearing all of the Sheep on the Farm
	public double getWool() {
		double totalWool = 0.0;
		//Shear each sheep individually and then sum them
		for(int i=0; i<getNumSheep(); i++) {
			totalWool += sheep[i].shear();
		}
		return totalWool;
	}
}
