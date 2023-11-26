<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<head>
	<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/account/dashBoard/DashBoard.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
	<script src="<%=request.getContextPath()%>/resources/main/account.js"></script>
	<script src="<%=request.getContextPath()%>/resources/account/dashBoard/DashBoard.js"></script>
	<script>
		window.onload=function(){
			progress();
		}
	</script>
</head>

<!--Bodies-->
<section id="container">
	<!--header-->
	<header id="MainHeader">
		<h2>Dash Board</h2>
		<span></span>
	</header>
	<!--Contents-->
	<article id="MainSection">
		<div id="user">
			<div id="profile">
				<div id="dashBoardProfileImg">
					<img src="<%=request.getContextPath()%>/img/userProfile/${profileImg}">
				</div>
				<div id="info">
					<div class="infoData">
						<span>Email </span>
						<h3>${logEmail}</h3>
					</div>
					<div id="AccInfo">
						<div class="infoData">
							<span>Username</span>
							<h4>${logName}</h4>
						</div>
						<div class="infoData" style="margin-left: 15px">
							<span>UID</span>
							<h4>${logId}</h4>
						</div>
					</div>
					<div id="link">
						<a href="<%=request.getContextPath()%>/account/myPage">Edit profile</a>
						<a href="../Program/Program.html">Edit program</a>
					</div>
				</div>
			</div>

			<hr style="width: 100%">

			<div id="level">
				<div id="myProgram">
					<div id="progressImg">
						<img src="<%=request.getContextPath()%>/img/program" alt="">
					</div>

					<div id="progInfo">
						<div>
							<span>진행중</span>
							<a href="#">관리</a>
						</div>
						<div>
							<span>Strong Lift 5X5</span>
							<span>(8 weeks)</span>
						</div>
						<div id="achieve">
							<!--<span>달성률 52%</span>-->
							<!--<span>13/25 회차</span>-->
						</div>

					</div>
				</div>
				<progress id="prgs" max="100"></progress>
			</div>

		</div>
		
		<span id="line"></span>
		
		<div id="progress">
			<div id="prgDate">
				<button> < </button>
				<h3>2023-10-17</h3>
				<button> > </button>
			</div>

			<form action="">
				<div id="prgsData">
					<div class="exercises">
						<label>
							<span>스쿼트</span>
							<span>140kg</span>
							<span>
								5reps * 5set
								<input type="checkbox" value="success">
							</span>
						</label>
					</div>

					<div class="exercises">
						<label>
							<span>스쿼트</span>
							<span>140kg</span>
							<span>
								5reps * 5set
								<input type="checkbox" value="success">
							</span>
						</label>
					</div>
					<div class="exercises">
						<label>
							<span>스쿼트</span>
							<span>140kg</span>
							<span>
								5reps * 5set
								<input type="checkbox" value="success">
							</span>
						</label>
					</div>
				<input type="submit" id="warn" value="오.운.완!">
				</div>
			</form>

		</div>
	</article>
</section>
