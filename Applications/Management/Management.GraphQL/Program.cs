
using Management.GraphQL;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.RegisterServices();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (builder.Environment.IsDevelopment())
{
	app.UseDeveloperExceptionPage();
}

app.UseAuthorization();

app.UseRouting();
app.UseEndpoints(endpoints =>
{
	endpoints.MapControllers();

	endpoints.MapHealthChecks("/health");

});

app.Run();
