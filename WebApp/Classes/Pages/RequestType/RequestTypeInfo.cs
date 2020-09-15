using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WebApp.Classes.Base;
using Utilities;

namespace WebApp.Classes.Pages.RequestType
{
    public class RequestTypeInfo
    {
        public string[] Items { get; set; }
        public int TypeID { get; set; }
        public int RequestModelID { get; set; }
        public int Importance { get; set; }

        public List<Models.Generated.AutomationDB.Automation.RequestModel> GetAllRequest()
        {
            var Reqlist = Business.FacadeAutomation.GetSPBusiness().SP_GetUserRequesTypes(BasePage.CurrentUser.Level.ToLong(), BasePage.CurrentUser.RoleGroupID.ToLong()).Select(r => r.ID);

            var Biz = Business.FacadeAutomation.GetRequestTypeBusiness();
            var q = Biz.GetAll();
            q.And(Models.Generated.AutomationDB.Automation.RequestType.Columns.ID, Business.CompareFilter.In, Reqlist);
            var entity = Biz.Fetch(q);

            for (int i = 0; i < entity.Count; i++)
            {
                var j = entity.Count - 1;
                while ( i < j )
                {
                  if(entity[i].RequestModelID == entity[j].RequestModelID)
                    {
                        if (entity[i].Importance > entity[j].Importance)
                            entity.RemoveAt(j);
                        else
                            entity.RemoveAt(i);
                    }
                    --j;

                }

            }
            var allowedlist =  entity.Select(r => r.RequestModelID);
            var BizModel = Business.FacadeAutomation.GetRequestModelBusiness();
            var qmodel = BizModel.GetAll();
            qmodel.And(Models.Generated.AutomationDB.Automation.RequestModel.Columns.ID, Business.CompareFilter.In, allowedlist);
            var entitymodel = BizModel.Fetch(qmodel);

            return entitymodel;
        }
    }
 
}