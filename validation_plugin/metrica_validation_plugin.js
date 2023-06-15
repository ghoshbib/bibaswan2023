// Metrica validation plugin for all kind of validation

function validateEmail(element) {

    var elementValue = $(element).val();

    var filter = /^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;

    if (filter.test(elementValue)) {
        $(element).css('background-color', 'white');
        return true;
    }
    else {
        $.prompt("Please enter valid email address ");
        element.value = "";
        $(element).css('background-color','red');
        return false;
    }
}





