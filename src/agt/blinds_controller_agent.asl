/* Maria's blinds controller agent */

/*
  The agent believes that it can offer regulating the natural light
  for the task of waking up Maria
*/
available_offer(wake_up(maria), natural_light).


/* Initial goals */
!start.


/* Behavior for handling goal-achievement addition start */
@start
+!start : true
<-
  .print("Hello from blinds controller agent.").


/* TASK 3 - STEP 1
  Behavior for handling the belief addition cfp(Task)
  Implement the behavior for responding to Call For Proposals
  by sending a Propose with a natural_light offer.
*/
+cfp(Task)[source(Agent)] :
  available_offer(Task, Offer)
<-
  .print("Received CALL FOR PROPOSAL for task ", Task, " from ", Agent);
  .send(Agent, tell, proposal(Offer)).


// TASK - STEP 3
+acceptProposal(Offer)[source(Agent)] : true 
<-
  .print(Agent, " accepted proposal for ", Offer);
  !blindsUp;
  .send(Agent, tell, done).


+!blindsUp : true
<-
  .print("Moving the blinds up!").


/* Additional behaviors */
{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
{ include("$jacamoJar/templates/org-obedient.asl") }
