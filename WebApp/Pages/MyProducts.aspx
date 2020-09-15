<%@ Page Title="وسایل من" Language="C#" MasterPageFile="~/Pages/Site.Master" AutoEventWireup="true" CodeBehind="MyProducts.aspx.cs"
    Inherits="WebApp.Pages.MyProducts" gref="E37F8409-4AB1-47D8-B4DA-B357589884B8" gid="BE929B84-B1E4-4CE3-94B7-9DD8BCF63E10" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <script>
        var repairstr;
        var table;
        $(document).ready(function () {
            $.ajax({
                type: 'POST',
                url: 'MyProducts.aspx/GetTableRows',
                contentType: "application/json; charset=utf-8",
                dataType: "JSON"
            }).then(
                function (data) {
                    if (data.d[0] == '1') {
                        var tablediv = "ProductTables";
                        var tabledata = $.parseJSON(data.d[1]);
                        var printIcon = function (cell, formatterParams) { //plain text value
                            return "<img style=\"width:70%;\" src=\"../Images/print.png\" />";
                        };
                        var tablecolumns = [
                            {
                                title: "اطلاعات وسیله",
                                columns: [
                                    { title: "شناسه", field: "ID", width: 100 },
                                    { title: "نام وسیله", field: "ProductName" },
                                    { title: "مدل وسیله", field: "ProductBrand" },
                                    { title: "وضعیت وسیله", field: "ProductStatus" },
                                    { title: "سریال", field: "SerialNo" },
                                    { title: "بارکد وسیله", field: "UserProductBarcodNo" },
                                ],
                            },
                            {
                                title: "اطلاعات شخص",
                                columns: [
                                    { title: "نام", field: "FirstName" },
                                    { title: "نام خانوادگی", field: "LastName" },
                                    { title: "واحد", field: "RoleTitle" },
                                ],
                            },
                            {
                                title: "سایر اطلاعات",
                                columns: [
                                    //{ title: "تاریخ تحویل", field: "ReceiveTime", width: 150 },
                                    { title: "توضیحات", field: "Description" },
                                    {
                                        formatter: printIcon, width: 40, hozAlign: "center", cellClick: function (e, cell) {
                                            var QRURL = cell.getRow().getData().UserProductBarcodNo;
                                            $(".modal-body").html("<img width=\"100%\" height=\"100%\" src=\"" + "../Images/" + QRURL + ".jpg" + "\" />");
                                            $("#myModal").modal("toggle");
                                        }
                                    },
                                ],
                            },
                        ];
                         table = new Tabulator("#" + tablediv, {
                            reactiveData: true,
                            selectable: 1,
                            maxHeight: "100%",
                            pagination: "local", //enable local pagination.
                            paginationSize: 15,
                            responsiveLayout: "hide",
                            data: tabledata, //assign data to table
                            layout: "fitColumns", //fit columns to width of table (optional)
                            columns: tablecolumns,
                            rowClick: function (e, row) { //trigger an alert message when the row is clicked
                                Clear();
                                key = row.getData().ID;
                                repairstr = "وسیله " + row.getData().ProductName + " به مدل و سریال " + row.getData().ProductBrand + row.getData().SerialNo + " نیاز به تعمیر دارد یا خراب شده است؟";
                                hdfAction.Set('ID', key);
                                cmbAction.SetEnabled(true);
                            },
                        });
                        $("#downloadxlsx").click(function () {
                            table.download("xlsx", "data.xlsx", { sheetName: "My Data" });
                        });
                        $("#repairbutton").click(function () {
                            var rowinfo = hdfAction.Get('ID');

                            $.ajax({
                                type: 'POST',
                                url: 'MyProducts.aspx/RepairProduct',
                                data: JSON.stringify({ prid: rowinfo }),
                                contentType: "application/json; charset=utf-8",
                                dataType: "JSON"
                            }).then(
                                function (data) {
                                    if (data.d[0] == '1') {
                                        Cancel();
                                        ShowSuccess();
                                        CreateTable();
                                        $("#myModal").modal("toggle");
                                    }
                                    else
                                        ShowFailure(data.d[1]);
                                },
                                function (data) {
                                    ShowFailure();
                                });
                        });
                    }
                    else
                        ShowFailure(data.d[1]);
                },
                function (data) {
                    ShowFailure();
                });
        });
        function CreateTable() {
            $.ajax({
                type: 'POST',
                url: 'MyProducts.aspx/GetTableRows',
                contentType: "application/json; charset=utf-8",
                dataType: "JSON"
            }).then(
                function (data) {
                    if (data.d[0] == '1') {
                        var tabledatas = $.parseJSON(data.d[1]);
                        table.setData(tabledatas);
                    }
                    else
                        ShowFailure(data.d[1]);
                },
                function (data) {
                    ShowFailure();
                });
        }
        function Clear() {
            cmbAction.SetValue(null);
            cmbAction.SetEnabled(false);
            hdfAction.Set('ID', null);
        }
        function NeedRepair(key) {
            $(".modal-body").html(repairstr);
            $("#myModal").modal("toggle");
        }
        function actions_SelectedIndexChanged(s, e) {
            if (typeof key == 'undefined') {
                cmbAction.SetValue(null);
                cmbAction.SetEnabled(false);
                return;
            }
            if (s.GetValue() == "3BCAB3FD-00B6-43F6-BEA3-DC4693693DC6")
                NeedRepair(key);
        }

    </script>
    <div class="container-fluid">

        <div class="row">
            <div class="col-xs-12 col-md-2"></div>
            <div class="col-xs-12 col-md-8">
                <br />
                <div class="well">
                    <Aut:Button ID="downloadxlsx" ClientInstanceName="downloadxlsx" ClientIDMode="Static" Width="150" runat="server" Text="دریافت اکسل" CssClass="Newbtn">
                    </Aut:Button>
                    <div style="margin-top: 7px;">
                        <div>
                            <div class="Action-Group">
                                <Aut:Label ID="lblAction" runat="server" Text="عملیات" CssClass="Action-Label" />
                                <div class="Action-Combo">
                                    <Aut:ComboBox ID="cmbAction" runat="server" ClientInstanceName="cmbAction" ClientEnabled="False" isaction="true" Height="35px">
                                        <ClientSideEvents SelectedIndexChanged="actions_SelectedIndexChanged" />
                                    </Aut:ComboBox>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row" style="margin-top: 10px;">
                    </div>
                    <div id="ProductTables"></div>
                </div>
            </div>
            <div class="col-xs-12 col-md-2"></div>
        </div>
        <br />
    </div>
    <div id="myModal" class="modal fade" role="dialog">
        <div class="modal-dialog" style="font-family: Vazir">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title">اعلام خرابی</h4>
                </div>
                <div class="modal-body">
                </div>
                <div class="modal-footer">
                    <button type="button" id="repairbutton" class="btn btn-warning">اعلام خرابی</button>
                    <button type="button" class="btn btn-danger" data-dismiss="modal">انصراف</button>
                </div>
            </div>
        </div>
    </div>
    <Aut:HiddenField ID="hdfProduct" ClientInstanceName="hdfProduct" runat="server" />
</asp:Content>
