using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Utilities
{
    public class Constants
    {
        public static class Images
        {
            public const string Enable = "~/Images/Checked.png";
            public const string Disable = "~/Images/Unchecked.png";
        }
        public enum Status
        {
            Created = 1,
            Sent = 2,
            InProgress = 3,
            Accepted = 4,
            Rejected = 5
        }

    }
}
