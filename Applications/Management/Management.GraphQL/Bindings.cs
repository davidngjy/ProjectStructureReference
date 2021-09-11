
namespace Management.GraphQL;
internal static class Bindings
{
	public static void RegisterServices(this IServiceCollection serviceCollection)
	{
		serviceCollection.AddControllers();
	}
}
