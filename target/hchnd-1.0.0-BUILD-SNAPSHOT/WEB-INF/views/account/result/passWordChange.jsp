<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<head>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/account/log/pwChangeStyle.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="<%=request.getContextPath()%>/resources/account/log/pwChange.js"></script>
</head>

<!--Bodies-->
<section id="container">
    <!--Contents-->
    <article id="MainSection">
        <!--LogIn-->
        <h2>비밀번호 변경</h2>
        <form action="<%=request.getContextPath()%>/account/pwcAction"
              method="post" id="pwChangeAction"
              onsubmit="return passwordCheck('<%=request.getContextPath()%>')">
            <div id="formInput">
                <div id="Error" style="color: red; display: none;"></div>
                <input type="password" name="nowPwd" id="nowPwd" placeholder="현재 비밀번호를 입력하세요.">
                <hr>
                <input type="password" name="pwd" id="Pw" placeholder="새로운 비밀번호를 입력하세요." minlength="8" maxlength="20">
                <input type="password" id="Pw_Check" placeholder="새로운 비밀번호를 다시 입력하세요." minlength="8" maxlength="20">
            </div>
            <input type="submit" value="비밀번호 변경">
        </form>
    </article>
</section>
