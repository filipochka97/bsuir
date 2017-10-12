let ajaxTable = document.getElementById('ajaxTable');
let headers = document.querySelector('.events').children;
let insertTable = document.querySelector('.insert-fields');
let saveBtn = document.querySelector('.save-changes');
let abortBtn = document.querySelector('.abort');
let deleteBtns;
let input = document.querySelector('.input-premium');

document.querySelector('.submit-premium')
    .addEventListener('click', ajaxPremium);

document.querySelector('button[data-target="#myModal6"]')
    .addEventListener('click', ajaxGetSurnames);

function ajaxPremium () {
    let ajaxObject;
    ajaxObject = new XMLHttpRequest();
    ajaxObject.onreadystatechange = function () {   
        if (ajaxObject.readyState === 4) {
            $('#myModalDelField p').html(ajaxObject.responseText);
            $('#myModalDelField').modal('show');
        }
    };

    let queryString = `surname=${input.value}`;
    ajaxObject.open("GET", "premium.php?" + queryString, true);
    ajaxObject.send(null);
}

function ajaxGetSurnames () {
    let ajaxObject;
    ajaxObject = new XMLHttpRequest();
    ajaxObject.onreadystatechange = function () {   
        if (ajaxObject.readyState === 4) {
            input.innerHTML = ajaxObject.responseText;
        }
    };

    ajaxObject.open("GET", "surname.php", true);
    ajaxObject.send(null);
}


// Отправляем запрос на получение любой таблицы по нажатию на header
function ajaxRequest (arg) {
    let ajaxObject;
    ajaxObject = new XMLHttpRequest();
    ajaxObject.onreadystatechange = function () {   
        if (ajaxObject.readyState === 4) {
            ajaxTable.innerHTML = ajaxObject.responseText;
            let table = document.getElementById('ajaxTable').children[0];
            table.classList.add('table', 'table-hover', 'table-bordered');
            document.getElementsByTagName('tr')[0].classList.add('warning');
        }
    };
    

    // создаём строку, которую отправим вместе с url
    let queryString = "?name=" + ((this === window || this === undefined)?
        "service": this.getAttribute('name'));
    if (arg === 'tool') {
        queryString = "?name=" + arguments[0];
        setTimeout( () => document.querySelector('button[data-target="#myModal2"]')
            .click(), 1000);
    } 
   
    ajaxObject.open("GET", "getuser1.php" + queryString, true);
    ajaxObject.send(null);
}

function ajaxRequestFields () {
    let ajaxObject;
    ajaxObject = new XMLHttpRequest();
    ajaxObject.onreadystatechange = function () {   
        if (ajaxObject.readyState === 4) {
            insertTable.innerHTML = ajaxObject.responseText;            
        }
    };
    let name = document.querySelector('.select-table')
        .querySelector('option:checked').getAttribute('name');

    // создаём строку, которую отправим вместе с url
    let queryString = "?table=" + name;
   
    ajaxObject.open("GET", "editFields.php" + queryString, true);
    ajaxObject.send(null);
}

function ajaxDeleteField () {
    let checked = insertTable.querySelector('option:checked');

    if (checked === null) {
        $('#myModalDelField p').html('Пожалуйста, выберите поле!');
        $('#myModalDelField').modal('show');
        return;
    }

    if (checked.id === 'key') {
        $('#myModalDelField p').html('Нельзя удалить ключевое поле!');
        $('#myModalDelField').modal('show');
        return;
    }

    let ajaxObject;
    ajaxObject = new XMLHttpRequest();
    ajaxObject.onreadystatechange = function () {   
        if (ajaxObject.readyState === 4) {
            $('#myModalDelField p').html(ajaxObject.responseText);
            $('#myModalDelField').modal('show');
            ajaxRequestFields();   
            ajaxRequest.call(ajaxTable.children[0]);     
        }
    };

    let value = insertTable.querySelector('option:checked').value;
    let tableValue = document.querySelector('.select-table')
        .querySelector('option:checked').getAttribute('name');

    let queryString = "?table=" + tableValue + "&field=" + value;
   
    ajaxObject.open("GET", "delete.php" + queryString, true);
    ajaxObject.send(null);
}

