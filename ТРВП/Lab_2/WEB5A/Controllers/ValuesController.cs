using Microsoft.AspNetCore.Mvc;
using System;

namespace WEB5A.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ValuesController : Controller
    {
        [HttpGet]
        public IActionResult Index()
        {
            return RedirectToPage("/Index");
        }

        [HttpPost]
        public IActionResult CalculateSum()
        {
            // Получаем значения из заголовков запроса
            if (!Request.Headers.ContainsKey("X-Value-x") || !Request.Headers.ContainsKey("X-Value-y"))
            {
                return BadRequest("Headers X-Value-x and X-Value-y are required.");
            }

            if (!int.TryParse(Request.Headers["X-Value-x"], out int x) || !int.TryParse(Request.Headers["X-Value-y"], out int y))
            {
                return BadRequest("Invalid header values. Please provide integer values.");
            }

            // Считаем сумму и формируем ответ
            int z = x + y;
            Response.Headers.Add("X-Value-z", z.ToString());

            return Ok();
        }
    }
}
