<%@ Page Title="داشبورد" Language="C#" MasterPageFile="~/Pages/Site.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="WebApp.Pages.Dashboard"
    gref="A9462B29-B091-4F3D-8F48-0EC42BDF460B" gid="E2BE42FD-5530-4668-AC12-74D33274AE7F" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <script>
        function FetchInfo(rowid) {
            $.ajax({
                type: 'POST',
                url: 'Dashboard.aspx/GetInfo',
                data: JSON.stringify({ Info: rowid }),
                contentType: "application/json; charset=utf-8",
                dataType: "JSON"
            }).then(
                function (data) {
                    if (data.d[0] == '1') {
                        hdfAction.Set('ID', rowid);
                        var Request = $.parseJSON(data.d[1]);
                        if (Request.StatusID == 4 || Request.StatusID == 5) {
                            Cancel();
                            ShowWarning("درخواست در مرحله بررسی نیست");
                            return;
                        }

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
                    ShowFailure(data);
                });
        }
        function Clear() {
            $('#NewEdit').slideUp('fast');
            txtDescription.SetValue("");
            cmbAction.SetEnabled(false);
            cmbAction.SetValue(null);
            hdfAction.Set('ID', null);
        }
        function ConfirmRequest() {
            var ConfirmReq = {};
            ConfirmReq.ReqID = hdfAction.Get('ID');
            if (ConfirmReq.ReqID == null) {
                ShowFailure("هیچ درخواستی انتخاب نشده است")
                return
            }
            if (txtDescription.GetValue() != null) {
                ConfirmReq.Description = txtDescription.GetValue();
            }
            ConfirmReq = JSON.stringify(ConfirmReq);
            $.ajax({
                type: 'POST',
                url: 'Dashboard.aspx/Confirm',
                data: JSON.stringify({ Info: ConfirmReq }),
                contentType: "application/json; charset=utf-8",
                dataType: "JSON"
            }).then(
                function (data) {
                    if (data.d[0] == '1') {
                        Cancel();
                        gridView.PerformCallback();
                        gridViewReport.PerformCallback();
                        ShowSuccess("درخواست با موفقیت تایید شد");
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
        function RejectRequest() {
            var RejectReq = {};
            RejectReq.ReqID = hdfAction.Get('ID');
            if (RejectReq.ReqID == null) {
                ShowFailure("هیچ درخواستی انتخاب نشده است")
                return
            }
            if (txtDescription.GetValue() == null) {
                ShowFailure('توضیحات رد درخواست نوشته نشده است');
                return;
            }
            RejectReq.Description = txtDescription.GetValue();
            RejectReq = JSON.stringify(RejectReq);
            $.ajax({
                type: 'POST',
                url: 'Dashboard.aspx/Reject',
                data: JSON.stringify({ Info: RejectReq }),
                contentType: "application/json; charset=utf-8",
                dataType: "JSON"
            }).then(
                function (data) {
                    if (data.d[0] == '1') {
                        Cancel();
                        gridView.PerformCallback();
                        gridViewReport.PerformCallback();
                        ShowSuccess("درخواست با موفقیت رد شد");
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
            else if (s.GetValue() == "5D18A142-3091-4F8A-AD50-CD02D275EA1E")
                ShowPopupDetail(key);
        }

        function ShowPopupDetail(rowid) {
            $.ajax({
                type: 'POST',
                url: 'Dashboard.aspx/GetDetail',
                data: JSON.stringify({ rowId: rowid }),
                contentType: "application/json; charset=utf-8",
                dataType: "JSON"
            }).then(function (data) {
                if (data.d[0] == '1') {
                    var ReqDetail = $.parseJSON(data.d[1]);

                    console.log(ReqDetail);
                    $("#popupFestivalDetail").modal("show");
                } else {
                    ShowFailure(data.d[1])
                }
            },
                function (data) {
                    ShowFailure(null);
                }
            );
        }
    </script>
    <div class="container-fluid">
        <div class="row">
            <div class="col-md-4"></div>
            <div class="col-md-5">
                <ul class="nav nav-tabs">
                    <li class="active"><a data-toggle="tab" href="#menu1" style="font-family: iRANSANSWEB_Bold; font-size: 20px; border-radius: 15px">درخواست های  بررسی نشده</a></li>
                    <li><a data-toggle="tab" href="#menu2" style="font-family: iRANSANSWEB_Bold; font-size: 20px; border-radius: 15px;">درخواست های  پایان یافته</a></li>
                </ul>
            </div>
            <div class="col-md-3"></div>
        </div>


        <br />

        <div class="tab-content">
            <div id="menu1" class="tab-pane fade in active">
                <div class="row">
                    <div class="col-xs-12 col-md-2"></div>
                    <div class="col-xs-12 col-md-8">
                        <div class="well">
                            <div style="display: inline-flex; margin-top: 7px;">
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
                            <Aut:GridView Width="100%" ID="gridView" ClientInstanceName="gridView" CssClass="Grid" runat="server" KeyFieldName="RequestID" defaultradioitemkey="0" AutoGenerateColumns="False"
                                OnCustomCallback="gridView_CustomCallback" OnBeforeColumnSortingGrouping="gridView_BeforeColumnSortingGrouping" OnHtmlRowPrepared="gridView_HtmlRowPrepared">
                                <ClientSideEvents SelectionChanged="function(s, e) { if (e.isSelected) {Clear(); key = s.GetRowKey(e.visibleIndex); s.GetRowValues(e.visibleIndex,'ID',function(value){keyIdentifier = value});  hdfAction.Set('ID', s.GetRowKey(e.visibleIndex));  cmbAction.SetEnabled(true);} else cmbAction.SetEnabled(false);}" />
                                <Columns>
                                    <dx:GridViewDataTextColumn FieldName="RequestID" Visible="True" Caption="شناسه" Width="50" />
                                    <dx:GridViewDataTextColumn FieldName="CreatedBy" Visible="True" Caption="ایجاد شده توسط" />
                                    <dx:GridViewDataTextColumn FieldName="CreatedOn" Visible="True" Caption="تاریخ ایجاد" />
                                    <dx:GridViewDataTextColumn FieldName="description" Visible="True" Caption="توضیحات" />
                                    <dx:GridViewDataComboBoxColumn FieldName="StatusID" Caption="مرحله درخواست">
                                        <PropertiesComboBox TextField="Title" ValueField="ID" ValueType="System.Int64"
                                            DataSourceID="odsStatus">
                                        </PropertiesComboBox>
                                    </dx:GridViewDataComboBoxColumn>
                                    <dx:GridViewDataComboBoxColumn FieldName="RequestModelID" Caption="نوع درخواست">
                                        <PropertiesComboBox TextField="Title" ValueField="ID" ValueType="System.Int64"
                                            DataSourceID="odsrequestmodel">
                                        </PropertiesComboBox>
                                    </dx:GridViewDataComboBoxColumn>
                                    <dx:GridViewDataTextColumn FieldName="LevelTitle" Visible="True" Caption="سطح درخواست دهنده" />
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
                                    <div class="col-xs-12 col-sm-6 col-md-12">
                                        <Aut:Label runat="server" Text="توضیحات" />
                                        <Aut:Memo ID="txtDescription" ClientInstanceName="txtDescription" runat="server" Height="80px" Width="409px">
                                        </Aut:Memo>
                                    </div>
                                </div>
                                <div class="row">
                                    <br />
                                    <br />
                                    <div class="col-xs-12 col-sm-6 col-md-12">
                                        <Aut:Button runat="server" Text="تایید" ClientSideEvents-Click="ConfirmRequest" BackColor="Green" />
                                        <Aut:Button runat="server" Text="رد" ClientSideEvents-Click="RejectRequest" BackColor="Red" />
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xs-12 col-md-2"></div>
                </div>
            </div>
            <div id="menu2" class="tab-pane fade">
                <div class="row">
                    <div class="col-md-2"></div>
                    <div class="col-md-8">
                        <div class="well">
                            <Aut:GridView Width="100%" ID="gridViewReport" ClientInstanceName="gridViewReport" CssClass="Grid" runat="server" KeyFieldName="RequestID" defaultradioitemkey="0" AutoGenerateColumns="False"
                                OnCustomCallback="gridViewReport_CustomCallback" OnBeforeColumnSortingGrouping="gridViewReport_BeforeColumnSortingGrouping" OnHtmlRowPrepared="gridViewReport_HtmlRowPrepared">
                                <%--<ClientSideEvents SelectionChanged="function(s, e) { if (e.isSelected) {Clear(); key = s.GetRowKey(e.visibleIndex); s.GetRowValues(e.visibleIndex,'ID',function(value){keyIdentifier = value});  hdfAction.Set('ID', s.GetRowKey(e.visibleIndex));  cmbAction.SetEnabled(true);} else cmbAction.SetEnabled(false);}" />--%>
                                <Columns>
                                    <dx:GridViewDataTextColumn FieldName="RequestID" Visible="True" Caption="شناسه" Width="50" />
                                    <dx:GridViewDataTextColumn FieldName="CreatedBy" Visible="True" Caption="ایجاد شده توسط" />
                                    <dx:GridViewDataTextColumn FieldName="CreatedOn" Visible="True" Caption="تاریخ ایجاد" />
                                    <dx:GridViewDataTextColumn FieldName="description" Visible="True" Caption="توضیحات" />
                                    <dx:GridViewDataComboBoxColumn FieldName="StatusID" Caption="مرحله درخواست">
                                        <PropertiesComboBox TextField="Title" ValueField="ID" ValueType="System.Int64"
                                            DataSourceID="odsStatus">
                                        </PropertiesComboBox>
                                    </dx:GridViewDataComboBoxColumn>
                                    <dx:GridViewDataComboBoxColumn FieldName="RequestModelID" Caption="نوع درخواست">
                                        <PropertiesComboBox TextField="Title" ValueField="ID" ValueType="System.Int64"
                                            DataSourceID="odsrequestmodel">
                                        </PropertiesComboBox>
                                    </dx:GridViewDataComboBoxColumn>
                                    <dx:GridViewDataTextColumn FieldName="LevelTitle" Visible="True" Caption="سطح درخواست دهنده" />
                                    <dx:GridViewDataTextColumn Visible="True" Caption="" Width="0" />
                                </Columns>
                            </Aut:GridView>
                        </div>
                    </div>
                    <div class="col-md-2"></div>
                </div>
            </div>
        </div>


        <div id="popupFestivalDetail" class="modal fade modal-wide" tabindex="-1" role="dialog" aria-labelledby="popupFestivalDetailTitle" aria-hidden="true" style="display: none; right: 25%">
            <div class="modal-dialog col-lg-8">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">×</span><span class="sr-only">Close</span></button>
                        <Aut:label runat="server" Font-Size="24px"  text="جزییات" />
                    </div>
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-xs-12">
                                <div class="filds">
                                    
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
    <asp:ObjectDataSource runat="server" ID="odsrequestmodel" SelectMethod="GetAllList"
        TypeName="Business.Automation.RequestModelBusiness"></asp:ObjectDataSource>
    <asp:ObjectDataSource runat="server" ID="odsLevel" SelectMethod="GetAllList"
        TypeName="Business.Automation.LevelBusiness"></asp:ObjectDataSource>
    <asp:ObjectDataSource runat="server" ID="odsStatus" SelectMethod="GetAllList"
        TypeName="Business.Automation.StatusBusiness"></asp:ObjectDataSource>
</asp:Content>
