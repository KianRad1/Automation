using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Models.Generated.AutomationDB.Automation;

namespace Business.Automation
{
    public class ParameterDetailBusiness : AutomationBaseBusiness<ParameterDetail>
    {
        public ParameterDetail GetById(long id)
        {
            var q = this.GetAll(1);
            q.And(ParameterDetail.Columns.ID, id);
            q.OrderBy(ParameterDetail.Columns.ID, "DESC");

            return this.Fetch(q).FirstOrDefault();
        }
    }
}
