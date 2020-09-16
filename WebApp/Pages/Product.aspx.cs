using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebApp.Classes.Base;
using WebApp.Classes.Pages.Product;
using Utilities;
using Models.Generated.AutomationDB.Automation;

namespace WebApp.Pages
{
    public partial class Product : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            var actions = new List<WebComponent.ComboBox.Actions>();
            actions.Add(new WebComponent.ComboBox.Actions() { gid = "3BCAB3FD-00B6-43F6-BEA3-DC4693693DC6", Title = "ویرایش" });
            actions.Add(new WebComponent.ComboBox.Actions() { gid = "E80794FA-56DD-436B-A635-91FE8F744AFF", Title = "حذف" });
            cmbAction.SetActions(actions);
        }
        #region WebMethods
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

                var ProductBiz = Business.FacadeAutomation.GetVwProductDetailBusiness();
                var q = ProductBiz.GetAll(300);
                if (ClassificationID != 0)
                    q.And(VwProductDetail.Columns.ProductClassificationID, ClassificationID);
                q.OrderBy(VwProductDetail.Columns.ID, "DESC");

                var ProductInfo = ProductBiz.Fetch(q).ToList();

                var json = JsonConvert.SerializeObject(ProductInfo);

                return new string[2] { "1", json };
            }
            catch (Exception ex)
            {
                return new string[2] { "0", ex.Message };
            }

        }
        [WebMethod]
        public static string[] DeleteProduct(int Info)
        {
            try
            {

                var productInfo = Business.FacadeAutomation.GetProductBusiness().GetByID(Info);
                if (productInfo == null)
                    throw new Exception("وسیله  یافت نشد");

                var userproductbiz = Business.FacadeAutomation.GetPersonalProductsBusiness();
                var userproductquery = userproductbiz.GetAll(300);
                userproductquery.And(Models.Generated.AutomationDB.Automation.PersonalProduct.Columns.ProductID, Info);
                var userproductlist = userproductbiz.Fetch(userproductquery).ToList();
                foreach (var useritem in userproductlist)
                {
                    useritem.Delete();
                }
                productInfo.Delete();
                var json = JsonConvert.SerializeObject(productInfo);

                return new string[2] { "1", json };
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

                var productInfo = Business.FacadeAutomation.GetProductBusiness().GetByID(Info);
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
                var Product = new System.Web.Script.Serialization.JavaScriptSerializer().Deserialize<ProductInfo>(Info);

                var ProductType = Business.FacadeAutomation.GetProductTypeBusiness().GetByID(Product.ProductTypeID);
                if (ProductType == null)
                    throw new Exception("نوع محصول به درستی وارد نشده است");

                var ProductBrand = Business.FacadeAutomation.GetProductBrandBusiness().GetByID(Product.ProductBrandID.ToInt());
                if (ProductBrand == null)
                    throw new Exception("برند محصول به درستی وارد نشده است");

                var ProductInfo = Business.FacadeAutomation.GetProductBusiness().GetByID(Product.ID.ToLong());
                if (ProductInfo == null)
                    ProductInfo = new Models.Generated.AutomationDB.Automation.Product();

                ProductInfo.ProductTypeID = Product.ProductTypeID;
                ProductInfo.ProductBrandID = Product.ProductBrandID;
                ProductInfo.ProductModel = Product.ProductModel;
                ProductInfo.Status = Product.Status;
                if (!Product.SerialNo.IsNullOrEmpty())
                    ProductInfo.SerialNo = Product.SerialNo;
                if (!Product.Description.IsNullOrEmpty())
                    ProductInfo.Description = Product.Description;

                ProductInfo.Save();

                return new string[2] { "1", "Success" };
            }
            catch (Exception ex)
            {
                return new string[2] { "0", ex.Message };
            }

        }
        #endregion

        protected void cmbproductbrand_Callback(object sender, DevExpress.Web.ASPxClasses.CallbackEventArgsBase e)
        {
            try
            {
                var ProductType = hdfTypeAction.Get("TypeID").ToInt();
                var ProductBrands = Business.FacadeAutomation.GetProductBrandBusiness().GetByProductTypeID(ProductType);
                if (ProductBrands.Count > 0)
                {
                    cmbproductbrand.DataSourceID = null;
                    cmbproductbrand.DataSource = ProductBrands;
                    cmbproductbrand.DataBind();
                }
                else
                {
                    cmbproductbrand.DataSourceID = null;
                    cmbproductbrand.DataSource = new List<Models.Generated.AutomationDB.Automation.ProductBrand>();
                    cmbproductbrand.DataBind();
                }
            }
            catch
            {
                cmbproductbrand.DataSourceID = null;
                cmbproductbrand.DataSource = new List<Models.Generated.AutomationDB.Automation.ProductBrand>();
                cmbproductbrand.DataBind();
            }
        }
    }
}