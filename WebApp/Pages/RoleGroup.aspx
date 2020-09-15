<%@ Page Title="انتخاب بخش/واحد" Language="C#" MasterPageFile="~/Pages/Site.Master" AutoEventWireup="true" CodeBehind="RoleGroup.aspx.cs" 
    Inherits="WebApp.Pages.RoleGroup" gref="E22FF517-6BA8-4DD1-8ADC-45B1C94B1BD6" gid="32F00EA9-D421-4B87-8D15-D6F4F8542906" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <script>
        function treeList_SelectedChange(s, e) {
            $('#NewEdit').slideUp('fast');
            $('#btnNew').attr('disabled', null);
            txtTitle.SetText(null);
            newTreeList.GetVisibleSelectedNodeKeys().forEach(function (el, index, arr) { newTreeList.SetNodeCheckState(el, "Unchecked"); });
            delete key;
            cmbAction.SetEnabled(false);

            if (s.GetVisibleSelectedNodeKeys().length == 1) {
                last = s.GetVisibleSelectedNodeKeys().pop();
                key = last;
                cmbAction.SetEnabled(true);
            }
            else if (s.GetVisibleSelectedNodeKeys().length > 1) {
                s.SetNodeCheckState(last, 'Unchecked');
                last = s.GetVisibleSelectedNodeKeys().pop();
                key = last;
                cmbAction.SetEnabled(true);
            }
            else {
                cmbAction.SetEnabled(false);
                delete key;
            }
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
        function save() {
            if (txtTitle.GetValue() == null) {
                ShowFailure("عنوان گروه نقش وارد نشده است");
                return;
            }
            var entity = {};
            if (hdfAction.Get("ID") != null)
                entity["ID"] = hdfAction.Get("ID");

            entity["Title"] = txtTitle.GetText();
            if (typeof newTreeList.GetVisibleSelectedNodeKeys().pop() != "undefined")
                entity["ParentID"] = parseInt(newTreeList.GetVisibleSelectedNodeKeys().pop());

            entity = JSON.stringify(entity);

            $.ajax({
                type: 'POST',
                url: 'RoleGroup.aspx/SaveRoleGroup',
                data: JSON.stringify({ Info: entity }),
                contentType: "application/json; charset=utf-8",
                dataType: "JSON"
            }).then(
                function (data) {
                    if (data.d[0] == '1') {
                        Cancel();
                        treeList.PerformCallback();
                        newTreeList.PerformCallback();
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
        function FetchInfo(rowid) {
            $.ajax({
                type: 'POST',
                url: 'RoleGroup.aspx/GetInfo',
                data: JSON.stringify({ Info: rowid }),
                contentType: "application/json; charset=utf-8",
                dataType: "JSON"
            }).then(
                function (data) {
                    if (data.d[0] == '1') {
                        var roleGroup = $.parseJSON(data.d[1]);
                        txtTitle.SetText(roleGroup.Title);
                        newTreeList.SetNodeCheckState(roleGroup["ParentID"], "Checked");
                        last1 = roleGroup["ParentID"];
                        hdfAction.Set('ID', rowid);
                        treeList.PerformCallback();
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

            txtTitle.SetValue("");
            cmbAction.SetEnabled(false);
            cmbAction.SetValue(null);
            hdfAction.Set('ID', null);
            treeList.PerformCallback();
            treeList.CollapseAll();
            newTreeList.PerformCallback();
            newTreeList.CollapseAll();
        }
    </script>
    <div class="container-fluid">
        <div class="row">
            <div class="col-xs-12 col-md-2"></div>
            <div class="col-xs-12 col-md-8">
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
                    <Aut:TreeList ID="treeList" ClientInstanceName="treeList" runat="server" AutoGenerateColumns="False" KeyFieldName="ID" DataSourceID="odsRoleGroups" OnCustomCallback="treeList_CustomCallback"
                        ParentFieldName="ParentID" PreviewFieldName="Title" Width="100%">
                        <SettingsSelection Enabled="true" AllowSelectAll="false" />
                        <Settings GridLines="Horizontal" SuppressOuterGridLines="True" />
                        <SettingsBehavior ExpandCollapseAction="NodeDblClick" ProcessSelectionChangedOnServer="false" />
                        <Columns>
                            <dx:TreeListTextColumn FieldName="Title" VisibleIndex="1" Caption="عنوان" HeaderStyle-HorizontalAlign="Right">
                                <HeaderStyle HorizontalAlign="Right" />
                            </dx:TreeListTextColumn>
                        </Columns>
                        <ClientSideEvents SelectionChanged="treeList_SelectedChange" />
                    </Aut:TreeList>
                </div>
            </div>
            <div class="col-xs-12 col-md-2"></div>
        </div>

        <div class="row">
            <div class="col-xs-12 col-md-2"></div>
            <div class="col-xs-12 col-md-8">
                <div id="NewEdit" class="well">
                    <div class="form">
                        <div class="row">
                            <div class="col-xs-12 col-md-2">
                                <Aut:Label runat="server" Text="نام نقش" />
                                <Aut:TextBox runat="server" ID="txtTitle" ClientInstanceName="txtTitle" ValidationGroup="NewEdit">
                                    <ValidationSettings RequiredField-IsRequired="true" />
                                </Aut:TextBox>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-xs-12 col-md-6">
                                <br />
                                <br />
                                <Aut:TreeList ID="newTreeList" ClientInstanceName="newTreeList" runat="server" AutoGenerateColumns="False" KeyFieldName="ID" DataSourceID="odsRoleGroups" OnCustomCallback="newTreeList_CustomCallback" ParentFieldName="ParentID"
                                    PreviewFieldName="Title" Width="100%" SettingsBehavior-AutoExpandAllNodes="true">
                                    <SettingsSelection Enabled="true" AllowSelectAll="false" />
                                    <Settings GridLines="Horizontal" SuppressOuterGridLines="True" />
                                    <SettingsBehavior ExpandCollapseAction="NodeDblClick" ProcessSelectionChangedOnServer="false" />
                                    <Columns>
                                        <dx:TreeListTextColumn FieldName="Title" VisibleIndex="1" Caption="عنوان" HeaderStyle-HorizontalAlign="Right">
                                            <HeaderStyle HorizontalAlign="Right" />
                                        </dx:TreeListTextColumn>
                                    </Columns>
                                    <ClientSideEvents SelectionChanged="newtreeList_SelectedChange" />
                                </Aut:TreeList>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-xs-12 col-md-6">
                                <br />
                                <br />
                                <Aut:Button runat="server" Text="ذخیره" ClientSideEvents-Click="save" CssClass="Savebtn" />
                                <Aut:Button runat="server" Text="انصراف" ClientSideEvents-Click="Cancel" CssClass="Cancelbtn" />
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-xs-12 col-md-2"></div>
            </div>
        </div>
    </div>
    <asp:ObjectDataSource runat="server" ID="odsRoleGroups" SelectMethod="GetAllList" TypeName="Business.Automation.RoleGroupBusiness" />
</asp:Content>
