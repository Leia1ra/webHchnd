function passwordCheck(context){
    let Error = document.getElementById("Error");
    let nowPwd = document.getElementById("nowPwd");
    Error.innerHTML = "";
    Error.style.display = "none";
    let pw = document.getElementById("Pw");
    let PwCheck = document.getElementById("Pw_Check");

    let errCount = 0;

    if(nowPwd.value === pw.value){
        nowPwd.style.borderColor = "red";
        Error.innerHTML = "입력한 현재 비밀번호와 새 비밀번호의 값이 같습니다.";
        Error.style.display = "block";
        nowPwd.style.borderColor = "red";
        ++errCount;
    }
    if(nowPwd.value===""){
        nowPwd.style.borderColor = "red";
        Error.innerHTML = "비밀번호를 입력하세요.";
        Error.style.display = "block";
        nowPwd.style.borderColor = "red";
        ++errCount;
    }
    if(pw.value===""){
        pw.style.borderColor = "red";
        PwCheck.value = "";
        pw.placeholder = "비밀번호를 입력하세요";
        ++errCount;
    }
    if(pw.value !== PwCheck.value){
        PwCheck.style.borderColor = "red";
        PwCheck.value = "";
        PwCheck.placeholder = "비밀번호가 같지 않습니다";
        ++errCount;
    }

    if(errCount > 0){
        return false;
    } else {
        $.ajax({
            url:context+"/account/pwValidationCheck",
            data:"nowPwd="+nowPwd.value+"&pwd="+pw.value,
            type:"POST",
            success:function(result){
                if(result === 0){
                    document.getElementById("pwChangeAction").submit();
                } else if(result === 1){
                    Error.innerHTML = "업데이트에 실패하였습니다."
                    Error.style.display = "block";
                    nowPwd.style.borderColor = "red";
                } else if(result === 2) {
                    Error.innerHTML = "일치하지 않은 비밀번호입니다."
                    Error.style.display = "block";
                    nowPwd.style.borderColor = "red";
                }
            },
            error:function(e){
                console.log(e.responseText);
            }
        });
        // Ajax 요청이 완료될 때까지 기다리지 않고 바로 리턴하지 않음
        return false;
    }
}