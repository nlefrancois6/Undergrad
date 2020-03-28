//Noah LeFrancois
//260706235

import java.util.Random;

public class Spell {
	
	private String name;
	private double minDamage;
	private double maxDamage;
	private double successRate;
	
	public static void main(String[] args) {
	}
	
	public Spell(String name, double minDamage, double maxDamage, double successRate) {
		//Verify proper inputs for spell info
		if(minDamage>maxDamage) {
			throw new IllegalArgumentException("Minimum Damage must be less than Maximum Damage");
		}
		if(minDamage<0){
			throw new IllegalArgumentException("Minimum Damage must be greater than zero");
		}
		if(successRate<0 || successRate>1) {
			throw new IllegalArgumentException("Chance of success must be between 0 and 1");
		}
		this.name = name;
		this.minDamage = minDamage;
		this.maxDamage = maxDamage;
		this.successRate = successRate;
	}
	//Getters
	public String getName() {
		return this.name;
	}
	//Returns 0 if rand>success rate, else returns random double between minDamage and maxDamage
	public double getMagicDamage(int seed) {
		Random rand = new Random(seed);
		double R = rand.nextDouble();
		if(R>this.successRate) {
			return 0.0;
		}
		else {
			double Low = this.minDamage;
			double High = this.maxDamage;
			double range = High - Low;
			double r = rand.nextDouble();
			return range*r + Low;
		}
	}
	//Return String of spell name, minDamage, maxDamage, and success chance
	public String toString() {
		return "Spell: " + this.name + " Damage Range: " + this.minDamage + "-" + this.maxDamage + " Success Chance: " + this.successRate;
	}
}
