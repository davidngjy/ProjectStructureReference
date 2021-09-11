
using Website.Blazor.Data;

namespace Website.Blazor;
internal static class Bindings
{
	public static void RegisterServices(this IServiceCollection serviceCollection)
	{
		serviceCollection.AddRazorPages();
		serviceCollection.AddServerSideBlazor();
		serviceCollection.AddSingleton<WeatherForecastService>();
	}
}
