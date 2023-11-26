<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<head>
	<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/account/log/logInStyle.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
	<script src="<%=request.getContextPath()%>/resources/account/log/logControl.js"></script>
</head>

<!--Bodies-->
<section id="container">
	<!--Contents-->
	<article id="MainSection">
		<!--LogIn-->
		<h2>로그인</h2>
		<form action="<%=request.getContextPath()%>/account/logInAction"
			  method="post" id="LogInActionForm"
			  onsubmit="return LogCheck('<%=request.getContextPath()%>')">
			<div id="formInput">
				<div id="Error" style="color: red; display: none;"></div>
				<input type="text" name="emailID" id="Id" placeholder="아이디를 입력하세요">
				<input type="password" name="pwd" id="Pw" placeholder="비밀번호를 입력하세요">
			</div>
			<div id="formClick">
				<div>
					<a href="<%=request.getContextPath()%>/account/join">회원가입</a><br>
					<a href="#">아이디/비밀번호 찾기</a>
				</div>
				<label>
					<span>로그인 정보 기억</span>
					<input type="checkbox" name="AutoLogin" id="Auto" value="">
				</label>
			</div>
			<input type="submit" value="로그인">
		</form>
	</article>
</section>