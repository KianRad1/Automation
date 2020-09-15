using Models.Generated.AutomationDB.Automation;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Business.Automation
{
    public class ProductBrandBusiness : AutomationBaseBusiness<ProductBrand>
    {
        public List<ProductBrand> GetByProductTypeID(int ProductTypeID)
        {
            var q = this.GetAll(300);
            q.And(ProductBrand.Columns.ProductTypeID, ProductTypeID);
            q.OrderBy(ProductBrand.Columns.ID, "DESC");

            return this.Fetch(q).ToList();
        }

        public ProductBrand GetByID(int id)
        {
            var q = this.GetAll(300);
            q.And(ProductBrand.Columns.ID, id);

            return this.Fetch(q).FirstOrDefault();
        }
        public List<ProductBrand> GetByProductType()
        {

            return new List<ProductBrand>();
        }
    }
}
