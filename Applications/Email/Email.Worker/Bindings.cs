
namespace Email.Worker;
internal static class Bindings
{
	public static void RegisterServices(this IServiceCollection serviceCollection)
	{
		serviceCollection.AddControllers();
	}

	public static void RegisterWorkers(this IServiceCollection serviceCollection)
	{
		serviceCollection.AddHostedService<Worker>();
	}
}
