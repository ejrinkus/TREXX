CS4121 - Program 3
Behnam Litkouhi
Due: 27 February 2014

README

HOW TO RUN:
	Run the world.rkt file in DrRacket.

HOW TO PLAY:
In this text adventure game, your goal is to escape Rekhi Hall.  There are two 
ways to win, and two ways to lose.

PLACES:
	*The game world is laid out like Rekhi Hall.  You begin in Rekhi-112.
	
OBJECTS:
	*The inventory is now limited to four items.
	*The backpack (limited to five items) is found in the second floor dead end.
	*The cash is found in the second floor north offices.
	*Snacks are found throughout the building.
	*The Fisher-key is obtained through a quest.
	*The research is obtained through a quest.
	*The coat is obtained through a quest.
	
MONSTERS/OTHER:
	*The demented professor (who randomly teleports the player on encounter) moves 
	randomly around the building.
	*Two zombie grad students (who kill the player if in the same area for more 
	than two actions) move randomly around the building.
	*The programmer is located in Rekhi-117.  He offers a quest to get the 
	winter coat.
	*The disgruntled grad student is located in the first floor north offices.  
	He offers a quest to ultimately get the Fisher-key.

VERBS:
	Backpack-related actions:
		view backpack -> shows the contents of the backpack
		pack item -> takes item from your inventory and puts it into the backpack
		unpack item -> takes item from your backpack and puts it on the ground
		
	Quest interactions:
		talk person -> talk to the person
		trade person -> attempt to complete trade of items that the person is 
		expecting.
	
VICTORY/DEFEAT CONDITIONS:
Defeat 1: Leave to the outside without a winter coat.
	Exiting the building to the outside without having the coat item in your 
	inventory causes you to freeze to death, thus losing the game.
	
Defeat 2: Brains consumed
	A 'zombie grad student' monster will kill you if you stay in the same room 
	with it for more than two turns/actions.  Two such monsters move randomly 
	around the building.
	
Victory 1: Leave to the outside with a winter coat.
	Exiting the building to the outside with the coat item in your inventory
	leads to victory.  To learn how to obtain the coat item, go to Rekhi-117 and
	talk to the programmer (use the command: talk programmer).  He will give you
	instructions to bring him a backpack filled with snacks.  The backpack is in
	the second floor dead end; snacks are found throughout the building.  Once 
	you've collected the items he needs, return to him and use the command: 
	trade programmer .  He will then leave the needed coat on the ground.  With 
	this coat in your inventory, go to one of the exits to the outside and leave.

Victory	2: Leave to Fisher Hall.
	Exiting the building to Fisher Hall constitutes victory.  To do so, however,
	you need the key to Fisher Hall (the Fisher-key item).  To learn how to get 
	the Fisher-key, go to the first floor north offices and talk to the 
	disgruntled grad student (talk disgruntled-grad-student).  Once you find the
	cash he needs, which is located in the second floor north offices, return to
	him and obtain research (trade disgruntled-grad-student).  With the research
	in your inventory, find the demented professor (location unknown because of 
	monster movement); instead of teleporting you, he will be interested in 
	trading the research for the Fisher-key (trade professor).

TESTING:
A number of functions can be tested by running txtadv.rkt and calling (TEST-Homework3) .