//Name: Noah LeFrancois
//Student Number: 260706235

// do NOT touch the following import statement
import java.util.Random;
import java.util.Scanner;

public class GuessTheWord {
    
    private static final String[] words = {"perfect", "country", "pumpkin", "special", "freedom", "picture", "husband", 
        "monster", "seventy", "nothing", "sixteen", "morning", "journey", "history", "amazing", "dolphin", "teacher", 
        "forever", "kitchen", "holiday", "welcome", "diamond", "courage", "silence", "someone", "science", "revenge", 
        "harmony", "problem","awesome", "penguin", "youtube", "blanket", "musical", "thirteen", "princess", "assonant", 
        "thousand", "language", "chipotle", "business", "favorite", "elephant", "children", "birthday", "mountain", 
        "football", "kindness", "abdicate", "treasure", "strength", "together", "memories", "darkness", "sandwich", 
        "calendar", "marriage", "building", "function", "squirrel", "tomorrow", "champion", "sentence", "daughter", 
        "hospital", "identical", "chocolate", "beautiful", "happiness", "challenge", "celebrate", "adventure", 
        "important", "consonant", "dangerous", "irregular", "something", "knowledge", "pollution", "wrestling", 
        "pineapple", "adjective", "secretary", "ambulance", "alligator", "congruent", "community", "different", 
        "vegetable", "influence", "structure", "invisible", "wonderful", "nutrition", "crocodile", "education", 
        "beginning", "everything", "basketball", "weathering", "characters", "literature", "perfection", "volleyball", 
        "homecoming", "technology", "maleficent", "watermelon", "appreciate", "relaxation", "abominable", "government", 
        "strawberry", "retirement", "television", "silhouette", "friendship", "loneliness", "punishment", "university", 
        "confidence", "restaurant", "abstinence", "blackboard", "discipline", "helicopter", "generation", "skateboard", 
        "understand", "leadership", "revolution"};  
    
    // this method takes an integer as input and returns a radom String from the array above. 
    // you can use it, but do NOT modified neither the method NOR the above array. 
    public static String getRandomWord(int seed) {
        Random gen = new Random(seed);
        int randomIndex = gen.nextInt(words.length);
        return words[randomIndex];
    }
    
    //========================
    // Enter your code below
    public static void main(String[] args) { 
    	//Input seed to play game
    	play(123);
    	
    }
    //Check if the guess is a valid lower case letter
    public static boolean isValidGuess(char guess) {
    	if(guess >= 'a' && guess <= 'z') {	
    		return true;
    	}
    	else {
    		return false;
    	}
    }
    //Create zeros array of same length as word
    public static int[] generateArrayOfGuesses(String word) {
    	int length = word.length();
    	int[] guesses = new int[length];
    	return guesses;
    }
    //If guess is in word, update array of guesses to 1 for guessed letters
    public static boolean checkAndUpdate(String word, int[] guesses, char guess) {
    	boolean isInWord = false;
    	//Compare the guess to the letter in each position
    	for(int i=0; i< word.length(); i++) {
    		if(word.charAt(i) == guess) {
    			guesses[i] = 1;
    			isInWord = true;
    		}
    	}
    	return isInWord;
    }
    //Display the secret word with unguessed letters replaced with "-", 
    //letters from most recent guess as upper case, and all other guessed
    //letters as lower case
    public static String getWordToDisplay(String word, int[] guesses, char guess) {
    	String display = "";
    	for(int i = 0; i < word.length(); i++) {
    		if(guesses[i]==0) {
    			display += "-";
    		}
    		if (guesses[i]==1) {
    			if(word.charAt(i)==guess) {
    				display += Character.toUpperCase(guess);
    			}
    			else {
    				display += word.charAt(i);
    			}
    		}
    	}
    	
    	return display;
    }
    //Return true if all letters have been guessed successfully, else return false
    public static boolean isWordGuessed(int[] guesses) {
    	boolean isGuessed = true;
    	for(int i = 0; i< guesses.length; i++) {
    		if(guesses[i]==0) {
    			isGuessed = false;
    		}
    	}
    	return isGuessed;	
    }
    //Generate random word using an int seed and play a 
    //round with user input for guesses
    public static void play(int in) {
    	//Initialize word, lives and array of guesses, print welcome message 
    	//with word length and lives left
    	String word = getRandomWord(in);
    	int[] guesses = generateArrayOfGuesses(word);
    	System.out.println("Welcome to Guess The Word!");
    	System.out.println("Your secret word has been generated. It has " + word.length() + " letters. You have 10 lives. Good Luck!");
    	int lives = 10;
    	//Play while user has remaining lives
    	while(lives>0) {
    		//Take user input for guess, convert to char
    		Scanner read = new Scanner(System.in);
    		System.out.println("You have " + lives + " lives left. Please enter a character:");
    		String input = read.nextLine();
    		read.close();
    		//Check for single char input
    		if(input.length() == 1) {
    			char guess = input.charAt(0);
        		//Check for lower case valid letter
    			if(isValidGuess(guess)){
        			//If correct guess, update guesses array 
    				//and print the partially guessed word
    				if(checkAndUpdate(word, guesses, guess)==true){
        				System.out.println("Good job! The word contains the character '" + guess + "'");
        				checkAndUpdate(word, guesses, guess);
        				System.out.println(getWordToDisplay(word, guesses, guess));
        			}
    				//If incorrect guess, lose a life, display incorrect guess message
    				//and print partially guessed word
        			else{
        				lives -= 1;
        				//If user has run out of lives, print losing message and end game
        				if(lives == 0) {
        	    			System.out.println("You have no lives left :( Better luck next time! The secret word was: " + word);
        					break;
        				}
        				System.out.println("There's no such character. Try again!");
    					System.out.println(getWordToDisplay(word, guesses, guess));
        	    		
        			}
    				//If the user has completed the word, display the victory message
        			if(isWordGuessed(guesses)==true){
        				System.out.println("Congratulations! You guessed the secret word!");
        				break;
        			}
        		}
    			//Error message for invalid character input
        		else {
        			System.out.println("The character must be a lower case letter of the English alphabet. Try again!");
        		}
    		}
    		//error message for more than a single character input
    		else {
    			System.out.println("You can only enter one single character. Try Again!");
    		}	
    	}
    }
}
