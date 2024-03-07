using System.Net.WebSockets;
using System.Text;

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

app.UseWebSockets();

var htmlFilePath = Path.Combine(Directory.GetCurrentDirectory(), "html", "index.html");

app.MapGet("/", async (HttpContext context) =>
{
    await context.Response.WriteAsync(File.ReadAllText(htmlFilePath));
});

app.Map("/ws", async (HttpContext context) =>
{
    if (context.WebSockets.IsWebSocketRequest)
    {
        using var webSocket = await context.WebSockets.AcceptWebSocketAsync();

        while (webSocket.State != WebSocketState.Closed && webSocket.State != WebSocketState.Aborted)
        {
            var time = Encoding.UTF8.GetBytes(DateTime.Now.ToString());
            await webSocket.SendAsync(new ArraySegment<byte>(time, 0, time.Length), WebSocketMessageType.Text, true, CancellationToken.None);
            await Task.Delay(2000);
        }
    }
    else
    {
        context.Response.StatusCode = 400;
    }
});

app.Run();