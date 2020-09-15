<%@ Page Title="تعریف درخواست" Language="C#" MasterPageFile="~/Pages/Site.Master" AutoEventWireup="true" CodeBehind="RequestModel.aspx.cs" Inherits="WebApp.Pages.RequestModel" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <script>
        function FetchInfo(rowid) {
            $.ajax({
                type: 'POST',
                url: 'RequestModel.aspx/GetInfo',
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
                ShowFailure("عنوان درخواست وارد نشده است");
                return;
            }
            var RequestInfo = {};
            try {
                if (key != undefined) {
                    RequestInfo.ID = key;
                }
            } catch (e) {

            }
            RequestInfo.Title = txtNameNew.GetValue();

            RequestInfo = JSON.stringify(RequestInfo);

            $.ajax({
                type: 'POST',
                url: 'RequestModel.aspx/SaveInfo',
                data: JSON.stringify({ Info: RequestInfo }),
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
            else if (s.GetValue() == "1A02762A-987C-4D24-B328-B14ED7A94BFD")
                ShowPopupFeature(key);
        }
        function Clear() {
            $('#NewEdit').slideUp('fast');
            btnNew.SetEnabled(true);
            btnNew.SetVisible(true);

            txtNameNew.SetValue("");
            cmbAction.SetEnabled(false);
            cmbAction.SetValue(null);
            action.Set('action', null);
            hdfAction.Set('ID', null)
        }

        function ShowPopupFeature(rowId) {
            action.Set("action", rowId);
            $("#popupFeature").modal('show');
            CancelFeature();
            grid.PerformCallback();
        }
        function CancelFeature(s, e) {
            $('#FeatureNewEdit').slideUp('fast');
            $('#btnFeatureNew').attr('disabled', null);
            clearFeature();
        }
        function clearFeature() {
            delete popupKey;
            cmbFeatureActions_SelectedIndexChanged(cmbFeatureActions, null);
            popupAction.Set("popupAction", null);
            ASPxClientEdit.ClearGroup("feature", true);
        }

        function cmbFeatureActions_SelectedIndexChanged(s, e) {
            if (typeof popupKey == 'undefined') {
                s.SetValue(null);
                s.SetEnabled(false);
                return;
            }
            if (s.GetValue() == "549D1BB7-0F97-411C-BA68-F55F504FDDCB")
                FetchFeature(popupKey);
            s.SetValue(null);
        }
        function NewFeature() {
            if ($("#btnFeatureNew").attr('disabled') == 'disabled')
                return false;
            $("#FeatureNewEdit").slideDown('fast', function () {
                $('.modal').animate({
                    scrollTop: $("#FeatureNewEdit").offset().top
                }, 1000);
            });
            $("#btnFeatureNew").attr('disabled', 'disabled');
            popupAction.Set("popupAction", 0);
            clearFeature();
        }

        function FetchFeature(rowid) {
            $.ajax({
                type: 'POST',
                url: 'RequestModel.aspx/GetFeatureGroup',
                data: JSON.stringify({ rowId: rowid }),
                contentType: "application/json; charset=utf-8",
                dataType: "JSON"
            }).then(
                function (data) {
                    if (data.d[0] == '1') {
                        var feature = $.parseJSON(data.d[1]);

                        txtTitleFa.SetText(feature.faTitle);
                        txtTitleEn.SetText(feature.enTitle);
                        cmbParameterType.SetValue(feature.ParameterTypeID);
                        //if (feature.FeatureGroupID != null) {
                        //    action.Set("action", feature.FeatureGroupID);
                        //}
                        $("#FeatureNewEdit").slideDown('fast', function () {
                            $('.modal').animate({
                                scrollTop: $("#FeatureNewEdit").offset().top
                            }, 1000);
                        });
                        $("#btnFeatureNew").attr('disabled', 'disabled');
                        popupAction.Set("popupAction", rowid);
                    }
                    else
                        ShowFailure(data.d[1]);
                },
                function (data) {
                    ShowFailure();
                });
        }

        function SaveFeature(s, e) {

            if (cmbParameterType.GetValue() == null) {
                ShowFailure("نوع پارامتر وارد نشده است");
                return;
            }
            if (txtTitleFa.GetValue() == null) {
                ShowFailure("عنوان فارسی وارد نشده است");
                return;
            }
            if (txtTitleEn.GetValue() == null) {
                ShowFailure("عنوان لاتین وارد نشده است");
                return;
            }
            if (typeof ReqID.Get('ID') == "undefined") {
                ShowFailure("نوع درخواست پیدا نشد");
                return;
            }


            var feature_info = {};
            feature_info.ID = typeof popupAction.Get("popupAction") == "undefined" ? null : popupAction.Get("popupAction");
            feature_info.ReqId = ReqID.Get('ID');
            feature_info.faTitle = txtTitleFa.GetText();
            feature_info.enTitle = txtTitleEn.GetText();
            feature_info.ParameterTypeID = cmbParameterType.GetValue();

            feature_info = JSON.stringify(feature_info);
            $.ajax({
                type: 'POST',
                url: 'RequestModel.aspx/SaveFeatureGroup',
                data: JSON.stringify({ featuregroup: feature_info }),
                contentType: "application/json; charset=utf-8",
                dataType: "JSON"
            }).then(
                function (data) {
                    if (data.d[0] == '1') {
                        ShowSuccess(data.d[1]);
                        CancelFeature();
                        grid.PerformCallback();
                    }
                    else
                        ShowFailure(data.d[1]);
                },
                function (data) {
                    ShowFailure(null);
                }
            );
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
                                <Aut:Label ID="lblSearchRoleModel" runat="server" Text="عنوان درخواست" />
                                <Aut:TextBox ID="txtSearchRoleModel" runat="server" Width="150" />
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
                        <ClientSideEvents SelectionChanged="function(s, e) { if (e.isSelected) { key = s.GetRowKey(e.visibleIndex); ReqID.Set('ID', s.GetRowKey(e.visibleIndex)); s.GetRowValues(e.visibleIndex,'ID',function(value){keyIdentifier = value}); Clear(); cmbAction.SetEnabled(true);} else cmbAction.SetEnabled(false);}" />
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

        <div class="row">
            <div class="col-xs-12 col-md-2">
                <div class="modal fade modal-wide" tabindex="-1" role="dialog" aria-labelledby="modtertit" aria-hidden="true" style="display: none;"></div>
            </div>
            <div class="col-xs-12 col-md-8">
                <div id="popupFeature" class="modal fade modal-wide" tabindex="-1" role="dialog" aria-labelledby="modtertit" aria-hidden="true" style="display: none; right: 25%;">
                    <div class="modal-dialog col-lg-8">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">×</span><span class="sr-only">Close</span></button>
                                <Aut:Label runat="server" CssClass="h4 modal-title" Text="تخصیص پارامتر" />
                            </div>
                            <div class="modal-body">
                                <div class="Search-Panel">
                                    <div style="display: inline-flex; margin-top: 7px;">
                                        <div style="margin-left: 10px;">
                                            <Aut:Button ID="btnFeatureNew" ClientInstanceName="btnFeatureNew" ClientIDMode="Static" runat="server" Text="جدید" CausesValidation="false" AutoPostBack="false" CssClass="Newbtn" Paddings-PaddingTop="10">
                                                <ClientSideEvents Click="function(s,e){NewFeature()}" />
                                            </Aut:Button>
                                        </div>
                                        <div>
                                            <div class="Action-Group">
                                                <Aut:Label ID="Label1" runat="server" Text="عملیات" CssClass="Action-Label" />
                                                <div class="Action-Combo">
                                                    <Aut:ComboBox ID="cmbFeatureActions" runat="server" ClientInstanceName="cmbFeatureActions" ClientEnabled="false" isaction="true"  Height="35px">
                                                        <ClientSideEvents SelectedIndexChanged="cmbFeatureActions_SelectedIndexChanged" />
                                                    </Aut:ComboBox>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div style="height: 7px;"></div>
                                <div class="row">
                                    <div class="col-xs-12">
                                        <Aut:Label runat="server" Text="پارامتر ها" />
                                        <Aut:GridView Width="100%" ID="grid" ClientInstanceName="grid" runat="server" KeyFieldName="ID" OnCustomCallback="grid_CustomCallback"
                                            defaultradioitemkey="0" denykeyfieldname="False" hasradio="False" AutoGenerateColumns="False"
                                            OnBeforeColumnSortingGrouping="grid_BeforeColumnSortingGrouping" OnPageIndexChanged="grid_PageIndexChanged">
                                            <SettingsBehavior AllowSelectSingleRowOnly="true" />
                                            <ClientSideEvents SelectionChanged="function(s, e) { CancelFeature(); if (e.isSelected) { popupKey = s.GetRowKey(e.visibleIndex); cmbFeatureActions.SetEnabled(true); } else cmbFeatureActions.SetEnabled(false); }" />
                                            <Columns>
                                                <dx:GridViewDataTextColumn FieldName="faTitle" Visible="True" Caption="عنوان فارسی" />
                                                <dx:GridViewDataTextColumn FieldName="enTitle" Visible="True" Caption="عنوان لاتین" />
                                                <dx:GridViewDataComboBoxColumn FieldName="ParameterTypeID" Caption="نوع پارامتر">
                                                    <PropertiesComboBox TextField="ParameterName" ValueField="ID" ValueType="System.Int64"
                                                        DataSourceID="odsParameterType">
                                                    </PropertiesComboBox>
                                                </dx:GridViewDataComboBoxColumn>
                                                <dx:GridViewDataTextColumn Visible="True" Caption="" Width="0" />
                                            </Columns>
                                        </Aut:GridView>
                                    </div>
                                </div>
                                <div style="height: 10px;"></div>
                                <div id="FeatureNewEdit" class="well edit">
                                    <div class="from">
                                        <div class="row">
                                            <div class="col-md-3">
                                                <Aut:Label runat="server" Text="عنوان فارسی" />
                                                <Aut:TextBox ID="txtTitleFa" ClientInstanceName="txtTitleFa" runat="server" masktype="title">
                                                    <ValidationSettings RequiredField-IsRequired="true" ValidationGroup="feature" />
                                                </Aut:TextBox>
                                            </div>
                                            <div class="col-md-3">
                                                <Aut:Label runat="server" Text="عنوان لاتین" />
                                                <Aut:TextBox ID="txtTitleEn" ClientInstanceName="txtTitleEn" runat="server" masktype="entitle">
                                                    <ValidationSettings RequiredField-IsRequired="true" ValidationGroup="feature" />
                                                </Aut:TextBox>
                                            </div>
                                            <div class="col-md-3">
                                                <Aut:Label runat="server" Text="نوع پارامتر" />
                                                <Aut:ComboBox ID="cmbParameterType" ClientInstanceName="cmbParameterType" runat="server" ValueField="ID" TextField="ParameterName" DataSourceID="odsParameterType" ValueType="System.Int64">
                                                </Aut:ComboBox>
                                            </div>

                                        </div>
                                        <div class="row">
                                            <br />
                                            <br />
                                            <div class="col-md-1" style="margin-left: 5px;">
                                                <Aut:Button ID="btnPopupSave" runat="server" Text="ذخیره" ClientSideEvents-Click="SaveFeature" AutoPostBack="false" CssClass="Savebtn" Paddings-PaddingTop="10" />
                                            </div>
                                            <div class="col-md-1">
                                                <Aut:Button runat="server" Text="لغو" AutoPostBack="false" ClientSideEvents-Click="CancelFeature" CausesValidation="false" CssClass="Cancelbtn" Paddings-PaddingTop="10" />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                            </div>
                        </div>
                        <!-- /.modal-content -->
                    </div>
                    <!-- /.modal-dialog -->
                </div>
            </div>
            <div class="col-xs-12 col-md-2"></div>
        </div>

        <dx:ASPxHiddenField ID="ReqID" ClientInstanceName="ReqID" runat="server" />
        <dx:ASPxHiddenField ID="popupAction" ClientInstanceName="popupAction" runat="server" />
        <asp:ObjectDataSource runat="server" ID="odsParameterType" SelectMethod="GetAllList" TypeName="Business.Automation.ParameterTypeBusiness" />
        <asp:ObjectDataSource runat="server" ID="odsRequestModel" SelectMethod="GetAllList" TypeName="Business.Automation.RequestModelBusiness" />

    </div>
</asp:Content>
