# Material para la clase 6

Ejecuta los siguientes comandos:

```bash
dotnet new xunit -o ApiContactos.Tests

dotnet add ApiContactos.Tests reference ApiContactos

dotnet new sln -n ApiContactos

dotnet sln ApiContactos.sln add ApiContactos ApiContactos.Tests

dotnet add ApiContactos.Tests package Microsoft.AspNetCore.Mvc.Testing --version 8.0.15
```

Agrega este código a tu proyecto de pruebas (dentro del archivo .cs):

```csharp
using System.Net;
using System.Text.Json;
using Microsoft.AspNetCore.Mvc.Testing;
using Xunit;

public class ProgramTest : IClassFixture<WebApplicationFactory<Program>>
{
    private readonly WebApplicationFactory<Program> _factory;

    public ProgramTest(WebApplicationFactory<Program> factory)
    {
        _factory = factory;
    }

    [Fact]
    public async Task GetWeatherForecast_ReturnsValidResponse()
    {
        var client = _factory.CreateClient();
        var response = await client.GetAsync("/weatherforecast");

        Assert.Equal(HttpStatusCode.OK, response.StatusCode);

        var responseString = await response.Content.ReadAsStringAsync();
        var forecasts = JsonSerializer.Deserialize<WeatherForecast[]>(responseString, new JsonSerializerOptions
        {
            PropertyNameCaseInsensitive = true
        });

        Assert.NotNull(forecasts);
        Assert.Equal(5, forecasts.Length);

        foreach (var forecast in forecasts)
        {
            Assert.InRange(forecast.TemperatureC, -20, 55);
            Assert.False(string.IsNullOrEmpty(forecast.Summary));
        }
    }

    private record WeatherForecast(DateOnly Date, int TemperatureC, string? Summary)
    {
        public int TemperatureF => 32 + (int)(TemperatureC / 0.5556);
    }
}
```

Termina con el comando final:

```bash
dotnet test
```
