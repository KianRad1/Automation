<%@ Page Title="خانه" Language="C#" MasterPageFile="~/Pages/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="WebApp.Pages.Default" IsDefault="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <script>

        $(document).ready(function () {
            if (hdfUser.Get("UserIsNull") == true)
                ShowFailure("اطلاعات شما ناقص است. برای تکمیل اطلاعات به پشتیبان اطلاع دهید", "اخطار مهم");

            var Privilages = GetPrivilege();
            Privilages = JSON.stringify(Privilages);
            $.ajax({
                type: 'POST',
                url: 'Default.aspx/CheckPrivilage',
                data: JSON.stringify({ Info: Privilages }),
                contentType: "application/json; charset=utf-8",
                dataType: "JSON"
            }).then(
                function (data) {
                    if (data.d[0] == '1') {
                        Cancel();
                    }
                    else 
                        ShowFailure(data.d[1]);
                    return;
                },
                function (data) { 
                    Cancel();
                    ShowFailure();
                });
        });

        function Clear() {
        }

    </script>
    <div class="form">
        <div class="col-xs-12 col-md-3"></div>
        <div class="col-xs-12 col-md-6">
            <div class="panel panel-primary">
                <div style="font-family: 'Iranian Sans'" class="panel-heading">
                    <p><span class="glyphicon glyphicon-search"></span>&nbsp مشخصات</p>
                </div>
                <div class="InfoTable">
                    <div class="panel-body">
                        <div class="row" style="border-bottom: groove; border-bottom-left-radius: 30px; border-bottom-right-radius: 30px; border-bottom-color: #99ddff;">
                            <div class="col-xs-12 col-md-6">
                                <p><span class="glyphicon glyphicon-user"></span>&nbsp نام:</p>
                            </div>
                            <div class="col-xs-12 col-md-6" style="text-align: center;">
                                <Aut:Label ID="lblName" ClientInstanceName="lblName" runat="server" Font-Names="Century Gothic" Font-Size="25pt" />
                            </div>
                        </div>
                        <div class="row" style="border-bottom: groove; border-bottom-left-radius: 30px; border-bottom-right-radius: 30px; border-bottom-color: #99ddff;">
                            <div class="col-xs-12 col-md-6">
                                <p><span class="glyphicon glyphicon-user"></span>&nbsp نام خانوادگی:</p>
                            </div>
                            <div class="col-xs-12 col-md-6" style="text-align: center;">
                                <Aut:Label ID="lblFamily" ClientInstanceName="lblFamily" runat="server" Font-Names="Century Gothic" Font-Size="25pt" />
                            </div>
                        </div>
                        <div class="row" style="border-bottom: groove; border-bottom-left-radius: 30px; border-bottom-right-radius: 30px; border-bottom-color: #99ddff;">
                            <div class="col-xs-12 col-md-6">
                                <p><span class="glyphicon glyphicon-pencil"></span>&nbsp نام کاربری:</p>
                            </div>
                            <div class="col-xs-12 col-md-6" style="text-align: center;">
                                <Aut:Label ID="lblUsername" ClientInstanceName="lblUsername" runat="server" Font-Names="Century Gothic" Font-Size="25pt" />
                            </div>
                        </div>
                        <div class="row" style="border-bottom: groove; border-bottom-left-radius: 30px; border-bottom-right-radius: 30px; border-bottom-color: #99ddff;">
                            <div class="col-xs-12 col-md-6">
                                <p><span class="glyphicon glyphicon-home"></span>&nbsp آدرس:</p>
                            </div>
                            <div class="col-xs-12 col-md-6" style="text-align: center;">
                                <Aut:Label ID="lblAddress" ClientInstanceName="lblAddress" runat="server" Font-Names="B Yekan" Font-Size="25pt" />
                            </div>
                        </div>
                        <div class="row" style="border-bottom: groove; border-bottom-left-radius: 30px; border-bottom-right-radius: 30px; border-bottom-color: #99ddff;">
                            <div class="col-xs-12 col-md-6">
                                <p><span class="glyphicon glyphicon-envelope"></span>&nbsp ایمیل:</p>
                            </div>
                            <div class="col-xs-12 col-md-6" style="text-align: center;">
                                <Aut:Label ID="lblEmail" ClientInstanceName="lblEmail" runat="server" Font-Names="Century Gothic" Font-Size="25pt" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-xs-12 col-md-6">
                                <p><span class="glyphicon glyphicon-earphone"></span>&nbsp موبایل:</p>
                            </div>
                            <div class="col-xs-12 col-md-6" style="text-align: center;">
                                <Aut:Label ID="lblMobile" ClientInstanceName="lblMobile" runat="server" Font-Names="Century Gothic" Font-Size="25pt" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-xs-12 col-md-3"></div>
    </div>
        <Aut:HiddenField ID="hdfUser" ClientInstanceName="hdfUser" runat="server" />
</asp:Content>
