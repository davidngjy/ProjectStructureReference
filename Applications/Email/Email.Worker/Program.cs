using Email.Worker;

IHost host = Host.CreateDefaultBuilder(args)
	.ConfigureServices(services =>
	{
		services.RegisterWorkers();
	})
	.Build();

await host.RunAsync();
