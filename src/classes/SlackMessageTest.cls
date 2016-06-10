@isTest
private class SlackMessageTest
{
	@isTest static void test_emptyConstructor()
  {
    insertSlackTeams();
    // Set mock callout class
    Test.setMock(HttpCalloutMock.class, new SlackMessageCallHttpCalloutMock(200, 'OK'));

    SlackMessage objMessage = new SlackMessage();
    objMessage.team         = 'team1';
    objMessage.channel      = 'channel';
    objMessage.message      = 'message';
    objMessage.ignoreFlood  = true;

    system.assertEquals('team1',objMessage.getTeam());
    system.assertEquals('channel',objMessage.getChannel());
    system.assertEquals('message',objMessage.getMessage());
    system.assertEquals(UserInfo.getName(),objMessage.getUsername()); // tests default value
    system.assertEquals(':cloud:',objMessage.getIconEmoji()); //tests default value
    system.assertEquals(true,objMessage.getIgnoreFlood());

    SlackMessage.post(new SlackMessage[]{ objMessage });
	}

	@isTest static void test_Constructor1()
  {
    insertSlackTeams();
    // Set mock callout class
    Test.setMock(HttpCalloutMock.class, new SlackMessageCallHttpCalloutMock(200, 'OK'));

    SlackMessage objMessage = new SlackMessage('team1','channel','message');
    system.assertEquals('team1',objMessage.getTeam());
    system.assertEquals('channel',objMessage.getChannel());
    system.assertEquals('message',objMessage.getMessage());
    system.assertEquals(UserInfo.getName(),objMessage.getUsername()); // tests default value
    system.assertEquals(':cloud:',objMessage.getIconEmoji()); //tests default value
    system.assertEquals(false,objMessage.getIgnoreFlood()); //tests default value

    SlackMessage.post(new SlackMessage[]{ objMessage });
	}


  @isTest static void test_Constructor2()
  {
    insertSlackTeams();
    // Set mock callout class
    Test.setMock(HttpCalloutMock.class, new SlackMessageCallHttpCalloutMock(200, 'OK'));

    SlackMessage objMessage = new SlackMessage('team1','channel','message','username',':smiley:');
    system.assertEquals('team1',objMessage.getTeam());
    system.assertEquals('channel',objMessage.getChannel());
    system.assertEquals('message',objMessage.getMessage());
    system.assertEquals('username',objMessage.getUsername());
    system.assertEquals(':smiley:',objMessage.getIconEmoji());
    system.assertEquals(false,objMessage.getIgnoreFlood()); //tests default value

    SlackMessage.post(new SlackMessage[]{ objMessage });
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