toastr.options = {
    "closeButton": true,
    "debug": false,
    "newestOnTop": false,
    "progressBar": true,
    "preventDuplicates": true,
    "positionClass": "toast-top-right",
    "onclick": null,
    "fadeIn": 300,
    "fadeOut": 100,
    "timeOut": 7000,
    "extendedTimeOut": 1000
}

function ShowSuccess(Message, Title) {
    if (typeof (Message) == 'undefined')
        Message = 'عملیات با موفقیت انجام شد';
    if (typeof (Title) == 'undefined')
        Title = 'عملیات موفق';
    toastr.success(Message, Title);
}

function ShowFailure(Message, Title) {
    if (typeof (Message) == 'undefined')
        Message = 'عملیات با موفقیت انجام نشد';
    if (typeof (Title) == 'undefined')
        Title = 'عملیات ناموفق';
    toastr.error(Message, Title);
}

function ShowWarning(Message, Title) {
    if (typeof (Message) == 'undefined')
        Message = 'اخطار رخ داده است';
    if (typeof (Title) == 'undefined')
        Title = 'اخطار';
    toastr.warning(Message, Title);
}

function ShowInfo(Message, Title) {
    if (typeof (Message) == 'undefined')
        Message = 'پیغام برای شما فرستاده شد';
    if (typeof (Title) == 'undefined')
        Title = 'پیغام';
    toastr.info(Message, Title);
}