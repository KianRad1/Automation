<%@ Page Title="وسایل پرسنل" Language="C#" MasterPageFile="~/Pages/Site.Master" AutoEventWireup="true" CodeBehind="UserProduct.aspx.cs"
    Inherits="WebApp.Pages.UserProduct" gref="E37F8409-4AB1-47D8-B4DA-B357589884B8" gid="252E6F47-EE5C-4028-A307-6A5EC476D7F7" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <script>
        $(document).ready(function () {
            CreateTable();
        });
        function CreateTable() {
            $.ajax({
                type: 'POST',
                url: 'UserProduct.aspx/GetTableRows',
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
                                    { title: "شناسه", field: "ID", width: 100, headerFilter: "input" },
                                    { title: "نام وسیله", field: "ProductName", headerFilter: "input" },
                                    { title: "برند وسیله", field: "ProductBrand", headerFilter: "input" },
                                    { title: "وضعیت وسیله", field: "ProductStatus", headerFilter: "input" },
                                    { title: "سریال", field: "SerialNo", headerFilter: "input" },
                                    { title: "بارکد وسیله", field: "UserProductBarcodNo", headerFilter: "input" },
                                ],
                            },
                            {
                                title: "اطلاعات شخص",
                                columns: [
                                    { title: "نام کاربری", field: "Username", headerFilter: "input" },
                                    { title: "واحد", field: "RoleTitle", headerFilter: "input" },
                                ],
                            },
                            {
                                title: "سایر اطلاعات",
                                columns: [
                                    //{ title: "تاریخ تحویل", field: "ReceiveTime", width: 150, headerFilter: "input" },
                                    { title: "توضیحات", field: "Description", headerFilter: "input" },
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
                        var table = new Tabulator("#" + tablediv, {
                            reactiveData: true,
                            selectable: 1,
                            maxHeight: "100%",
                            pagination: "local", //enable local pagination.
                            paginationSize: 15,
                            responsiveLayout: "hide",
                            data: tabledata, //assign data to table
                            layout: "fitColumns", //fit columns to width of table (optional)
                            columns: tablecolumns,
                            rowContextMenu: [
                                {
                                    label: "مشاهده QR Code",
                                    action: function (e, row) {
                                        var QRURL = row.getData().UserProductBarcodNo;
                                        $(".modal-body").html("<img width=\"100%\" height=\"100%\" src=\"" + "../Images/" + QRURL + ".jpg" + "\" />");
                                        $("#printqr").click(function () {
                                            popup = window.open("../Images/" + QRURL + ".jpg");
                                            popup.focus(); 
                                            popup.print();
                                        });
                                        $("#myModal").modal("toggle");
                                    }
                                }
                            ],
                            rowClick: function (e, row) { //trigger an alert message when the row is clicked
                                Clear();
                                key = row.getData().ID;
                                hdfAction.Set('ID', key);
                                cmbAction.SetEnabled(true);
                            },
                        });
                    }
                    else
                        ShowFailure(data.d[1]);
                },
                function (data) {
                    ShowFailure();
                });
        }

        function FetchInfo(rowid) {
            $.ajax({
                type: 'POST',
                url: 'UserProduct.aspx/GetInfo',
                data: JSON.stringify({ Info: rowid }),
                contentType: "application/json; charset=utf-8",
                dataType: "JSON"
            }).then(
                function (data) {
                    if (data.d[0] == '1') {
                        var product = $.parseJSON(data.d[1]);
                        cmbuser.SetValue(product.UserID);
                        cmbproduct.SetValue(product.ID);
                        document.getElementById("selectproductdetail").innerHTML = "<option value=\"" + product.ID + "\">" + product.ProductModel + product.SerialNo + "</option>";
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
        function DeleteProduct(rowid) {
            $.ajax({
                type: 'POST',
                url: 'UserProduct.aspx/DeleteUserProduct',
                data: JSON.stringify({ Info: rowid }),
                contentType: "application/json; charset=utf-8",
                dataType: "JSON"
            }).then(
                function (data) {
                    if (data.d[0] == '1') {
                        Cancel();
                        CreateTable();
                        ShowSuccess();
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
        function Save() {
            if (cmbuser.GetValue() == null) {
                ShowFailure('کاربر مشخص نشده است');
                return;
            }
            if ($('#selectproductdetail').find(":selected").val() == null || $('#selectproductdetail').find(":selected").val() == 0) {
                ShowFailure('سریال وسیله انتخاب نشده است');
                return;
            }
            var ProductInfo = {};
            if (hdfAction.Get('ID') != null)
                ProductInfo.ID = hdfAction.Get('ID');
            ProductInfo.UserID = cmbuser.GetValue();
            ProductInfo.ProductID = $('#selectproductdetail').find(":selected").val();

            ProductInfo = JSON.stringify(ProductInfo);
            $.ajax({
                type: 'POST',
                url: 'UserProduct.aspx/SaveInfo',
                data: JSON.stringify({ Info: ProductInfo }),
                contentType: "application/json; charset=utf-8",
                dataType: "JSON"
            }).then(
                function (data) {
                    if (data.d[0] == '1') {
                        Cancel();
                        CreateTable();
                        ShowSuccess();
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

        function Clear() {
            $('#NewEdit').slideUp('fast');
            cmbAction.SetValue(null);
            cmbuser.SetValue(null);
            cmbproduct.SetValue(null);
            document.getElementById("selectproductdetail").innerHTML = "<option value=\"0\">انتخاب</option>";
            cmbAction.SetEnabled(false);
            btnNew.SetEnabled(true);
            btnNew.SetVisible(true);
            hdfAction.Set('ID', null);
        }

        function actions_SelectedIndexChanged(s, e) {
            if (typeof key == 'undefined') {
                cmbAction.SetValue(null);
                cmbAction.SetEnabled(false);
                return;
            }
            if (s.GetValue() == "3BCAB3FD-00B6-43F6-BEA3-DC4693693DC6")
                FetchInfo(key);
            else if (s.GetValue() == "E80794FA-56DD-436B-A635-91FE8F744AFF")
                DeleteProduct(key);
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
                            document.getElementById("selectproductdetail").innerHTML += "<option value=\"" + prdetail[i].ID + "\">" + prdetail[i].ProductBrand  + prdetail[i].SerialNo + "</option>"
                        }
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
        <div class="row">
            <div class="col-xs-12 col-md-2"></div>
            <div class="col-xs-12 col-md-8">
                <div id="NewEdit" class="well">
                    <div class="form">
                        <div class="row">
                            <div class="col-md-2">
                                <Aut:Label runat="server" Text="نام کاربری" />
                                <Aut:ComboBox ID="cmbuser" ClientInstanceName="cmbuser" runat="server" ValueField="ID" TextField="Username" DataSourceID="odsuser" ValueType="System.Int64">
                                    <ValidationSettings RequiredField-IsRequired="true">
                                        <RequiredField IsRequired="True"></RequiredField>
                                    </ValidationSettings>
                                </Aut:ComboBox>
                            </div>
                            <div class="col-md-2">
                                <Aut:Label runat="server" Text="مدل" />
                                <Aut:ComboBox ID="cmbproduct" ClientInstanceName="cmbproduct" runat="server" ValueField="ID" TextField="ProductName" DataSourceID="odsproducttype" ValueType="System.Int64">
                                    <ClientSideEvents SelectedIndexChanged="cmbproduct_SelectedIndexChanged" />
                                    <ValidationSettings RequiredField-IsRequired="true">
                                        <RequiredField IsRequired="True"></RequiredField>
                                    </ValidationSettings>
                                </Aut:ComboBox>
                            </div>
                            <div class="col-md-2">
                                <Aut:Label runat="server" Text="سریال" />
                                <select id="selectproductdetail">
                                    <option value="0">انتخاب</option>
                                </select>
                            </div>
                        </div>
                        <br />
                        <div class="row"></div>
                        <br />
                        <div class="row">
                            <div class="col-md-4"></div>
                            <div class="col-md-2">
                                <Aut:Button runat="server" Text="ذخیره" ClientSideEvents-Click="Save" CssClass="ProductSavebtn" />
                            </div>
                            <div class="col-md-2">
                                <Aut:Button runat="server" Text="انصراف" ClientSideEvents-Click="Cancel" CssClass="ProductCancelbtn" />
                            </div>
                            <div class="col-md-4">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-xs-12 col-md-2"></div>
        </div>
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
    <asp:ObjectDataSource runat="server" ID="odsuser" SelectMethod="GetAllList" TypeName="Business.Automation.UserBusiness"></asp:ObjectDataSource>
    <asp:ObjectDataSource runat="server" ID="odsproducttype" SelectMethod="GetAllList" TypeName="Business.Automation.ProductTypeBusiness"></asp:ObjectDataSource>
    <asp:ObjectDataSource runat="server" ID="odsproductdetail" SelectMethod="GetProductDetail" TypeName="WebApp.Pages.UserProduct"></asp:ObjectDataSource>
</asp:Content>

<%--popup = window.open("../Images/Unchecked3.png");
popup.focus(); //required for IE
popup.print();--%>