function validationCheck(context){
    let Error = document.getElementById("Error");
    let userid = document.getElementById("Id");
    let Email_reg = /^\w{4,14}[@][a-z]{2,8}[.][a-z]{2,3}([.][a-z]{2,3})?$/;
    let UserPw = document.getElementById("Pw");
    let PwCheck = document.getElementById("Pw_Check");
    let terms = document.getElementById("Terms");
    let errCount = 0;

    if (userid.value === ""){
        userid.style.borderColor = "red";
        userid.placeholder = "이메일을 입력하세요.";
        userid.value = ""
        Error.style.display = "none";
        ++errCount;
    } else if(!Email_reg.test(userid.value)){
        userid.style.borderColor = "red";
        userid.placeholder = "이메일을 잘못 입력하셨습니다.";
        userid.value = ""
        ++errCount;
    }
    if(UserPw.value===""){
        UserPw.style.borderColor = "red";
        UserPw.value = "";
        PwCheck.value = "";
        UserPw.placeholder = "비밀번호를 입력하세요";
        ++errCount;
    }
    if(UserPw.value !== PwCheck.value){
        PwCheck.style.borderColor = "red";
        // UserPw.value = "";
        PwCheck.value = "";
        PwCheck.placeholder = "비밀번호가 같지 않습니다";
        ++errCount;
    }
    if(!terms.checked){
        alert("약관에 동의하지 않으면 가입을 진행할 수 없습니다.");
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
                    document.getElementById("JoinActionForm").submit();
                } else {
                    Error.innerHTML = "이미 사용중인 이메일입니다."
                    Error.style.display = "block";
                    userid.style.borderColor = "red";
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

