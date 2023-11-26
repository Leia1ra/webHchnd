let condition = false;
let st = document.getElementById("management").style;
function showAccount(logStatus){
    if(logStatus === 'Y' &&  condition === false){
        st.visibility = 'visible'
        condition = true;
    } else if(logStatus === 'Y' && condition === true){
        hideAccount(logStatus);
    }
}
function hideAccount(logStatus){
    if(logStatus === 'Y' && condition === true){
        st.visibility = 'hidden'
        condition = false;
    }
}