<%@ Page Title="تغییر رمز" Language="C#" MasterPageFile="~/Pages/Site.Master" AutoEventWireup="true" CodeBehind="ChangePassword.aspx.cs" Inherits="WebApp.Pages.ChangePassword"
    gref="E22FF517-6BA8-4DD1-8ADC-45B1C94B1BD6" gid="53C72925-8CB6-46A5-ACB1-3844F3484881" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .Savebtn{
height:100% !important;
}
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <script>
        function Save() {
            if (txtCurrentPass.GetValue() == null) {
                alert("رمز عبور فعلی وارد نشده است");
                return;
            }
            if (txtPasswordNew.GetValue() == null) {
                alert("رمز عبور جدید وارد نشده است");
                return;
            }
            if (txtPasswordNew.GetValue() != txtPasswordCheck.GetValue()) {
                alert("تکرار رمز عبور اشتباه است");
                return;
            }
            if (txtCurrentPass.GetValue() == txtPasswordNew.GetValue()) {
                alert("رمز عبور جدید با رمز عبور فعلی یکسان است");
                return;
            }
            var UserInfo = {};
            UserInfo.CurrentPassword = txtCurrentPass.GetValue();
            UserInfo.NewPassword = txtPasswordNew.GetValue();
            UserInfo.CheckPassword = txtPasswordCheck.GetValue();

            UserInfo = JSON.stringify(UserInfo);
            $.ajax({
                type: 'POST',
                url: 'ChangePassword.aspx/SaveInfo',
                data: JSON.stringify({ Info: UserInfo }),
                contentType: "application/json; charset=utf-8",
                dataType: "JSON"
            }).then(
                function (data) {
                    if (data.d[0] == '1') {
                        window.location.replace("<%=ResolveUrl("~")%>/Pages/Default.aspx");
                    }
                    else
                        alert("fail : " + data.d[1]);
                    return;
                },
                function (data) {
                    alert("Can Not Connect");
                });
        }

    </script>
    <div class="form">
        <div class="col-sm-6 col-sm-offset-3">
            <div class="panel panel-primary">
                <div style="font-family: IRANSansWeb" class="panel-heading">تغییر رمز عبور</div>
                <div class="panel-body">
                    <div class="col-md-4"></div>
                    <div class="col-md-4">
                        <div>
                            <div>
                                <Aut:Label runat="server" Text="رمز عبور فعلی" />
                                <Aut:TextBox Password="true" runat="server" ID="txtCurrentPass" ClientInstanceName="txtCurrentPass" ClientIDMode="Static" ReadOnly="false">
                                    <ValidationSettings RequiredField-IsRequired="true" />
                                </Aut:TextBox>
                            </div>
                            <div>
                                <Aut:Label runat="server" Text="رمز عبور جدید" />
                                <Aut:TextBox Password="true" runat="server" ID="txtPasswordNew" ClientInstanceName="txtPasswordNew">
                                    <ValidationSettings RequiredField-IsRequired="true" />
                                </Aut:TextBox>
                            </div>
                            <div>
                                <Aut:Label runat="server" Text="تکرار رمز عبور جدید" />
                                <Aut:TextBox Password="true" runat="server" ID="txtPasswordCheck" ClientInstanceName="txtPasswordCheck">
                                    <ValidationSettings RequiredField-IsRequired="true" />
                                </Aut:TextBox>
                            </div>
                        </div>
                        <br />
                        <div class="row">
                            <div class="col-md-2"></div>
                            <div class="col-md-4">
                                <dx:ASPxHiddenField ID="action" ClientInstanceName="action" runat="server" />
                                <Aut:Button runat="server" Text="ذخیره" ClientSideEvents-Click="Save" CssClass="Savebtn"/>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4"></div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
