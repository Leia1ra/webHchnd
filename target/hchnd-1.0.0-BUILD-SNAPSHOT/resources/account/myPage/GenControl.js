function genControl(state){
    let select = document.getElementById("Gender")
    let none = document.getElementsByTagName("option")[0];
    let male = document.getElementsByTagName("option")[1];
    let female = document.getElementsByTagName("option")[2];

    if(state === 0) {
        none.setAttribute('selected', true);
    } else if(state === 1) {
        male.setAttribute('selected', true);
    } else if(state === 2) {
        female.setAttribute('selected', true);
    }
}

function duplicateCheck(context, now){
    let nickName = document.getElementById("userNickName");
    let checkBtn = document.getElementById("CheckBtn");
    let isPass = document.getElementById("duplicatePass")
    if (nickName.value === ""){
        alert("닉네임을 입력해주세요");
    } else if(nickName === now) {
        alert("닉네임을 변경후에 확인해주세요");
    } else {
        $.ajax({
            url:context+"/account/duplicateCheck",
            data:"nickName="+nickName.value,
            type:"GET",
            success:function(result) {
                if(result){
                    checkBtn.value = "사용가능"
                    checkBtn.style.borderColor = "white";
                    isPass.value = "Y";
                } else {
                    checkBtn.value = "사용불가"
                    checkBtn.style.borderColor = "red";
                    isPass.value = "N";
                }
            }, error:function(e){
                console.log(e.responseText);
            }
        });
    }
}

function nickNameKeyUpCheck(now){
    let dp = document.getElementById("duplicatePass");
    let checkBtn = document.getElementById("CheckBtn");
    let userNickName = document.getElementById("userNickName");
    userNickName.addEventListener("keyup", function () {
        if(userNickName.value === now){
            dp.value = "Y";
            checkBtn.value = "중복검사"
            checkBtn.style.borderColor = "white";
        } else {
            dp.value = "N";
            checkBtn.value = "중복검사"
            checkBtn.style.borderColor = "red";
        }
    })
}

function myPageSubmit(){
    let dp = document.getElementById("duplicatePass");
    if(dp.value === "Y"){
        return true;
    } else {
        return false;
    }
}

function imgUpLoad(){
    let imgUpload = document.getElementById("upload");
    let imgPreview = document.getElementById("myPageProfileImg");

    let file = imgUpload.files[0];
    if(file){
        let reader = new FileReader();
        reader.onload = function (e){
            imgPreview.src = e.target.result;
        };
        reader.readAsDataURL(file);
    } else {
        imgPreview.src="";
    }
}