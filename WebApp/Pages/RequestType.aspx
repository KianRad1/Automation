<%@ Page Title="نوع درخواست" Language="C#" MasterPageFile="~/Pages/Site.Master" AutoEventWireup="true" CodeBehind="RequestType.aspx.cs" Inherits="WebApp.Pages.ResquestType" gref="5DFC1B7C-E3FB-4304-8FF5-FA964A4EECA5" gid="1D11E36C-5D66-472C-8B49-FCA560A9EDD9" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
       
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <script>
        function FetchInfo(rowid) {
            $.ajax({
                type: 'POST',
                url: 'RequestType.aspx/GetInfo',
                data: JSON.stringify({ Info: rowid }),
                contentType: "application/json; charset=utf-8",
                dataType: "JSON"
            }).then(
                function (data) {
                    if (data.d[0] == '1') {
                        var request = $.parseJSON(data.d[1]);
                        request.forEach(AddtoListbox);
                        action.Set('action', rowid);
                        btnNew.SetEnabled(false);
                        btnNew.SetVisible(false);

                        $("#NewEdit").slideDown('fast', function () {
                            $('html, body').animate({
                                scrollTop: $("#NewEdit").offset().top
                            }, 1000);
                        });
                    }
                    else {
                        Cancel();
                        ShowFailure(data.d[1]);
                    }
                },

                function (data) {
                    ShowFailure(null);
                });
        }

        function AddtoListbox(item) {
            var newlevel = item.LevelTitle;
            var newrolegroup = item.RoleGroupTitle;
            cmbRequestModel.SetValue(item.RequestModelID);
            txtImportance.SetValue(item.Importance);

            if (newlevel == null && newrolegroup == null) {
                ListBox1.AddItem("*/*", "*");
                return;
            }
            if (newlevel == null && newrolegroup != null) {
                ListBox1.AddItem(newrolegroup, item.RoleGroupID + ",null");
                return;
            }
            if (newlevel != null && newrolegroup == null) {
                ListBox1.AddItem(newlevel, "null," + item.LevelID);
                return;
            }
            ListBox1.AddItem(newrolegroup + "/" + newlevel, item.RoleGroupID + "," + item.LevelID);
        }

        function Save() {
            if (cmbRequestModel.GetValue() == null) {
                ShowFailure("نوع درخواست وارد نشده است");
                return;
            }
            if (txtImportance.GetValue() == null) {
                ShowFailure("اهمیت درخواست وارد نشده است");
                return;
            }
            if (ListBox1.GetItemCount() == 0) {
                ShowFailure("ترتیب درخواست وارد نشده است");
                return;
            }

            var entity = {};
            entity.Items = ListBox1.itemsValue;
            try {
                entity.TypeID = key == 'undefined' ? 0 : key;
            } catch (e) { }

            entity.Importance = txtImportance.GetValue();
            entity.RequestModelID = cmbRequestModel.GetValue();
            entity = JSON.stringify(entity);

            $.ajax({
                type: 'POST',
                url: 'RequestType.aspx/SaveInfo',
                data: JSON.stringify({ Info: entity }),
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
            btnNew.SetEnabled(true);
            btnNew.SetVisible(true);

            txtImportance.SetValue("");
            cmbAction.SetEnabled(false);
            cmbAction.SetValue(null);
            cmbRequestModel.SetValue(null);
            cmblevels.SetValue(null);
            ListBox1.ClearItems();
            action.Set('action', null);
            newTreeList.PerformCallback();
            newTreeList.CollapseAll();
        }
        function actions_SelectedIndexChanged(s, e) {
            if (typeof key == 'undefined') {
                Clear();
                return;
            }
            if (s.GetValue() == "3BCAB3FD-00B6-43F6-BEA3-DC4693693DC6")
                FetchInfo(key);
        }

        function levelList_actions_SelectedIndexChanged(s, e) {
            if (ListBox1.GetItemCount() > 1) {
                if (ListBox1.itemsValue[e.index - 1] == ListBox1.itemsValue[e.index + 1])
                    return
            }
            ListBox1.RemoveItem(e.index);
            cmblevels.SetValue("انتخاب");
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
        function Addtolist() {
            var SelectedRoleGroupTitle = null;
            var SelectedRoleGroup = newTreeList.GetVisibleSelectedNodeKeys().pop();

            if (typeof SelectedRoleGroup == 'undefined' && cmblevels.GetValue() == null) {
                var count = ListBox1.GetItemCount();
                if (count != 0)
                    return;
                ListBox1.AddItem("*/*", "*");
                return;
            }
            if (typeof SelectedRoleGroup == 'undefined' && cmblevels.GetValue != null) {
                if (cmblevels.GetValue() != "انتخاب") {
                    if (ListBox1.GetItemCount() != 0) {
                        var Count = ListBox1.GetItemCount();
                        var Lastitem = ListBox1.GetItem(Count - 1);
                        if (Lastitem.value == "null," + cmblevels.GetValue()) {
                            return
                        }
                    }
                    ListBox1.AddItem(cmblevels.GetText(), "null," + cmblevels.GetValue());
                    cmblevels.SetValue("انتخاب");
                }
                var count = ListBox1.GetItemCount();
                if (count != 0)
                    return;
                ListBox1.AddItem("*/*", "*");
                return;
            }
            newTreeList.GetNodeValues(SelectedRoleGroup, "Title", function (value) {
                SelectedRoleGroupTitle = value;
                if (cmblevels.GetValue() == null || cmblevels.GetValue() == "انتخاب") {
                    if (ListBox1.GetItemCount() != 0) {
                        var Count = ListBox1.GetItemCount();
                        var Lastitem = ListBox1.GetItem(Count - 1);
                        if (Lastitem.value == SelectedRoleGroup + ",null") {
                            return
                        }
                    }
                    ListBox1.AddItem(SelectedRoleGroupTitle, SelectedRoleGroup + ",null");
                    newTreeList.PerformCallback();
                }
                else {
                    if (ListBox1.GetItemCount() != 0) {
                        var Count = ListBox1.GetItemCount();
                        var Lastitem = ListBox1.GetItem(Count - 1);
                        if (Lastitem.value == SelectedRoleGroup + "," + cmblevels.GetValue()) {
                            cmblevels.SetValue("انتخاب");
                            newTreeList.PerformCallback();
                            return
                        }
                    }
                    ListBox1.AddItem(SelectedRoleGroupTitle + "/" + cmblevels.GetText(), SelectedRoleGroup + "," + cmblevels.GetValue());
                    cmblevels.SetValue("انتخاب");
                    newTreeList.PerformCallback();
                }
            });
        }

    </script>
    <div class="container-fluid">
        <div class="row">
            <div class="col-xs-12 col-md-2"></div>
            <div class="col-xs-12 col-md-8">
                <div class="well" style="margin-bottom: 8px;">
                    <div class="Search-Panel">
                        <div class="row">
                            <div class="col-xs-6 col-md-2" style="margin-left: 0;">
                                <Aut:Label ID="lblSearchReqTypeTitle" runat="server" Text="نوع درخواست" />
                                <Aut:ComboBox ID="cmbSearchReqTypeTitle" runat="server" ValueField="ID" TextField="Title"
                                    DataSourceID="odsRequestModel" ValueType="System.Int64">
                                </Aut:ComboBox>
                            </div>
                            <div class="col-xs-6 col-md-2" style="margin-left: -20px;">
                                <Aut:Label ID="lblSearchReqTypePriority" runat="server" Text="اولویت درخواست" />
                                <Aut:TextBox ID="txtSearchReqTypePriority" runat="server" Width="150" />
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
                    <Aut:GridView Width="100%" ID="gridView" ClientInstanceName="gridView" CssClass="Grid" runat="server" KeyFieldName="ID" defaultradioitemkey="0" AutoGenerateColumns="False" OnBeforeColumnSortingGrouping="gridView_BeforeColumnSortingGrouping" OnCustomCallback="gridView_CustomCallback">
                        <ClientSideEvents SelectionChanged="function(s, e) { if (e.isSelected) { key = s.GetRowKey(e.visibleIndex); Clear(); cmbAction.SetEnabled(true);} else cmbAction.SetEnabled(false);}" />
                        <Columns>
                            <dx:GridViewDataTextColumn FieldName="ID" Visible="True" Caption="شناسه" Width="50" />
                            <%--     <dx:GridViewDataTextColumn FieldName="Title" Visible="True" Caption="عنوان" />--%>
                            <dx:GridViewDataComboBoxColumn FieldName="RequestModelID" Caption="نوع درخواست">
                                <PropertiesComboBox TextField="Title" ValueField="ID" ValueType="System.Int64"
                                    DataSourceID="odsRequestModel">
                                </PropertiesComboBox>
                            </dx:GridViewDataComboBoxColumn>
                            <dx:GridViewDataTextColumn FieldName="Importance" Visible="True" Caption="اولویت" Width="50" />
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
                        <div class="row">
                            <div class="col-xs-12 col-md-2">
                                <Aut:Label runat="server" Text="نوع درخواست" />
                                <Aut:ComboBox ID="cmbRequestModel" ClientInstanceName="cmbRequestModel" runat="server" ValueField="ID" TextField="Title" DataSourceID="odsRequestModel" ValueType="System.Int64">
                                </Aut:ComboBox>
                                <Aut:Label runat="server" Text="اولویت درخواست" />
                                <Aut:TextBox runat="server" ID="txtImportance" ClientInstanceName="txtImportance">
                                </Aut:TextBox>
                            </div>
                            <div class="col-xs-12 col-md-3">
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
                            <div class="col-xs-12 col-md-2">
                                <Aut:Label runat="server" Text="سطح دسترسی" />
                                <Aut:ComboBox ID="cmblevels" ClientInstanceName="cmblevels" runat="server" ValueField="ID" TextField="Title" DataSourceID="odslevel" ValueType="System.Int64">
                                </Aut:ComboBox>
                                <br />
                                <Aut:Button runat="server" Text="اضافه به لیست" ClientSideEvents-Click="Addtolist" CssClass="Savebtn" Width="170" />
                            </div>


                            <div class="col-xs-12 col-md-2" style="margin-top: 20px;">
                                <asp:ObjectDataSource runat="server" ID="odslevel" SelectMethod="GetAllLevel" TypeName="Business.Automation.LevelBusiness"></asp:ObjectDataSource>
                                <Aut:ListBox ID="ListBox1" runat="server" ClientInstanceName="ListBox1">
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                    <ClientSideEvents SelectedIndexChanged="levelList_actions_SelectedIndexChanged" />
                                </Aut:ListBox>
                            </div>

                        </div>
                        <div class="row">
                            <div class="col-xs-12 col-md-3">
                                <br />
                                <Aut:Button runat="server" Text="ذخیره" ClientSideEvents-Click="Save" CssClass="Savebtn" />
                                <Aut:Button runat="server" Text="انصراف" ClientSideEvents-Click="Cancel" CssClass="Cancelbtn" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-xs-12 col-md-2"></div>
        </div>
    </div>
    <asp:ObjectDataSource runat="server" ID="odsRoleGroups" SelectMethod="GetAllList" TypeName="Business.Automation.RoleGroupBusiness" />
    <asp:ObjectDataSource runat="server" ID="odsRequestModel" SelectMethod="GetAllList" TypeName="Business.Automation.RequestModelBusiness" />
</asp:Content>
