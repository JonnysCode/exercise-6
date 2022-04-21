/* Maria's personal assistant agent */

/* Initial beliefs */

/* The assistant agent believes the current time is 8AM */
current_time(8).

/* Initial goals */
!start.

/* TASK 1 - STEP 1
  Behavior for handling goal-achievement addition start
  Extend the plan start so that the agent tells the alarm agent its
  preferred methods of being notified along with a degree of preference (ranking).
*/
@start
+!start : true
<-
  .print("Hello from user agent.");
  .wait(3000);
  .send(alarm, tell, alarm_rank(natural_light, 1));
  .send(alarm, tell, alarm_rank(artificial_light, 0)).


/*
  TASK 1 - STEP 2
  Behavior for handling belief addition upcoming_event(Event, Time).
  Update the behavior upcoming_event so that if an upcoming event is
  happening at the current time, the assistant agent communicates
  with the alarm agent to achieve wake_up(maria).
*/
+upcoming_event(Event, Time) : current_time(Time)
<-
  .print("There is an upcoming event: ", Event, " at ", Time);
  .send(alarm, achieve, wake_up(maria)).

/* TASK 2 - STEP 2
  Behavior for handling goal-achievement addition inform_friend_of(maria).
  Update the behavior inform_friend_of that creates a DweetArtifact
  instance and uses the instance to send a text message to maria's friend.
  (Choose a unique name for Maria's friend)
*/
@inform_friend_of
+!inform_friend_of(maria) : true <-
  .print("Informing friend of ", maria, " with a dweet.");
  makeArtifact("dweet", "tools.DweetArtifact", [], DweetArtId);
  dweet("Hallo", "Josef").


/* Additional behaviors */
{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
{ include("$jacamoJar/templates/org-obedient.asl") }
