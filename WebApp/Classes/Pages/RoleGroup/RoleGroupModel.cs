using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebApp.Classes.Pages.RoleGroup
{
    public class RoleGroupModel
    {
        public long ID { get; set; }
        public string Title { get; set; }
        public long ParentID { get; set; }
    }
}