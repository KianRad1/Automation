<%@ Page Title="ثبت درخواست" Language="C#" MasterPageFile="~/Pages/Site.Master" AutoEventWireup="true" CodeBehind="SubmitRequest.aspx.cs" Inherits="WebApp.Pages.SubmitRequest"
    gref="A9462B29-B091-4F3D-8F48-0EC42BDF460B" gid="902C8971-0A51-4A01-8CC1-FB0DC2B6761B" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <script>
        function FetchInfo(rowid) {
            $.ajax({
                type: 'POST',
                url: 'SubmitRequest.aspx/GetInfo',
                data: JSON.stringify({ Info: rowid }),
                contentType: "application/json; charset=utf-8",
                dataType: "JSON"
            }).then(
                function (data) {
                    if (data.d[0] == '1') {
                        hdfAction.Set('ID', rowid);
                        var Request = $.parseJSON(data.d[1]);
                        cmbrequestmodel.SetValue(Request.RequestModelID);
                        txtDescription.SetText(Request.description);

                        //Send
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
            if (cmbrequestmodel.GetValue() == null) {
                ShowFailure('نوع درخواست مشخص نشده است');
                return;
            }
            var ListOfParam = [];
            var allinput = $("#parametersection input");
            for (var i = 0; i < allinput.length; i++ ) {
                var element = {};
                element.ParameterID = allinput[i].id;
                element.ParameterType = allinput[i].type;
                element.ParameterValue = allinput[i].value;
                ListOfParam.push(element);
            }

            var RequestInfo = {};
            RequestInfo.ReqID = hdfAction.Get('ID');
            RequestInfo.RequestModelID = cmbrequestmodel.GetValue();
            RequestInfo.description = txtDescription.GetValue();
            RequestInfo.ParamList = ListOfParam;

            RequestInfo = JSON.stringify(RequestInfo);

            $.ajax({
                type: 'POST',
                url: 'SubmitRequest.aspx/SaveInfo',
                data: JSON.stringify({ Info: RequestInfo }),
                contentType: "application/json; charset=utf-8",
                dataType: "JSON"
            }).then(
                function (data) {
                    if (data.d[0] == '1') {
                        Cancel();
                        gridView.PerformCallback();
                        ShowSuccess("درخواست با موفقیت ثبت شد");
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

            txtDescription.SetValue("");
            cmbAction.SetEnabled(false);
            cmbAction.SetValue(null);
            cmbrequestmodel.SetValue(null);
            hdfAction.Set('ID', null);
        }
        function SendRequest() {
            var ReqID = hdfAction.Get('ID');
            if (ReqID == null) {
                ShowFailure("درخواستی برای ارسال انتخاب نشده است");
                return;
            }
            $.ajax({
                type: 'POST',
                url: 'SubmitRequest.aspx/SendRequest',
                data: JSON.stringify({ Info: ReqID }),
                contentType: "application/json; charset=utf-8",
                dataType: "JSON"
            }).then(
                function (data) {
                    if (data.d[0] == '1') {
                        Cancel();
                        gridView.PerformCallback();
                        ShowSuccess("درخواست با موفقیت ارسال شد");
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

        function CreateParameterElemnts(element) {
            $("#parametersection").append("<div class=\"col - xs - 12 col - md - 1\"><label>" + element.faTitle + "</label><input id=\"" + element.ParameterID + "\" type=\"" + element.ParameterType + "\"/>");
        }
        function parameteractions_SelectedIndexChanged(s, e) {
            if (cmbrequestmodel.GetValue() == null)
                return;

            var ReqModelid = JSON.stringify(cmbrequestmodel.GetValue());
            $.ajax({
                type: 'POST',
                url: 'SubmitRequest.aspx/AddParameter',
                data: JSON.stringify({ Info: ReqModelid }),
                contentType: "application/json; charset=utf-8",
                dataType: "JSON"
            }).then(
                function (data) {
                    if (data.d[0] == '1') {
                        var entity = JSON.parse(data.d[1]);
                        entity.forEach(CreateParameterElemnts);
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
    </script>
    <Aut:HiddenField ID="hdfUser" ClientInstanceName="hdfUser" runat="server" />
    <div class="container-fluid">
        <div class="row">
            <div class="col-xs-12 col-md-2"></div>
            <div class="col-xs-12 col-md-8">
                <div class="well" style="margin-bottom: 8px;">
                    <div class="Search-Panel">
                        <div class="row">
                            <div class="col-xs-6 col-md-2" style="margin-left: -20px;">
                                <Aut:Label ID="lblSearchCreatedBy" runat="server" Text="ایجاد شده توسط" />
                                <Aut:TextBox ID="txtSearchCreatedBy" runat="server" Width="150" />
                            </div>
                            <div class="col-xs-6 col-md-2" style="margin-left: -20px;">
                                <Aut:Label ID="lblSearchCreatedFrom" runat="server" Text="از تاریخ" />
                                <Aut:TextBox ID="txtSearchCreatedFrom" runat="server" Width="150" />
                            </div>
                            <div class="col-xs-6 col-md-2" style="margin-left: -20px;">
                                <Aut:Label ID="lblSearchCreatedTo" runat="server" Text="تا تاریخ" />
                                <Aut:TextBox ID="txtSearchCreatedTo" runat="server" Width="150" />
                            </div>
                            <div class="col-xs-6 col-md-2">
                                <Aut:Label ID="lblSearchReqModel" runat="server" Text="نوع درخواست" />
                                <Aut:ComboBox ID="cmbSearchReqModel" runat="server" ValueField="ID" TextField="Title"
                                    DataSourceID="odsRequestModel" ValueType="System.Int64">
                                </Aut:ComboBox>
                            </div>
                            <div class="col-xs-6 col-md-2">
                                <Aut:Label ID="lblSearchReqStatus" runat="server" Text="وضعیت درخواست" />
                                <Aut:ComboBox ID="cmbSearchStatus" runat="server" ValueField="ID" TextField="Title"
                                    DataSourceID="odsStatus" ValueType="System.Int64">
                                </Aut:ComboBox>
                            </div>
                            <div class="col-xs-6 col-md-2">
                                <Aut:Label ID="lblSearchCurrentLevel" runat="server" Text="سطح بررسی کننده" />
                                <Aut:ComboBox ID="cmbSearchCurrentLevel" runat="server" ValueField="ID" TextField="Title"
                                    DataSourceID="odsLevel" ValueType="System.Int64">
                                </Aut:ComboBox>
                            </div>
                            <div class="col-xs-6 col-md-2">
                                <Aut:Label ID="lblSearchRoleGroup" runat="server" Text="بخش بررسی کننده" />
                                <Aut:ComboBox ID="cmbSearchRoleGroup" runat="server" ValueField="ID" TextField="Title"
                                    DataSourceID="odsRoleGroup" ValueType="System.Int64">
                                </Aut:ComboBox>
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
                    <Aut:GridView Width="100%" ID="gridView" ClientInstanceName="gridView" CssClass="Grid" runat="server" KeyFieldName="RequestID" defaultradioitemkey="0" AutoGenerateColumns="False"
                        OnBeforeColumnSortingGrouping="gridView_BeforeColumnSortingGrouping" OnCustomCallback="gridView_CustomCallback" OnHtmlRowPrepared="gridView_HtmlRowPrepared">
                        <ClientSideEvents SelectionChanged="function(s, e) { if (e.isSelected) {Clear(); key = s.GetRowKey(e.visibleIndex); s.GetRowValues(e.visibleIndex,'ID',function(value){console.log(value);});  hdfAction.Set('ID', s.GetRowKey(e.visibleIndex));  cmbAction.SetEnabled(true);} else cmbAction.SetEnabled(false);}" />
                        <Columns>
                            <dx:GridViewDataTextColumn FieldName="RequestID" Visible="True" Caption="شناسه" Width="50" />
                            <dx:GridViewDataTextColumn FieldName="CreatedBy" Visible="True" Caption="ایجاد شده توسط" />
                            <dx:GridViewDataTextColumn FieldName="CreatedOn" Visible="True" Caption="تاریخ ایجاد" />
                            <dx:GridViewDataTextColumn FieldName="description" Visible="True" Caption="توضیحات" />
                            <dx:GridViewDataComboBoxColumn FieldName="RequestModelID" Caption="نوع درخواست">
                                <PropertiesComboBox TextField="Title" ValueField="ID" ValueType="System.Int64"
                                    DataSourceID="odsrequestmodel">
                                </PropertiesComboBox>
                            </dx:GridViewDataComboBoxColumn>
                            <dx:GridViewDataComboBoxColumn FieldName="StatusID" Caption="وضعیت درخواست">
                                <PropertiesComboBox TextField="Title" ValueField="ID" ValueType="System.Int64"
                                    DataSourceID="odsStatus">
                                </PropertiesComboBox>
                            </dx:GridViewDataComboBoxColumn>
                            <dx:GridViewDataComboBoxColumn FieldName="CurrentLevel" Caption="سطح بررسی کننده">
                                <PropertiesComboBox TextField="Title" ValueField="ID" ValueType="System.Int64"
                                    DataSourceID="odsLevel">
                                </PropertiesComboBox>
                            </dx:GridViewDataComboBoxColumn>
                            <dx:GridViewDataComboBoxColumn FieldName="CurrentRoleGroup" Caption="بخش بررسی کننده">
                                <PropertiesComboBox TextField="Title" ValueField="ID" ValueType="System.Int64"
                                    DataSourceID="odsRoleGroup">
                                </PropertiesComboBox>
                            </dx:GridViewDataComboBoxColumn>
                            <dx:GridViewDataColumn Caption="وضعیت ارسال" Width="90">
                                <DataItemTemplate>
                                    <img alt="" id="img" runat="server" src='<%# GetImageName(Eval("Sent")) %>' />
                                </DataItemTemplate>
                            </dx:GridViewDataColumn>

                            <dx:GridViewDataColumn FieldName="Sent" Visible="True" Caption="ارسال درخواست">
                                <DataItemTemplate>
                                    <Aut:Button runat="server" Text="ارسال" ID="Sendbtn" ClientInstanceName="Sendbtn" ClientSideEvents-Click="SendRequest" CssClass="Savebtn" />
                                </DataItemTemplate>
                            </dx:GridViewDataColumn>
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
                            <div class="row">
                                <div class="col-xs-12 col-sm-6 col-md-6">
                                    <Aut:Label runat="server" Text="نوع درخواست" />
                                    <Aut:ComboBox ID="cmbrequestmodel" ClientInstanceName="cmbrequestmodel" runat="server" ValueField="ID" TextField="Title" DataSourceID="odsrequestmodel" ValueType="System.Int64">
                                        <ValidationSettings RequiredField-IsRequired="true">
                                            <RequiredField IsRequired="True"></RequiredField>
                                        </ValidationSettings>
                                        <ClientSideEvents SelectedIndexChanged="parameteractions_SelectedIndexChanged" />
                                    </Aut:ComboBox>
                                </div>
                            </div>
                            <div class="row">
                                <div id="parametersection" class="col-md-12" style="font-family:IRANSansWeb_Light">
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-xs-12 col-sm-6 col-md-12">
                                    <Aut:Label runat="server" Text="توضیحات" />
                                    <Aut:Memo ID="txtDescription" ClientInstanceName="txtDescription" runat="server" Height="80px" Width="409px">
                                    </Aut:Memo>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <br />
                            <br />
                            <div class="col-xs-12 col-sm-6 col-md-6">
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
    <asp:ObjectDataSource runat="server" ID="odsrequestmodel" SelectMethod="GetAllRequest"
        TypeName="WebApp.Classes.Pages.RequestType.RequestTypeInfo"></asp:ObjectDataSource>
    <asp:ObjectDataSource runat="server" ID="odsLevel" SelectMethod="GetAllList"
        TypeName="Business.Automation.LevelBusiness"></asp:ObjectDataSource>
    <asp:ObjectDataSource runat="server" ID="odsStatus" SelectMethod="GetAllList"
        TypeName="Business.Automation.StatusBusiness"></asp:ObjectDataSource>
    <asp:ObjectDataSource runat="server" ID="odsRoleGroup" SelectMethod="GetAllList"
        TypeName="Business.Automation.RoleGroupBusiness"></asp:ObjectDataSource>
</asp:Content>
