package movie.dao;

import movie.canshu.*;
import java.util.ArrayList;
import java.util.List;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;


public class UsersDao {
	public boolean isLogin(String name ,String pass)
	{
		boolean isL = false;
		Connection c = null;
		PreparedStatement st = null;
		ResultSet rs = null;
		
		
		System.out.print("zheli");
		try{
			Class.forName("com.mysql.jdbc.Driver");
			c = DriverManager.getConnection("jdbc:mysql://localhost:3306/cgf?useSSL=false","root","");
			//sql
			String sql = "select count(1) from users where name =? and pass =?";
			st = c.prepareStatement(sql);
			//ÉèÖÃ²ÎÊý
			st.setString(1,name);
			st.setString(2, pass);
			rs = st.executeQuery();
			rs.next();
			int count = rs.getInt(1);
			if(count>0)
				isL = true;
				
			
		} catch (Exception e)
		{
			e.printStackTrace();
		}
		return isL;
	}
}
