<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 기존 세션을 지우고 갱신. session.invalidate(); -- 로그아웃 --> home 이동
	// 따로 폼이 존재하지 않고 메인메뉴창에 링크로만 만들어둠
	session.invalidate();
	response.sendRedirect(request.getContextPath()+"/home.jsp");
%>
