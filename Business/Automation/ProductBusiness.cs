using Models.Generated.AutomationDB.Automation;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Business.Automation
{
    public class ProductBusiness : AutomationBaseBusiness<Product>
    {
        public Product GetByID(long productid)
        {
            var q = this.GetAll(1);
            q.And(Product.Columns.ID, productid);

            return this.Fetch(q).FirstOrDefault();
        }
        public List<Product> GetByType(long typeid)
        {
            var q = this.GetAll(300);
            q.And(Product.Columns.ProductTypeID, typeid);

            return this.Fetch(q);
        }
        public class Productcmb
        {
            public long ID { get; set; }
            public string ProductFullName { get; set; }
        }
        private static List<Productcmb> _productdata;
        public static List<Productcmb> ProductData
        {
            get
            {
                var Biz = Business.FacadeAutomation.GetProductBusiness();
                if (_productdata == null)
                {
                    var prod = new List<Productcmb>();
                    var prod2 = Biz.Fetch((Biz.GetAll()));
                    foreach (var item in prod2)
                    {
                        var proditem = new Productcmb();
                        proditem.ID = item.ID;
                        //proditem.ProductFullName = item.ProductName + " " + item.ProductModel;
                        prod.Add(proditem);
                    }
                    _productdata = prod;
                }

                return _productdata;
            }
            set
            {
                _productdata = value;
            }
        }
        public List<Productcmb> GetAllProduct()
        {
            try
            {
                return ProductData;
            }
            catch
            {

                throw;
            }
        }
    }
}
