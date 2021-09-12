
using Jaeger;
using Jaeger.Samplers;
using Jaeger.Senders;
using Jaeger.Senders.Thrift;
using Microsoft.Extensions.Diagnostics.HealthChecks;
using OpenTracing;
using OpenTracing.Util;

namespace Management.GraphQL;
internal static class Bindings
{
	public static void RegisterServices(this IServiceCollection serviceCollection)
	{
		serviceCollection.AddControllers();

		serviceCollection.AddOpenTracing();
		serviceCollection.AddSingleton(RegisterTracer);

		serviceCollection
			.AddHealthChecks()
			.AddCheck("Startup", () => HealthCheckResult.Healthy("Service is running!"));
	}

	private static ITracer RegisterTracer(IServiceProvider serviceProvider)
	{
		var loggerFactory = serviceProvider.GetService<ILoggerFactory>();
		var configuration = serviceProvider.GetService<IConfiguration>();
		var serviceName = configuration.GetValue<string>("JAEGER_SERVICE_NAME");

		if (string.IsNullOrWhiteSpace(serviceName))
			return GlobalTracer.Instance; // Noop tracer

		Configuration.SenderConfiguration.DefaultSenderResolver = new SenderResolver(loggerFactory)
			.RegisterSenderFactory<ThriftSenderFactory>();

		return Configuration
			.FromIConfiguration(
				loggerFactory,
				configuration)
			.GetTracerBuilder()
			.WithSampler(new ConstSampler(true))
			.Build();
	}
}
