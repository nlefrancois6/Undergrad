import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException; //required

public class Building {

    private String name;
    private String type;
    private double yearlySales;
    private double unpaidTaxes;

    public Building(String name, String type, double yearlySales){

        if (yearlySales < 0){
            String msg = "Error: Sales cannot be negative!";
            throw new IllegalArgumentException(msg);
        }

        this.name = name;
        this.type = type;
        String n = this.name;
        n = n + n;
        this.yearlySales = yearlySales;
        this.unpaidTaxes = 0; //not needed, but helps others understand
    }


    public void calculateTaxes(){

        //can be equals or equalsIgnoreCase
        if (this.type.equalsIgnoreCase("COMMERCIAL")){
            this.unpaidTaxes = this.yearlySales * 0.15;
        }else{
            this.unpaidTaxes = yearlySales * 0.10;
        }
    }

    public double collectUnpaidTaxes(){
        double temp = this.unpaidTaxes;
        this.unpaidTaxes = 0;
        return temp;

        //we cannot do the following:
        //return this.unpaidTaxes;
        //this.unpaidTaxes = 0;
        //the second statement is unreachable
    }

    public static Building[][] loadBuildings(String fileName) throws IOException {


        // This code is not required


        FileReader fr = new FileReader(fileName);
        BufferedReader br = new BufferedReader(fr);

        String numBlocksStr = br.readLine();
        int numBlocks = Integer.parseInt(numBlocksStr);

        Building[][] buildings = new Building[numBlocks][];

        for (int i =0; i<numBlocks; i++){
            String input = br.readLine().trim();

            if (input.length() == 0){
                continue;
            }

            buildings[i] = new Building[input.length()];

            for (int j = 0; j < input.length(); j++){
                char c = input.charAt(j);

                if (c == 'B'){

                    String type = "COMMERCIAL";
                    if (Math.random() < 0.5){
                        type = "OTHER";
                    }

                    double yearlySales = Math.random() * 1000000;

                    Building b = new Building("Building" + i, type, yearlySales);
                    buildings[i][j] = b;
                }
            }
        }

        return buildings;

    }
}
