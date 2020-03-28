import java.io.IOException;
import java.text.DecimalFormat;

public class Nation {



    public static void main(String[] args){

        Building[][] buildings = null;
        String filename = "NewMeowCity.txt";

        try{
            buildings = Building.loadBuildings(filename);

        } catch (IOException e) {
            System.out.println("Error with filename: " + filename);
            return;
        }

        //watch out for scope here
        //if you declare buildings inside the try, it can't be used here
        City nmc = new City("New Meow City", buildings);

        nmc.calculateTaxes();
        double taxes = nmc.collectTaxes();

        //formatting doesn't matter
        //here's a way to have pretty money formatting
        DecimalFormat formatter = new DecimalFormat("#,###.00");
        String taxStr = formatter.format(taxes);

        String s = nmc.getName() + " - Total tax collected: " + taxStr + " dollars.";
        System.out.println(s);
    }
}
