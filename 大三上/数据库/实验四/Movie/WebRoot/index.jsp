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
    
    <title>My JSP 'index.jsp' starting page</title>
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
     <table>
  <tr>
  <td>序号</td>
    <td>电影名</td>
      <td>类型</td>
        <td>热爱百分度</td>
    <td>操作</td>
    </tr>
    
    <%
    List<movies> lm = (List<movies>) session.getAttribute("lms");
    for(movies m:lm){
    %>
     <tr>
  <td><%=m.getId() %></td>
    <td><%=m.getName() %></td>
      <td><%=m.getType() %></td>
        <td><%=m.getPrice() %></td>
    <td>  <a href="servlet/deleteMovies?id=<%=m.getId()%>" >删除</a> </td>
        <%} %>
    </tr>
    
    <td>  <a href="add.jsp" >新增我的最爱</a>
     
    
  </table>
  </body>
</html>
