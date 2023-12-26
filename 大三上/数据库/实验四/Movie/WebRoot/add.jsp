<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page language="java" import="movie.canshu.*" %>
<%@ page language="java" import="movie.dao.*" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'add.jsp' starting page</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
		
  </head>
  
  <body>
            <form action ="/Movie/servlet/addMovies" method="post">
     
     序号<input type="text" name="id" id = "id" > <br>
  电影名<input   type="text" name="name" id="name">  <br>
    类型<input   type="text" name="type" id="type">  <br>
      喜爱程度<input   type="text" name="price" id="price">  <br>
  
  <input type="submit"  value="确认爱了"  >  
     
     </form>
  </body>
</html>
