<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<head>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/program/programGen.css">
    <script src="<%=request.getContextPath()%>/resources/main/account.js"></script>
    <script>
        var selectDay;
        var clr;
        var pname = '${vo.prgname}';
        //달력
        let weekName = ["일", "월", "화", "수", "목", "금", "토"];

        function calendar(year, month) {
            let now = new Date(year, month - 1, 1);
            let nowDate = now.getDate();
            let y = now.getFullYear();
            let m = now.getMonth() + 1;
            let w = now.getDay();

            let lastDay = new Date(y, m, 0).getDate();

            let tag = "<div id = 'head'>" + y + "년 " + m + "월" + "</div>";

            tag += "<ul>";
            for (var i = 0; i < weekName.length; i++) {
                tag += "<li>" + weekName[i] + "</li>";
            }
            for (var i = 1; i <= w; i++) {
                tag += "<li>&nbsp;</li>";
            }

            let dayCounter = 1;
            tag += "<ul>";

            for (var i = 1; i <= lastDay; i++) {
                tag += "<li>" + i + "</li>";
                w = (w + 1) % 7;
                if (i % 7 == 0) { // 7일마다 줄바꿈
                    tag += "</ul><ul>";
                }
            }//

            tag += "</ul>";
            document.getElementById("cal_view").innerHTML = tag;

            let dateCells = document.querySelectorAll("#cal_view li");
            dateCells.forEach(cell => {
                cell.addEventListener("click", function () {
                    selectDay = this;
                    clr = selectDay.style.backgrounColor;
                    console.log(selectDay.style.backgroundColor);
                    // 이미 선택된 날짜라면 선택 해제
                    if (cell.innerText < 1 || weekName.includes(cell.innerText)) {
                        return;
                    } else if (cell.classList.contains("selected")) {
                        cell.classList.remove("selected")
                    } else {
                        cell.classList.add("selected");
                        // 선택된 날짜의 월과 일 출력
                        let selectedMonth = m;
                        let selectedDay = cell.innerText;
                        let selectedDateText = selectedMonth + "월 " + selectedDay + "일";
                        let selectedMainText = "";

                        selectedMainText += "<div class='planner' style = 'margin-bottom : 100px;'>"


                            + "<ul>"
                            + "<h1 style =' color : rgb(255,159,41);'>Squat 120kg 기준</h1>"
                            + "<li style = 'border : 5px solid white; border-radius:10px; width : 650px; height : 175px;'>"
                            + " <label for='squat' ></label>"
                            + " <label style = 'margin-left : 30px; margin-top : 20px;'>워밍업</label>"
                            + " <p style = 'margin-left : 50px;'>빈바(5회), 40kg(5회), 60kg(5회), 80kg(5회), 100kg(3회), 110kg(1회)</p>"
                            + " <label for='squat_main_set'  style = 'margin-left : 30px;'>메인세트<br><br></label>"
                            + " <input style = 'margin-left : 50px;' type='checkbox' id='squat_main_set1'>"
                            + " <label for='squat_main_set1'>120kg (5회)</label>"
                            + " <input type='checkbox' id='squat_main_set2'>"
                            + " <label for='squat_main_set2'>120kg (5회)</label>"
                            + " <input type='checkbox' id='squat_main_set3'>"
                            + " <label for='squat_main_set3'>120kg (5회)</label>"
                            + " <input type='checkbox' id='squat_main_set4'>"
                            + " <label for='squat_main_set4'>120kg (5회)</label>"
                            + " <input type='checkbox' id='squat_main_set5'>"
                            + " <label for='squat_main_set5'>120kg (5회)</label>"
                            + " </li>"


                            + "<h1 style =' color : rgb(255,159,41);'>BenchPress 45kg 기준</h1>"
                            + "<li style = 'border : 5px solid white; border-radius:10px;width : 650px; height : 175px';>"
                            + " <label for='bench_press'></label>"
                            + " <label style = 'margin-left : 30px;'>워밍업</label>"
                            + " <p style = 'margin-left : 50px;'>빈바(5회), 40kg(5회), 50kg(5회), 60kg(5회), 70kg(3회)</p>"
                            + " <label for='bench_press_main_set' style ='margin-left : 30px;' >&nbsp;메인세트<br><br></label>"
                            + " <input style = 'margin-left : 50px;' type='checkbox' id='bench_press_main_set1'>"
                            + " <label for='bench_press_main_set1'>45kg (5회)</label>"
                            + " <input type='checkbox' id='bench_press_main_set2'>"
                            + " <label for='bench_press_main_set2'>45kg (5회)</label>"
                            + " <input type='checkbox' id='bench_press_main_set3'>"
                            + " <label for='bench_press_main_set3'>45kg (5회)</label>"
                            + " <input type='checkbox' id='bench_press_main_set4'>"
                            + " <label for='bench_press_main_set4'>45kg (5회)</label>"
                            + " <input type='checkbox' id='bench_press_main_set5'>"
                            + " <label for='bench_press_main_set' >45kg (5회)</label>"
                            + "</li>"


                            + "<h1 style =' color : rgb(255,159,41);'>BarBellRow 45kg 기준</h1>"
                            + "<li style = 'border : 5px solid white; border-radius:10px; width : 650px; height : 175px;'>"
                            + " <label for='barbell_row'></label>"
                            + " <label style = 'margin-left : 30px;'>워밍업</label>"
                            + " <p style = 'margin-left : 50px;'>빈바(5회), 40kg(5회), 50kg(5회), 60kg(5회), 70kg(3회)</p>"
                            + " <label for='barbell_row_main_set' style = 'margin-left : 30px;'>메인세트<br><br></label>"
                            + " <input style = 'margin-left : 50px;' type='checkbox' id='barbell_row_main_set1'>"
                            + " <label for='barbell_row_main_set1'>45kg (5회)</label>"
                            + " <input type='checkbox' id='barbell_row_main_set2'>"
                            + " <label for='barbell_row_main_set2'>45kg (5회)</label>"
                            + " <input type='checkbox' id='barbell_row_main_set3'>"
                            + " <label for='barbell_row_main_set3'>45kg (5회)</label>"
                            + " <input type='checkbox' id='barbell_row_main_set4'>"
                            + " <label for='barbell_row_main_set4'>45kg (5회)</label>"
                            + " <input type='checkbox' id='barbell_row_main_set5'>"
                            + " <label for='barbell_row_main_set5'>45kg (5회)</label>"
                            + " </li>"
                            + " </ul>"
                            + " <button onclick = 'selectedDay12()' style = 'background-color : rgb(52,152,219); color:white; border-radius : 50px; font-weight : bold; padding : 15px 15px; font-size : 1.5rem; margin-left : 280px; margin-top : 30px;'>Set START Day</button>"
                            + " </div>"

                        document.getElementById("selected_date").innerHTML = selectedDateText;
                        document.getElementById("selected_Main").innerHTML = selectedMainText;
                    }
                });
            });

        }

        window.onload = function () {
            let now = new Date();
            let year = now.getFullYear();
            let month = now.getMonth() + 1;
            calendar(year, month);
        }

        function selectedDay12(pname) {
            selectDay.classList.remove("selected");
            //selectDay.classList.remove("selected");
            selectDay.classList.add("yellow_back");
            console.log(selectDay);
        }

    </script>
</head>

<body>

<section id="container" onclick="hideAccount('${logStatus}')">
    <!--Contents-->
    <article id="MainSection">
        <h2 style="text-align: center;">없는게 정상${vo.prgname}</h2>
        <div id="planContainer">
            <div id="main">
                <div id="cal_view"></div>
            </div>
            <button onclick = 'selectedDay12()' id="startDayBtn">Set START Day</button>
        </div>

        <div id="selected_date"></div>
        <div id="selected_Main"></div>
    </article>
    <h2 style="text-align: center;">프로그램 시작요일을 선택해주세요</h2>
</section>


</body>