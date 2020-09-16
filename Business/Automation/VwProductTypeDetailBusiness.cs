using Models.Generated.AutomationDB.Automation;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Business.Automation
{
    public class VwProductTypeDetailBusiness : AutomationBaseBusiness<VwProductTypeDetail>
    {
        public VwProductTypeDetail GetByID(long productid)
        {
            var q = this.GetAll(1);
            q.And(VwProductTypeDetail.Columns.ID, productid);

            return this.Fetch(q).FirstOrDefault();
        }

        public List<VwProductTypeDetail> GetByProductClassificationID(long classificationID)
        {
            var q = this.GetAll(300);
            if (classificationID != 0)
                q.And(VwProductTypeDetail.Columns.ProductClassificationID, classificationID);
            q.OrderBy(VwProductTypeDetail.Columns.ID, "DESC");
            return this.Fetch(q).ToList();
        }
    }
}
