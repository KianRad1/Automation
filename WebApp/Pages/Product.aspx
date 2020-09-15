<%@ Page Title="لیست اموال" Language="C#" MasterPageFile="~/Pages/Site.Master" AutoEventWireup="true" CodeBehind="Product.aspx.cs"
    Inherits="WebApp.Pages.Product" gref="E37F8409-4AB1-47D8-B4DA-B357589884B8" gid="ECBC04B9-1BA5-460A-AA2A-8B965F5E31F5" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        input[type="search"] {
            color: black;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <script>
        $(document).ready(function () {
            CreateTable();
        });
        function CreateTable() {
            $.ajax({
                type: 'POST',
                url: 'Product.aspx/GetTableRows',
                contentType: "application/json; charset=utf-8",
                dataType: "JSON"
            }).then(
                function (data) {
                    if (data.d[0] == '1') {
                        var tablediv = "ProductTables";
                        var tabledata = $.parseJSON(data.d[1]);
                        var tablecolumns = [
                            { title: "شناسه", field: "ID", width: 100, headerFilter: "input" },
                            { title: "نام محصول", field: "ProductName", headerFilter: "input" },
                            { title: "برند", field: "ProductBrand", headerFilter: "input" },
                            //{ title: "تعداد", field: "ProductCount", headerFilter: "input" },
                            { title: "شماره سریال", field: "SerialNo", headerFilter: "input" },
                            { title: "وضعیت", field: "ProductStatus", headerFilter: "input" },
                            { title: "توضیحات", field: "Description", headerFilter: "input" },
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
                        cmbproductbrand.SetValue(product.ProductBrandID);
                        cmbproductstatus.SetValue(product.Status);
                        //txtProductcount.SetText(product.ProductCount);
                        //txtProductmodel.SetText(product.ProductModel);
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
        function Save() {

            if (cmbproducttype.GetValue() == null) {
                ShowFailure("نام محصول وارد نشده است");
                return;
            }
            if (cmbproductbrand.GetValue() == null) {
                ShowFailure("برند محصول وارد نشده است");
                return;
            }
            if (cmbproductstatus.GetValue() == null) {
                ShowFailure("وضعیت محصول وارد نشده است");
                return;
            }
            if (txtSerialNo.GetText() == null) {
                ShowFailure("سریال محصول وارد نشده است");
                return;
            }

            var ProductInfo = {};
            if (hdfAction.Get('ID') != null)
                ProductInfo.ID = hdfAction.Get('ID');
            ProductInfo.ProductTypeID = cmbproducttype.GetValue();
            ProductInfo.ProductBrandID = cmbproductbrand.GetValue();
            //ProductInfo.ProductModel = txtProductmodel.GetValue();
            //ProductInfo.ProductCount = txtProductcount.GetValue();
            ProductInfo.Description = txtDescription.GetValue();
            ProductInfo.Status = cmbproductstatus.GetValue();
            ProductInfo.SerialNo = txtSerialNo.GetValue();

            ProductInfo = JSON.stringify(ProductInfo);
            $.ajax({
                type: 'POST',
                url: 'Product.aspx/SaveInfo',
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
            cmbproducttype.SetValue(null);
            cmbproductbrand.SetValue(null);
            cmbproductstatus.SetValue(null);
            //txtProductcount.SetValue("");
            //txtProductmodel.SetValue("");
            txtDescription.SetValue("");
            txtSerialNo.SetValue("");
            cmbAction.SetEnabled(false);
            btnNew.SetEnabled(true);
            btnNew.SetVisible(true);
            hdfAction.Set('ID', null);
            hdfAction.Set('TypeID', null);
            cmbproductbrand.PerformCallback();
            cmbproductbrand.SetEnabled(false);
        }
        function DeleteProduct(rowid) {
            $.ajax({
                type: 'POST',
                url: 'Product.aspx/DeleteProduct',
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
        function cmbproducttype_SelectedIndexChanged() {
            if (cmbproducttype.GetValue() != null) {
                hdfTypeAction.Set('TypeID', cmbproducttype.GetValue());
                cmbproductbrand.PerformCallback();
                cmbproductbrand.SetEnabled(true)
            }
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
                                <Aut:Label runat="server" Text="نام وسیله" />
                                <Aut:ComboBox ID="cmbproducttype" ClientInstanceName="cmbproducttype" runat="server" ValueField="ID" TextField="ProductName" DataSourceID="odsproducttype" ValueType="System.Int64">
                                    <ClientSideEvents SelectedIndexChanged="cmbproducttype_SelectedIndexChanged" />
                                    <ValidationSettings RequiredField-IsRequired="true">
                                        <RequiredField IsRequired="True"></RequiredField>
                                    </ValidationSettings>
                                </Aut:ComboBox>
                            </div>
                            <div class="col-md-2">
                                <Aut:Label runat="server" Text="برند وسیله" />
                                <Aut:ComboBox ID="cmbproductbrand" ClientInstanceName="cmbproductbrand" runat="server" ValueField="ID" TextField="_ProductBrand" OnCallback="cmbproductbrand_Callback" DataSourceID="odsproductbrand" ValueType="System.Int64">
                                    <ValidationSettings RequiredField-IsRequired="true">
                                        <RequiredField IsRequired="True"></RequiredField>
                                    </ValidationSettings>
                                </Aut:ComboBox>
                            </div>
                            <%--    <div class="col-md-2">
                                <Aut:Label runat="server" Text="مدل" />
                                <Aut:TextBox runat="server" ID="txtProductmodel" ClientInstanceName="txtProductmodel" validationgroup="NewEdit">
                                </Aut:TextBox>
                            </div>--%>
                            <%-- <div class="col-md-2">
                                <Aut:Label runat="server" Text="تعداد" />
                                <Aut:TextBox runat="server" ID="txtProductcount" ClientInstanceName="txtProductcount" validationgroup="NewEdit">
                                    <ValidationSettings RequiredField-IsRequired="true" />
                                </Aut:TextBox>
                            </div>--%>
                            <div class="col-md-2">
                                <Aut:Label runat="server" Text="سریال" />
                                <Aut:TextBox runat="server" ID="txtSerialNo" ClientInstanceName="txtSerialNo" validationgroup="NewEdit">
                                    <ValidationSettings RequiredField-IsRequired="true" />
                                </Aut:TextBox>
                            </div>
                            <div class="col-md-2">
                                <Aut:Label runat="server" Text="وضعیت وسیله" />
                                <Aut:ComboBox ID="cmbproductstatus" ClientInstanceName="cmbproductstatus" runat="server" ValueField="ID" TextField="Title" DataSourceID="odsproductstatus" ValueType="System.Int64">
                                    <ValidationSettings RequiredField-IsRequired="true">
                                        <RequiredField IsRequired="True"></RequiredField>
                                    </ValidationSettings>
                                </Aut:ComboBox>
                            </div>
                            <div class="col-md-2">
                                <Aut:Label runat="server" Text="توضیحات" />
                                <Aut:Memo runat="server" ID="txtDescription" ClientInstanceName="txtDescription" validationgroup="NewEdit">
                                </Aut:Memo>
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
    <Aut:HiddenField ID="hdfTypeAction" ClientInstanceName="hdfTypeAction" runat="server" />
    <asp:ObjectDataSource runat="server" ID="odsproductstatus" SelectMethod="GetAllList" TypeName="Business.Automation.ProductStatusBusiness"></asp:ObjectDataSource>
    <asp:ObjectDataSource runat="server" ID="odsproducttype" SelectMethod="GetAllList" TypeName="Business.Automation.ProductTypeBusiness"></asp:ObjectDataSource>
    <asp:ObjectDataSource runat="server" ID="odsproductbrand" SelectMethod="GetAllList" TypeName="Business.Automation.ProductBrandBusiness"></asp:ObjectDataSource>
</asp:Content>
