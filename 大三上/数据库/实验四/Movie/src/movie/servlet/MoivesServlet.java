package movie.servlet;

import java.io.IOException;
import java.util.List;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import movie.canshu.*;
import movie.dao.*;
public class MoivesServlet extends HttpServlet {


	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		request.setCharacterEncoding("UTF-8");
		System.out.print("222");
		MovieDao gd = new MovieDao();
		List<movies> lm = gd.findMovies();
		
		HttpSession session = request.getSession();
		session.setAttribute("lms", lm);
		response.sendRedirect("../index.jsp");
		
		
	}


	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		doPost(request,response);
		System.out.print("111");
	}

}
