<%@ Page Title="انواع اموال" Language="C#" MasterPageFile="~/Pages/Site.Master" AutoEventWireup="true" CodeBehind="ProductType.aspx.cs"
    Inherits="WebApp.Pages.ProductType" gref="E37F8409-4AB1-47D8-B4DA-B357589884B8" gid="81DC5955-467A-435B-9243-CB8E47600413" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <script>
        $(document).ready(function () {
            CreateTable('all');
            $("#btnNewBrand").click(function () {
                if (btnNewBrand.GetEnabled()) {
                    ClearBrand();
                    btnNewBrand.SetEnabled(false);
                    btnNewBrand.SetVisible(false);
                    $("#NewEditBrand").slideDown('fast');
                }
            });
            $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
                var target = $(e.target).attr("id") // activated tab
                hdfAction.Set("currenttab", target);
                CreateTable(target);
            });
        });
        function CreateTable(classification) {
            $.ajax({
                type: 'POST',
                url: 'ProductType.aspx/GetTableRows',
                data: JSON.stringify({ Info: classification }),
                contentType: "application/json; charset=utf-8",
                dataType: "JSON"
            }).then(
                function (data) {
                    if (data.d[0] == '1') {
                        var tablediv = "ProductTables";
                        var tabledata = $.parseJSON(data.d[1]);
                        var tablecolumns = [
                            { title: "شناسه", field: "ID", width: 100, headerFilter: "input" },
                            { title: "نام وسیله", field: "ProductName", headerFilter: "input" },
                            { title: "نوع وسیله", field: "ProductClassification", headerFilter: "input" },
                            { title: "تعداد وسیله", field: "ProductCount", headerFilter: "input" },
                        ]; 
                        CreateDBTable(tabledata, tablecolumns, tablediv);
                    }
                    else
                        ShowFailure(data.d[1]);
                },
                function (data) {
                    ShowFailure();
                });
        }
        function CreateBrandTable() {
            if (hdfAction.Get('ID') != null)
                rowid = hdfAction.Get('ID');
            $.ajax({
                type: 'POST',
                url: 'ProductType.aspx/GetBrandsTableRows',
                data: JSON.stringify({ rowId: rowid }),
                contentType: "application/json; charset=utf-8",
                dataType: "JSON"
            }).then(
                function (data) {
                    if (data.d[0] == '1') {
                        var tablediv = "ProductBrandsTables";
                        var tabledata = $.parseJSON(data.d[1]);
                        var tablecolumns = [
                            { title: "شناسه", field: "ID", width: 100, headerFilter: "input" },
                            { title: "برند وسیله", field: "_ProductBrand", headerFilter: "input" },
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
                            rowClick: function (e, row) { //trigger an alert message when the row is clicked
                                ClearBrand();
                                key = row.getData().ID;
                                hdfAction.Set('BrandID', key);
                                cmbBrandAction.SetEnabled(true);
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
        function FetchBrandInfo(rowid) {
            $.ajax({
                type: 'POST',
                url: 'ProductType.aspx/GetBrandInfo',
                data: JSON.stringify({ Info: rowid }),
                contentType: "application/json; charset=utf-8",
                dataType: "JSON"
            }).then(
                function (data) {
                    if (data.d[0] == '1') {
                        var product = $.parseJSON(data.d[1]);
                        txtProductBrand.SetText(product._ProductBrand);
                        hdfAction.Set('BrandID', rowid);
                        btnNewBrand.SetEnabled(false);
                        btnNewBrand.SetVisible(false)
                        $("#NewEditBrand").slideDown('fast', function () {
                            $('html, body').animate({
                                scrollTop: $("#NewEditBrand").offset().top
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
        function FetchInfo(rowid) {
            $.ajax({
                type: 'POST',
                url: 'ProductType.aspx/GetInfo',
                data: JSON.stringify({ Info: rowid }),
                contentType: "application/json; charset=utf-8",
                dataType: "JSON"
            }).then(
                function (data) {
                    if (data.d[0] == '1') {
                        var product = $.parseJSON(data.d[1]);
                        txtProductName.SetText(product.ProductName);
                        cmbproductClassification.SetValue(product.ProductClassificationID)
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
        function Save() {
            if (txtProductName.GetValue() == null) {
                ShowFailure("نام محصول وارد نشده است");
                return;
            }
            if (cmbproductClassification.GetValue() == null) {
                ShowFailure("دسته بندی محصول وارد نشده است");
                return;
            }
            var ProductInfo = {};
            if (hdfAction.Get('ID') != null)
                ProductInfo.ID = hdfAction.Get('ID');
            ProductInfo.ProductName = txtProductName.GetValue();
            ProductInfo.ProductClassificationID = cmbproductClassification.GetValue();
            ProductInfo = JSON.stringify(ProductInfo);
            $.ajax({
                type: 'POST',
                url: 'ProductType.aspx/SaveInfo',
                data: JSON.stringify({ Info: ProductInfo }),
                contentType: "application/json; charset=utf-8",
                dataType: "JSON"
            }).then(
                function (data) {
                    if (data.d[0] == '1') {
                        Cancel();
                        var currenttab = hdfAction.Get("currenttab");
                        if (typeof currenttab == 'undefined')
                            CreateTable('all');
                        else
                            CreateTable(currenttab);
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
        function SaveBrand() {

            if (txtProductBrand.GetValue() == null) {
                ShowFailure("برند وسیله وارد نشده است");
                return;
            }
            var ProductInfo = {};

            if (hdfAction.Get('ID') != null) {
                ProductInfo.ProductTypeID = hdfAction.Get('ID');
            }
            else {
                ShowFailure("وسیله ای وارد نشده است");
                return;
            }

            if (hdfAction.Get('BrandID') != null)
                ProductInfo.ID = hdfAction.Get('BrandID');
            ProductInfo.ProductBrand = txtProductBrand.GetValue();
            ProductInfo = JSON.stringify(ProductInfo);
            $.ajax({
                type: 'POST',
                url: 'ProductType.aspx/SaveBrandInfo',
                data: JSON.stringify({ Info: ProductInfo }),
                contentType: "application/json; charset=utf-8",
                dataType: "JSON"
            }).then(
                function (data) {
                    if (data.d[0] == '1') {
                        CancelBrand();
                        CreateBrandTable();
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
        function CancelBrand() {
            $('#NewEditBrand').slideUp('fast');
            ClearBrand();
            delete key;
        }
        function ClearBrand() {
            $('#NewEditBrand').slideUp('fast');
            cmbBrandAction.SetValue(null);
            txtProductBrand.SetValue("");
            cmbBrandAction.SetEnabled(false);
            btnNewBrand.SetEnabled(true);
            btnNewBrand.SetVisible(true);
            hdfAction.Set('BrandID', null);
        }

        function Clear() {
            $('#NewEdit').slideUp('fast');
            cmbAction.SetValue(null);
            cmbproductClassification.SetValue(null);
            txtProductName.SetValue("");
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
            else if (s.GetValue() == "64AD7E42-A176-487E-91CE-18CFAC9F3C4D")
                PopUpBrands(key);

        }
        function brandactions_SelectedIndexChanged(s, e) {
            if (typeof key == 'undefined') {
                cmbBrandAction.SetValue(null);
                cmbBrandAction.SetEnabled(false);
                return;
            }
            if (s.GetValue() == "E431B8C8-0D73-4BE4-9A0F-2F33F15EB62B")
                FetchBrandInfo(key);
            else if (s.GetValue() == "1B1EA337-2CE9-4FEF-8AC0-6FAAC840902A")
                DeleteBrand(key);
        }
        function PopUpBrands(rowid) {
            CreateBrandTable();
            $("#popupBrands").modal("show");
            CancelBrand();
        }
        function DeleteBrand(rowid) {
            $.ajax({
                type: 'POST',
                url: 'ProductType.aspx/DeleteProductBrand',
                data: JSON.stringify({ Info: rowid }),
                contentType: "application/json; charset=utf-8",
                dataType: "JSON"
            }).then(
                function (data) {
                    if (data.d[0] == '1') {
                        CancelBrand();
                        btnNewBrand.SetEnabled(true);
                        CreateBrandTable();
                        ShowSuccess();
                    }
                    else
                        ShowFailure(data.d[1]);
                    return;
                },
                function (data) {
                    CancelBrand();
                    ShowFailure("fail");
                });
        }
        function DeleteProduct(rowid) {
            $.ajax({
                type: 'POST',
                url: 'ProductType.aspx/DeleteProductType',
                data: JSON.stringify({ Info: rowid }),
                contentType: "application/json; charset=utf-8",
                dataType: "JSON"
            }).then(
                function (data) {
                    if (data.d[0] == '1') {
                        Cancel();
                        var currenttab = hdfAction.Get("currenttab");
                        if (typeof currenttab == 'undefined')
                            CreateTable('all');
                        else
                            CreateTable(currenttab);
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
    </script>
    <div class="container-fluid">

        <div class="row">
            <div class="col-xs-12 col-md-5"></div>
            <div class="col-xs-12 col-md-3">
                <ul class="nav nav-tabs" style="font-family: IRANSansWeb_Bold">
                    <li class="active"><a id="all" data-toggle="tab" href="#home">تمام وسایل</a></li>
                    <li><a id="electro" data-toggle="tab" href="#home">وسایل الکترونیکی</a></li>
                    <li><a id="asasie" data-toggle="tab" href="#home">اموال و اثاثه</a></li>
                    <li><a id="sayer" data-toggle="tab" href="#home">سایر</a></li>
                </ul>
            </div>
            <div class="col-xs-12 col-md-4"></div>

        </div>
    </div>

    <div class="tab-content">
        <div id="home" class="tab-pane fade in active">
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
                                        <Aut:Label runat="server" Text="نام وسیله" />
                                        <Aut:TextBox runat="server" ID="txtProductName" ClientInstanceName="txtProductName" validationgroup="NewEdit">
                                        </Aut:TextBox>
                                    </div>
                                    <div class="col-md-2">
                                        <Aut:Label runat="server" Text="نوع وسیله" />
                                        <Aut:ComboBox ID="cmbproductClassification" ClientInstanceName="cmbproductClassification" runat="server" ValueField="ID" TextField="Title" DataSourceID="odsproductclassification" ValueType="System.Int64">
                                            <ValidationSettings RequiredField-IsRequired="true">
                                                <RequiredField IsRequired="True"></RequiredField>
                                            </ValidationSettings>
                                        </Aut:ComboBox>
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
                <div id="popupBrands" class="modal fade modal-wide" tabindex="-1" role="dialog" aria-labelledby="popupBrands" aria-hidden="true" style="display: none; right: 25%">
                    <div class="modal-dialog col-lg-8">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">×</span><span class="sr-only">Close</span></button>
                                <Aut:Label runat="server" Font-Size="24px" Text="برند ها" />
                            </div>
                            <div class="modal-body">
                                <div class="row">
                                    <div style="padding: 0 5% 0 5%;">
                                        <div style="display: inline-flex; margin-top: 7px;">
                                            <div style="margin-left: 10px;">
                                                <Aut:Button ID="btnNewBrand" ClientInstanceName="btnNewBrand" ClientIDMode="Static" runat="server" Text="جدید" CssClass="Newbtn">
                                                </Aut:Button>
                                            </div>
                                            <div>
                                                <div class="Action-Group">
                                                    <Aut:Label ID="lblActionBrand" runat="server" Text="عملیات" CssClass="Action-Label" />
                                                    <div class="Action-Combo">
                                                        <Aut:ComboBox ID="cmbBrandAction" runat="server" ClientInstanceName="cmbBrandAction" ClientEnabled="False" isaction="true" Height="35px">
                                                            <ClientSideEvents SelectedIndexChanged="brandactions_SelectedIndexChanged" />
                                                        </Aut:ComboBox>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row" style="margin-top: 10px;">
                                        </div>
                                        <div id="ProductBrandsTables"></div>
                                        <br />
                                        <div id="NewEditBrand" class="well">
                                            <div class="form">
                                                <div class="row">
                                                    <div class="col-md-2">
                                                        <Aut:Label runat="server" Text="برند وسیله" />
                                                        <Aut:TextBox runat="server" ID="txtProductBrand" ClientInstanceName="txtProductBrand" validationgroup="NewEdit">
                                                        </Aut:TextBox>
                                                    </div>
                                                </div>
                                                <br />
                                                <div class="row"></div>
                                                <br />
                                                <div class="row">
                                                    <div class="col-md-4"></div>
                                                    <div class="col-md-2">
                                                        <Aut:Button runat="server" Text="ذخیره" ClientSideEvents-Click="SaveBrand" CssClass="ProductSavebtn" />
                                                    </div>
                                                    <div class="col-md-2">
                                                        <Aut:Button runat="server" Text="انصراف" ClientSideEvents-Click="CancelBrand" CssClass="ProductCancelbtn" />
                                                    </div>
                                                    <div class="col-md-4">
                                                    </div>
                                                </div>
                                            </div>
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
    </div>
    <Aut:HiddenField ID="hdfProduct" ClientInstanceName="hdfProduct" runat="server" />
    <asp:ObjectDataSource runat="server" ID="odsproductclassification" SelectMethod="GetAllList" TypeName="Business.Automation.ProductClassificationBusiness"></asp:ObjectDataSource>
</asp:Content>
