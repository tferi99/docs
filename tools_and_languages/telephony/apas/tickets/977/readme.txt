#977

Scenario:

	- You have an agent in a queue (Q1) and in a group (G2) which does not contain agent DN but an expression which contains Q1
		- Agent Group is G1
		- Agents primary queue is Q1

		Q1:	A1, A2		G1: expr(Q1)
		Q2, A2			G2: expr(Q2)	
		
		So agent displays group with expression.
	
	- You add a new queue (Q2) with new group (G2) and adds agent to Q2, too.
		- Agent Group is G2
		- Agent primary queue will be changed to Q2
		
	In this case group display will be 'frozen' - so won't be refreshed.
		- If you reset phone it won't diplay group display at all.
		- If you restart APAS both of groups won't be displayed on any affected devices.
		- IF YOU SAVE GROUP, group dislay appearing, but:
		
		
		BUT once I noteced some strange:
		
			Primary queue of A2 (common) Agent is Q2 and
			- changing G1, only G1 will be displayed
			- changing G2, only G2 will be displayed
			
				Q2 contains only A2 
			
			Primary queue of A2 (common) Agent is Q1 and
			- changing G1, both will be displayed !!!!!
			- changing G2, NOTHING be displayed !!!!!
			
				Q1 contains A1 and A2, so changing G2 does not have any affect on agents
				but changing G1 affects both of agents (via Q1)
			
	WORKAROUND:
	
		put A2 into a new page of groups, pages won't be displayed in devices (only on DCs)