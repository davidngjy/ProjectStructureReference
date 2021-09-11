using Microsoft.AspNetCore.Mvc;
using System.Data.SqlClient;
using Dapper;

namespace Management.GraphQL.Controllers;

[ApiController]
[Route("[controller]")]
public class TestController : ControllerBase
{
	private readonly string _connectionString;

	public TestController(IConfiguration configuration)
	{
		_connectionString = configuration.GetConnectionString("ManagementDB");
	}

	[HttpGet("Connection")]
	public IActionResult Index()
	{
		try
		{
			using var connection = new SqlConnection(_connectionString);

			var result = connection.QueryFirst<string>("SELECT name FROM dbo.Test");

			return Ok($"Result: {result}");
		}
		catch (Exception ex)
		{
			return BadRequest(ex.Message);
		}
	}
}
