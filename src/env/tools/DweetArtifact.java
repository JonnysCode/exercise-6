package tools;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URI;
import static java.net.URLEncoder.encode;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

import cartago.Artifact;
import cartago.OPERATION;

/* TASK 2 - STEP 1
  Extend the implementation of the artifact that exploits the dweet.io API
*/
public class DweetArtifact extends Artifact {

  private final static String DWEET_ENDPOINT = "https://dweet.io/dweet/for/";

  public void init() {

  }

  @OPERATION
  public void dweet(String message, String agent) throws UnsupportedEncodingException {

    String url = DWEET_ENDPOINT + "was-jonathan?message=" + encode(message, "UTF-8") + "&agent=" + encode(agent,
        "UTF-8");

    log("Sending dweet to " + url);

    HttpClient client = HttpClient.newHttpClient();
    HttpRequest request = HttpRequest.newBuilder()
        .uri(URI.create(url))
        .build();

    try {
      HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

      if (response.statusCode() != 200) {
        failed("Status code: " + response.statusCode());
      }

    } catch (IOException | InterruptedException e) {
      failed(e.getMessage());
    }

    log("Dweet sent successfully!");
  }
}
