@isTest
public class SlackMessageCallHttpCalloutMock implements HttpCalloutMock
{
  protected Integer code;
  protected String status;

  public SlackMessageCallHttpCalloutMock(Integer code, String status)
  {
    this.code = code;
    this.status = status;
  }

  public HTTPResponse respond(HTTPRequest req)
  {
    System.assertEquals('https://hooks.slack.com/services/', req.getEndpoint().left(33));
    System.assertEquals('POST', req.getMethod());

    HttpResponse res = new HttpResponse();
    res.setStatusCode(this.code);
    res.setStatus(this.status);
    return res;
  }
}