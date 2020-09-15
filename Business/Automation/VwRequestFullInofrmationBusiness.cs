using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Models.Generated.AutomationDB.Automation;

namespace Business.Automation
{
    public class VwRequestFullInofrmationBusiness : AutomationBaseBusiness<VwRequestFullInofrmation>
    {
        public VwRequestFullInofrmation GetByRequestID(long info)
        {
            var q = this.GetAll(1);
            q.And(VwRequestFullInofrmation.Columns.RequestID, info);

            return this.Fetch(q).FirstOrDefault();
        }
    }
}
