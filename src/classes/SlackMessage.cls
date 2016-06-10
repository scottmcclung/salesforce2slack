global with sharing class SlackMessage
{
  @InvocableVariable(
    required      = true
    label         = 'Team Name'
    description   = 'The name of the Slack Team being posted to (required)')
  public String team;




  @InvocableVariable(
    required      = true
    label         = 'Channel Name'
    description   = 'The name of the Slack Channel being posted to (required)')
  public String channel;




  @InvocableVariable(
    required      = false
    label         = 'User Name'
    description   = 'The message poster name (defaults to the current user\'s name)')
  public String username;




  @InvocableVariable(
    required      = true
    label         = 'Message'
    description   = 'The message to be posted (required)')
  public String message;




  @InvocableVariable(
    required      = false
    label         = 'Icon Emoji'
    description   = 'The icon image displayed on the message')
  public String iconemoji;




  @InvocableVariable(
    required      = false
    label         = 'Force Send'
    description   = 'Ignores the flood gates and sends even if it exceeds the maximum number of posts per context')
  public Boolean ignoreFlood;





  /**
   * Constructor
   *
   */
  public SlackMessage() {}




  /**
   * Constructor
   *
   * @param String strTeam
   * @param String strChannel
   * @param String strMessage
   */
  public SlackMessage(String strTeam, String strChannel, String strMessage)
  {
    this.team         = strTeam;
    this.channel      = strChannel;
    this.message      = strMessage;
  }




  /**
   * Constructor
   *
   * @param String strTeam
   * @param String strChannel
   * @param String strMessage
   * @param String strUsername
   * @param String strIconEmoji
   */
  public SlackMessage(String strTeam, String strChannel, String strMessage, String strUsername, String strIconEmoji)
  {
    this.team         = strTeam;
    this.channel      = strChannel;
    this.message      = strMessage;
    this.username     = strUsername;
    this.iconemoji    = strIconEmoji;
  }



  /**
   * Return the team name to post to
   *
   * @return String
   */
  public String getTeam()
  {
    return this.team;
  }




  /**
   * Return the channel name to post to
   *
   * @return String
   */
  public String getChannel()
  {
    return this.channel;
  }



  /**
   * Return the username
   * Default to the running user name if not set at runtime
   *
   * @return String
   */
  public String getUsername()
  {
    if(this.username == null)
      return UserInfo.getName();
    return username;
  }




  /**
   * Return the message to post
   *
   * @return String
   */
  public String getMessage()
  {
    return this.message;
  }




  /**
   * Return the Icon Emoji to use on the post
   * Default to the ':cloud:' icon if not set at runtime
   *
   * @return String
   */
  public String getIconEmoji()
  {
    if(this.iconemoji == null)
      return ':cloud:';
    return this.iconemoji;
  }



  /**
   * Return whether to ignore the flood protection for this message
   *
   * @return Boolean
   */
  public Boolean getIgnoreFlood()
  {
    if(this.ignoreFlood == null)
      return false;
    return this.ignoreFlood;
  }



  /**
   * Send list of posts to the SlackMessageService
   *
   * @param SlackMessage[]
   */
  @InvocableMethod(
    label       = 'Slack Message'
    description = 'Posts a message in a Slack channel.')
  global static void post(SlackMessage[] lstMessages)
  {
    SlackMessageService.post( lstMessages );
  }
}