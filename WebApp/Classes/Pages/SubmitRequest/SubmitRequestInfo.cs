using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebApp.Classes.Pages.SubmitRequest
{
    public class SubmitRequestInfo
    {
        public int? ReqID { get; set; }
        public int RequestModelID { get; set; }
        public string description { get; set; }
        public List<Parameter> ParamList { get; set; }
        public class Parameter
        {
            public long ParameterID { get; set; }
            public string ParameterType { get; set; }
            public string ParameterValue { get; set; }

        }
    }
}