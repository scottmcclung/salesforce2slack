public with sharing class SlackMessageCall implements System.Queueable, Database.AllowsCallouts
{
  private final String strWebhookUrl;
  private final String strBody;

  private final Map<String, String[]> mapMessages;

  public SlackMessageCall(Map<String, String[]> mapMessages)
  {
    this.mapMessages = mapMessages;
  }

  public void execute(System.QueueableContext ctx)
  {
    for(String strWebhookUrl : mapMessages.keySet())
      for(String strPayload : mapMessages.get(strWebhookUrl))
        SlackMessageService.httpPost(strWebhookUrl, strPayload);
  }
}
