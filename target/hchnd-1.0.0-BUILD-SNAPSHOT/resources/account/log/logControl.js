function LogCheck(context) {
    let Error = document.getElementById("Error");
    let userid = document.getElementById("Id");
    let UserPw = document.getElementById("Pw");
    console.log(userid.value);
    console.log(UserPw.value);

    let errCount = 0;
    if(userid.value===""){
        userid.style.borderColor = "red";
        userid.placeholder = "이메일을 입력하세요.";
        userid.value = ""
        Error.style.display = "none";
        ++errCount;
    }
    if(UserPw.value===""){
        UserPw.style.borderColor = "red";
        UserPw.value = "";
        UserPw.placeholder = "비밀번호를 입력하세요";
        Error.style.display = "none";
        ++errCount;
    }

    if(errCount > 0){
        return false;
    } else {
        $.ajax({
            url:context+"/account/accountCheck",
            data:"emailID="+userid.value,
            type:"POST",
            success:function(result){
                if(result){
                    Error.innerHTML = "존재하지 않는 메일입니다."
                    Error.style.display = "block";
                    userid.style.borderColor = "red";
                } else {
                    $.ajax({
                        url:context+"/account/auth",
                        data:"emailID="+userid.value+"&pwd="+UserPw.value,
                        type:"POST",
                        success:function(result){
                            if (result === 0){
                                document.getElementById("LogInActionForm").submit();
                            } else if (result === 1){
                                Error.innerHTML = "인증되지 않은 이메일입니다."
                                Error.style.display = "block";
                                userid.style.borderColor = "red";
                                UserPw.value = "";
                                return false
                            } else if(result === 2) {
                                location.href = context+"/account/passWordChange"
                                return false
                            } else if(result === 3) {
                                Error.innerHTML = "일치하지 않은 비밀번호입니다."
                                Error.style.display = "block";
                                UserPw.style.borderColor = "red";
                                UserPw.value = "";
                                return false
                            }
                        }, error:function(e){
                            console.log(e.responseText);
                        }
                    });
                    // Ajax 요청이 완료될 때까지 기다리지 않고 바로 리턴하지 않음
                    return false;
                }
            },
            error:function(e){
                alert(e.responseText);
            }
        });
        // Ajax 요청이 완료될 때까지 기다리지 않고 바로 리턴하지 않음
        return false;
    }
}