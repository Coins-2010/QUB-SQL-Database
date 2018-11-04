package wombat.crm;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Scanner;

/**
 * Dave's Dodgy Software Emporium
 * 2008
 * 
 * You bought it - no warranties
 * 
 * Wombat Widgets Inc CRM
 *
 */

public class WombatCRM {

	public Database database = null;	// instance of database
	public Scanner scanner = null;		// scanner to read from keyboard
	
	/**
	 * Main method - start when run
	 */
	public static void main(String[] args) {
		WombatCRM crm = new WombatCRM();	// new instance of this class
		crm.Start();						// start the CRM
	}
	
	/**
	 * Read a line from the keyboard
	 */
	public String getLine()
	{
		return scanner.nextLine();
	}
	
	/**
	 * Constructor to create CRM instance - sets up scanner
	 */
	public WombatCRM()
	{
		scanner = new Scanner(System.in);
	}
	
	/**
	 * Start the CRM
	 */
	public void Start()
	{
		database = new Database();	// instance of database
		if (!database.Connect())	// connect to database or die with error
		{
			System.out.println("Fatal error - cannot connect to database");
			return;
		}
		
		Action action = Action.MAINMENU;	// default action (show main menu)
		
		// Welcome user
		System.out.println("Dave's Dodgy Software Emporium Presents...");
		System.out.println("Welcome to Wombat CRM - Database Connected");
		
		// While we're not going to exit
		while (action != Action.EXIT)
		{
			switch(action)	// see what action is selected
			{
				case MAINMENU:	// show main menu
					action = MainMenu();
					break;
				case EXIT:		// quit
					break;
				case CUSTOMERSEARCH:	// search for a customer
					action = CustomerSearch();
					break;
				case CUSTOMERADD:		// add a customer
					action = CustomerAdd();
					break;
				default:
					System.out.println("Fatal internal error: Unexpected ACTION State");
					action = Action.EXIT;
			}
		}
		
		// Exiting Wombat CRM
		System.out.println("Exiting Wombat CRM - Closing Database Connection");
		database.Disconnect();	// disconnect database
		System.out.println("Bye now!");
	}
	
	/**
	 * Show the main menu - return the next action to be done
	 */
	public Action MainMenu()
	{
		boolean leaveMenu = false;	// flag to leave the menu
		while (!leaveMenu)			// until we leave the menu
		{
			// Display main menu
			System.out.println("");
			System.out.println("** WombatCRM Main Menu **");
			System.out.println("S\tSearch for Customer");
			System.out.println("A\tAdd a Customer");
			System.out.println("X\tExit Wombat CRM");
			
			String line = getLine();	// read line
			
			// check input and set action as appropriate
			if (line.equalsIgnoreCase("X"))
				return Action.EXIT;
			else if (line.equalsIgnoreCase("S"))
				return Action.CUSTOMERSEARCH;
			else if (line.equalsIgnoreCase("A"))
				return Action.CUSTOMERADD;
			else
				System.out.println("Illegal Entry Detected");
		}
		
		return Action.MAINMENU;		// no other action specified so we return ourselves
	}
	
	/**
	 * Search for a customer and return next action
	 */
	public Action CustomerSearch()
	{
		boolean selected = false;	// have they selected a customer
		// while a customer is not selected
		while (!selected)
		{
			// print search prompt and read, return to main menu if it's an X
			System.out.println("Customer Search (X to Exit to Main Menu) :> ");
			String search = getLine();
			if (search.equalsIgnoreCase("X"))
				return Action.MAINMENU;
			
			try
			{
				// Perform the search of the input string
				String query = "SELECT * FROM wcrm_Company WHERE CompanyName LIKE '%"+search+"%' OR PersonName LIKE '%"+search+"%'";
				Statement statement = database.getConnection().createStatement();
				// Get the results, loop through and display them
				ResultSet results = statement.executeQuery(query);
				int index = 1;
				while(results.next())
				{
					System.out.println(index+"\t"+results.getString("CompanyName"));
					index++;
				}
				
				// Prompt for a company ID
				System.out.println("Enter the ID of the company (or 0 to quit): ");
				String in = getLine();
				if (in.equalsIgnoreCase("0"))
					return Action.MAINMENU;
				try
				{
					int c = Integer.parseInt(in);
					results.absolute(c);
					int id = results.getInt("CompanyID");
					selected=true;
					
					// What are the options to view or log a contact - read and call appropriate method
					System.out.println("Enter V to view contacts, L to log a contact, anything else to return: ");
					String choice = getLine();
					if (choice.equalsIgnoreCase("L"))					
						LogContact(id);
					else if (choice.equalsIgnoreCase("V"))
						ViewContact(id);
				}
				catch (NumberFormatException nfe)
				{
					// not a number - loop again!
				}
			}
			catch(SQLException ex)
			{
				System.out.println("Internal error - an SQL exception occurred");
				System.out.println("SQLException: " + ex.getMessage());
			    System.out.println("SQLState: " + ex.getSQLState());
			    System.out.println("VendorError: " + ex.getErrorCode());
			}
			
		}
		return Action.MAINMENU;
	}
	
