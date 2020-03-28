import java.util.Scanner;
import java.util.Random;
public class WoolFactory{
  //The provided code generates random ages for sheep, and picks random names from the below array
  //You can modify this list of names as you wish (add/remove/replace elements).
  private static String[] namesForSheep = {"Cerdic","Cynric","Ceawlin","Ceol","Ceolwulf","Cynegils",
    "Cenwalh","Seaxburh","Aescwine","Centwine","Davros","Ceadwalla","Ine","Aethelheard","Cuthred","Cynewulf",
    "Berhtric","Ashildr","Egbert","Aethelwulf","Aethelbald","Aethelberht","Aethelred","Hengest","Aesc","Octa",
    "Eormenric","Aethelbert I","Eadbald","Rassilon","Earconbert","Egbert I","Hlothere","Oswine","Wihtred",
    "Aethelbert II","Sigered","Egbert II","Eadberht II","Strax","Cuthred","Baldred","Aethelfrith","Edwin","St. Oswald",
    "Oswiu","Ecgfrith","Aldfrith","Osred I","Slitheen","Cenred","Osric","Ceolwulf","Eadberht",
    "Aethelwald","Maldovar","Alhred","Aethelred I","Aelfwald I","Eardwulf","Eanred","George V","Edward VIII",
    "George VI","Elizabeth II"};
  private static Random r = new Random(123);
  
  //returns a random String from the above array. 
  private static String getRandomName(){
    int index = r.nextInt(namesForSheep.length);
    return namesForSheep[index];
  }
  //returns a random age for a sheep from 1 to 10
  private static int getRandomAge(){
    return r.nextInt(10)+1;
  }
  //End of provided name/age generation code. 
  
  public static void main(String[] args){
    //Student Name: Noah LeFrancois
    //Student Number: 260706235
    //Your code goes here.
	//Initialize Farm name from user input
	Scanner read = new Scanner(System.in);
	System.out.println("What is the name of your farm?");
	String farmName = read.nextLine();
	//Initialize Dog name from user input
	System.out.println("What is the name of your dog?");
	String dogName = read.nextLine();
	//Initialize Dog breed from user input
	System.out.println("What kind of dog is " + dogName + "?");
	String dogBreed = read.nextLine();
	//Initialize number of Sheep from user input
	System.out.println("How many sheep do you have?");
	int numSheep = read.nextInt();
	read.close();
	//Initialize array of Sheep with random names and ages
	Sheep[] sheepList = new Sheep[numSheep];
	for(int i=0; i<numSheep; i++) {
		sheepList[i] = new Sheep(getRandomName(), getRandomAge());
	}
	System.out.println("The farm has " + numSheep + " sheep.");
	//Initialize Dog object
	Dog farmDog = new Dog(dogName, dogBreed);
	//Initialize Farm object
	Farm farmObject = new Farm(farmName, farmDog, sheepList);
	//Display Farm information
	farmObject.printFarm();
	//Calculate value of wool sheared from all sheep, where wool sells for $1.45/pound
	double woolSheared = farmObject.getWool();
	double profit = woolSheared * 1.45;
	//Print amount and value of wool sheared from this Farm
	System.out.println("We just sheared " + woolSheared + " lbs of wool for a value of $" + profit);
  }
}
