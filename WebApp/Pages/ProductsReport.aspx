<%@ Page Title="گزارش اموال شرکت" Language="C#" MasterPageFile="~/Pages/Site.Master" AutoEventWireup="true" CodeBehind="ProductsReport.aspx.cs"
    Inherits="WebApp.Pages.ProductsReport" gref="E37F8409-4AB1-47D8-B4DA-B357589884B8" gid="AB8AD16D-4ED5-4B0D-A9C7-AA61BDB4BC64" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <script>
        $(document).ready(function () {
            var tablediv;
            var tabledata;
            var tablecolumns;
            var table;
            $('#selectproductdetail').prop('disabled', 'disabled');
            $('#selectuserbygroup').prop('disabled', 'disabled');
            $.ajax({
                type: 'POST',
                url: 'ProductsReport.aspx/GetTableRows',
                contentType: "application/json; charset=utf-8",
                dataType: "JSON"
            }).then(
                function (data) {
                    if (data.d[0] == '1') {
                        tablediv = "ProductTables";
                        tabledata = $.parseJSON(data.d[1]);
                        var printIcon = function (cell, formatterParams) { //plain text value
                            return "<img style=\"width:70%;\" src=\"../Images/print.png\" />";
                        };
                        tablecolumns = [
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
                                            $("#printqr").click(function () {
                                                popup = window.open("../Images/" + QRURL + ".jpg");
                                                popup.focus();
                                                popup.print();
                                            });
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
                                hdfAction.Set('ID', key);
                                cmbAction.SetEnabled(true);
                            },
                        });
                        $("#downloadxlsx").click(function () {
                            table.download("xlsx", "data.xlsx", { sheetName: "My Data" });
                        });
                    }
                    else
                        ShowFailure(data.d[1]);
                },
                function (data) {
                    ShowFailure();
                });

            $("#btnSearch").click(function () {
                var filterlist = [];
                var ProductIDval = ($('#selectproductdetail').find(":selected").val() == 0) ? null : $('#selectproductdetail').find(":selected").val();
                var productidvalobj = { field: "ID", type: "like", value: ProductIDval };
                if (productidvalobj.value != null)
                    filterlist.push(productidvalobj);
                var ProductStatusVal = (cmbproductstatus.GetText() == "انتخاب") ? null : cmbproductstatus.GetText();
                var productstatusvalobj = { field: "ProductStatus", type: "like", value: ProductStatusVal };
                if (productstatusvalobj.value != null)
                    filterlist.push(productstatusvalobj);
                var Productusergroup = (cmbusergroup.GetText() == "انتخاب") ? null : cmbusergroup.GetText();
                var Productusergroupobj = { field: "RoleTitle", type: "like", value: Productusergroup };
                if (Productusergroupobj.value != null)
                    filterlist.push(Productusergroupobj);
                var Productuserfamily = ($('#selectuserbygroup').find(":selected").text() == "انتخاب") ? null : $('#selectuserbygroup').find(":selected").text();
                var Productuserfamilyobj = { field: "LastName", type: "like", value: Productuserfamily };
                if (Productuserfamilyobj.value != null)
                    filterlist.push(Productuserfamilyobj);
                table.setFilter(filterlist);
            });
            $("#btnClearFilter").click(function () {
                cmbproduct.SetValue(null);
                cmbproductstatus.SetValue(null);
                cmbusergroup.SetValue(null);
                document.getElementById("selectproductdetail").innerHTML = "<option value=\"0\">انتخاب</option>";
                document.getElementById("selectuserbygroup").innerHTML = "<option value=\"0\">انتخاب</option>";
                $('#selectproductdetail').prop('disabled', 'disabled');
                $('#selectuserbygroup').prop('disabled', 'disabled');
                table.clearFilter();
            });


        });

        function FetchInfo(rowid) {
            $.ajax({
                type: 'POST',
                url: 'Product.aspx/GetInfo',
                data: JSON.stringify({ Info: rowid }),
                contentType: "application/json; charset=utf-8",
                dataType: "JSON"
            }).then(
                function (data) {
                    if (data.d[0] == '1') {
                        var product = $.parseJSON(data.d[1]);
                        cmbproducttype.SetValue(product.ProductTypeID);
                        cmbproductstatus.SetValue(product.Status);
                        //txtProductcount.SetText(product.ProductCount);
                        txtProductmodel.SetText(product.ProductModel);
                        txtDescription.SetText(product.Description);
                        txtSerialNo.SetText(product.SerialNo);
                        hdfAction.Set('ID', rowid);

                        btnNew.SetEnabled(false);
                        btnNew.SetVisible(false)
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
        function Clear() {
            $('#NewEdit').slideUp('fast');

            hdfAction.Set('ID', null);
        }

        function cmbproduct_SelectedIndexChanged(s, e) {
            var ProductTypeID = cmbproduct.GetValue();
            hdfProduct.Set('TypeID', ProductTypeID)
            $.ajax({
                type: 'POST',
                url: 'UserProduct.aspx/GetProductDetail',
                data: JSON.stringify({ Info: ProductTypeID }),
                contentType: "application/json; charset=utf-8",
                dataType: "JSON"
            }).then(
                function (data) {
                    if (data.d[0] == '1') {
                        console.log(data.d[1]);
                        var prdetail = JSON.parse(data.d[1]);
                        document.getElementById("selectproductdetail").innerHTML = "<option value=\"0\">انتخاب</option>";
                        for (var i = 0; i < prdetail.length; i++) {
                            document.getElementById("selectproductdetail").innerHTML += "<option value=\"" + prdetail[i].ID + "\">" + prdetail[i].ProductBrand + prdetail[i].SerialNo + "</option>"
                        }
                        $('#selectproductdetail').prop('disabled', false);
                    }
                    else
                        ShowFailure(data.d[1]);
                    return;
                },
                function (data) {
                    Cancel();
                    ShowFailure("fail");
                });
        }
        function cmbusergroup_SelectedIndexChanged(s, e) {
            var RoleGroupID = cmbusergroup.GetValue();
            hdfProduct.Set('RoleGroupID', RoleGroupID)
            $.ajax({
                type: 'POST',
                url: 'UserProduct.aspx/GetRoleGroupIDDetail',
                data: JSON.stringify({ Info: RoleGroupID }),
                contentType: "application/json; charset=utf-8",
                dataType: "JSON"
            }).then(
                function (data) {
                    if (data.d[0] == '1') {
                        console.log(data.d[1]);
                        var userdetail = JSON.parse(data.d[1]);
                        document.getElementById("selectuserbygroup").innerHTML = "<option value=\"0\">انتخاب</option>";
                        for (var i = 0; i < userdetail.length; i++) {
                            document.getElementById("selectuserbygroup").innerHTML += "<option value=\"" + userdetail[i].ID + "\">" + userdetail[i].Family + "</option>"
                        }
                        $('#selectuserbygroup').prop('disabled', false);
                    }
                    else
                        ShowFailure(data.d[1]);
                    return;
                },
                function (data) {
                    Cancel();
                    ShowFailure("fail");
                });
        }
    </script>
    <div class="container-fluid">

        <div class="row">
            <div class="col-xs-12 col-md-2"></div>
            <div class="col-xs-12 col-md-8">
                <br />
                <div class="well" style="margin-bottom: 8px;">
                    <div class="Search-Panel">
                        <div class="row">

                            <div class="col-xs-6 col-md-2" style="margin-left: -20px;">
                                <Aut:Label ID="lblSearchUsername" runat="server" Text="نام وسیله" />
                                <Aut:ComboBox ID="cmbproduct" ClientInstanceName="cmbproduct" runat="server" ValueField="ID" TextField="ProductName" DataSourceID="odsproducttype" ValueType="System.Int64">
                                    <ClientSideEvents SelectedIndexChanged="cmbproduct_SelectedIndexChanged" />
                                </Aut:ComboBox>
                            </div>
                            <div class="col-xs-6 col-md-2" style="margin-left: -20px;">
                                <Aut:Label runat="server" Text="سریال" />
                                <select id="selectproductdetail">
                                    <option value="0">انتخاب</option>
                                </select>
                            </div>
                            <div class="col-xs-6 col-md-2" style="margin-left: -20px;">
                                <Aut:Label runat="server" Text="وضعیت وسیله" />
                                <Aut:ComboBox ID="cmbproductstatus" ClientInstanceName="cmbproductstatus" runat="server" ValueField="ID" TextField="Title" DataSourceID="odsproductstatus" ValueType="System.Int64">
                                </Aut:ComboBox>
                            </div>
                            <div class="col-xs-6 col-md-2" style="margin-left: -20px;">
                                <Aut:Label ID="Label1" runat="server" Text="واحد کاربر" />
                                <Aut:ComboBox ID="cmbusergroup" ClientInstanceName="cmbusergroup" runat="server" ValueField="ID" TextField="Title" DataSourceID="odsusergroup" ValueType="System.Int64">
                                    <ClientSideEvents SelectedIndexChanged="cmbusergroup_SelectedIndexChanged" />
                                </Aut:ComboBox>
                            </div>
                            <div class="col-xs-6 col-md-3" style="margin-left: -20px;">
                                <Aut:Label runat="server" Text="کاربر" />
                                <select id="selectuserbygroup">
                                    <option value="0">انتخاب</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <br />
                                <Aut:Button ID="btnSearch" ClientInstanceName="btnSearch" ClientIDMode="Static" Width="150" runat="server" Text="جستجو" CssClass="Newbtn">
                                </Aut:Button>
                                <Aut:Button ID="btnClearFilter" ClientInstanceName="btnClearFilter" ClientIDMode="Static" Width="150" runat="server" Text="حذف فیلتر ها" CssClass="Newbtn">
                                </Aut:Button>
                                <Aut:Button ID="downloadxlsx" ClientInstanceName="downloadxlsx" ClientIDMode="Static" Width="150" runat="server" Text="دریافت اکسل" CssClass="Newbtn">
                                </Aut:Button>
                            </div>
                            <div class="col-md-2">
                                <br />

                            </div>
                        </div>
                    </div>
                </div>
                <br />
                <div class="well">
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
                    <h4 class="modal-title">کد وسیله</h4>
                </div>
                <div class="modal-body">
                </div>
                <div class="modal-footer">
                    <button type="button" id="printqr" class="btn btn-primary">پرینت</button>
                    <button type="button" class="btn btn-danger" data-dismiss="modal">بازگشت</button>
                </div>
            </div>

        </div>
    </div>
    <Aut:HiddenField ID="hdfProduct" ClientInstanceName="hdfProduct" runat="server" />
    <asp:ObjectDataSource runat="server" ID="odsproductstatus" SelectMethod="GetAllList" TypeName="Business.Automation.ProductStatusBusiness"></asp:ObjectDataSource>
    <asp:ObjectDataSource runat="server" ID="odsproducttype" SelectMethod="GetAllList" TypeName="Business.Automation.ProductTypeBusiness"></asp:ObjectDataSource>
    <asp:ObjectDataSource runat="server" ID="odsusergroup" SelectMethod="GetAllList" TypeName="Business.Automation.RoleGroupBusiness"></asp:ObjectDataSource>
</asp:Content>
