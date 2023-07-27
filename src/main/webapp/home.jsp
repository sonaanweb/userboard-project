<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	
	response.setCharacterEncoding("utf-8");

	/* <!--컨트롤러 계층-->
		1. 요청분석
		1) session JSP내장(기본)객체
		2) request / response JSP내장(기본)객체	*/
		
	// 페이징 -----------------------------------------------------------
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){ //null값이 아니면 그대로 출력
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	int rowPerPage = 10; //페이지당 출력 될 행의 수
	
	int startRow = (currentPage-1)*rowPerPage; // maria DB 페이징 알고리즘 * 시작행 번호 0부터
	int totalRow = 0; // 출력될 총 행의 수 
	
	int pageCount = 5; // 하단 페이징 버튼 수
	int startPage = ((currentPage - 1) / pageCount) * pageCount + 1; //페이징 버튼 시작 값
	int endPage = startPage + pageCount - 1; // 페이징 종료 값
	
	// -------------------------------------------------------------------
	
	String localName = "전체"; // null<->전체. 따라서 기본값 전체로 설정. 굳이 조건 세개로 늘릴 필요 없다.
	if(request.getParameter("localName") != null) { // 전체가 아니면, 해당 localName으로 뜬다
		localName = request.getParameter("localName");
	}
	/*System.out.println(localName + "<----home localname"); == 전체*/
	
	// 2. 모델 계층
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	
	//------ 서브메뉴 결과셋 (모델) ------
	PreparedStatement subMenuStmt = null;
	ResultSet subMenuRs = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	/*
	SELECT '전체' localName, COUNT(local_name) cnt FROM board
	UNION ALL
	SELECT local_name, COUNT(local_name) FROM board GROUP BY local_name;
	*/
	String subMenuSql = "SELECT '전체' localName, COUNT(local_name) cnt FROM board UNION ALL SELECT local_name, COUNT(local_name) FROM board GROUP BY local_name";
	subMenuStmt = conn.prepareStatement(subMenuSql);
	subMenuRs = subMenuStmt.executeQuery();
	
	// subMenuList 모델데이터 - 지역 카테고리 목록 개수
	// HashMap <키값,실제들어오는 값 Object(=*모든값이 들어올 수 있음)>
	ArrayList<HashMap<String, Object>>subMenuList = new ArrayList<HashMap<String, Object>>();
	while(subMenuRs.next()) {
	HashMap<String, Object> m = new HashMap<String, Object>();
	m.put("localName", subMenuRs.getString("localName"));
	m.put("cnt", subMenuRs.getInt("cnt"));
	subMenuList.add(m);
	}
	
	//------ 게시판 목록 결과셋(모델) ------
	
	PreparedStatement boardStmt = null;
	ResultSet boardRs = null; //pstmt를 받을 값
	/*
	 select no, local name, title 최신글 보이게 하기
	 1. if 로컬네임이 전체인 경우에는 전체리스트 최신순으로 보여주고 (order by createdate desc..)
	 2. else 로컬네임에 따른 리스트를 보여준다. (where local_name=? order by updatedate desc..)
	 	
	 	SELECT	
	 		board_no boardNo,
	 		local_name localName,
	 		board_title boardTitle,
	 		createdate
	 	From board
	 	(WHERE local_name = ?)
	 	ORDER BY createdate DESC
	 	LIMIT ?,?
	*/
	
	// ------ 보드 쿼리 ----------------
	
	String boardSql = ""; //null로 초기화 하면 equals를 사용하지 못 함
	// boardStmt = conn.prepareStatement(boardSql); // 밖에 빼주면 안에 따로 넣지 않아도 됨
	if(localName.equals("전체")){ // where절 없을 때 '?' -- 2개
		boardSql = "SELECT board_no boardNo, local_name localName, board_title boardTitle, createdate FROM board ORDER BY createdate DESC LIMIT ?,?";
		boardStmt = conn.prepareStatement(boardSql);
		boardStmt.setInt(1,startRow);
		boardStmt.setInt(2,rowPerPage);
	} else { // where절 있을 때 '?' -- 3개
		boardSql = "SELECT board_no boardNo, local_name localName, board_title boardTitle, createdate FROM board WHERE local_name=? ORDER BY createdate DESC LIMIT ?,?";
		boardStmt = conn.prepareStatement(boardSql);
		boardStmt.setString(1, localName);
		boardStmt.setInt(2, startRow);
		boardStmt.setInt(3, rowPerPage);
	}
	System.out.println(boardStmt+"<--home boardStmt");
	boardRs = boardStmt.executeQuery(); // DB쿼리 결과셋 모델 
	// 모델데이터. 애플리케이션에서 사용할 모델 null 사용 지양 & boardRs -> boardList
	ArrayList<Board> boardList = new ArrayList<Board>(); // 사이즈0
	while(boardRs.next()) {
		Board b = new Board();//꼭 {} 안쪽에 집어넣기
		b.setBoardNo(boardRs.getInt("boardNo"));
		b.setLocalName(boardRs.getString("localName"));
		b.setBoardTitle(boardRs.getString("boardTitle"));
		b.setCreatedate(boardRs.getString("createdate"));
		boardList.add(b);
	}		
	
	// 페이징 마지막 설정 ---------------------
	// 전체 행 쿼리
	/* String totalRowSql = "SELECT count(*) FROM board";
	PreparedStatement totalStmt = conn.prepareStatement(totalRowSql);
	ResultSet totalRs = null;
	totalRs = totalStmt.executeQuery();
	System.out.println("totalStmt-->"+totalStmt);
	System.out.println("totalRs-->"+totalRs);
			
	//전체 페이지수
	if(totalRs.next()){
		totalRow=totalRs.getInt("count(*)");
	}
	*/
	// 카테고리 정보에 따라 전체 게시글 수를 다르게 조회하도록 변경
	if (localName.equals("전체")) { // 카테고리 네임이 "전체"일 때는 모든 테이블을 select하고,
	    String totalRowSql = "SELECT COUNT(*) FROM board";
	    PreparedStatement totalStmt = conn.prepareStatement(totalRowSql);
	    ResultSet totalRs = totalStmt.executeQuery();

	    if (totalRs.next()) {
	        totalRow = totalRs.getInt(1);
	    }
	} else { // 카테고리 네임을 따로 선택했을 시 해당 카테고리내 게시글만 select 된다.
	    String totalRowSql = "SELECT COUNT(*) FROM board WHERE local_name=?";
	    PreparedStatement totalStmt = conn.prepareStatement(totalRowSql);
	    totalStmt.setString(1, localName);
	    ResultSet totalRs = totalStmt.executeQuery();

	    if (totalRs.next()) {
	        totalRow = totalRs.getInt(1);
	    }
	}
	int lastPage = totalRow/rowPerPage;
	
	//마지막 페이지의 나머지가 0이 아니면 페이지수 1추가
	if(totalRow%rowPerPage!=0){
		lastPage++;
	}
	
	int totalPage = (int) Math.ceil(totalRow / (double) rowPerPage); //출력할 전체 페이지 수
	
	// 추가로 조건 설정
	if(currentPage > totalPage){
		currentPage = totalPage;
	}
	
	if(endPage > totalPage){
		endPage = totalPage;
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<title>home</title>
<!-- 부트스트랩5 사용 -->
<style>
.ul2 {
  list-style-type: none;
  margin: 0;
  padding: 0;
  width: 200px;
  background-color: #f1f1f1;
}

.li2 a {
  display: block;
  color: #000;
  padding: 8px 16px;
  text-decoration: none;
}

.li2 a:hover:not(.active) {
  background-color: #555;
  color: white;
}
a{text-decoration: none;}
.page-link{
color: black;}
.page-link:hover {
	color:green;
}
</style>
</head>
<body>
	<!--- 뷰 계층 --------------------------------------------------------------------------------->
	<div class="container mt-3">
	<!--- 메인메뉴(가로) ---------------------------------------------------------------------------->
		<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
		</div>
	<!--- 로그인 폼 메인메뉴바로 옮김 ------------------------------------------------------------------>
	<!-- home이 받는 메세지 출력 -->
	<div>
		<%
			if(request.getParameter("msg") != null){
		%>
			<div style="color: #22741C" align="center"><%=request.getParameter("msg")%></div>
		<%
			}
		%>
	</div>
	<!--- 서브메뉴(세로)subMenuList모델을 출력 -------------------------------------------------------->
	<br>
<!-- 
<div class="dropdown">
  <button class="btn btn-secondary dropdown-toggle" type="button" id="dropdownMenu2" data-bs-toggle="dropdown" aria-expanded="false">
    Dropdown
  </button>
  <ul class="dropdown-menu" aria-labelledby="dropdownMenu2">
    <li><button class="dropdown-item" type="button">Action</button></li>
    <li><button class="dropdown-item" type="button">Another action</button></li>
    <li><button class="dropdown-item" type="button">Something else here</button></li>
  </ul>
</div>
 -->
		<div>
			<ul class="ul2">
	         <%
	            for(HashMap<String, Object> m : subMenuList) {
	         %>
		<li class="li2">
		<a href="<%=request.getContextPath()%>/home.jsp?localName=<%=(String)m.get("localName")%>">
		<%=(String)m.get("localName")%>(<%=(Integer)m.get("cnt")%>)
	    </a>
		</li>
	         <%      
	            }
	         %>
	      	</ul>
		</div>
	<!--- 로그인 유효할 시 보이는 게시글 추가 버튼 -->
	<br>
		<div>
		<h2>최근 게시글 목록&#128194;</h2>
	<%
	     if(session.getAttribute("loginMemberId") != null) { // 로그인 상태여야 게시글 추가 버튼 보임
	%>
	     <a href="<%=request.getContextPath()%>/board/insertBoard.jsp" style="float: right;">&#9997;추가</a>
	<%
	      	}
	%>
	<!---[시작]최근 게시글 목록 ------------------------------------------------------------------------>
		<table class="table">
			<tr>
				<th>지역</th>
				<th>제목</th>
				<th>작성일</th>
			</tr>
		<%
			for(Board b : boardList) {
		%>
			<tr>
				<td><%=b.getLocalName()%></td> <!-- vo -->
				<td>
				<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=b.getBoardNo()%>">
				<%=b.getBoardTitle()%>
				</a>
				</td>
				<td><%=b.getCreatedate()%></td>
			</tr>
		<%
			}
		%>
		</table>
		</div>
	<!---페이징 버튼----------------------------------------------------------------------------------->
		<div class="container mt-3">
		<ul class="pagination">
		<%
			if(currentPage > pageCount){ //이전 페이지 버튼
		%>
			<li class="page-item">
			<a class="page-link" href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=startPage-5 %>&localName=<%=localName%>">
	   		이전
	   		</a>
	   		</li>
	   	<%
			}
			for(int i = startPage; i <= endPage; i++){
			if(i==currentPage){
	    %>
			<li class="page-item">
			<a class="page-link" href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=i %>&localName=<%=localName%>">
			<%=i %>
			</a>
			</li>
	    <%
	        }else{
	   	%>
			<li class="page-item">
			<a class="page-link" href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=i %>&localName=<%=localName%>">
			<%=i %>
			</a>
			</li>
	       <%
	       		}
	        }
	    	if(currentPage < (lastPage-pageCount+1)){ // 다음페이지 버튼
	       %>
			<li class="page-item">
			<a class="page-link" href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=endPage+1 %>&localName=<%=localName%>">
			다음
			</a>
			</li>
		<%
			}
		%>
	</ul>
	</div>
		
	<!---[끝]-------------------------------------------------------------------------------------->
		<!-- 자주 쓰는 자바 태그 -> JSP 태그(액션태그) -> 태그라이브러리 -->
	<!-- include 페이지 :  Copyright &copy; 구디아카데미 ---------------------------------------------->
		<% //자바태그
		//request.getRequestDispatcher(request.getContextPath()+"/inc/copyright.jsp").include(request, response);
		//위 코드를 아래 코드로 변경하면 아래와 같다.	
		//+)절대주소 상대주소
		%>
		<jsp:include page="/inc/copyright.jsp"></jsp:include>
	</div>
<br>
</body>
</html>