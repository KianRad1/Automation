<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="WebApp.Pages.Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>اتوماسیون اداری</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="../Styles/bootstrap.min.css" />
    <script src="../Scripts/jquery-3.4.1.min.js"></script>
    <script src="../Scripts/bootstrap.min.js"></script>
    <link rel="stylesheet" href="../Scripts/toastr.min.css" />
    <script src="../Scripts/toastr.min.js"></script>
    <script src="../Scripts/script.js"></script>
    <link rel="stylesheet" href="../Styles/bootstrap-rtl.min.css" />
    <link rel="stylesheet" href="../Styles/StyleSheet.css" />
    <script language="javascript" type="text/javascript">

        function checklogin(s, e) {
            if ($("#txtuname").val() == "") {
                ShowWarning("نام کاربری وارد نشده است");
                return;
            }
            if ($("#txtpsw").val() == "") {
                ShowWarning("رمز عبور وارد نشده است");
                return;
            }

            var UserInfo = {};
            UserInfo.UserName = $("#txtuname").val();
            UserInfo.Password = $("#txtpsw").val();

            UserInfo = JSON.stringify(UserInfo);

            $.ajax({
                type: 'POST',
                url: 'Login.aspx/Check',
                data: JSON.stringify({ Info: UserInfo }),
                contentType: "application/json; charset=utf-8",
                dataType: "JSON"
            }).then(
                function (data) {
                    if (data.d[0] == '1') {
                        window.location.replace("<%=ResolveUrl("~")%>/Pages/Default.aspx");
                    }
                    else
                    ShowFailure(data.d[1]);
                },
                function (data) {
                    ShowFailure("اتصال برقرار نشد");
                }
            );
        }
    </script>
</head>
<body style="height: 100vh; background: url('../Images/loginback.png') no-repeat; background-size: 100% 100%;">
    <div class="container-fluid">

        <div class="row" style="margin-top: 16%;">
            <div class="col-md-3 col-md-offset-1">
                <div class="panel panel-primary" style="font-family: Vazir">
                    <div class="panel-heading" style="align-content: center">ورود به سایت</div>
                    <div class="panel-body">
                        <div class="row">
                            <div class="col-xs-12">
                                <input name="txtuname" type="text" id="txtuname" placeholder="نام کاربری" class="form-control" required="required"/>
                            </div>
                            <div class="col-xs-12">
                                <input name="txtpsw" type="password" id="txtpsw" placeholder="رمز عبور" class="form-control" required ="required"/>
                            </div>
                            <div class="col-xs-12">
                                <div class="row">
                                    <div class="col-xs-4">&nbsp;</div>
                                    <div class="col-xs-4">
                                        <br />
                                        <input class="btn btn-primary" type="button" id="test" value="ورود" onclick="checklogin()" style="width: 100%;" />
                                    </div>
                                    <div class="col-xs-4">&nbsp;</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-8">&nbsp;</div>
        </div>

    </div>
</body>
</html>
