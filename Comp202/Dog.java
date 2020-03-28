public class Dog {
	//Initialize variables
	private String name;
	private String breed;
	
	public static void main(String[] args) {
		
	}
	
	//Take name and breed inputs to create a Dog object
	public Dog(String dogName, String breed) {
		name = dogName;
		this.breed = breed;
	}
	
	//Take no inputs and return the Dog's name
	public String getName() {
		return name;
	}
	//Take no inputs and return number of sheep the Dog can herd
	public int herd() {
		//Convert breed input to lower case so that it can be compared to the listed breeds
		String compare = breed.toLowerCase();
		//Check if the breed matches one of the listed breeds
		if(compare.contains("collie")) {
			return 20;
		}
		if(compare.contains("shepherd")) {
			return 25;
		}
		if(compare.contains("kelpie") || compare.contains("teruven")) {
			return 30;
		}
		//If breed is not listed, return 10
		else {
			return 10;
		}
	}
}
