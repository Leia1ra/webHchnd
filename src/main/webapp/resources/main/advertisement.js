function setPosterList(){
    var imgTag = "<div id='imgList'>";

    for(var i=1; i<=5; i++){
        imgTag += "<img src='/hchnd/img/imgs_main/postAd/ad_" + i + ".png'/>";
    }
    imgTag += "</div>";

    document.getElementById("imgView").innerHTML = imgTag;
}

// 포스트 이동
var xStep = -1;
var x = 0;
var timer;

function posterMove(){
    x += xStep;
    document.getElementById("imgList").style.left = x + "px";
    let w = document.getElementById("imgList").clientWidth;
    let end = document.getElementById("imgView").clientWidth;
    let viewPoint = w-end;

    // 방향 전환 left 이동 -> right 이동으로 변경
    if(x <= -viewPoint) xStep = 1;

    // right 이동 -> left 이동으로 변경
    if(x >= 0) xStep = -1;
}

window.onload = function(){
    /*하단 광고*/
    setPosterList();
    timer = setInterval(posterMove, 10);

    document.getElementById("imgView").onmouseover = function(){
        clearInterval(timer);
    };

    document.getElementById("imgView").addEventListener('mouseout',function(){
        timer = setInterval(posterMove, 10);
    });
}
