using System.Net;
using System.Text.Json;
using Microsoft.AspNetCore.Mvc.Testing;
using Xunit;

public class ContactosTest : IClassFixture<WebApplicationFactory<Program>>
{
    private readonly WebApplicationFactory<Program> _factory;

    public ContactosTest(WebApplicationFactory<Program> factory)
    {
        _factory = factory;
    }

    [Fact]
    public async Task ObtenerContactos_ReturnsExpectedContactList()
    {
        // Arrange
        var client = _factory.CreateClient();

        // Act
        var response = await client.GetAsync("/obtenercontactos");

        // Assert
        Assert.Equal(HttpStatusCode.OK, response.StatusCode);

        var responseString = await response.Content.ReadAsStringAsync();
        var contactos = JsonSerializer.Deserialize<List<string>>(responseString, new JsonSerializerOptions
        {
            PropertyNameCaseInsensitive = true
        });

        Assert.NotNull(contactos);
        Assert.Equal(3, contactos.Count);
        Assert.Contains("Amin Espinoza", contactos);
        Assert.Contains("Oscar Barajas", contactos);
        Assert.Contains("Pepe Rodelo", contactos);
    }
}