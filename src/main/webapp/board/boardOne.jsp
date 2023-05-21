<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.util.*" %>
<%
	
	request.setCharacterEncoding("utf-8");
	
	// 유효성 검사
	if(request.getParameter("boardNo") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;	
	}
	
	// 로그인 세션 유효성 검사 -- 수정/삭제 기능
	String loginMemberId = "";
	if(session.getAttribute("loginMemberId") != null) {
		loginMemberId = (String)session.getAttribute("loginMemberId"); // 현재 로그인 사용자
	}
	
	// 게시판 번호 불러오기
	// 1. 컨트롤러 계층
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	// ------ 페이징
	int currentPage = 1;
	int rowPerPage = 10;
	int startRow = 0;
	
	// 유효성 검사
	if(request.getParameter("boardNo") == null
	|| request.getParameter("boardNo").equals("")) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	//System.out.println(boardNo + "<----");
	
	// 2. 모델 계층
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	// 보여질 게시판 내용 7개(전부)
	// SELECT
	// executeQuery
	/*
		SELECT board_no boardNo, local_name localName,
		board_title board Title, board_content boardContent,
		member_id memberId,
		createdate, updatedate
		FROM board WHERE board_no = ?
	*/
// 2-1) board one 결과셋 ------------------------------------------------------------
	PreparedStatement boardStmt = null;
	ResultSet boardRs = null;
	String boardSql = "SELECT board_no boardNo, local_name localName, board_title boardTitle, board_content boardContent, member_id memberId, createdate, updatedate FROM board WHERE board_no = ?";
	boardStmt = conn.prepareStatement(boardSql);
	boardStmt.setInt(1,boardNo);
	boardRs = boardStmt.executeQuery();// row -> board타입 필요
	
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
// 2-2) comment list 결과셋 ---------------------------------------------------------
	PreparedStatement commentStmt = null;
	ResultSet commentRs = null;
	String commentSql = "SELECT comment_no commentNo, board_no boardNo, comment_content commentContent, member_id memberId, createdate, updatedate FROM comment WHERE board_no =? ORDER BY createdate DESC LIMIT ?,?";
	commentStmt = conn.prepareStatement(commentSql);
	commentStmt.setInt(1,boardNo);
	commentStmt.setInt(2,startRow);
	commentStmt.setInt(3,rowPerPage);
	commentRs = commentStmt.executeQuery(); // row -> ArrayList<Comment> 필요
	
	// 댓글 arrayList 배열
	ArrayList<Comment> commentList = new ArrayList<Comment>();
	while(commentRs.next()){ // 내용, id, 게시, 수정일
		Comment c = new Comment();
		c.setCommentNo(commentRs.getInt("commentNo"));
		c.setBoardNo(commentRs.getInt("boardNo"));
		c.setCommentContent(commentRs.getString("commentContent"));
		c.setMemberId(commentRs.getString("memberId"));
		c.setCreatedate(commentRs.getString("createdate"));
		c.setUpdatedate(commentRs.getString("updatedate"));
		commentList.add(c);	
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
<title>상세페이지</title>
</head>
<body>
	<!-- 메인메뉴 -->
	<div class="container mt-3">
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	 
	<br>
	<h2 style="text-align: center">게시글 상세정보</h2>
	<hr>
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
	<table class="table">
	<!-- 3-1) board one 결과셋 ------------------------------------------------------------>
		<tr>
			<td>board_no</td>
			<td><%=one.getBoardNo()%></td>
		</tr>
		<tr>
			<td>지역명</td>
			<td><%=one.getLocalName()%></td>
		</tr>
		<tr>
			<td>제목</td>
			<td><%=one.getBoardTitle()%></td>
		</tr>
		<tr>
			<td>내용</td>
			<td><%=one.getBoardContent()%></td>
		</tr>
		<tr>
			<td>작성자</td>
			<td><%=one.getMemberId()%></td>
		</tr>
		<tr>
			<td>게시일</td>
			<td><%=one.getCreatedate()%></td>
		</tr>
		<tr>
			<td>수정일</td>
			<td><%=one.getUpdatedate()%></td>
		</tr>
	</table>
	<!----- 게시글의 작성자와 로그인 한 사용자가 일치할 때만 수정 삭제 버튼 보이게 하기 ------------------->
	<%
		if(loginMemberId != null && loginMemberId.equals(one.getMemberId())) {
	%>
	<div>
		<a href="<%=request.getContextPath()%>/board/updateBoard.jsp?boardNo=<%=one.getBoardNo()%>" class="btn btn-light">수정</a>
		<a href="<%=request.getContextPath()%>/board/deleteBoard.jsp?boardNo=<%=one.getBoardNo()%>&memberId=<%=one.getMemberId()%>" class="btn btn-light">삭제</a>
	</div>
	<%
		}
	%>
	<!------------------------------------------------------------------------------------->
	
	<!-- 3-2) comment 입력 : 세션유무에 따른 분기 -->
	<br>
	<%
		// 로그인한 사용자에게만 댓글 입력 허용
		if(session.getAttribute("loginMemberId")!=null){
	%>
	<div>
		<form action="<%=request.getContextPath()%>/board/insertCommentAction.jsp">
			<input type="hidden" name="boardNo" value="<%=one.getBoardNo()%>">
			<input type="hidden" name="memberId" value="<%=loginMemberId%>"> <!-- 로그인한 아이디. 불러온 값 -->
			<table class="table2">
				<tr>
					<td style="padding-right: 5pt;">boardNo</td>
					<td>
					<input type="text" name="boardNo" value="<%=one.getBoardNo()%>">
					</td>
				</tr>
				<tr>
					<td style="padding-right: 5pt;">comment</td>
					<td>
						<textarea rows="2" cols="100" name="commentContent" placeholder="내용을 입력하세요"></textarea>
					</td>
					<th>
					<button type="submit" class="btn btn-light">댓글입력</button> <!-- 입력시 boardNo, commentcontent같이 넘어감 -->
					</th>
				</tr>
			</table>
		</form>	
	</div>	
	<%	
		}
	%>
	<!-- 3-3) comment list 결과셋 ----------------------------------------------------------->
	<table class="table table-borderless">
		<tr style="background-color: #F6F6F6;">
			<th>작성자</th>
			<th>내용</th>
			<th>작성일</th>
			<th>수정일</th>
			<th></th>
			<th></th>
		</tr>
		<%
			for(Comment c : commentList){
		%>
		<tr>
			<td><%=c.getMemberId()%></td>
			<td style="width : 50%;"><%=c.getCommentContent()%></td>
			<td><%=c.getCreatedate()%></td>
			<td><%=c.getUpdatedate()%></td>
			<% 
				if (loginMemberId.equals(c.getMemberId())) { 
			%>
			<td>
				<a href="<%=request.getContextPath()%>/board/updateCommentForm.jsp?boardNo=<%=c.getBoardNo()%>&commentNo=<%=c.getCommentNo()%>&memberId=<%=c.getMemberId()%>&commentContent=<%=c.getCommentContent()%>" class="btn btn-success" style="font-size: 12px;">수정</a>
			</td>
			<td>
				<a href="<%=request.getContextPath()%>/board/deleteCommentAction.jsp?commentNo=<%=c.getCommentNo()%>&boardNo=<%=c.getBoardNo()%>&memberId=<%=c.getMemberId()%>" class="btn btn-success" style="font-size: 12px;">삭제</a>
			</td>
		<%
			}
		%>
		</tr>
		<%
			}
		%>
	</table>
	<div>
		<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>&currentPage=<%=currentPage-1%>">
		이전
		</a>
		<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>&currentPage=<%=currentPage+1%>">
		다음
		</a>
	</div>
	<br>
	<jsp:include page="/inc/copyright.jsp"></jsp:include>
	<br>
</div>
</body>
</html>