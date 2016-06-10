@isTest
private class SlackMessageServiceTest
{
  @isTest static void test_post_withList()
  {
    insertSlackTeams();
    SlackMessage[] lstMessages = new SlackMessage[]{
       new SlackMessage('team1','channel','message','username',':cloud:')
      ,new SlackMessage('team2','channel','message')
    };
    // Set mock callout class
    Test.setMock(HttpCalloutMock.class, new SlackMessageCallHttpCalloutMock(200, 'OK'));

    SlackMessageService.post(lstMessages);
  }


  @isTest static void test_post_singleMessage1()
  {
    insertSlackTeams();

    // Set mock callout class
    Test.setMock(HttpCalloutMock.class, new SlackMessageCallHttpCalloutMock(200, 'OK'));
    SlackMessageService.post('team1','channel','message');
  }



  @isTest static void test_post_singleMessage2()
  {
    insertSlackTeams();

    // Set mock callout class
    Test.setMock(HttpCalloutMock.class, new SlackMessageCallHttpCalloutMock(200, 'OK'));
    SlackMessageService.post('team1','channel','message','username',':cloud:');
  }


  @isTest static void test_postToUnconfiguredTeam()
  {
    try
    {
      insertSlackTeams();
      SlackMessage[] lstMessages = new SlackMessage[]{
         new SlackMessage('test','channel','message','username',':cloud:')
      };
      // Set mock callout class
      Test.setMock(HttpCalloutMock.class, new SlackMessageCallHttpCalloutMock(200, 'OK'));

      SlackMessageService.post(lstMessages);
      system.assert(false, 'Expecting an exception, none generated');
    }
    catch(SlackMessageException e)
    {
      system.assertEquals('An attempt was made to post a message to the Slack team \'test\', but that team has not been configured yet.  Please have the administrator add it before trying again.', e.getMessage());
    }
  }



  @isTest static void test_getMaximumMessages()
  {
    system.assertEquals(3, SlackMessageService.getMaximumMessages());
  }


  @isTest static void test_setMaximumMessages()
  {
    SlackMessageService.setMaximumMessages(5);
    system.assertEquals(5, SlackMessageService.getMaximumMessages());
  }



	@isTest static void test_httpPost()
  {
    Map<String, Object> mapPayload = new Map<String, Object>{
      'username'    => 'bot',
      'channel'     => 'channel',
      'text'        => 'message',
      'icon_emoji'  => ':cloud:',
      'mrkdwn'      => true
    };

    // Set mock callout class
    Test.setMock(HttpCalloutMock.class, new SlackMessageCallHttpCalloutMock(200, 'OK'));

    HttpResponse response = SlackMessageService.httpPost( 'https://hooks.slack.com/services/', JSON.serialize(mapPayload) );

    // Verify response received contains mock values
    system.assertEquals('OK', response.getStatus());
    system.assertEquals(200, response.getStatusCode());
	}



  private static void insertSlackTeams()
  {
    SlackTeam__c[] lstTeams = new SlackTeam__c[]{
       new SlackTeam__c(Name = 'team1', WebHookUrl__c = 'https://hooks.slack.com/services/')
      ,new SlackTeam__c(Name = 'team2', WebHookUrl__c = 'https://hooks.slack.com/services/')
      ,new SlackTeam__c(Name = 'team3', WebHookUrl__c = 'https://hooks.slack.com/services/')
    };
    insert lstTeams;
  }
}