	/**
	 * Log a contact with a company
	 */
	public void LogContact(int CompanyID)
	{
		System.out.println("Logging Contact with Company");
		
		// Notes prompt and read
		System.out.print("Enter notes on one line: ");
		String notes = getLine();
		
		// Action required prompt and read
		System.out.print("Action Required y/N: ");
		String actline = getLine();
		// Turn action into a numeric value 1/0
		int action = 0;
		if (actline.equalsIgnoreCase("Y"))
			action = 1;
		
		// Prompts user if they wish to make the contact visible
		System.out.print("Contact set to visible Y/N: ");
		String visLine = getLine();
		int visible;
		if (visLine.equalsIgnoreCase("N")) {
			visible = 0;
		}
		else if (visLine.equalsIgnoreCase("Y")) {
			visible = 1;
		}
		else {
			System.out.println("Invalid entry detected. Visibilty automatically set to Yes");
			visible = 1;
		}
		// Build insert query
		String query = "INSERT INTO wcrm_Contact(CompanyID,Occurred,Notes,ActionNeeded,visible) VALUES("
				+CompanyID+",NOW(),'"+notes+"',"+action+","+visible+")";
		try 
		{
			// Execute query to insert
			Statement statement = database.getConnection().createStatement();
			statement.execute(query);
		} 
		catch (SQLException ex) 
		{
			System.out.println("Internal Error: SQL Exception");
			System.out.println("SQLException: " + ex.getMessage());
		    System.out.println("SQLState: " + ex.getSQLState());
		    System.out.println("VendorError: " + ex.getErrorCode());
		}
	}
	
	/**
	 * View contacts with company
	 */
	public void ViewContact(int CompanyID)
	{
		System.out.println("Viewing Contact with Company");
		try
		{
			// Build search query for contacts
			String query = "SELECT * FROM wcrm_Contact WHERE CompanyID="+CompanyID+" AND wcrm_Contact.Visible !=0";
			Statement statement = database.getConnection().createStatement();
			ResultSet results = statement.executeQuery(query);
			
			// Loop through and display contacts
			while(results.next())
			{
				System.out.println(results.getString("Occurred")+"\t"+results.getString("Notes"));
				System.out.print("Action Needed: ");
				if (results.getInt("ActionNeeded")==1)
				System.out.println("Yes");
					else
				System.out.println("No");
				System.out.println("");
			}
		}
		catch(SQLException ex)
		{
			System.out.println("Internal error - an SQL exception occurred");
			System.out.println("SQLException: " + ex.getMessage());
		    System.out.println("SQLState: " + ex.getSQLState());
		    System.out.println("VendorError: " + ex.getErrorCode());
		}
		System.out.println("Press enter to return to menu");
		getLine();
	}
	
	/**
	 * Add a customer
	 */
	public Action CustomerAdd()
	{
		System.out.println("Add New Customer");
		
		// Get the required data
		System.out.print("Company Name: ");
		String company = getLine();
		System.out.print("Country: ");
		String country = getLine();
		System.out.print("Person Name: ");
		String person = getLine();
		System.out.print("Phone Num: ");
		String phone = getLine();
		System.out.print("Email: ");
		String email = getLine();
		
		// Confirm creation
		System.out.print("Create new customer (Y/n)? ");
		String confirm = getLine();
		
		if (confirm.equalsIgnoreCase("N"))	// selected N to NOT add
			return Action.MAINMENU;			// return and show main menu
		
		// Build insert query
		String query="INSERT INTO wcrm_Company(CompanyName,Country,PersonName,Phone,Email) VALUES("
				+"'"+company+"','"+country+"','"+person+"','"+phone+"','"+email+"')";
		
		try 
		{
			// Execute query to insert
			Statement statement = database.getConnection().createStatement();
			statement.execute(query);
		} 
		catch (SQLException ex) 
		{
			System.out.println("Internal Error: SQL Exception");
			System.out.println("SQLException: " + ex.getMessage());
		    System.out.println("SQLState: " + ex.getSQLState());
		    System.out.println("VendorError: " + ex.getErrorCode());
		}
		
		return Action.MAINMENU; // loop back to us
	}

}
