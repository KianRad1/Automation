using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebApp.Classes.Pages.Roles
{
    public class RoleModel
    {
        public int RoleID { get; set; }
        public List<Nodes> SelectedNodes { get; set; }
        public string Title { get; set; }
        public int RoleLevel { get; set; }
        public RoleModel()
        {
            SelectedNodes = new List<Nodes>();
        }

        public class Nodes
        {
            public long ID { get; set; }
            public Guid gid { get; set; }
            public Guid? gref { get; set; }
            public string Title { get; set; }
        }
    }


}