using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Models.Generated.AutomationDB.Automation;

namespace Business.Automation
{
    public class VwRequestTypeDetailBusiness : AutomationBaseBusiness<VwRequestTypeDetail>
    {
        public List<VwRequestTypeDetail> GetByTypeID(long ID)
        {
            var q = this.GetAll();
            q.And(VwRequestTypeDetail.Columns.RequestTypeID, ID);
            q.OrderBy(VwRequestTypeDetail.Columns.Priority, "ASC");
            return this.Fetch(q);
        }
    }
}
