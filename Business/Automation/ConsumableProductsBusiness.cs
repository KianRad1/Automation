using Models.Generated.AutomationDB.Automation;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Business.Automation
{
    public class ConsumableProductsBusiness : AutomationBaseBusiness<ConsumableProduct>
    {
        public ConsumableProduct GetByID(long productid)
        {
            var q = this.GetAll(1);
            q.And(ConsumableProduct.Columns.ID, productid);

            return this.Fetch(q).FirstOrDefault();
        }
    }
}
