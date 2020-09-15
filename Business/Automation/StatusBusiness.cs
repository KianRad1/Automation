using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Models.Generated.AutomationDB.Automation;

namespace Business.Automation
{
    public class StatusBusiness : AutomationBaseBusiness<Status>
    {
        public Status GetByID(long levelID)
        {
            var q = this.GetAll(1);
            q.And(Status.Columns.ID, levelID);

            return this.Fetch(q).FirstOrDefault();
        }
    }
}
