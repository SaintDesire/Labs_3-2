using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Mvc;
using System.Text.Json;

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

//https://localhost:7027/KNI?parmA=14&parmB=15
app.MapGet("/KNI", (string? parmA, string? parmB) =>
{
    if (parmA != null && parmB != null && int.TryParse(parmA, out var a) && int.TryParse(parmB, out var b))
    {
        return $"GET-Http-KNI:ParmA ={parmA},ParmB = {parmB}";
    }

    return "Error during request: invalid params";
}); 

// POST: https://localhost:7027/KNI?parmA=5&parmB=12
app.MapPost("/KNI", (string? parmA, string? parmB) =>
{
    if (parmA != null && parmB != null && int.TryParse(parmA, out var a) && int.TryParse(parmB, out var b))
    {
        return $"POST-Http-KNI:ParmA ={parmA},ParmB = {parmB}";
    }

    return "Error during request: invalid params";
});

// PUT: https://localhost:7027/KNI?parmA=4&parmB=13
app.MapPut("/KNI", (string? parmA, string? parmB) =>
{
    if (parmA != null && parmB != null && int.TryParse(parmA, out var a) && int.TryParse(parmB, out var b))
    {
        return $"PUT-Http-KNI:ParmA ={parmA},ParmB = {parmB}";
    }

    return "Error during request: invalid params";
});

// POST: https://localhost:7027/KNI/sum?x=2&y=12
app.MapPost("/KNI/sum", (int x, int y) =>
{
    return x + y;
});

//ex5
var htmlFilePath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "calculate.html");

//https://localhost:7027/calculate
app.MapGet("/calculate", async (HttpContext context) =>
{
    await context.Response.WriteAsync(File.ReadAllText(htmlFilePath));
});

//https://localhost:7027/calculate
app.MapPost("/calculate", async (HttpContext context) =>
{
    var json = await new StreamReader(context.Request.Body).ReadToEndAsync();
    var data = JsonSerializer.Deserialize<Dictionary<string, int>>(json);
    int x = data["x"];
    int y = data["y"];
    return Results.Ok(x * y);
});

//ex6
//https://localhost:7027/calculate2
var htmlFilePath2 = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "calculateWithForm.html");
app.MapGet("/calculate2", async (HttpContext context) =>
{
    await context.Response.WriteAsync(File.ReadAllText(htmlFilePath2));
});

app.MapPost("/calculate2", async (HttpContext context) =>
{
    if (context.Request.HasFormContentType)
    {
        var form = await context.Request.ReadFormAsync();
        int x = int.Parse(form["x"]);
        int y = int.Parse(form["y"]);
        return Results.Ok(x * y);
    }
    else
    {
        return Results.BadRequest("The request content type is not a form.");
    }
});

app.Run();
