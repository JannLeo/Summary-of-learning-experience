package movie.servlet;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import movie.canshu.*;
import movie.dao.*;
public class pd extends HttpServlet {


	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		
		request.setCharacterEncoding("UTF-8");
		System.out.print("111");
		String name =request.getParameter("userName");
		String pass =request.getParameter("pass");
		
		UsersDao ud = new UsersDao();
		boolean bb = ud.isLogin(name,pass);
		System.out.print("111");
		
		if(bb)
			response.sendRedirect("MoivesServlet");
		else
			response.sendRedirect("../login.html");
	}


	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
			doGet(request,response);
	}

}
