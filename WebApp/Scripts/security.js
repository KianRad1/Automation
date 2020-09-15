//Get All Privilege in the page
function GetPrivilege() {

    var Allgid = $('[gid]');
    var SecurityArray = [];
    for (i = 0; i < Allgid.length; i++) {
        var Entity = {};
        Entity.gid = $(Allgid[i]).attr('gid');
        Entity.gref = $(Allgid[i]).attr('gref') == '' ? null : $(Allgid[i]).attr('gref');
        Entity.title = $(Allgid[i]).text();
        SecurityArray[i] = Entity;
    }
    return SecurityArray;
}

//Get all Gid Elements  in page
function GetGidElements() {

    var Allgid = $('[gid]');
    return Allgid;
}

function showAccess(userRole) {

    var Privileges = GetGidElements();
    for (i = 0; i < Privileges.length; i++) {
        $(Privileges[i]).hide();
    }

    var Allgid = $('[gid]');
    var result = JSON.parse(userRole);
    console.log(result);
    for (var i = 0; i < Allgid.length; i++) {
        if ($(Allgid[i]).attr('gid') != undefined) {
            var arr = ($(Allgid[i]).attr('gid'));
            var show = false;
            if ($.inArray(arr.toLowerCase(), result) > -1) {
                show = true;
            }

            if (show) {
                $(Allgid[i]).show();
            }
        }
    }

}

function managerAccess() {

}
