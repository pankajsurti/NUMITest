# NUMITest - ASP.NET Web Forms with Microsoft Entra ID Authentication

## Overview

NUMITest is a sample ASP.NET Web Forms application built on .NET Framework 4.7.2 that demonstrates how to integrate **Microsoft Entra ID (Azure AD)** authentication using **OWIN middleware** and **OpenID Connect**. The application provides a secure login flow where users authenticate via their Microsoft account and access protected content.

## Features

- **Microsoft Entra ID Integration**: Single Sign-On (SSO) authentication using OpenID Connect
- **OWIN Middleware**: Cookie-based session management with sliding expiration
- **Protected Pages**: Automatic redirection to login for unauthenticated users
- **Sign In/Sign Out**: Complete authentication lifecycle management

## Project Structure

| File | Description |
|------|-------------|
| `Startup.cs` | OWIN startup configuration for OpenID Connect and cookie authentication |
| `Default.aspx/.cs` | Protected home page that displays the authenticated user's name |
| `Login.aspx/.cs` | Login page that triggers Microsoft authentication challenge |
| `Logout.aspx/.cs` | Handles sign-out from both cookie and OpenID Connect sessions |
| `Global.asax.cs` | Application lifecycle event handlers |
| `Web.config` | Configuration settings including Entra ID credentials |

## Configuration

### Setting Up Microsoft Entra ID Credentials

Before running the application, you need to configure your own Microsoft Entra ID (Azure AD) app registration credentials in the `Web.config` file.

#### Step 1: Register an Application in Azure Portal

1. Go to the [Azure Portal](https://portal.azure.com)
2. Navigate to **Microsoft Entra ID** > **App registrations**
3. Click **New registration**
4. Enter a name for your application (e.g., "NUMITest Dev")
5. Select **Accounts in this organizational directory only** (or as appropriate)
6. Set the **Redirect URI** to `http://localhost:44300/`
7. Click **Register**

#### Step 2: Create a Client Secret

1. In your app registration, go to **Certificates & secrets**
2. Click **New client secret**
3. Add a description and select an expiration period
4. Click **Add**
5. **Copy the secret value immediately** - it won't be shown again

#### Step 3: Update Web.config

Open `Web.config` and update the following settings in the `<appSettings>` section:

```xml
<appSettings>
    <add key="owin:AutomaticAppStartup" value="true" />
    <!-- Microsoft Entra ID (Azure AD) Configuration -->
    <add key="ida:ClientId" value="YOUR_CLIENT_ID_HERE" />
    <add key="ida:TenantId" value="YOUR_TENANT_ID_HERE" />
    <add key="ida:ClientSecret" value="YOUR_CLIENT_SECRET_HERE" />
    <add key="ida:RedirectUri" value="http://localhost:44300/" />
    <add key="ida:PostLogoutRedirectUri" value="http://localhost:44300/" />
</appSettings>
```

| Setting | Where to Find |
|---------|---------------|
| `ida:ClientId` | Azure Portal > App Registration > Overview > **Application (client) ID** |
| `ida:TenantId` | Azure Portal > App Registration > Overview > **Directory (tenant) ID** |
| `ida:ClientSecret` | The secret value you copied in Step 2 |

## Code Highlights

### Startup.cs - OWIN Authentication Configuration

The `Startup.cs` file configures the OWIN middleware pipeline:

- **Cookie Authentication**: Persists authentication state with a 60-minute sliding expiration
- **OpenID Connect**: Configures the Microsoft Entra ID authority, client credentials, and token validation
- **Response Type**: Uses `CodeIdToken` for hybrid flow authentication

```csharp
app.UseOpenIdConnectAuthentication(new OpenIdConnectAuthenticationOptions
{
    ClientId = ClientId,
    ClientSecret = ClientSecret,
    Authority = Authority,
    ResponseType = OpenIdConnectResponseType.CodeIdToken,
    Scope = OpenIdConnectScope.OpenIdProfile + " email",
    // ...
});
```

### Login.aspx.cs - Authentication Challenge

The login page triggers the OpenID Connect authentication flow when the user clicks "Sign in with Microsoft":

```csharp
authenticationManager.Challenge(
    new AuthenticationProperties { RedirectUri = returnUrl },
    OpenIdConnectAuthenticationDefaults.AuthenticationType);
```

### Default.aspx.cs - Protected Page

The default page checks authentication status and redirects unauthenticated users to login:

```csharp
if (!Request.IsAuthenticated)
{
    Response.Redirect($"~/Login.aspx?ReturnUrl={returnUrl}");
    return;
}
```

## Running the Project Locally with VS Code

### Prerequisites

- [.NET Framework 4.7.2 Developer Pack](https://dotnet.microsoft.com/download/dotnet-framework/net472)
- [IIS Express](https://www.microsoft.com/en-us/download/details.aspx?id=48264) (usually installed with Visual Studio)
- [Visual Studio Code](https://code.visualstudio.com/)
- [C# Dev Kit Extension](https://marketplace.visualstudio.com/items?itemName=ms-dotnettools.csdevkit) for VS Code

### Steps to Run

1. **Open the project in VS Code**
   ```
   code c:\SRC\TestDotNet472WebProject
   ```

2. **Restore NuGet packages**
   
   Open the terminal in VS Code (`Ctrl+``) and run:
   ```powershell
   dotnet restore
   ```

3. **Build the project**
   
   Use the VS Code task (press `Ctrl+Shift+B`) or run:
   ```powershell
   dotnet build
   ```

4. **Start IIS Express**
   
   Use the VS Code task by pressing `Ctrl+Shift+P`, then:
   - Type "Tasks: Run Task"
   - Select **start-iisexpress**
   
   Or run manually:
   ```powershell
   & "${env:ProgramFiles}\IIS Express\iisexpress.exe" /path:"c:\SRC\TestDotNet472WebProject" /port:44300 /clr:v4.0
   ```

5. **Open in browser**
   
   Navigate to: `http://localhost:44300/`

6. **Stop IIS Express**
   
   Run the task **stop-iisexpress** or:
   ```powershell
   Stop-Process -Name 'iisexpress' -ErrorAction SilentlyContinue
   ```

### Available VS Code Tasks

The project includes pre-configured tasks in `.vscode/tasks.json`:

| Task | Description |
|------|-------------|
| `build` | Builds the project |
| `clean` | Cleans build output |
| `restore` | Restores NuGet packages |
| `publish` | Publishes for deployment |
| `start-iisexpress` | Starts IIS Express server |
| `stop-iisexpress` | Stops IIS Express server |
| `build-and-start-iisexpress` | Builds and starts the server |

## Dependencies

- Microsoft.Owin 4.2.2
- Microsoft.Owin.Host.SystemWeb 4.2.2
- Microsoft.Owin.Security 4.2.2
- Microsoft.Owin.Security.Cookies 4.2.2
- Microsoft.Owin.Security.OpenIdConnect 4.2.2
- Microsoft.IdentityModel.Protocols.OpenIdConnect 7.5.1
- System.IdentityModel.Tokens.Jwt 7.5.1

## Troubleshooting

### Common Issues

1. **Authentication failed error**: Ensure your Client ID, Tenant ID, and Client Secret are correctly configured in `Web.config`.

2. **Redirect URI mismatch**: Verify that `http://localhost:44300/` is registered as a redirect URI in your Azure app registration.

3. **IIS Express not starting**: Ensure IIS Express is installed and the path in the task configuration is correct.

4. **Build errors**: Run `dotnet restore` to ensure all NuGet packages are restored.

## License

This is a sample project for demonstration purposes.
