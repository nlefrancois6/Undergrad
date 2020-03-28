//Noah LeFrancois 
//260706235

import java.io.*;
import java.util.ArrayList;

public class FileIO {
	
	public static Character readCharacter(String fileName) {
		try {
			//Constructor for character using given character file
			FileReader fr = new FileReader(fileName);
			BufferedReader br = new BufferedReader(fr);
			String n = br.readLine();
			double a = Double.parseDouble(br.readLine());
			double mH = Double.parseDouble(br.readLine());
			int w = Integer.parseInt(br.readLine());
			br.close();
			fr.close();
			Character newChar = new Character(n,a,mH,w);
			return newChar;
		}
		//Check file not found and IO exceptions
		catch(FileNotFoundException f){
			throw new IllegalArgumentException("File was not found.");
		}
		catch(IOException e){
		    throw new IllegalArgumentException("There was an IO Exception.");
		}
	}

	public static ArrayList<Spell> readSpells(String fileName){
		try {
			//Constructor for spell list using given spell file
			FileReader fr = new FileReader(fileName);
			BufferedReader br = new BufferedReader(fr);
			ArrayList<Spell> spellList = new ArrayList<Spell>();
			String nextLine = null;
			while((nextLine = br.readLine()) != null) {
			String[] info = nextLine.split("\t");
			double minDam = Double.parseDouble(info[1]);
			double maxDam = Double.parseDouble(info[2]);
			double succRate = Double.parseDouble(info[3]);
			Spell s = new Spell(info[0], minDam, maxDam, succRate);
			spellList.add(s);
			}
			br.close();
			fr.close();
			return spellList;
		}
		//Check file not found and IO exceptions
		catch(FileNotFoundException f){
			throw new IllegalArgumentException("File was not found.");
		}
		catch(IOException e){
		    throw new IllegalArgumentException("There was an IO Exception.");
		}
	}

	public static void writeCharacter(Character Char, String charFile) {
		 try{
			 //Update given character file to increment the number of wins for the winner after each game
		     FileWriter fw = new FileWriter(charFile);
		     BufferedWriter bw = new BufferedWriter(fw);
		     bw.write(Char.getName());
		     bw.write("\n");
		     String attackStr = String.format("%1$.1f", Char.getAttackValue());
		     bw.write(attackStr);
		     bw.write("\n");
		     String maxHealthStr = String.format("%1$.1f", Char.getMaxHealth());
		     bw.write(maxHealthStr);
		     bw.write("\n");
		     String numWinsStr = String.format("%d", Char.getNumWins());
		     bw.write(numWinsStr);
		     bw.close();
		   }
		 	//Check IO exception
		   catch(IOException io){
		     throw new IllegalArgumentException ("There was an IO Exception.");
		   }
	}
}
