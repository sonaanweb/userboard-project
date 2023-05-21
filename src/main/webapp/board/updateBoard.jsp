<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.util.*" %>
<%

	// 1) 세션 유효성 검사
	if(session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	if(request.getParameter("boardNo") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	} 
	
	// null string error 기록
	// 게시판 번호 불러오기 & 요청값 저장
	String loginMemberId = (String)session.getAttribute("loginMemberId");
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	System.out.println(boardNo+"<---updateBoard boardNo");
	
	// 2. 모델 계층
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	//보여질 게시판 내용 7개(전부)
	/*
		SELECT board_no boardNo, local_name localName,
		board_title board Title, board_content boardContent,
		member_id memberId,
		createdate, updatedate
		FROM board WHERE board_no = ?
	*/
	// 2-1) board one 결과셋
	PreparedStatement boardStmt = null;
	ResultSet boardRs = null;
	
	String boardSql = "SELECT board_no boardNo, local_name localName, board_title boardTitle, board_content boardContent, member_id memberId, createdate, updatedate FROM board WHERE board_no = ?";
	boardStmt = conn.prepareStatement(boardSql);
	boardStmt.setInt(1,boardNo);
	boardRs = boardStmt.executeQuery();// row -> board타입 필요
	
	ResultSet rs = boardStmt.executeQuery();
	Board one = new Board();
	if(boardRs.next()){ //캡슐화_set*get과 구분하기 위해 변수명 앞 대문자
		one.setBoardNo(boardRs.getInt("boardNo"));
		one.setLocalName(boardRs.getString("localName"));
		one.setBoardTitle(boardRs.getString("boardTitle"));
		one.setBoardContent(boardRs.getString("boardContent"));
		one.setMemberId(boardRs.getString("memberId"));
		one.setCreatedate(boardRs.getString("createdate"));
		one.setUpdatedate(boardRs.getString("updatedate"));
	}
	
	// 게시글 수정 카테고리 지역명 선택 쿼리	
	String localsql = "SELECT local_name localName FROM local";
	PreparedStatement stmt = conn.prepareStatement(localsql);
	System.out.println(stmt+"<---update board local stmt");
	ResultSet rs2 = stmt.executeQuery();
	
	ArrayList<Local> localList = new ArrayList<Local>();
	while(rs2.next()){ //같은 페이지 내 rs값이 두개 이상일 때 설정한 변수값 잘 확인하기. 오류를 띄워주지 않음
		Local L = new Local();	
		L.setLocalName(rs2.getString("localName"));
		localList.add(L);
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<style>
a {text-decoration: none;}
</style>
<title>게시글 수정</title>
</head>
<body>
	<!-- 메인메뉴 -->
	<div class="container mt-3">
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	<br>
	<h2 style="text-align: center">게시글 수정하기</h2>
	<hr>
	<!-- 메세지 출력 -->
	<div>
	<%
		if(request.getParameter("msg") != null){
	%>
			<%=request.getParameter("msg")%>
	<%
		}
	%>
	</div>
	<!-------------->
	<form action="<%=request.getContextPath()%>/board/updateBoardAction.jsp?boardNo=<%=boardNo%>" method="post">
	<table class="table">
	<!------ board one과 폼은 동일하게, 단 게시글번호/작성자/게시일/수정일은 readonly ---------->
		<tr>
			<td>board_no</td>
			<td>
			<input type="text" name="boardNo" value="<%=one.getBoardNo()%>" readonly="readonly">
			</td>
		</tr>
		<tr>
			<td>지역명</td>
			<td>
				<select name="updateLocal">
				<option value="bagic">=====</option>
				<% 
						for (Local L: localList) {
				%>
	      		<option value="<%=L.getLocalName()%>">
	      		<%=L.getLocalName()%></option>
				<%
					} 
				%>
				</select>
			</td>
		</tr>
		<tr>
			<td>제목</td>
			<td>
			<input type="text" name="updateTitle" value="<%=one.getBoardTitle()%>">
			</td>
		</tr>
		<tr>
			<td>내용</td>
			<td>
			<textarea rows="5" cols="80" name="updateContent"><%=one.getBoardContent()%>
			</textarea>
			</td>
		</tr>
		<tr>
			<td>작성자</td>
			<td>
			<input type="text" name="memberId" value="<%=one.getMemberId()%>" readonly="readonly">
			</td>
		</tr>
		<tr>
			<td>게시일</td>
			<td>
			<input type="text" name="createdate" value="<%=one.getCreatedate()%>" readonly="readonly">
			</td>
		</tr>
		<tr>
			<td>수정일</td>
			<td>
			<input type="text" name="updatedate" value="<%=one.getUpdatedate()%>" readonly="readonly">
			</td>
		</tr>
	</table>
	<div>
		<button type=submit class="btn btn-light">수정</button>
		<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=one.getBoardNo()%>" class="btn btn-light">취소</a>	
	</div>
	<br>
	</form>
	</div>
</body>
</html>