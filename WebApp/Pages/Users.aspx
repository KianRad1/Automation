<%@ Page Title="کاربران" Language="C#" MasterPageFile="~/Pages/Site.Master" AutoEventWireup="true" CodeBehind="Users.aspx.cs" Inherits="WebApp.Pages.Users"
    gref="E22FF517-6BA8-4DD1-8ADC-45B1C94B1BD6" gid="44FCA737-C86E-4249-B5C9-E5955E45EE7E" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <script>
        function FetchInfo(rowid) {
            $.ajax({
                type: 'POST',
                url: 'Users.aspx/GetInfo',
                data: JSON.stringify({ Info: rowid }),
                contentType: "application/json; charset=utf-8",
                dataType: "JSON"
            }).then(
                function (data) {
                    if (data.d[0] == '1') {
                        var person = $.parseJSON(data.d[1]);
                        if (person != null) {
                            txtUsernameNew.SetText(person.Username);
                            txtNameNew.SetText(person.Name);
                            txtLastNameNew.SetText(person.Family);
                            txtEmailNew.SetText(person.Email);
                            txtAddressNew.SetText(person.Address);
                            txtMobileNew.SetText(person.Mobile);
                            cmblevels.SetValue(person.Level);
                            cmbrole.SetValue(data.d[2] == null ? null : parseInt(data.d[2]));
                            newTreeList.SetNodeCheckState(person["RoleGroupID"], "Checked");
                            last1 = person["RoleGroupID"];
                        }
                        else {
                            if (hdfAction.Get('Username') != null)
                                txtUsernameNew.SetText(hdfAction.Get('Username'));
                        }
                        hdfAction.Set('ID', rowid);

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
            if (txtUsernameNew.GetValue() == null) {
                ShowFailure("نام کاربری وارد نشده است");
                return;
            }
            if (txtNameNew.GetValue() == null) {
                ShowFailure("نام وارد نشده است");
                return;
            }
            if (txtLastNameNew.GetValue() == null) {
                ShowFailure('نام خانوادگی وارد نشده است');
                return;
            }
            if (cmblevels.GetValue() == null) {
                ShowFailure('سطح دسترسی مشخص نشده است');
                return;
            }
            if (cmbrole.GetValue() == null) {
                ShowFailure('نقش مشخص نشده است');
                return;
            }
           
            if (typeof newTreeList.GetVisibleSelectedNodeKeys().pop() == "undefined") {
                ShowFailure("بخش انتخاب نشده است");
                return;
            }

            var UserInfo = {};
            if (hdfAction.Get('ID') != null)
                UserInfo.ID = hdfAction.Get('ID');
            UserInfo.UserName = txtUsernameNew.GetValue();
            UserInfo.Name = txtNameNew.GetValue();
            UserInfo.Family = txtLastNameNew.GetValue();
            UserInfo.Email = txtEmailNew.GetValue();
            UserInfo.Address = txtAddressNew.GetValue();
            UserInfo.Mobile = txtMobileNew.GetValue();
            UserInfo.Level = cmblevels.GetValue();
            UserInfo.RoleID = cmbrole.GetValue();
            UserInfo.RoleGroupID = parseInt(newTreeList.GetVisibleSelectedNodeKeys().pop());

            UserInfo = JSON.stringify(UserInfo);
            $.ajax({
                type: 'POST',
                url: 'Users.aspx/SaveInfo',
                data: JSON.stringify({ Info: UserInfo }),
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

        function Clear() {
            $('#NewEdit').slideUp('fast');
            cmbAction.SetValue(null);
            cmblevels.SetValue(null);
            cmbrole.SetValue(null);
            txtUsernameNew.SetValue("");
            txtNameNew.SetValue("");
            txtLastNameNew.SetValue("");
            txtEmailNew.SetValue("");
            txtAddressNew.SetValue("");
            txtMobileNew.SetValue("");
            cmbAction.SetEnabled(false);
            btnNew.SetEnabled(true);
            btnNew.SetVisible(true);

            hdfAction.Set('ID', null);
            newTreeList.PerformCallback();
            newTreeList.CollapseAll();
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
        function newtreeList_SelectedChange(s, e) {
            if (s.GetVisibleSelectedNodeKeys().length == 1) {
                last1 = s.GetVisibleSelectedNodeKeys().pop();
            }
            else if (s.GetVisibleSelectedNodeKeys().length > 1) {
                s.SetNodeCheckState(last1, 'Unchecked');
                last1 = s.GetVisibleSelectedNodeKeys().pop();
            }

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
                                <Aut:Label ID="lblSearchUsername" runat="server" Text="نام کاربری" />
                                <Aut:TextBox ID="txtSearchUsername" runat="server" Width="150" />
                            </div>
                            <div class="col-xs-6 col-md-2" style="margin-left: -20px;">
                                <Aut:Label ID="lblSearchName" runat="server" Text="نام" />
                                <Aut:TextBox ID="txtSearchName" runat="server" Width="150" />
                            </div>
                            <div class="col-xs-6 col-md-2" style="margin-left: -20px;">
                                <Aut:Label ID="lblSearchFamily" runat="server" Text="نام خانوادگی" />
                                <Aut:TextBox ID="txtSearchFamily" runat="server" Width="150" />
                            </div>
                            <div class="col-xs-6 col-md-2" style="margin-left: -20px;">
                                <Aut:Label ID="lblSearchEmail" runat="server" Text="پست الکترونیک" />
                                <Aut:TextBox ID="txtSearchEmail" runat="server" Width="150" />
                            </div>
                            <div class="col-xs-6 col-md-2" style="margin-left: -20px;">
                                <Aut:Label ID="lblSearchAddress" runat="server" Text="آدرس" />
                                <Aut:TextBox ID="txtSearchAddress" runat="server" Width="150" />
                            </div>
                            <div class="col-xs-6 col-md-2">

                                <Aut:Label ID="lblSearchMobile" runat="server" Text="موبایل" />
                                <Aut:TextBox ID="txtSearchMobile" runat="server" Width="150" />
                            </div>
                            <div class="col-md-4">
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
                    <Aut:GridView Width="100%" ID="gridView" ClientInstanceName="gridView" CssClass="Grid" runat="server" KeyFieldName="ID" defaultradioitemkey="0" AutoGenerateColumns="False"
                    OnPageIndexChanged="gridView_PageIndexChanged"    OnBeforeColumnSortingGrouping="gridView_BeforeColumnSortingGrouping" OnCustomCallback="gridView_CustomCallback">
                        <ClientSideEvents SelectionChanged="function(s, e) { if (e.isSelected) { Clear(); key = s.GetRowKey(e.visibleIndex); s.GetRowValues(e.visibleIndex,'ID',function(value){keyIdentifier = value});  hdfAction.Set('ID', s.GetRowKey(e.visibleIndex)); s.GetRowValues(e.visibleIndex,'Username',function(value){hdfAction.Set('Username', value)}); cmbAction.SetEnabled(true);} else cmbAction.SetEnabled(false);}" />
                        <Columns>
                            <dx:GridViewDataTextColumn FieldName="ID" Visible="True" Caption="شناسه" Width="50" />
                            <dx:GridViewDataTextColumn FieldName="Username" Visible="True" Caption="نام کاربری" />
                            <dx:GridViewDataTextColumn FieldName="Name" Visible="True" Caption="نام" />
                            <dx:GridViewDataTextColumn FieldName="Family" Visible="True" Caption="نام خانوادگی" />
                            <dx:GridViewDataTextColumn FieldName="Email" Visible="True" Caption="پست الکترونیک" />
                            <dx:GridViewDataTextColumn FieldName="Address" Visible="True" Caption="آدرس" />
                            <dx:GridViewDataTextColumn FieldName="Mobile" Visible="True" Caption="شماره همراه" />
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
                        <div>
                            <div class="col-xs-12 col-sm-6 col-md-3">
                                <Aut:Label runat="server" Text="نام کاربری" />
                                <Aut:TextBox runat="server" ID="txtUsernameNew" ClientInstanceName="txtUsernameNew" ClientIDMode="Static" ReadOnly="false" ValidationGroup="NewEdit">
                                    <ValidationSettings RequiredField-IsRequired="true" />
                                </Aut:TextBox>
                            </div>
                            <div class="col-xs-12 col-sm-12 col-md-12"></div>
                            <div class="col-xs-12 col-sm-6 col-md-3">
                                <Aut:Label runat="server" Text="نام" />
                                <Aut:TextBox runat="server" ID="txtNameNew" ClientInstanceName="txtNameNew" ValidationGroup="NewEdit">
                                </Aut:TextBox>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-3">
                                <Aut:Label runat="server" Text="نام خانوادگی" />
                                <Aut:TextBox runat="server" ID="txtLastNameNew" ClientInstanceName="txtLastNameNew" ValidationGroup="NewEdit">
                                </Aut:TextBox>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-3" style="margin-left: -20px">
                                <Aut:Label runat="server" Text="پست الکترونیک" />
                                <Aut:TextBox runat="server" ID="txtEmailNew" ClientInstanceName="txtEmailNew" ValidationGroup="NewEdit">
                                </Aut:TextBox>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-3">
                                <Aut:Label runat="server" Text="موبایل" />
                                <Aut:TextBox runat="server" ID="txtMobileNew" ClientInstanceName="txtMobileNew" ValidationGroup="NewEdit">
                                </Aut:TextBox>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-3">
                                <Aut:Label runat="server" Text="سطح دسترسی" />
                                <Aut:ComboBox ID="cmblevels" ClientInstanceName="cmblevels" runat="server" ValueField="ID" TextField="Title" DataSourceID="odslevel" ValueType="System.Int64">
                                    <ValidationSettings RequiredField-IsRequired="true">
                                        <RequiredField IsRequired="True"></RequiredField>
                                    </ValidationSettings>
                                </Aut:ComboBox>
                                <asp:ObjectDataSource runat="server" ID="odslevel" SelectMethod="GetAllLevel"
                                    TypeName="Business.Automation.LevelBusiness"></asp:ObjectDataSource>
                                <Aut:Label runat="server" Text="آدرس" />
                                <Aut:Memo ID="txtAddressNew" ClientInstanceName="txtAddressNew" runat="server" Height="80px" Width="435px">
                                </Aut:Memo>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-3">
                                <Aut:Label runat="server" Text="نقش" />
                                <Aut:ComboBox ID="cmbrole" ClientInstanceName="cmbrole" runat="server" ValueField="ID" TextField="RoleName" DataSourceID="odsrole" ValueType="System.Int64">
                                    <ValidationSettings RequiredField-IsRequired="true">
                                        <RequiredField IsRequired="True"></RequiredField>
                                    </ValidationSettings>
                                </Aut:ComboBox>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-5">
                                <br />
                                <Aut:TreeList ID="newTreeList" ClientInstanceName="newTreeList" runat="server" AutoGenerateColumns="False" KeyFieldName="ID" DataSourceID="odsRoleGroups" OnCustomCallback="newTreeList_CustomCallback" ParentFieldName="ParentID"
                                    PreviewFieldName="Title" Width="100%" SettingsBehavior-AutoExpandAllNodes="true">
                                    <SettingsSelection Enabled="true" AllowSelectAll="false" />
                                    <Settings GridLines="Horizontal" SuppressOuterGridLines="True" />
                                    <SettingsBehavior ExpandCollapseAction="NodeDblClick" ProcessSelectionChangedOnServer="false" />
                                    <Columns>
                                        <dx:TreeListTextColumn FieldName="Title" VisibleIndex="1" Caption="بخش" HeaderStyle-HorizontalAlign="Right">
                                            <HeaderStyle HorizontalAlign="Right" />
                                        </dx:TreeListTextColumn>
                                    </Columns>
                                    <ClientSideEvents SelectionChanged="newtreeList_SelectedChange" />
                                </Aut:TreeList>
                            </div>
                        </div>
                        <br>
                        <div class="row"></div>
                        <br />
                        <div class="row">
                            <div class="col-md-5"></div>
                            <Aut:Button runat="server" Text="ذخیره" ClientSideEvents-Click="Save" CssClass="Savebtn" />
                            <Aut:Button runat="server" Text="انصراف" ClientSideEvents-Click="Cancel" CssClass="Cancelbtn" />
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-xs-12 col-md-2"></div>
        </div>
    </div>
    <asp:ObjectDataSource runat="server" ID="odsRoleGroups" SelectMethod="GetAllList" TypeName="Business.Automation.RoleGroupBusiness" />
    <asp:ObjectDataSource runat="server" ID="odsrole" SelectMethod="GetAllList" TypeName="Business.Automation.RoleBusiness"></asp:ObjectDataSource>
</asp:Content>
