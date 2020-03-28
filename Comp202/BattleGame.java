//Noah LeFrancois 
//260706235

import java.util.Random;
import java.util.Scanner;
import java.util.ArrayList;


public class BattleGame {
	private static Random r = new Random(2);
	
	public static void main(String[] args) {
		playGame("player.txt", "monster.txt", "spells.txt");
	}
	//Play the game using input files containing a player, monster, and list of spells to be used
	public static void playGame(String playerFile, String monsterFile, String spellFile) {
		//Initialize player, monster, and spell list using input files
		Character player = FileIO.readCharacter(playerFile);
		Character monster = FileIO.readCharacter(monsterFile);
		ArrayList<Spell> spellList = FileIO.readSpells(spellFile);
		//If no spells, notify the player
		if(spellList == null) {
			System.out.println("This game will be played without spells");
		}
		//Set and display the available spells
		Character.setSpells(spellList);
		Character.displaySpells();
		
		//Display name, curr health, attack, numWins for player&monster
		player.printStats();
		monster.printStats();
		//Take user input
		Scanner read = new Scanner(System.in);
		//While neither player nor monster have run out of health
		while(player.getCurrHealth() > 0 && monster.getCurrHealth() > 0) {
			System.out.println("Enter a command:");
			String command = read.nextLine().toLowerCase();
			//Attack
			if(command.contains("attack")) {
				attack(player,monster);
				//If monster survives attack, monster attacks player
				if(monster.getCurrHealth() > 0) {
					attack(monster,player);
				}	
			}
			//Quit
			if(command.contains("quit")) {
				System.out.println("Goodbye!");
				break;
			}
			//Neither attack nor quit, assume it is a spell
			if(!command.contains("attack") && !command.contains("quit")) {
				//Generate random seed and then calculate spell damage
				int seed = r.nextInt();
				double spellDamage = player.castSpell(command, seed);
				
				//If invalid input or unsuccessful spell, notify user
				if(spellDamage<=0) {
					System.out.println(player.getName() + " tried to cast a spell, but it failed!");
				}
				//Else display the spell&it's damage done, apply damage to monster
				else{
					String spellRound = String.format("%1$.2f", spellDamage);
					System.out.println(player.getName() + " casted " + command + " for " + spellRound + " damage!");
					monster.takeDamage(spellDamage);
					//If monster survives attack, display monster info
					if(monster.getCurrHealth()>0) {
						System.out.println(monster.toString());
					}
					//Else notify user that monster has been knocked out
					else {
						System.out.println(monster.getName() + " has been knocked out!");
					}
				}
				//If monster survives attack, monster attacks player
				if(monster.getCurrHealth() > 0) {
					attack(monster,player);
				}	
			}
		}
		read.close();
		Character winner = null;
		//Display losing message, increase wins of monster
		if(player.getCurrHealth() < 0) {
			System.out.println("You ran out of health! Game Over!");
			monster.increaseWins();
			winner = monster;
		}
		//Display winning message, increase wins of player
		if(monster.getCurrHealth() < 0) {
			System.out.println("You win! Game Over!");
			player.increaseWins();
			winner = player;
		}
		
		//Display number of wins for each character
		System.out.println(player.getName() + ": " + player.getNumWins() + " wins");
		System.out.println(monster.getName() + ": " + monster.getNumWins() + " wins");
		
		//Update winner's file to increment number of wins
		if(winner == monster) {
			FileIO.writeCharacter(monster, monsterFile);
		}
		if(winner == player) {
			FileIO.writeCharacter(player, playerFile);
		}
	}
	
	///Calculate&apply attack damage to defender
	private static void attack(Character attacker, Character defender) {
		//Generate random seed for getAttackDamage
		int var = r.nextInt();
		double damage = attacker.getAttackDamage(var);
		//Display damage, apply to defender
		String damageString = String.format("%1$.2f", damage);
		System.out.println(attacker.getName() + " does " + damageString + " damage!");
		defender.takeDamage(damage);
		//If defender survives, print defender info. Else display knockout message
		if(defender.getCurrHealth()>0) {
			System.out.println(defender.toString());
		}
		else {
			System.out.println(defender.getName() + " has been knocked out!");
		}
	}
	
}
