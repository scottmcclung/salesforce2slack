/**
 * Slack Message Service
 *
 * Provides an API to post messages to a Slack channel.
 * Teams and their related webhook urls are stored in the SlackTeams__c custom object
 * The channel that the message should post into is provide by the caller
 *
 * The "https://hooks.slack.com" endpoint must be entered as a Remote Site Setting
 * Configure this at: Settings -> Security Controls -> Remote Site Settings
 */

public class SlackMessageService
{
  /**
   * Holds the count of messages that have been sent in the current context
   *
   * @return Integer
   */
  private static Integer intFloodCounter;



  /**
   * Holds the maximum number of message that can be sent in a single execution context
   *
   * @return Integer
   */
  private static Integer intMaxMessages;



  /**
   * Holds the configured Slack team webhooks
   *
   * @return Map<String, SlackTeam__c>
   */
  private static Map<String, SlackTeam__c> mapSlackTeams = new Map<String, SlackTeam__c>();



  /**
   * Initialize the static variables
   *
   */
  static
  {
    intFloodCounter   = 0;
    intMaxMessages    = 3;  // The maximum messages allowed per execution context

    for(SlackTeam__c objTeam : [SELECT Name, WebHookUrl__c FROM SlackTeam__c])
      mapSlackTeams.put(objTeam.Name, objTeam);
  }



  /**
   * Post a message to Slack
   *
   * @param  String strTeam
   * @param  String strChannel
   * @param  String strMessage
   */
  public static void post(String strTeam, String strChannel, String strMessage)
  {
    SlackMessage objMessage = new SlackMessage(strTeam, strChannel, strMessage);
    post(new SlackMessage[]{ objMessage });
  }



  /**
   * Post a message to Slack
   *
   * @param  String strTeam
   * @param  String strChannel
   * @param  String strMessage
   * @param  String strUsername
   * @param  String strIconEmoji
   */
  public static void post(String strTeam, String strChannel, String strMessage, String strUsername, String strIconEmoji)
  {
    SlackMessage objMessage = new SlackMessage(strTeam, strChannel, strMessage, strUsername, strIconEmoji);
    post(new SlackMessage[]{ objMessage });
  }



  /**
   * Post a message to Slack
   *
   * @param  SlackMessage objMessage
   */
  public static void post(SlackMessage[] lstMessages)
	{
    Map<String, String[]> mapMessages = new Map<String, String[]>();

    for(SlackMessage objMessage : lstMessages)
    {
      if(SlackMessageService.isFlood() && ! objMessage.getIgnoreFlood() ) continue;  // Flood protection

      Map<String, Object> mapPayload = new Map<String, Object>{
        'username'    => objMessage.getUsername(),
        'channel'     => objMessage.getChannel(),
        'text'        => objMessage.getMessage(),
        'icon_emoji'  => objMessage.getIconEmoji(),
        'mrkdwn'      => true
      };

      String strWebhookUrl = getTeamWebhook(objMessage.getTeam());
      if( ! mapMessages.containsKey(strWebhookUrl))
        mapMessages.put(strWebhookUrl, new String[]{});
      mapMessages.get(strWebhookUrl).add(JSON.serialize(mapPayload));
    }

    system.enqueueJob( new SlackMessageCall( mapMessages ) );
	}



  /**
   * Return the maximum number of allowed messages
   *
   * @return Integer
   */
  public static Integer getMaximumMessages()
  {
    return intMaxMessages;
  }



  /**
   * Override the default maximum messages allowed
   *
   * @param Integer intMax
   */
  public static void setMaximumMessages(Integer intMax)
  {
    intMaxMessages = intMax;
  }



  /**
   * Http callout with POST method
   *
   * @param  String strWebhookUrl
   * @param  String strBody
   * @return HttpResponse
   */
  public static HttpResponse httpPost(String strWebhookUrl, String strBody)
  {
    HttpRequest request = new HttpRequest();
    request.setEndpoint(strWebhookUrl);
    request.setMethod('POST');
    request.setBody(strBody);

    Http http = new Http();
    HttpResponse response = http.send(request);

    system.debug('Slack HTTP Callout Response: ' + response);
    return response;
  }



  /**
   * Checks if we've exceeded the maximum number of messages per context
   *
   * @return Boolean
   */
  private static Boolean isFlood()
  {
    intFloodCounter++;
    return intFloodCounter > getMaximumMessages();
  }



  /**
   * Return the webhook url for a given team name
   *
   * @param  String strTeam
   * @return String
   */
  private static String getTeamWebhook(String strTeam)
  {
    return getTeam(strTeam).WebHookUrl__c;
  }



  /**
   * Return the SlackTeam__c record with the given team name
   * @param  String strTeam
   * @return SlackTeam__c
   */
  private static SlackTeam__c getTeam(String strTeam)
  {
    if( ! mapSlackTeams.containsKey(strTeam))
      throw new SlackMessageException(String.format('An attempt was made to post a message to the Slack team \'\'{0}\'\', but that team has not been configured yet.  Please have the administrator add it before trying again.', new String[]{strTeam}));

    return mapSlackTeams.get(strTeam);
  }
}