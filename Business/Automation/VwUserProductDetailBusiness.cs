using Models.Generated.AutomationDB.Automation;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Business.Automation
{
    public class VwUserProductDetailBusiness : AutomationBaseBusiness<VwUserProductDetail>
    {
        public VwUserProductDetail GetByID(long userproductid)
        {
            var q = this.GetAll(1);
            q.And(VwUserProductDetail.Columns.ID, userproductid);

            return this.Fetch(q).FirstOrDefault();
        }
    }
}
