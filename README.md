<h1>SPACE GAME</h1>
Ethan Crosbie
C22351646
This project was done solo

<a href="https://youtu.be/CZQrhlxbTEI?si=IiU8SWxNDnj_JCLY">YouTube demo</a>
The YouTube demo doesn't have sound but that is due to Mac not being able to record internal sound



I want to make a game where you get to watch a space battle unfold around you, watch ships tail and explode each other in glorious combat!



GOALS                                      
SHIPS
- ships should be able to:
 - chase an enemy ship DONE
 - fire at enemy ship DONE
 - on hit ship should explode DONE
 - more ships should respawn to replace the destroyed ship DONT NEED
 - ships should move realistically as if they are using thrusters in a 0 gravity environment DONE
 - ships should make a noise to indicate they have exploded DONE
 - ships should be able to ask their allies for help if trailed - perhaps make a particle effect + sound to show this to user DONT NEED
 - if ship is trailed they should be able to dodge shots DONE
 - ships should be distinguishable based on team DONE
BACKGROUND
- large carrier ships where new ships spawn DONE
- skybox should be distant stars DONE
- should be planets to simulate a solar system DONE



STRETCH GOALS                                                                             
- reverb added to sound effects to simulate illusion of space DONE
- trash ships used to collect debris of destroyed ships - NOT COMPLETED DUE TO TIME AND PROCESSING LIMITATIONS
- player can in some way interact with the ships - PLAYER CAN CONTROL A TURRET


HOW IT WORKS:
Fighters are spawned in a set area at the beginning with the team of red or blue, they both want to kill each other which results in an explosion and an increase to the score.
The fighters use a state machine to decide their actions

<b>PATROL</b> when no enemy is in their detection radius - 
	it just has them fly forward

<b>PURSUE</b> when no enemy is in their detection radius - 
	gets the normalised position of the enemy and combines it with the avoidance force to steer toward the enemy
	avoidance force is used to lightly redirect the fighter from getting too far away
	PURSUE is done when health is above 30, no target is set and we are not within 20 units of a target


<b>ATTACK</b> when no enemy is in their detection radius - 
	is done when within 20 units of a target
	works the same as pursue, but tries to shoot the target
	it instantiates a bullet scene which moves in its spawner's direction
	this bullet is given the parent team so we know which fighter hit the enemy
	it also instantiates a shoot noise
	
<b>EVADE</b> when no enemy is in their detection radius - 
	Old code that hasn't been removed
	kept for future use and to make it easier to implement a player
	occurs when health is less than 30
	made not happen as fights would drag out and it is difficult enough to aim with the turret
	basically just moves the fighter in its opposite direction





REFLECTION:
I'm happy with the end product, the fights simulated look interesting and there has been some cool emergent behaviour like the clustering of the same fighters and how the lowest lasting groups form lines which protects them, 
The turret is a little lacking as it is hard to aim and the style of the gun is weird compared to the other assets, this was done in order to include the BFG
For future development I would like to increase the player interactivity through use of a player controlled ship
For future work approaching from a player first perspective would lead to this.





















