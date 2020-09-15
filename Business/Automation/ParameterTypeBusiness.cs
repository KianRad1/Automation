using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Models.Generated.AutomationDB.Automation;

namespace Business.Automation
{
    public class ParameterTypeBusiness : AutomationBaseBusiness<ParameterType>
    {
        public ParameterType GetById(long id)
        {
            var q = this.GetAll(1);
            q.And(ParameterType.Columns.ID, id);

            return this.Fetch(q).FirstOrDefault();
        } 
    }
}