function ajaxAddField () {
    let fieldName = document.querySelector('#field-name');
    if (fieldName.value === '') {
        $('#myModalDelField p').html('Пожалуйста, введите название поля!');
        $('#myModalDelField').modal('show');
        return;
    }

    let bool = [].some.call(insertTable.children, (child) => {
        if (child.value === fieldName.value) {
            return true;
        }
    });

    if (bool) {
        $('#myModalDelField p').html('Такое поле уже существует!');
        $('#myModalDelField').modal('show');
        fieldName.value = '';
        return;
    }
    

    if (document.querySelector('.select-table').value === '') {
        $('#myModalDelField p').html('Пожалуйста, выберите таблицу!');
        $('#myModalDelField').modal('show');
        return;
    }

    let ajaxObject;
    ajaxObject = new XMLHttpRequest();
    ajaxObject.onreadystatechange = function () {   
        if (ajaxObject.readyState === 4) {
            $('#myModalDelField p').html(ajaxObject.responseText);
            $('#myModalDelField').modal('show');
            fieldName.value = '';
            ajaxRequestFields();  
            console.log(ajaxTable.children[0]);
            ajaxRequest.call(ajaxTable.children[0]);        
        
        }
    };

    let tableValue = document.querySelector('.select-table')
        .querySelector('option:checked').getAttribute('name');

    let fieldType = document.getElementById('field-type').
        querySelector('option:checked').getAttribute('name');

    let queryString = "?table=" + tableValue + "&field=" + fieldName.value + "&type=" + fieldType;
   
    ajaxObject.open("GET", "add.php" + queryString, true);
    ajaxObject.send(null);
}

// Добавляем обработчики событий на названия таблиц в headerе
for (let i = 0; i < headers.length; i++) {
    headers[i].firstChild.addEventListener('click', ajaxRequest);
}

// Как только страница загрузится, отправялем запрос на открытие основной таблицы (Услуги)
window.onload = ajaxRequest;

// По нажатию на кнопку "Редактировать таблицу" таблица становится редактируемой,
// также появляются кнопочки Сохранить и Отменить;
document.querySelector('button[data-target="#myModal3"]')
    .addEventListener('click', () => {
        let table = document.getElementById('ajaxTable').children[0];
        table.setAttribute('contenteditable', true);

        //add event listener on td in table
        ajaxTable.querySelector('table').addEventListener('keydown', ajaxUpdateRecord);
        

        // table.setAttribute('data-edit-table', true);
        [].forEach.call(table.querySelectorAll('td:first-child'), 
            (child) => child.setAttribute('contenteditable', false));
        [].forEach.call(table.querySelectorAll('tr:first-child'), 
            (child) => child.setAttribute('contenteditable', false));
    });

// По нажатию на кнопку добавить запись появляется новая строка, таблица становится редактируемой,
// и появляются кнопочки Отменить И сохранить
document.querySelector('button[data-target="#myModal2"]')
    .addEventListener('click', () => {
        let firstRow = ajaxTable.querySelector('tr:first-child');
        let table = document.getElementById('ajaxTable').children[0];
        let newRow = document.createElement('tr');
        newRow.innerHTML = '<td></td>'
            .repeat(document.querySelector('#ajaxTable tr').children.length);
        document.querySelector('tbody').appendChild(newRow);
        table.setAttribute('contenteditable', true);
        [].forEach.call(table.querySelectorAll('td:first-child'), 
            (child) => child.setAttribute('contenteditable', false));
        saveBtn.classList.add('visible');
        abortBtn.classList.add('visible');

        if (table.getAttribute('name') === 'agreement') {
            newRow.querySelector('td:nth-of-type(2)').innerHTML = 
            '<input type="date">';
            newRow.querySelector('td:nth-of-type(3)').innerHTML = 
            '<select class="form-control agr3"></select>';
            newRow.querySelector('td:nth-of-type(4)').innerHTML = 
            '<select class="form-control agr4"></select>';
            newRow.querySelector('td:nth-of-type(5)').innerHTML = 
            '<select class="form-control agr5"></select>';
            newRow.querySelector('td:nth-of-type(6)').innerHTML = 
            '<select class="form-control agr6"></select>' + 
            '<button type="button" class="btn btn-primary add-tool">' +
            'Добавить инструмент</button>';
            newRow.querySelector('td:nth-of-type(7)').innerHTML = 
            '<input list="pass-data" >' +
                '<datalist id="pass-data" class="agr7">' +
                '</datalist>';

            newRow.querySelector('td:nth-of-type(6)').setAttribute('contenteditable', false);

            ajaxInsertOption(firstRow.querySelector('th:nth-child(3)').innerHTML);
            ajaxInsertOption(firstRow.querySelector('th:nth-child(4)').innerHTML);
            ajaxInsertOption(firstRow.querySelector('th:nth-child(5)').innerHTML);
            ajaxInsertOption(firstRow.querySelector('th:nth-child(6)').innerHTML);
            ajaxInsertOption(firstRow.querySelector('th:nth-child(7)').innerHTML);

            document.querySelector('.add-tool').addEventListener('click', () => {
                $('#myModalDelField p').html('Открылась таблица &ldquo;Инструменты&rdquo;!');
                $('#myModalDelField').modal('show');
                saveBtn.classList.remove('visible');
                abortBtn.classList.remove('visible');
                ajaxRequest('tool');
            });
        }

    });

