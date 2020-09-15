<%@ Page Title="نقش ها" Language="C#" MasterPageFile="~/Pages/Site.Master" AutoEventWireup="true" CodeBehind="Roles.aspx.cs" Inherits="WebApp.Pages.Roles"
    gref="E22FF517-6BA8-4DD1-8ADC-45B1C94B1BD6" gid="F840CA59-6BB1-403A-8638-9E471AAC8E22" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <script>
        function FetchInfo(rowid) {
            $.ajax({
                type: 'POST',
                url: 'Roles.aspx/GetInfo',
                data: JSON.stringify({ Info: rowid }),
                contentType: "application/json; charset=utf-8",
                dataType: "JSON"
            }).then(
                function (data) {
                    if (data.d[0] == '1') {

                        hdfAction.Set('ID', rowid);
                        var role = $.parseJSON(data.d[1]);
                        txtRoleName.SetText(role.RoleName);
                        txtRoleLevel.SetText(role.RoleLevel);
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

        var selectedIds = [];
        function treeList_SelectionChanged(s, e) {
            if (s.GetVisibleSelectedNodeKeys().length > 0) {
                selectedIds.concat(s.GetVisibleSelectedNodeKeys().pop());
            }
            else {
                selectedIds = null;
            }
        }
        function save() {
            treeList.GetSelectedNodeValues("ID Title gref gid", function (Nodes) {

                var entity = {};
                entity.SelectedNodes = [];
                entity.RoleID = (hdfAction.Get('ID') == null) ? 0 : hdfAction.Get('ID');
                entity.Title = txtRoleName.GetValue();
                entity.RoleLevel = txtRoleLevel.GetValue();

                for (i = 0; i < Nodes.length; i++) {
                    var PrivilegeEntity = {};
                    PrivilegeEntity.ID = Nodes[i][0];
                    PrivilegeEntity.Title = Nodes[i][1];
                    PrivilegeEntity.gref = Nodes[i][2];
                    PrivilegeEntity.gid = Nodes[i][3];

                    entity.SelectedNodes[i] = PrivilegeEntity;
                }

                entity = JSON.stringify(entity);

                $.ajax({
                    type: 'POST',
                    url: 'Roles.aspx/SaveRoles',
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
            })
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

            txtRoleName.SetValue("");
            txtRoleLevel.SetValue("");
            cmbAction.SetEnabled(false);
            cmbAction.SetValue(null);
            hdfAction.Set('ID', null);
            treeList.PerformCallback();
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
                                <Aut:Label ID="lblSearchRoleTitle" runat="server" Text="عنوان نقش" />
                                <Aut:TextBox ID="txtSearchRoleTitle" runat="server" Width="150" />
                            </div>
                            <div class="col-xs-6 col-md-2" style="margin-left: -20px;">
                                <Aut:Label ID="lblSearchRolePriority" runat="server" Text="سطح نقش" />
                                <Aut:TextBox ID="txtSearchRolePriority" runat="server" Width="150" />
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
                        <ClientSideEvents SelectionChanged="function(s, e) { if (e.isSelected) { Clear(); key = s.GetRowKey(e.visibleIndex); s.GetRowValues(e.visibleIndex,'ID',function(value){keyIdentifier = value}); hdfAction.Set('ID', s.GetRowKey(e.visibleIndex)); cmbAction.SetEnabled(true);} else cmbAction.SetEnabled(false);}" />
                        <Columns>
                            <dx:GridViewDataTextColumn FieldName="ID" Visible="True" Caption="شناسه" Width="50" />
                            <dx:GridViewDataTextColumn FieldName="RoleName" Visible="True" Caption="نام نقش" />
                            <dx:GridViewDataTextColumn FieldName="RoleLevel" Visible="True" Caption="سطح نقش" />
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
                                <Aut:Label runat="server" Text="نام نقش" />
                                <Aut:TextBox runat="server" ID="txtRoleName" ClientInstanceName="txtRoleName" ValidationGroup="NewEdit">
                                    <ValidationSettings RequiredField-IsRequired="true" />
                                </Aut:TextBox>
                            </div>
                            <div class="col-xs-12 col-md-2">
                                <Aut:Label runat="server" Text="سطح نقش" />
                                <Aut:TextBox runat="server" ID="txtRoleLevel" ClientInstanceName="txtRoleLevel" ValidationGroup="NewEdit">
                                    <ValidationSettings RequiredField-IsRequired="true" />
                                </Aut:TextBox>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-xs-12 col-md-6">
                                <br />
                                <br />
                                <Aut:TreeList ID="treeList" ClientInstanceName="treeList" runat="server" AutoGenerateColumns="False" KeyFieldName="gid"
                                    ParentFieldName="gref" PreviewFieldName="Title" Width="100%" SettingsSelection-Recursive="false" DataSourceID="odsRoles" OnCustomCallback="treeList_CustomCallback" Font-Names="B Nazanin" Font-Size="13pt">
                                    <SettingsSelection Enabled="True" AllowSelectAll="false" />
                                    <Settings GridLines="Horizontal" SuppressOuterGridLines="True" />
                                    <SettingsBehavior ExpandCollapseAction="NodeDblClick" ProcessSelectionChangedOnServer="false" />
                                    <ClientSideEvents SelectionChanged="treeList_SelectionChanged" />
                                    <Columns>
                                        <dx:TreeListTextColumn FieldName="ID" Visible="false" VisibleIndex="0">
                                        </dx:TreeListTextColumn>
                                        <dx:TreeListTextColumn FieldName="Title" VisibleIndex="1" Caption="عنوان" HeaderStyle-HorizontalAlign="Right">
                                            <HeaderStyle HorizontalAlign="Right"></HeaderStyle>
                                        </dx:TreeListTextColumn>
                                    </Columns>
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
    <asp:ObjectDataSource runat="server" ID="odsRoles" SelectMethod="GetAll_Cache" TypeName="Business.Automation.PrivilegeBusiness" />
</asp:Content>
