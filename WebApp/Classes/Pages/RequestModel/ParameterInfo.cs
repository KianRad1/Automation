using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebApp.Classes.Pages.RequestModel
{
    public class ParameterInfo
    {
        public long? ID { get; set; }
        public long ReqId { get; set; }
        public string faTitle { get; set; }
        public string enTitle { get; set; }
        public long ParameterTypeID { get; set; }

    }
}