function ajaxInsertOption(id) {

    let ajaxObject = new XMLHttpRequest();
    ajaxObject.onreadystatechange = function () {   
        if (ajaxObject.readyState === 4) {
            switch (id) {
                case 'id_employee':
                    document.querySelector('.agr3').innerHTML = ajaxObject.responseText;
                    break;
                case 'id_service':
                    document.querySelector('.agr4').innerHTML = ajaxObject.responseText;
                    break;
                case 'id_material':
                    document.querySelector('.agr5').innerHTML = ajaxObject.responseText;
                    break;
                case 'id_tool':
                    document.querySelector('.agr6').innerHTML = ajaxObject.responseText;
                    break;
                case 'pass_client':
                    document.querySelector('.agr7').innerHTML = ajaxObject.responseText;
                    break;
            }
        }
    };


    let queryString = "?id=" + id;
    
    ajaxObject.open("GET", "agreement.php" + queryString, true);
    ajaxObject.send(null);
}

// По нажатию на кнопку Удалить запись появляются скрытые ячейки с кнопками Удалить
document.querySelector('button[data-target="#myModal4"]')
    .addEventListener('click', ()=> {
        [].forEach.call(document.querySelectorAll('td[id*=note]'), 
            (item) => item.style.visibility = 'visible');

    deleteBtns = document.querySelectorAll('button[data-target="#myModalDel"]');
    //Delete record
    [].forEach.call(deleteBtns, (deleteBtn) => {
        deleteBtn.addEventListener('click', ajaxDeleteRecord);
    });

});

document.querySelector('.select-table').addEventListener('change', ajaxRequestFields); 

document.querySelector('.delete-field').addEventListener('click', ajaxDeleteField);

document.querySelector('.add-field').addEventListener('click', ajaxAddField);


function ajaxSubmitChanges () {
    let ajaxObject;
    let queryString = '';
    let temp = '';

    let table = document.getElementById('ajaxTable').children[0];
    let firstRow = table.firstChild.firstChild.children;
    let lastRow = table.firstChild.lastChild.children;
    ajaxObject = new XMLHttpRequest();
    ajaxObject.onreadystatechange = function () {
        if (ajaxObject.readyState === 4 && ajaxObject.status === 200) {
            $('#myModalDelField p').html(ajaxObject.responseText);
            $('#myModalDelField').modal('show');
            saveBtn.classList.remove('visible');
            abortBtn.classList.remove('visible');
            ajaxRequest.call(ajaxTable.querySelector('table'));
        }
    };

    if (table.getAttribute('name') === 'agreement') {
        [].forEach.call(firstRow, (child, i) => {
            if (i)  {
                if (i === 1 || i === 6) {
                    queryString += `${child.innerHTML}=${lastRow[i].firstElementChild.value}&`;
                } else {
                    queryString += `${child.innerHTML}=${lastRow[i]
                    .firstElementChild.querySelector('option:checked').id}&`;
                }  
            } 
        });
    } else {
            temp = [].some.call(firstRow, (child, i) => {
            if (table.getAttribute('name') === 'material'
                    && child.innerHTML === 'country'
                    && lastRow[i].innerHTML.toUpperCase() === 'КИТАЙ' ) {
                $('#myModalDelField p').html('Стоит ограничение на поставку материлов из некоторых стран!');
                $('#myModalDelField').modal('show');
                return true;
            }

            if (table.getAttribute('name') === 'service'
                    && child.innerHTML === 'cost'
                    && lastRow[i].innerHTML < 20 ) {
                $('#myModalDelField p').html('Стоимость услуги должна начинаться с 20 у.е.!');
                $('#myModalDelField').modal('show');
                return true;
            }

            if (table.getAttribute('name') === 'service'
                    && child.innerHTML === 'max_term'
                    && lastRow[i].innerHTML > 30 ) {
                $('#myModalDelField p').html('Максимальный срок выполнения услуги не может превышать 30 дней!');
                $('#myModalDelField').modal('show');
                return true;
            }

            if (i) queryString += `${child.innerHTML}=${lastRow[i].innerHTML}&`;
        });
    }
    
    if (temp) return;



    ajaxObject.open("POST", "insert.php", true);
    ajaxObject.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    ajaxObject.send(queryString);
}

