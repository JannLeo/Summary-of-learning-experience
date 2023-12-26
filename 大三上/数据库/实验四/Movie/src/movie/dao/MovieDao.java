package movie.dao;

import movie.canshu.*;
import java.util.ArrayList;
import java.util.List;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;


public class MovieDao {
	//²é
	public List<movies> findMovies()
	{
		List<movies> lm = new ArrayList<movies>();
		Connection c = null;
		PreparedStatement st = null;
		ResultSet rs = null;
		
		try{
			Class.forName("com.mysql.jdbc.Driver");
			c = DriverManager.getConnection("jdbc:mysql://localhost:3306/cgf?useUnicode&characterEncoding=UTF-8","root","");
			//sql
			String sql = "select * from goods";
			st = c.prepareStatement(sql);
			rs = st.executeQuery();
			
			while(rs.next())
			{
				int id = rs.getInt(1);
				String name = rs.getString(2);
				String type = rs.getString(3);
				double price = rs.getDouble(4);
				movies m = new movies(id,name,type,price);
				lm.add(m);
			}
			
		} catch (Exception e)
		{
			e.printStackTrace();
		}
return lm;
	}
	
	//É¾³ý
	public void deleteMoviesById(int id)
	{
	
		Connection c = null;
		PreparedStatement st = null;
	
		
		try{
			Class.forName("com.mysql.jdbc.Driver");
			c = DriverManager.getConnection("jdbc:mysql://localhost:3306/cgf","root","");
			//sql
			String sql = "delete  from goods where id=?";
			st = c.prepareStatement(sql);
			st.setInt(1,id);
			
			int i = st.executeUpdate();

			
		} catch (Exception e)
		{
			e.printStackTrace();
		}
	}
	
	public movies findMoviesById(int id)
	{
		movies m = null;
		Connection c = null;
		PreparedStatement st = null;
		ResultSet rs = null;
		
		try{
			Class.forName("com.mysql.jdbc.Driver");
			c = DriverManager.getConnection("jdbc:mysql://localhost:3306/cgf","root","");
			//sql
			String sql = "select * from goods where id=?";
			st = c.prepareStatement(sql);
			st.setInt(1, id);
			rs = st.executeQuery();
			rs.next();

			m = new movies(rs.getInt("id"),rs.getString("name"),rs.getString("type"),rs.getDouble("price"));
			
		} catch (Exception e)
		{
			e.printStackTrace();
		}
return m;
	}
	//¸üÐÂ
	public void updateMovies(int id,String name,String type, double price)
	{
	
		Connection c = null;
		PreparedStatement st = null;
	
		
		try{
			Class.forName("com.mysql.jdbc.Driver");
			c = DriverManager.getConnection("jdbc:mysql://localhost:3306/cgf?useUnicode&characterEncoding=UTF-8","root","");
			//sql
			String sql = "update goods set name=?,type=?,price=?,id=?";
			st = c.prepareStatement(sql);
			st.setString(1,name);
			st.setString(2,type);
			st.setDouble(3,price);
			st.setInt(4,id);
			
			int i = st.executeUpdate();

			
		} catch (Exception e)
		{
			e.printStackTrace();
		}

	}
	public void addMovies(int id,String name,String type, double price)
	{
	
		Connection c = null;
		PreparedStatement st = null;
	
		
		try{
			Class.forName("com.mysql.jdbc.Driver");
			c = DriverManager.getConnection("jdbc:mysql://localhost:3306/cgf?useUnicode&characterEncoding=UTF-8","root","");
			//sql
			String sql = "insert into goods values(?,?,?,?)";
			st = c.prepareStatement(sql);
			
			st.setInt(1,id);
			st.setString(2,name);
			st.setString(3,type);
			st.setDouble(4,price);
			
			
			int i = st.executeUpdate();

			
		} catch (Exception e)
		{
			e.printStackTrace();
		}

	}
}
