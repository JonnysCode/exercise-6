/* Maria's alarm agent that notifies Maria in case of upcomin events.


/* Initial rules */
/* TASK 1 - STEP 3
  Rule for inferring the best ranked alarm type for waking up Maria
  Update the rule to infer the best alarm type in order of ranking
  (see alarm_rank(AlramType)) and exclude any alarm types that have already failed
  (see failed(AlarmType)).
*/
best_alarm_type(AlarmType) :-
  alarm_rank(AlarmType1, Rank1) & 
  alarm_rank(AlarmType2, Rank2) & 
  ( Rank1 > Rank2 | failed(AlarmType2)) & 
  not failed(AlarmType1) & 
  .print("Best alarm type: ", AlarmType1) &
  AlarmType = AlarmType1.


/* Initial goals */
!start.


/* Behavior for handling goal-achievement addition start */
@start
+!start : true
<-
  .print("Hello from alarm agent.");
  .wait(3000).


/*
  Behavior for handling goal-achievement addition wake_up(maria).
*/
@wake_up
+!wake_up(maria) : true <-
  // Initiate the Contract Net Protocol
  !initiate_CNP(wake_up(maria), 10000);

  // Select a winning bid (if any)
  !select_bid.


/* TASK 3 - STEP 2
  Behavior for handling goal-achievement addition select_bid.
  Update the plan context so that the plan body is executed only if there is
  a best alarm type (see best_alarm_type(AlarmType)), and the alarm agent has
  received a proposal (based on your implementation of Task 3 Step 1).
  Update the plan body so that the alarm agent sends an Accept Proposal message
  to the agent that proposed an offer with the best alarm type.
*/
@select_bid
+!select_bid : 
  best_alarm_type(AlarmType) &
  proposal(AlarmType)[source(Agent)]
<-
  .print("Accepting proposal ", AlarmType, " from ", agent);
  .send(Agent, tell, acceptProposal(AlarmType));

  // After communicating with the agent that sent the best proposal, the agent
  // waits for 5 sec.
  .wait(5000);

  // Then, the agent tests if Maria is awake. This will always fail so that
  // the agent will attempt again to wake Maria up.
  ?is_awake(maria).


/*
  Behavior for handling goal-achievement addition select_bid if no one replied
  to the Call For Proposal message.
*/
+!select_bid : best_alarm_type(AlarmType) <-
  // Nobody bid for the best alarm type
  .print("No bid for alarm type ", AlarmType);

  // Ignore the alarm type and try again to wake up Maria
  +failed(AlarmType);
  !wake_up(maria).


/*
  Behavior for handling goal-achievement addition select_bid if no one replied
  to the Call For Proposal message and all alarm types are being ignored.
*/
+!select_bid : true <-
  .print("I've tried out all the alarm types.");

  // Inform Maria's friend to wake her up
  !inform_friend_of(maria).


/*
  Behavior for handling goal-achievement deletion select_bid.
  If an alarm type was used and failed to wake up Maria, it will be ignored
  from now on (failed(AlarmType)).
*/
-!select_bid : best_alarm_type(AlarmType)  <-
  .print("Failed to wake up with ", AlarmType);

  // Ignore the alarm type and try again to wake up Maria
  +failed(AlarmType);
  !wake_up(maria).


/* TASK 1 - STEP 4
  Behavior for handling goal-achievement deletion inform_friend_of(maria).
  Update the body so that the alarm agent asks the assistant agent how to
  inform Maria's friend.
*/
-!inform_friend_of(maria) : true <-
  .print("I was not able to wake up Maria with any available method.");
  .send(assistant_agent, askHow, {+!inform_friend_of(maria)})
  // After the agent asks the assistant agent, it waits and then attempts
  // to inform again Maria's friend.
  .wait(3000);
  !inform_friend_of(maria).


/* Behavior for handling goal-achievent addition initiate_CNP(Task) */
@initiate_CNP
+!initiate_CNP(Task, Deadline) <-
  .print("Sending CALL FOR PROPOSAL for task " , Task);

  // Send a Call For Proposal for Task
  .broadcast(tell, cfp(Task));

  // Wait for bids
  .wait(Deadline).


/*
  Behavior for handling belief addition alarm_rank(AlarmType, Ranking)
  Adds an alarm type and its ranking
*/
+alarm_rank(AlarmType, Ranking) :
  .sublist([AlarmType], [natural_light, artificial_light]) &
  .sublist([Ranking], [0, 1])
<- .print("Added ranking ", Ranking, " for alarm type ", AlarmType).


/* Additional behaviors */
{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
{ include("$jacamoJar/templates/org-obedient.asl") }