document.querySelector('.save-changes').addEventListener('click', ajaxSubmitChanges);

document.querySelector('.abort').addEventListener('click', function () {
    let lastRow = document.getElementById('ajaxTable').children[0]
        .firstChild.lastChild;
    lastRow.remove();
    saveBtn.classList.remove('visible');
    abortBtn.classList.remove('visible');
});


// Удалить запись button
function ajaxDeleteRecord () {
    let id = this.parentNode.parentNode.firstElementChild.innerHTML;
    let tableValue = ajaxTable.children[0].getAttribute('name');
    let ajaxObject = new XMLHttpRequest();
    ajaxObject.onreadystatechange = function () {   
        if (ajaxObject.readyState === 4) {
            $('#myModalDelField p').html(ajaxObject.responseText);
            $('#myModalDelField').modal('show');
            ajaxRequest.call(ajaxTable.children[0]);          
        }
    };


    let queryString = "?table=" + tableValue + "&id=" + id;
   
    ajaxObject.open("GET", "deleteRec.php" + queryString, true);
    ajaxObject.send(null);
}



//Редактировать таблиц

function ajaxUpdateRecord (e) {
    if (e.keyCode === 13) {
        let tr = e.target.closest('tr');
        let number = [].indexOf.call(tr.children, e.target);
        let fieldName = ajaxTable.querySelector(`th:nth-child(${number + 1})`).innerHTML;
        let fieldText = e.target.innerHTML;
        let tableValue = ajaxTable.children[0].getAttribute('name');
        let id = tr.firstChild.innerHTML;

        if (tableValue === 'material' && fieldName === 'country'
            && fieldText.toUpperCase() === 'КИТАЙ' ) {
                $('#myModalDelField p').html('Стоит ограничение на поставку материлов из некоторых стран!');
                $('#myModalDelField').modal('show');
                ajaxRequest.call(ajaxTable.children[0]); 
                return;
            }

        let ajaxObject = new XMLHttpRequest();
        ajaxObject.onreadystatechange = function () {   
            if (ajaxObject.readyState === 4) {
                $('#myModalDelField p').html(ajaxObject.responseText);
                $('#myModalDelField').modal('show');
                ajaxRequest.call(ajaxTable.children[0]);          
            }
        };

        let queryString = `?id=${id}&field=${fieldName}&value=${fieldText}`;

        ajaxObject.open("GET", "update.php" + queryString, true);
        ajaxObject.send(null);
    }
}

//open reports

document.querySelector('.open-report')
    .addEventListener('click', ajaxNewReport);

function ajaxNewReport () {
    let reportValue = document.querySelector('.reports').value;
    let reportNumber = document.querySelector('.reports option:checked').id;
    if (reportNumber == 2) {
        $('#myModalParam').modal('show');
        sessionStorage.setItem('sentName', reportValue);
        sessionStorage.setItem('sentNumber', reportNumber);
        return;
    }

    sessionStorage.setItem('sentName', reportValue);
    sessionStorage.setItem('sentNumber', reportNumber);
    window.open('report.html');
}

document.querySelector('.submit-sum')
    .addEventListener('click', () => {
        sessionStorage.setItem('sentSum', document.querySelector('.input-sum').value);
        window.open('report.html');
});


