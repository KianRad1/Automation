using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using Utilities;
using WebApp.Classes.Base;
using WebApp.Classes.Pages.Product;

namespace WebApp.Pages
{
    public partial class ProductType : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            var actions = new List<WebComponent.ComboBox.Actions>();
            actions.Add(new WebComponent.ComboBox.Actions() { gid = "3BCAB3FD-00B6-43F6-BEA3-DC4693693DC6", Title = "ویرایش" });
            actions.Add(new WebComponent.ComboBox.Actions() { gid = "64AD7E42-A176-487E-91CE-18CFAC9F3C4D", Title = "برند ها" });
            actions.Add(new WebComponent.ComboBox.Actions() { gid = "E80794FA-56DD-436B-A635-91FE8F744AFF", Title = "حذف" });
            cmbAction.SetActions(actions);

            var Brandactions = new List<WebComponent.ComboBox.Actions>();
            Brandactions.Add(new WebComponent.ComboBox.Actions() { gid = "E431B8C8-0D73-4BE4-9A0F-2F33F15EB62B", Title = "ویرایش" });
            Brandactions.Add(new WebComponent.ComboBox.Actions() { gid = "1B1EA337-2CE9-4FEF-8AC0-6FAAC840902A", Title = "حذف" });
            cmbBrandAction.SetActions(Brandactions);

        }
        #region WebMethods
        [WebMethod]
        public static string[] GetBrandsTableRows(int rowId)
        {
            try
            {

                var ProductBrandsInfo = Business.FacadeAutomation.GetProductBrandBusiness().GetByProductTypeID(rowId);

                var json = JsonConvert.SerializeObject(ProductBrandsInfo);

                return new string[2] { "1", json };
            }
            catch (Exception ex)
            {
                return new string[2] { "0", ex.Message };
            }

        }
        [WebMethod]
        public static string[] GetTableRows(string Info)
        {
            try
            {
                long ClassificationID = 0;
                switch (Info)
                {
                    case "electro":
                        ClassificationID = 1;
                        break;
                    case "asasie":
                        ClassificationID = 2;
                        break;
                    case "sayer":
                        ClassificationID = 3;
                        break;
                    case "all":
                        ClassificationID = 0;
                        break;
                    default:
                        ClassificationID = 0;
                        break;
                }

                var ProductInfo = Business.FacadeAutomation.GetVwProductTypeDetailBusiness().GetByProductClassificationID(ClassificationID);
              
                var json = JsonConvert.SerializeObject(ProductInfo);

                return new string[2] { "1", json };
            }
            catch (Exception ex)
            {
                return new string[2] { "0", ex.Message };
            }

        }
        [WebMethod]
        public static string[] DeleteProductBrand(int Info)
        {
            try
            {

                var productBrandInfo = Business.FacadeAutomation.GetProductBrandBusiness().GetByID(Info);
                if (productBrandInfo == null)
                    throw new Exception("برند وسیله یافت نشد");

                productBrandInfo.Delete();


                return new string[2] { "1", "success" };
            }
            catch (Exception ex)
            {
                return new string[2] { "0", ex.Message };
            }

        }
        [WebMethod]
        public static string[] DeleteProductType(int Info)
        {
            try
            {

                var productTypeInfo = Business.FacadeAutomation.GetProductTypeBusiness().GetByID(Info);
                if (productTypeInfo == null)
                    throw new Exception("نوع وسیله یافت نشد");
                var productbiz = Business.FacadeAutomation.GetProductBusiness();
                var productquery = productbiz.GetAll(300);
                productquery.And(Models.Generated.AutomationDB.Automation.Product.Columns.ProductTypeID, Info);
                var productlist = productbiz.Fetch(productquery).ToList();
                foreach (var item in productlist)
                {
                    item.Delete();
                    var userproductbiz = Business.FacadeAutomation.GetPersonalProductsBusiness();
                    var userproductquery = userproductbiz.GetAll(300);
                    userproductquery.And(Models.Generated.AutomationDB.Automation.PersonalProduct.Columns.ProductID, item.ID);
                    var userproductlist = userproductbiz.Fetch(userproductquery).ToList();
                    foreach (var useritem in userproductlist)
                    {
                        useritem.Delete();
                    }
                }
                productTypeInfo.Delete();

                var json = JsonConvert.SerializeObject(productTypeInfo);

                return new string[2] { "1", json };
            }
            catch (Exception ex)
            {
                return new string[2] { "0", ex.Message };
            }

        }
        [WebMethod]
        public static string[] GetBrandInfo(int Info)
        {
            try
            {

                var productInfo = Business.FacadeAutomation.GetProductBrandBusiness().GetByID(Info);
                if (productInfo == null)
                    throw new Exception("برند یافت نشد");

                var json = JsonConvert.SerializeObject(productInfo);

                return new string[2] { "1", json };
            }
            catch (Exception ex)
            {
                return new string[2] { "0", ex.Message };
            }

        }
        [WebMethod]
        public static string[] SaveBrandInfo(string Info)
        {
            try
            {
                var Product = new System.Web.Script.Serialization.JavaScriptSerializer().Deserialize<ProductBrandInfo>(Info);
                var ProductInfo = Business.FacadeAutomation.GetProductBrandBusiness().GetByID(Product.ID.ToInt());
                if (ProductInfo == null)
                    ProductInfo = new Models.Generated.AutomationDB.Automation.ProductBrand();
                ProductInfo._ProductBrand = Product.ProductBrand;
                ProductInfo.ProductTypeID = Product.ProductTypeID;
                ProductInfo.Save();
                return new string[2] { "1", "Success" };
            }
            catch (Exception ex)
            {
                return new string[2] { "0", ex.Message };
            }

        }
        [WebMethod]
        public static string[] GetInfo(int Info)
        {
            try
            {

                var productInfo = Business.FacadeAutomation.GetProductTypeBusiness().GetByID(Info);
                if (productInfo == null)
                    throw new Exception("وسیله یافت نشد");

                var json = JsonConvert.SerializeObject(productInfo);

                return new string[2] { "1", json };
            }
            catch (Exception ex)
            {
                return new string[2] { "0", ex.Message };
            }

        }
        [WebMethod]
        public static string[] SaveInfo(string Info)
        {
            try
            {
                var Product = new System.Web.Script.Serialization.JavaScriptSerializer().Deserialize<ProductTypeInfo>(Info);
                var ProductInfo = Business.FacadeAutomation.GetProductTypeBusiness().GetByID(Product.ID.ToLong());
                if (ProductInfo == null)
                    ProductInfo = new Models.Generated.AutomationDB.Automation.ProductType();
                ProductInfo.ProductClassificationID = Product.ProductClassificationID;
                ProductInfo.ProductName = Product.ProductName;
                ProductInfo.Save();
                return new string[2] { "1", "Success" };
            }
            catch (Exception ex)
            {
                return new string[2] { "0", ex.Message };
            }

        }
        #endregion
    }
}