using System;
using System.Web;

namespace NUMITest
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is authenticated
            if (!Request.IsAuthenticated)
            {
                // Redirect to login page with return URL
                string returnUrl = HttpUtility.UrlEncode(Request.Url.PathAndQuery);
                Response.Redirect($"~/Login.aspx?ReturnUrl={returnUrl}");
                return;
            }

            // Display the authenticated user's name
            if (!IsPostBack)
            {
                lblUsername.Text = HttpUtility.HtmlEncode(User.Identity.Name);
            }
        }
    }
}
