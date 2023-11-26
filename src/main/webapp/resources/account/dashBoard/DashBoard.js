function progress(){
    let datas = {
        rounds : 13,
        last : 25
    }
    let achieve = document.getElementById("achieve");

    let prgsBar = document.getElementById("prgs");
    let Percent = ((parseInt(datas.rounds)/parseInt(datas.last))*100).toFixed(2);
    achieve.innerHTML = `
        <span>달성률 ${Percent}%</span>
        <span>${datas.rounds}/${datas.last} 회차</span>
    `;
    prgsBar.max=datas.last;
    prgsBar.value = datas.rounds;
    // prgsBar.setAttribute('value', Percent);
}