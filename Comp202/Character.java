//Noah LeFrancois
//260706235

import java.util.Random;
import java.util.ArrayList;

public class Character {
	private String name;
	private double attackValue;
	private double maxHealth;
	private double currentHealth;
	private int numWins;
	private static ArrayList<Spell> spells;
	
	public static void main(String[] args) {
	}
	
	//Constructor
	public Character(String n, double a, double mH, int w) {
		this.name = n;
		this.attackValue = a;
		this.maxHealth = mH;
		this.currentHealth = mH;
		this.numWins = w;
	}
	
	//Getters
	public String getName() {
		return this.name;
	}
	public double getAttackValue() {
		return this.attackValue;
	}
	public double getMaxHealth() {
		return this.maxHealth;
	}
	public double getCurrHealth() {
		return this.currentHealth;
	}
	public int getNumWins() {
		return this.numWins;
	}
	
	//Setter for spell list
	public static void setSpells(ArrayList<Spell> spellList) {
		spells = spellList;
	}
	
	//Print the list of spells
	public static void displaySpells() {
		for(int x=0; x<spells.size(); x++) {
			System.out.println(spells.get(x));
		}
	}
	
	//Check if valid name; if valid return damage, else return -1.0
	public double castSpell(String name, int seed) {
		for(int x=0; x<spells.size(); x++) {
			Spell spellCand = spells.get(x);
			if(spellCand.getName().equalsIgnoreCase(name)) {
				double damage = spellCand.getMagicDamage(seed);
				return damage;
			}
		}
		return -1.0;
		
	}
	
	//toString returns character name and current health
 	public String toString() {
		String healthString = String.format("%1$.2f", this.currentHealth);
		return "Character: " + this.name + System.lineSeparator() + "Health: " + healthString;
	}
	
	//Generate random damage = (character's attack)*(random double between 0.7 and 1.0)
	public double getAttackDamage(int seed) {
		Random rand = new Random(seed);
		double R = rand.nextDouble();
		double Low = 0.7;
		double High = 1.0;
		double range = High - Low;
		return this.attackValue * (range*R + Low);
	}
	
	//Take damage done to this character, return the character's new current health
	public double takeDamage(double damage) {
		this.currentHealth -= damage;
		return this.currentHealth;
	}
	
	//Increment this character's wins by 1
	public void increaseWins() {
		this.numWins ++;
	}
	
	//Print name, current health, attack value, and number of wins for character
	public void printStats() {
		System.out.println(this.toString());
		System.out.println("Attack Value: " + this.getAttackValue() + System.lineSeparator() + "Number of Wins: " + this.getNumWins());
	}
	
}
