<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<head>
	<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/account/join/join.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
	<script src="<%=request.getContextPath()%>/resources/account/join/join.js"></script>
</head>
	
<!--Bodies-->
<section id="container">
	<!--Contents-->
	<article id="MainSection">
		<!--LogIn-->
		<h2>회원가입</h2>
		<form action="<%=request.getContextPath()%>/account/joinAction"
			  method="post" id="JoinActionForm"
			  onsubmit="return validationCheck('<%=request.getContextPath()%>')">
			<div id="formInput">
				<div id="Error" style="color: red; display: none;"></div>
				<input type="text" name="emailID" id="Id" placeholder="이메일을 입력하세요.">
				<hr>
				<input type="password" name="pwd" id="Pw" placeholder="비밀번호를 입력하세요." minlength="8" maxlength="20">
				<input type="password" id="Pw_Check" placeholder="비밀번호를 다시 입력하세요." minlength="8" maxlength="20">
			</div>
			<div id="formClick">
				<div>
					<a href="<%=request.getContextPath()%>/account/logIn">로그인</a><br>
					<a href="#">아이디/비밀번호 찾기</a>
				</div>
				<label>
					<a href="#">약관동의</a>
					<input type="checkbox" name="TERMS" id="Terms" value="checked">
				</label>
			</div>
			<input type="submit" value="회원가입">
		</form>
	</article>
</section>
