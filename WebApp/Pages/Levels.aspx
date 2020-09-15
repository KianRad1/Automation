<%@ Page Title="سطح ها" Language="C#" MasterPageFile="~/Pages/Site.Master" AutoEventWireup="true" CodeBehind="Levels.aspx.cs" Inherits="WebApp.Pages.Levels"
    gref="E22FF517-6BA8-4DD1-8ADC-45B1C94B1BD6" gid="0A7CE8EB-F298-48D6-AA20-85FC9F7C98A9" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <script>
        function FetchInfo(rowid) {
            $.ajax({
                type: 'POST',
                url: 'Levels.aspx/GetInfo',
                data: JSON.stringify({ Info: rowid }),
                contentType: "application/json; charset=utf-8",
                dataType: "JSON"
            }).then(
                function (data) {
                    if (data.d[0] == '1') {
                        var level = $.parseJSON(data.d[1]);
                        txtNameNew.SetText(level.Title);

                        btnNew.SetEnabled(false);
                        btnNew.SetVisible(false);

                        $("#NewEdit").slideDown('fast', function () {
                            $('html, body').animate({
                                scrollTop: $("#NewEdit").offset().top
                            }, 1000);
                        });
                    }
                    else
                        ShowFailure(data.d[1]);
                },
                function (data) {
                    ShowFailure();
                });
        }
        function Save() {
            if (txtNameNew.GetValue() == null) {
                ShowFailure("عنوان سطح دسترسی وارد نشده است");
                return;
            }
            var LevelInfo = {};
            try {
                if (key != undefined) {
                    LevelInfo.ID = key;
                }
            } catch (e) {

            }
            LevelInfo.Title = txtNameNew.GetValue();

            LevelInfo = JSON.stringify(LevelInfo);

            $.ajax({
                type: 'POST',
                url: 'Levels.aspx/SaveInfo',
                data: JSON.stringify({ Info: LevelInfo }),
                contentType: "application/json; charset=utf-8",
                dataType: "JSON"
            }).then(
                function (data) {
                    if (data.d[0] == '1') {
                        Cancel();
                        gridView.PerformCallback();
                        ShowSuccess();
                    }
                    else
                        ShowFailure(data.d[1]);
                    return;
                },
                function (data) {
                    Cancel();
                    ShowFailure();
                });
        }

        function actions_SelectedIndexChanged(s, e) {
            if (typeof key == 'undefined') {
                cmbAction.SetValue(null);
                cmbAction.SetEnabled(false);
                return;
            }
            if (s.GetValue() == "3BCAB3FD-00B6-43F6-BEA3-DC4693693DC6")
                FetchInfo(key);
        }
        function Clear() {
            $('#NewEdit').slideUp('fast');
            btnNew.SetEnabled(true);
            btnNew.SetVisible(true);

            txtNameNew.SetValue("");
            cmbAction.SetEnabled(false);
            cmbAction.SetValue(null);
            action.Set('action', null);
        }
    </script>
    <div class="container-fluid">
        <div class="row">
            <div class="col-xs-12 col-md-2"></div>
            <div class="col-xs-12 col-md-8">
                <div class="well" style="margin-bottom: 8px;">
                    <div class="Search-Panel">
                        <div class="row">
                            <div class="col-xs-6 col-md-2" style="margin-left: -20px;">
                                <Aut:Label ID="lblSearchLevel" runat="server" Text="عنوان سطح" />
                                <Aut:TextBox ID="txtSearchLevel" runat="server" Width="150" />
                            </div>
                            <div class="col-md-12">
                                <br />
                                <Aut:Button ID="btnSearch" runat="server" Text="جستجو" CausesValidation="false" CssClass="Newbtn" Width="150" AutoPostBack="false" ClientSideEvents-Click="function(s,e){Cancel(); gridView.PerformCallback();}" />
                            </div>
                        </div>
                    </div>
                </div>
                <div class="well">
                    <div style="display: inline-flex; margin-top: 7px;">
                        <div style="margin-left: 10px;">
                            <Aut:Button ID="btnNew" ClientInstanceName="btnNew" ClientIDMode="Static" runat="server" Text="جدید" CssClass="Newbtn">
                            </Aut:Button>
                        </div>
                        <div>
                            <div class="Action-Group">
                                <Aut:Label ID="lblAction" runat="server" Text="عملیات" CssClass="Action-Label" />
                                <div class="Action-Combo">
                                    <Aut:ComboBox ID="cmbAction" runat="server" ClientInstanceName="cmbAction" ClientEnabled="False" IsAction="true" Height="35px">
                                        <ClientSideEvents SelectedIndexChanged="actions_SelectedIndexChanged" />
                                    </Aut:ComboBox>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row" style="margin-top: 10px;">
                    </div>
                    <Aut:GridView Width="100%" ID="gridView" ClientInstanceName="gridView" CssClass="Grid" runat="server" KeyFieldName="ID" defaultradioitemkey="0" AutoGenerateColumns="False" OnBeforeColumnSortingGrouping="gridView_BeforeColumnSortingGrouping" OnCustomCallback="gridView_CustomCallback" Theme="iOS">
                        <ClientSideEvents SelectionChanged="function(s, e) { if (e.isSelected) { key = s.GetRowKey(e.visibleIndex); s.GetRowValues(e.visibleIndex,'ID',function(value){keyIdentifier = value}); Clear(); cmbAction.SetEnabled(true);} else cmbAction.SetEnabled(false);}" />
                        <Columns>
                            <dx:GridViewDataTextColumn FieldName="ID" Visible="True" Caption="شناسه" Width="50" />
                            <dx:GridViewDataTextColumn FieldName="Title" Visible="True" Caption="عنوان" />
                            <dx:GridViewDataTextColumn Visible="True" Caption="" Width="0" />
                        </Columns>
                    </Aut:GridView>
                </div>
            </div>
            <div class="col-xs-12 col-md-2"></div>
        </div>
        <div class="row">
            <div class="col-xs-12 col-md-2"></div>
            <div class="col-xs-12 col-md-8">
                <div id="NewEdit" class="well">
                    <div class="form">
                        <Aut:Label runat="server" Text="عنوان" />
                        <Aut:TextBox runat="server" ID="txtNameNew" ClientInstanceName="txtNameNew" ValidationGroup="NewEdit">
                            <ValidationSettings RequiredField-IsRequired="true" />
                        </Aut:TextBox>
                        <dx:ASPxHiddenField ID="ASPxHiddenField1" ClientInstanceName="action" runat="server" />
                        <br />
                        <br />
                        <Aut:Button runat="server" Text="ذخیره" ClientSideEvents-Click="Save" CssClass="Savebtn" />
                        <Aut:Button runat="server" Text="انصراف" ClientSideEvents-Click="Cancel" CssClass="Cancelbtn" />
                    </div>
                </div>
                <div class="col-xs-12 col-md-2"></div>
            </div>
        </div>
    </div>
</asp:Content>
