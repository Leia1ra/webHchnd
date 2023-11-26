<%@ page import="com.web.hchnd.vo.ProfileVO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<head>
	<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/account/myPage/myPageStyle.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
	<script src="<%=request.getContextPath()%>/resources/main/account.js"></script>
	<script src="<%=request.getContextPath()%>/resources/account/myPage/GenControl.js"></script>
	<script>
		window.onload = function () {
			genControl(${pvo.gender});
			nickNameKeyUpCheck('${pvo.nickName}');
		}
	</script>
</head>
<!--Bodies-->
<section id="container" onclick="hideAccount('${logStatus}')">
	<!--Contents-->
	<article id="MainSection">
		<!--My Page-->
		<h2>마이 페이지</h2>
		<form action="<%=request.getContextPath()%>/account/myPageAction" method="post"
			  onsubmit="myPageSubmit()" enctype="multipart/form-data">
			<div id="account">
				<label>
					<img src="<%=request.getContextPath()%>/img/userProfile/${pvo.profileImgName}" alt="" id="myPageProfileImg">
					<input type="hidden" name="profileImgName" value="${pvo.profileImgName}">
					<input type="file" name="profileImg" id="upload" hidden="hidden"
						   accept="image/jpeg, image/png" onchange="imgUpLoad()">
					<div>
						<span>사진을 변경하려면</span>
						<span>클릭하세요</span>
					</div>
				</label>

				<div id="accInput">
					<div id="nickName">
						<input type="hidden" name="duplicatePass" id="duplicatePass" value="Y">
						<input type="text" name="nickName" id="userNickName"
							   placeholder="닉네임" value="${pvo.nickName}" required>
						<input type="button" id="CheckBtn" value="중복검사"
							   onclick="duplicateCheck('<%=request.getContextPath()%>','${logName}')">
					</div>
					<div id="authInfo">
						<input type="text" name="emailID" id="email" placeholder="이메일" value="${pvo.emailID}" readonly>
						<input type="button" id="changePW" value="비밀번호 변경"
							   onclick="location.href = '<%=request.getContextPath()%>/account/passWordChange'">
					</div>
					<div id="Info">
						<input type="text" name="createDate" placeholder="가입일" value="${pvo.createDate}" readonly>
						<input type="text" name="age" placeholder="연령" value="${pvo.age}">
						<select name="gender" id="Gender">
							<option value="0">비공개</option>
							<option value="1">남성</option>
							<option value="2">여성</option>
						</select>
					</div>
				</div>
			</div>

			<div id="progress">
				<div>
					<h3>나의스펙</h3>
					<div id="inbody">
						<label>
							<span>키</span>
							<input type="text" name="height" placeholder="(Cm)" value="${pvo.height}">
						</label>
						<label>
							<span>몸무게</span>
							<input type="text" name="weight" placeholder="(Kg)" value="${pvo.weight}">
						</label>
						<label>
							<span>골격근량</span>
							<input type="text" name="skm" id="skeletalMuscleMass" placeholder="(Kg)"value="${pvo.skm}">
						</label>
						<label>
							<span>체지방량</span>
							<input type="text" name="bfm" id="bodyFatMass" placeholder="(Kg)" value="${pvo.bfm}">
						</label>
					</div>
				</div>
				<div>
					<h3>진행중인 프로그램</h3>
					<div id="program">
						<img src="../Style/Fox.png" alt="">
					</div>
				</div>
			</div>

			<input type="submit" value="저장">
		</form>
	</article>
</section>
