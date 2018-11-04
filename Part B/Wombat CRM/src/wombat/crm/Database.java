package wombat.crm;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Database {
	private Connection connection = null;

	public Connection getConnection()
	{
		return connection;
	}
	
	public boolean Connect()
	{
		try {
			String uri = "jdbc:mysql://"+Configuration.Hostname+"/"
					+Configuration.Database+"?user="
					+Configuration.Username+"&password="
					+Configuration.Password;
			if (Configuration.SSL)
				uri += "&useSSL=true";
			else
				uri += "&useSSL=false";
			connection = DriverManager.getConnection(uri);
			// We've got this far so the connection is made ok
			return true;
		}
		catch(SQLException ex)
		{
			System.out.println("Error connecting to database");
			System.out.println("SQLException: " + ex.getMessage());
		    System.out.println("SQLState: " + ex.getSQLState());
		    System.out.println("VendorError: " + ex.getErrorCode());
		}
		return false;
	}
	
	public void Disconnect()
	{
		try {
			connection.close();
		} catch (SQLException e) {
			System.out.println("Error encountered closing database connection");
		}
	}
}
