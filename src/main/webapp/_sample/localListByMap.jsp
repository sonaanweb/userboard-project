<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>
<%@ page import = "java.util.*" %>
<%
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	PreparedStatement stmt = null; 
	ResultSet rs = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	//--- 첫번째 쿼리
	String sql = "SELECT local_name localName, '대한민국' country, '박성환' worker FROM local LIMIT 0,1"; //LIMIT 1개 출력
	stmt = conn.prepareStatement(sql);
	rs = stmt.executeQuery(); //executeQuery 메서드: DB 데이터를 가져와서 결과 집합을 반환. Select 문에서만 실행하는 특징이 있음
	
	// VO 대신 HashMap타입을 사용

	// ★ 중요! HashMap 키로 사용할 것, 실제 들어오는 값. 총 두개 지정 (키, 실제들어오는 값=Object(=*모든값이 들어올 수 있음))
	HashMap<String, Object> map = null;
	if(rs.next()) {
		/* 디버깅
		System.out.println(rs.getString("localName"));
		System.out.println(rs.getString("country"));
		System.out.println(rs.getString("worker")); */ 
		map = new HashMap<String, Object>();
		map.put("localName",rs.getString("localName")); //앞에 값 키 -string, 값 -object = map.put(키이름,값)
		map.put("country",rs.getString("country"));
		map.put("worker",rs.getString("worker"));
	}
	System.out.println(map.get("localName"));
	System.out.println(map.get("country"));
	System.out.println(map.get("worker")); // vo타입을 만들지 않아도 되는 장점이 있다.
	
	//--- 두번째 쿼리
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	String sql2 = "SELECT local_name localName, '대한민국' country, '박성환' worker FROM local";
	stmt2 = conn.prepareStatement(sql);
	rs2 = stmt.executeQuery();
	
	// List는 무조건 여러개 만드는 것. 길이가 아닌 아닌 사이즈를 뽑는 것이기 때문에 (개수는 상관 없다)
	/*	1) length : 배열의 길이 출력 = int[]arr = new int[100]; -> sysout(arr.length); = 100
		2) length() : 문자열의 길이 출력 = String str = "abc"; -> sysout(str.length()); = 3
		3) size() : add 타입의 길이 출력(add된 수) = ArrayList<integer> intlist = new ArrayList<>(); -> sysout(intlist.size()); = 0 */ 
	ArrayList<HashMap<String,Object>> list = new ArrayList<HashMap<String,Object>>();
	while(rs2.next()) {
		HashMap<String,Object> m = new HashMap<String, Object>();
		m.put("localName", rs2.getString("localName"));
		m.put("country", rs2.getString("country"));
		m.put("worker", rs2.getString("worker"));
		list.add(m);
	}
	
	//--- 세번째 쿼리 count 그룹화
	PreparedStatement stmt3 = null;
	ResultSet rs3 = null;
	String sql3 = "SELECT local_name localName, COUNT(local_name) cnt FROM board GROUP BY local_name";
	stmt3 = conn.prepareStatement(sql3);
	rs3 = stmt3.executeQuery();
	ArrayList<HashMap<String, Object>> list3 = new ArrayList<HashMap<String, Object>>();
	while(rs3.next()) {
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("localName", rs3.getString("localName")); // map.put(키이름, 값)
		m.put("cnt", rs3.getInt("cnt")); //cnt=count
		list3.add(m);		
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>localListByMap</title>
</head>
<body>
	<div>
	<h2>rs1 결과셋</h2>
		<%=map.get("localName")%>
		<%=map.get("country")%>
		<%=map.get("worker")%>
	</div>

	<hr> <!-- 선 표시 태그 -->
	<h2>rs2 결과셋</h2>
	<table>
		<tr>
			<th>localName</th>
			<th>country</th>
			<th>worker</th>
		</tr>
		<%
			for(HashMap<String, Object> m : list){
		%>
			<tr>
				<td><%=m.get("localName")%></td>
				<td><%=m.get("country")%></td>
				<td><%=m.get("worker")%></td>
			</tr>
		<%
			}
		%>
	</table>
	
	<hr>
	<h2>rs3 결과셋</h2>
		<ul>
			<li>
				<a href="">전체</a>
			</li>
			<%
				for(HashMap<String, Object> m : list3) {
			%>
				<li>
					<a href="">
						<%=(String)m.get("localName")%>(<%=(Integer)m.get("cnt")%>)
					</a>
				</li>
			<%
				}
			%>
		</ul>
</body>
</html>