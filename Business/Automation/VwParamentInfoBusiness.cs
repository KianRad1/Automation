using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Models.Generated.AutomationDB.Automation;

namespace Business.Automation
{
    public class VwParamentInfoBusiness : AutomationBaseBusiness<VwParamentInfo>
    {
        public List<VwParamentInfo> GetByReqModelId(long id)
        {
            var q = this.GetAll();
            q.And(VwParamentInfo.Columns.RequestModelID, id);
            q.OrderBy(VwParamentInfo.Columns.ParameterType, "ASC");

            return this.Fetch(q);
        }
    }
}
