<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.net.URLEncoder"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "vo.*" %>
<%
	response.setCharacterEncoding("utf-8");

	// 세션 & 요청값 유효성 검사
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}

	// 입력칸 유효하지 않을 시 안내메세지 출력 - 카테고리/제목/내용
	String msg =""; 
	if(request.getParameter("localName") == null
	|| request.getParameter("localName").equals("")// 공백 입력시 변화 없음. 요청 무효
	|| request.getParameter("boardTitle") == null
	|| request.getParameter("boardTitle").equals("")
	|| request.getParameter("boardContent") == null
	|| request.getParameter("boardContent").equals("")){
		msg = URLEncoder.encode("내용을 입력하세요", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/insertBoard.jsp?msg="+msg);
		return;
	}
	
	// 필요한 값 저장 (아이디/카테고리/제목/내용)
	String loginMemberId = (String)session.getAttribute("loginMemberId");
	String localName = request.getParameter("localName");
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	System.out.println(loginMemberId + " <-- insert boardAction MemberId");
	System.out.println(localName + " <-- insert boardAction localName");
	System.out.println(boardTitle + " <-- insert boardAction boardTitle");
	System.out.println(boardContent + " <-- insert boardAction boardContent");
	
	
%>