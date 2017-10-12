window.onload = () => {
    let reportName = sessionStorage.getItem('sentName');
    let reportNumber = sessionStorage.getItem('sentNumber');
    let reportSum = sessionStorage.getItem('sentSum');
    let tableDiv = document.querySelector('.request-table');
    let date = document.querySelector('.date');
    document.querySelector('h1').innerHTML = reportName;

    let ajaxObject = new XMLHttpRequest();
    ajaxObject.onreadystatechange = function () {   
        if (ajaxObject.readyState === 4) {
            tableDiv.innerHTML = ajaxObject.responseText;
            let table = tableDiv.querySelector('table');
            table.classList.add('table', 'table-hover', 'table-bordered');
            document.getElementsByTagName('tr')[0].classList.add('warning');
            date.querySelector('div:first-child').innerHTML = getDate();
        }
    };

    let queryString = `?value=${reportNumber}`;
    if (reportSum) {
        queryString += `&summ=${reportSum}`;
    }
   
    ajaxObject.open("GET", "report.php" + queryString, true);
    ajaxObject.send(null);
}                                                                                                              

function getDate() {
    let dateNow = new Date();
    let month = dateNow.getMonth() + 1;
    let year = dateNow.getFullYear();
    let date = dateNow.getDate();
    month = (String(month).length === 2)? month: `0${month}`;
    date = (String(date).length === 2)? date: `0${date}`;
    return `${year}.${month}.${date}`;
}

