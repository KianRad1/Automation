<%@ Page Title="وسایل مصرفی" Language="C#" MasterPageFile="~/Pages/Site.Master" AutoEventWireup="true" CodeBehind="ConsumableProducts.aspx.cs"
    Inherits="WebApp.Pages.ConsumableProducts" gref="E37F8409-4AB1-47D8-B4DA-B357589884B8" gid="A78CC8C4-FF5A-4D6A-93EC-B13C93C61A05" %>

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
                url: 'ConsumableProducts.aspx/GetTableRows',
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
                            { title: "تعداد باقی مانده", field: "RemainingCount", headerFilter: "input" },
                            { title: "واحد", field: "ProductUnit", headerFilter: "input" },
                            { title: "حد اخطار", field: "DangerRange", headerFilter: "input" },
                        ];
                        tabledata.forEach(checkdanger);
                        CreateDBTable(tabledata, tablecolumns, tablediv);
                    }
                    else
                        ShowFailure(data.d[1]);
                },
                function (data) {
                    ShowFailure();
                });
        }
        function checkdanger(tbldata) {
            if (tbldata.RemainingCount < tbldata.DangerRange) {
                var dangerstr = "تعداد " + tbldata.ProductName + "از " + tbldata.DangerRange + " " + tbldata.ProductUnit + " کمتر شده است";
                ShowFailure(dangerstr, "اخطار");
                Push.create("اخطار", {
                    body: dangerstr,
                    icon: "../Images/intek.png",
                });
            }
        }
        function FetchInfo(rowid) {
            $.ajax({
                type: 'POST',
                url: 'ConsumableProducts.aspx/GetInfo',
                data: JSON.stringify({ Info: rowid }),
                contentType: "application/json; charset=utf-8",
                dataType: "JSON"
            }).then(
                function (data) {
                    if (data.d[0] == '1') {
                        var product = $.parseJSON(data.d[1]);
                        txtProductName.SetText(product.ProductName);
                        txtRemainingCount.SetText(product.RemainingCount);
                        txtProductUnit.SetText(product.ProductUnit);
                        txtDangerRange.SetText(product.DangerRange);
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
            if (txtRemainingCount.GetValue() == null) {
                ShowFailure("تعداد باقی مانده محصول وارد نشده است");
                return;
            }
            if (txtProductUnit.GetValue() == null) {
                ShowFailure("واحد اندازه گیری محصول وارد نشده است");
                return;
            }
            if (txtDangerRange.GetValue() == null) {
                ShowFailure("محدوده اخطار محصول وارد نشده است");
                return;
            }

            var ProductInfo = {};
            if (hdfAction.Get('ID') != null)
                ProductInfo.ID = hdfAction.Get('ID');
            ProductInfo.ProductName = txtProductName.GetValue();
            ProductInfo.RemainingCount = txtRemainingCount.GetValue();
            ProductInfo.ProductUnit = txtProductUnit.GetValue();
            ProductInfo.DangerRange = txtDangerRange.GetValue();
            ProductInfo = JSON.stringify(ProductInfo);
            $.ajax({
                type: 'POST',
                url: 'ConsumableProducts.aspx/SaveInfo',
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
            txtProductName.SetValue("");
            txtRemainingCount.SetValue("");
            txtProductUnit.SetValue("");
            txtDangerRange.SetValue("");
            cmbAction.SetEnabled(false);
            btnNew.SetEnabled(true);
            btnNew.SetVisible(true);
            hdfAction.Set('ID', null);
        }
        function SaveAddProduct() {
            if (txtUsedProduct.GetValue() == null) {
                ShowFailure("تعداد اضافه به انبار مشخص نشده است");
                return;
            }
            var ProductInfo = {};
            if (hdfAction.Get('ID') != null)
                ProductInfo.ID = hdfAction.Get('ID');
            else {
                ShowFailure("وسیله مورد نظر انتخاب نشده است");
                return;
            }
            ProductInfo.RemovedCount = txtUsedProduct.GetValue();
            ProductInfo.UserID = cmbuser.GetValue();
            ProductInfo = JSON.stringify(ProductInfo);
            $.ajax({
                type: 'POST',
                url: 'ConsumableProducts.aspx/SaveAddProduct',
                data: JSON.stringify({ Info: ProductInfo }),
                contentType: "application/json; charset=utf-8",
                dataType: "JSON"
            }).then(
                function (data) {
                    if (data.d[0] == '1') {
                        $("#NewEditRemove").slideDown('fast', function () {
                            $('html, body').animate({
                                scrollTop: $("#NewEditRemove").offset().top
                            }, 1000);
                        });
                        CancelAddCount();
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
        function CancelAddCount() {

        }
        function CancelRemoveCount() {

        }
        function AddConsumProduct(rowid) {
            $("#NewEditAdd").slideDown('fast', function () {
                $('html, body').animate({
                    scrollTop: $("#NewEditRemove").offset().top
                }, 1000);
            });
        }
        function SaveRemoveProduct() {
            if (txtUsedProduct.GetValue() == null) {
                ShowFailure("تعداد برداشت مشخص نشده است");
                return;
            }
            if (cmbuser.GetValue() == null) {
                ShowFailure("کاربر تحویل گیرنده مشخص نشده است");
                return;
            }
            var ProductInfo = {};
            if (hdfAction.Get('ID') != null)
                ProductInfo.ID = hdfAction.Get('ID');
            else {
                ShowFailure("وسیله مورد نظر انتخاب نشده است");
                return;
            }
            ProductInfo.RemovedCount = txtUsedProduct.GetValue();
            ProductInfo.UserID = cmbuser.GetValue();
            ProductInfo = JSON.stringify(ProductInfo);
            $.ajax({
                type: 'POST',
                url: 'ConsumableProducts.aspx/SaveRemoveProduct',
                data: JSON.stringify({ Info: ProductInfo }),
                contentType: "application/json; charset=utf-8",
                dataType: "JSON"
            }).then(
                function (data) {
                    if (data.d[0] == '1') {
                        $("#NewEditRemove").slideDown('fast', function () {
                            $('html, body').animate({
                                scrollTop: $("#NewEditRemove").offset().top
                            }, 1000);
                        });
                        CancelRemoveCount();
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
        function RemoveConsumProduct(rowid) {
            $("#NewEditRemove").slideDown('fast', function () {
                $('html, body').animate({
                    scrollTop: $("#NewEditRemove").offset().top
                }, 1000);
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
            else if (s.GetValue() == "8ABC571B-815C-4D7E-8EE3-2D5F95041CD4")
                RemoveConsumProduct(key); 
            else if (s.GetValue() == "118968BF-6B1F-48E7-BD29-72CE03386920")
                AddConsumProduct(key);

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
                            <Aut:Button ID="downloadxlsx" ClientInstanceName="downloadxlsx" ClientIDMode="Static" runat="server" Text="اکسل" CssClass="Newbtn">
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
                                <Aut:Label runat="server" Text="نام وسیله مصرفی" />
                                <Aut:TextBox runat="server" ID="txtProductName" ClientInstanceName="txtProductName" validationgroup="NewEdit">
                                </Aut:TextBox>
                            </div>
                            <div class="col-md-2">
                                <Aut:Label runat="server" Text="تعداد موجود" />
                                <Aut:TextBox runat="server" ID="txtRemainingCount" ClientInstanceName="txtRemainingCount" validationgroup="NewEdit">
                                    <ValidationSettings RequiredField-IsRequired="true" />
                                </Aut:TextBox>
                            </div>
                            <div class="col-md-2">
                                <Aut:Label runat="server" Text="واحد اندازه گیری" />
                                <Aut:TextBox runat="server" ID="txtProductUnit" ClientInstanceName="txtProductUnit" validationgroup="NewEdit">
                                    <ValidationSettings RequiredField-IsRequired="true" />
                                </Aut:TextBox>
                            </div>
                            <div class="col-md-2">
                                <Aut:Label runat="server" Text="حد اخطار" />
                                <Aut:TextBox runat="server" ID="txtDangerRange" ClientInstanceName="txtDangerRange" validationgroup="NewEdit">
                                    <ValidationSettings RequiredField-IsRequired="true" />
                                </Aut:TextBox>
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
                <div id="NewEditAdd" class="well">
                    <div class="form">
                        <div class="row">
                            <div class="col-md-2">
                                <Aut:Label runat="server" Text="تعداد اضافه شده با انبار" />
                                <Aut:TextBox runat="server" ID="TextBox1" ClientInstanceName="txtUsedProduct" validationgroup="NewEdit">
                                    <ValidationSettings RequiredField-IsRequired="true" />
                                </Aut:TextBox>
                            </div>
                        </div>
                        <br />
                        <div class="row"></div>
                        <br />
                        <div class="row">
                            <div class="col-md-4"></div>
                            <div class="col-md-2">
                                <Aut:Button runat="server" Text="ذخیره" ClientSideEvents-Click="SaveAddProduct" CssClass="ProductSavebtn" />
                            </div>
                            <div class="col-md-2">
                                <Aut:Button runat="server" Text="انصراف" ClientSideEvents-Click="CancelAddProduct" CssClass="ProductCancelbtn" />
                            </div>
                            <div class="col-md-4">
                            </div>
                        </div>
                    </div>
                </div>
                <div id="NewEditRemove" class="well">
                    <div class="form">
                        <div class="row">
                            <div class="col-md-2">
                                <Aut:Label runat="server" Text="تعداد برداشت" />
                                <Aut:TextBox runat="server" ID="txtUsedProduct" ClientInstanceName="txtUsedProduct" validationgroup="NewEdit">
                                    <ValidationSettings RequiredField-IsRequired="true" />
                                </Aut:TextBox>
                            </div>
                            <div class="col-md-2">
                                <Aut:Label runat="server" Text="کاربر تحویل گیرنده" />
                                <Aut:ComboBox ID="cmbuser" ClientInstanceName="cmbuser" runat="server" ValueField="ID" TextField="Username" DataSourceID="odsuser" ValueType="System.Int64">
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
                                <Aut:Button runat="server" Text="ذخیره" ClientSideEvents-Click="SaveRemoveProduct" CssClass="ProductSavebtn" />
                            </div>
                            <div class="col-md-2">
                                <Aut:Button runat="server" Text="انصراف" ClientSideEvents-Click="CancelRemoveProduct" CssClass="ProductCancelbtn" />
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
    <asp:ObjectDataSource runat="server" ID="odsuser" SelectMethod="GetAllList" TypeName="Business.Automation.UserBusiness"></asp:ObjectDataSource>
</asp:Content>
