import java.lang.reflect.*;
import java.util.ArrayList;

public class TesterA5
{
   public static void main( String[] args )
   { 
      //try { callAll(); }
      //catch( Exception e ){};
      
      System.out.println( "Testing class FileIO...\n" );
      
      try
      {
         FileIO fio = null;
         System.out.println( "Class found!" );
      }
      catch( Exception e )
      {
         System.out.println( "Class FileIO not found! Check the name of the class and the file!" );
      }
      
      try
      {         
         System.out.print( "Testing readCharacter()... " );
         Character monster = FileIO.readCharacter( "monster.txt" );
         Character player = FileIO.readCharacter( "player.txt" );
         System.out.println( "OK" );
         
         System.out.print( "Testing readSpells()... " );
         ArrayList< Spell > als = FileIO.readSpells( "spells.txt" );
         System.out.println( "OK" );
         
         System.out.print( "Testing writeCharacter()... " );
         FileIO.writeCharacter( monster,"monster_copy.txt" );
         System.out.println( "OK" );
      }
      catch( Exception e )
      {
         System.out.println( "\nFailed! Exception was raised. Check names of the methods and the assignment instructions!" );
      }
      
      System.out.println( "\n\nTesting class Spell...\n" );
      
      try
      {
         Spell s = null;
         System.out.println( "Class found!" );
      }
      catch( Exception e )
      {
         System.out.println( "Class Spell not found! Check the name of the class and the file!" );
      }
      
      try
      {
         System.out.print( "Testing constructor... " );
         Spell s = new Spell( "crucify",2.0,10.0,0.3 );
         System.out.println( "OK" );
         
         System.out.print( "Testing toString()... " );
         String ss = s.toString();
         System.out.println( "OK" );
         
         System.out.print( "Testing getName()... " );
         String s0 = s.getName();
         System.out.println( "OK" );
         
         System.out.print( "Testing getMagicDamage()... " );
         double d0 = s.getMagicDamage( 123 );
         System.out.println( "OK" );
      }
      catch( Exception e )
      {
         System.out.println( "\nFailed! Exception was raised. Check names of the methods and the assignment instructions!" );
      }
      
      System.out.println( "\n\nTesting class Character...\n" );
      
      try
      {
         Character c = null;
         System.out.println( "Class found!" );
      }
      catch( Exception e )
      {
         System.out.println( "Class Character not found! Check the name of the class and the file!" );
      }
      
      try
      {
         System.out.print( "Testing constructor... " );
         Character c = new Character( "soldier",2.0,100.0,1 );
         System.out.println( "OK" );
         
         System.out.print( "Testing increaseWins()... " );
         c.increaseWins();
         System.out.println( "OK" );
         
         System.out.print( "Testing setSpells()... " );
         ArrayList< Spell > als = new ArrayList< Spell >();
         als.add( new Spell( "crucify",2.0,10.0,0.9 ) ) ;
         als.add( new Spell( "woosha",1.0,8.0,0.5 ) ) ;
         Character.setSpells( als );
         System.out.println( "OK" );
         
         System.out.println( "Testing displaySpells()... " );
         Character.displaySpells();
         System.out.println( "OK" );
         
         System.out.print( "Testing getCurrHealth()... " );
         double d1 = c.getCurrHealth();
         System.out.println( "OK" );
         
         System.out.print( "Testing toString()... " );
         String s2 = c.toString();
         System.out.println( "OK" );
         
         System.out.print( "Testing getAttackDamage()... " );
         {
            Object[] results = { 1.8386881616119433,1.8339045217982881,1.8365382080197208 };
            Object[] obtained = { c.getAttackDamage( 2 ),c.getAttackDamage( 123 ),c.getAttackDamage( 42 ) };
            
            processResults( results,obtained );
         }
         
         System.out.print( "Testing castSpell()... " );
         {
            Object[] results = { 5.280646491937613,9.927191174217914,-1.0,0.0 };
            Object[] obtained = { c.castSpell( "crucify",1 ),c.castSpell( "CRUCIFY",123 ),c.castSpell( "abrakadabra",456 ),c.castSpell( "woosha",123 ) };
            
            processResults( results,obtained );
         }
         
         System.out.print( "Testing takeDamage()... " );
         double d4 = c.takeDamage( 1.0 );
         System.out.println( "OK" );
         
         System.out.print( "Testing getName()... " );
         String s3 = c.getName();
         System.out.println( "OK" );
         
         System.out.print( "Testing getAttackValue()... " );
         double d5 = c.getAttackValue();
         System.out.println( "OK" );
         
         System.out.print( "Testing getMaxHealth()... " );
         double d6 = c.getMaxHealth();
         System.out.println( "OK" );
         
         System.out.print( "Testing getNumWins()... " );
         int i1 = c.getNumWins();
         System.out.println( "OK" );
      }
      catch( Exception e )
      {
         System.out.println( "\nFailed! Exception was raised. Check names of the methods and the assignment instructions!" );
      }
   } 
   
   public static void processResults( Object[] results,Object[] obtained )
   {
      boolean passed = true;
            
      for( int i = 0; i < results.length; i++ )
      {
         if( results[ 0 ] instanceof Double  )
         {
            if( !String.format("%5.11f", results[ i ] ).equals( String.format("%5.11f", obtained[ i ] ) ) )
            {
               if( passed )
               {
                  System.out.println( "Failed\n" );
                  passed = false;
               }
               
               System.out.println( "Expected:  " + String.format("%5.11f", results[ i ] ) );
               System.out.println( "Obtained:  " + String.format("%5.11f", obtained[ i ] ) + "\n" );
            }
         }
         else if( !results[ i ].equals( obtained[ i ] ) )
         {
            if( passed )
            {
               System.out.println( "Failed\n" );
               passed = false;
            }
            
            System.out.println( "Expected:  " + results[ i ] );
            System.out.println( "Obtained:  " + obtained[ i ] + "\n" );
         }
      }
      
      if( passed )
      {
         System.out.println( "Passed" );
      }
      
   }
   
   
   /*
   public static void callAll() throws IllegalArgumentException, IllegalAccessException, InvocationTargetException
   {
      Character a = new Character( "Waldo",10.0,100.0,0 );
      ArrayList< Spell > als = new ArrayList< Spell >();
      als.add( new Spell ( "abraka",3.0,7.0,0.17 ) );
      
      String[] names = { "setSpells","takeDamage","getAttackDamage" } ;
      Object[] answers = { als,2.0,3 };
      Method[] methods = a.getClass().getDeclaredMethods();

      for( Method m : methods )
      {
         System.out.print( m.getReturnType() + " " + m.getName() + "( " );
         
         Class[] params = m.getParameterTypes();
         Object[] arguments = new Object[ params.length ];
         
         for( int i = 0; i < params.length; i++ )
         {
            System.out.print( params[ i ].toString() + ", " );
         }
         System.out.println( " )" );
         
         boolean parameter = false;
         int whichParameter = -1;
         
         for( int j = 0; j < answers.length; j++ )
         {  
            if( m.getName().equals( names[ j ] ) )
            {
               parameter = true;
               whichParameter = j;
            }
         }
         
         if( parameter )
            System.out.println( m.invoke( a,answers[ whichParameter ] ) );
         else
            System.out.println( m.invoke( a ) );
       
         System.out.println();
      }
   }
   */ 
}