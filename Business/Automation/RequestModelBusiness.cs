using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Models.Generated.AutomationDB.Automation;

namespace Business.Automation
{
    public class RequestModelBusiness : AutomationBaseBusiness<RequestModel>
    {
        public RequestModel GetByID(long ID)
        {
            var q = Business.FacadeAutomation.GetRequestModelBusiness().GetAll(1);
            q.And(RequestModel.Columns.ID, ID);
            return this.Fetch(q).FirstOrDefault();
        }
    }
}
