#lang reader "txtadv-reader.rkt"

===VERBS===


talk _, hello _
  "talk"

trade _
  "trade"

pack _
  "pack"

unpack _
  "unpack"

view _
  "view"

north, n
 "go north"

south, s
 "go south"

east, e
 "go east"

west, w
 "go west"

up
 "go up"

down
 "go down"

in, enter
 "enter"

out, leave
 "leave"

get _, grab _, take _
 "take"

put _, drop _, leave _
 "drop"

open _, unlock _
 "open"

close _, lock _
 "close"

knock _

quit, exit
 "quit"

look, show
 "look"

inventory
 "check inventory"

help

save

load


===EVERYWHERE===

quit 
 (begin
  (printf "Bye!\n")
  (exit))

look 
 (show-current-place)

inventory 
 (show-inventory)

save
 (save-game)

load
 (load-game)

help
 (show-help)


===THINGS===

---zombie---


---professor---
talk
  (printf "That's some rather interesting research.  I'd like to... review it.  I'd be glad to give you the key to leave the building if you let me borrow the research for a moment.\n")

trade
  (begin
    (printf "Yes! This research will look wonderful with my name as author at the upcoming conference! Good work; have you considered becoming my next graduate student? Go ahead and have the key; I've got a conference to enjoy!\n")
    (trade-items research Fisher-key)
    (get-rid-of professor))

---programmer---
trade
  (if (and (have-thing? backpack) (bp-full?) (andmap (lambda (t) (eq? t snack)) bp))
      (begin
        (trade-items backpack coat)
        (help-programmer!)
        (printf "Thanks! That'll keep me from starving during this all-nighter.  I've left my winter coat for you to use; I certainly won't need it for a long time.\n"))
      (if helped-programmer?
          (printf "Thanks, but we've already made the exchange.\n")
          (printf "I need a backpack full of snacks in order to give you my winter coat.\n")))

talk
  (if helped-programmer?
      (printf "Thanks again for the bag of snacks.\n")
      (printf "I understand you need to leave the building.  You can use my winter coat if you first give me a backpack full of snacks.  I've got a major programming assignment to complete and don't have time to go get snacks myself.\n"))

---disgruntled-grad-student---
trade
  (if (have-thing? cash)
      (begin
        (trade-items cash research)
        (help-grad!)
        (printf "Excellent.  You can have this research; I'll go take a tropical vacation! Give it to the prof; I'm sure he'll appreciate the research enough that he won't care about giving up the building key.\n"))
      (if helped-grad?
          (printf "I've nothing else to trade with you.  Take care!\n")
          (printf "I'm not giving away my research without first receiving a big wad of cash.  Even I know better than that!\n")))

talk
  (if helped-grad?
      (printf "It's great that you've helped me escape my indentured servitude in this winter wasteland.  Now I pray I can make it to the airport!\n")
      (printf "I'm tired of doing the dirty work just to see the professor take credit at conferences.  We both want to get out of here.  You give me cash for a tropical vacation, and I'll give you research valuable to the professor.  Who knows? Maybe he'll give away the building key in exchange for the research.\n")
      )

---cash---
get
  (if (inventory-full?)
     "You cannot carry more."
     (begin
       (take-thing! cash)
       "You picked up cash."))

put
  (if (have-thing? cash)
     (begin
       (drop-thing! cash)
       "You dropped the cash.")
     "You have no cash to drop.\n")
  
pack
  (if (and (have-thing? cash) (have-thing? backpack))
      (if (bp-full?)
          "The backpack is full."
          (begin
            (pack-thing! cash)
            "You have placed the cash into the backpack."))
      "You need both cash and a backpack.")

unpack
  (if (and (have-thing? backpack) (have-thing-bp? cash))
      (begin
        (unpack-thing! cash)
        "You have removed the cash from the backpack.")
      "You need a backpack containing a cash")


---research---
get
  (if (inventory-full?)
     "You cannot carry more."
     (begin
       (take-thing! research)
       "You picked up the research."))

put
  (if (have-thing? research)
     (begin
       (drop-thing! research)
       "You dropped the research.")
     "You have no research to drop.\n")
  
pack
  (if (and (have-thing? research) (have-thing? backpack))
      (if (bp-full?)
          "The backpack is full."
          (begin
            (pack-thing! research)
            "You have placed the research into the backpack."))
      "You need both research and a backpack.")

unpack
  (if (and (have-thing? backpack) (have-thing-bp? research))
      (begin
        (unpack-thing! research)
        "You have removed the research from the backpack.")
      "You need a backpack containing research.")

---coat---
get
  (if (have-thing? coat)
     "You already have a winter coat."
     (if (inventory-full?)
         "You cannot carry more."
         (begin
           (take-thing! coat)
           "You now have a winter coat.")))

put
  (if (have-thing? coat)
     (begin
       (drop-thing! coat)
       "You dropped the winter coat.")
     "You don't have a winter coat.")
  
pack
  (if (and (have-thing? coat) (have-thing? backpack))
      (if (bp-full?)
          "The backpack is full."
          (begin
            (pack-thing! coat)
            "You have placed the coat into the backpack."))
      "You need both a coat and a backpack.")

unpack
  (if (and (have-thing? backpack) (have-thing-bp? coat))
      (begin
        (unpack-thing! coat)
        "You have removed the coat from the backpack.")
      "You need a backpack containing a coat.")

---backpack---
get
  (if (have-thing? backpack)
     "You already have a backpack."
     (if (inventory-full?)
         "You cannot carry more."
         (begin
           (take-thing! backpack)
           "You now have a backpack.  Use pack and unpack to pack or unpack items from the ground, respectively.")))
 
put
  (if (have-thing? backpack)
     (begin
       (drop-thing! backpack)
       "You dropped the backpack.")
     "You don't have a backpack.")

view
  (if (have-thing? backpack)
      (begin
        (show-bp))
      "You need a backpack in order to view its contents.")
  
---snack---
get
  (if (inventory-full?)
     "You cannot carry more."
     (begin
       (take-thing! snack)
       "You picked up a snack."))

put
  (if (have-thing? snack)
     (begin
       (drop-thing! snack)
       "You dropped a snack.")
     "You have no snack to drop.\n")
  
pack
  (if (and (have-thing? snack) (have-thing? backpack))
      (if (bp-full?)
          "The backpack is full."
          (begin
            (pack-thing! snack)
            "You have placed the snack into the backpack."))
      "You need both a snack and a backpack.")

unpack
  (if (and (have-thing? backpack) (have-thing-bp? snack))
      (begin
        (unpack-thing! snack)
        "You have removed the snack from the backpack.")
      "You need a backpack containing a snack.")

---door-to-Fisher-Hall---
open
  (if (have-thing? Fisher-key)
      (begin
        (set-thing-state! door-to-Fisher-Hall 'open)
        "The door is now unlocked and open.")
      "The door is locked.")
  
close
  (begin
    (set-thing-state! door-to-Fisher-Hall #f)
    "The door is now closed.")

knock
  "Nobody comes to open the door."

---Fisher-key---
get
  (if (have-thing? Fisher-key)
      "You already have the key to Fisher Hall."
      (if (inventory-full?)
          "You cannot carry more."
          (begin
            (take-thing! Fisher-key)
            "You now have the key to Fisher Hall.")))
  
put
  (if (have-thing? Fisher-key)
      (begin
        (drop-thing! Fisher-key)
        "You dropped the key to Fisher Hall.")
      "You don't have the key to Fisher Hall.")

---door-to-outside---
open
  (begin
    (set-thing-state! door-to-outside 'open)
    "The door is now open.")
  
close
  (begin
    (set-thing-state! door-to-outside #f)
    "The door is now closed.")


===PLACES===

---Rekhi-112---
"You're standing in Rekhi 112. There is a hallway to the east."
[]

east
 first-floor-middle-hallway


---first-floor-middle-hallway---
"You're standing in the hallway between Rekhi 112 and Rekhi 113.  There is a junction to the north and a hallway to the south.  Rekhi 112 and Rekhi 113 are to the west and east, respectively."
[]

north
 first-floor-junction
 
south
 first-floor-south-hallway
 
west
 Rekhi-112

east
 Rekhi-113
 
---first-floor-junction---
"You're standing in the first floor junction.  There are stairs to the second floor junction here.  There are offices to the north and a hallway to the south."
[door-to-Fisher-Hall]

north
 first-floor-offices

south
 first-floor-middle-hallway

west
 first-floor-west-foyer

up
 second-floor-junction
 
in
  (if (eq? (thing-state door-to-Fisher-Hall) 'open)
      (fisher-victory)
      (printf "The door is not open.\n"))

---first-floor-south-hallway---
"You're standing in the first floor south hallway.  Rekhi 117 is to the south, stairs are to the east, a hallway is to the north, and a dead end is to the west."
[]

north
 first-floor-middle-hallway
 
east
 first-floor-east-stairs

south
 Rekhi-117

west
 first-floor-dead-end

---first-floor-offices---
"You're in the first floor offices.  The first floor junction is to the south."
[snack, snack, disgruntled-grad-student]

south
 first-floor-junction
 
---Rekhi-113---
"You're in Rekhi 113, where there is a printing station.  The hallway is to the west."
[zombie, snack]

west
 first-floor-middle-hallway

---first-floor-west-foyer---
"You're at the western exit.  Winter clothes will be needed to survive outside! The first floor junction is to the east."
[door-to-outside]

east
 first-floor-junction

in
  (if (eq? (thing-state door-to-outside) 'open)
      (if (have-thing? coat)
          (winter-victory)
          (winter-defeat))
      (printf "The door is not open.\n"))
 
---second-floor-junction---
"You're standing in the second floor junction.  There are stairs to the first floor junction here.  There are offices to the north and a hallway to the south."
[door-to-Fisher-Hall]

north
 second-floor-north-offices

south
 second-floor-middle-hallway

down
 first-floor-junction
 
in
  (if (eq? (thing-state door-to-Fisher-Hall) 'open)
      (fisher-victory)
      (printf "The door is not open.\n"))

---first-floor-east-stairs---
"You're in the first floor stairway.  There is a door to the outside; winter clothes will be needed to survive.  The stairs go to the second floor.  The first floor south hallway is to the west."
[door-to-outside, snack]

west
 first-floor-south-hallway

up
 second-floor-east-stairs
 
in
  (if (eq? (thing-state door-to-outside) 'open)
      (if (have-thing? coat)
          (winter-victory)
          (winter-defeat))
      (printf "The door is not open.\n"))

---Rekhi-117---
"You're in Rekhi 117.  The first floor south hallway is the north."
[programmer, snack]

north
 first-floor-south-hallway

---first-floor-dead-end---
"You're at a dead end.  The first floor middle hallway is to the east."
[snack]

east
 first-floor-south-hallway
 
---second-floor-north-offices---
"You're in the second floor north offices.  The second floor junction is to the south."
[zombie, cash]

south
 second-floor-junction
 
 
---second-floor-middle-hallway---
"You're in the second floor middle hallway.  Rekhi 214 is to the west.  The second floor south hallway is to the south.  The second floor junction is to the north."
[]

west
 Rekhi-214

south
 second-floor-south-hallway
 
north
 second-floor-junction
 
---second-floor-east-stairs---
"You're in the second floor floor stairway.  The stairs go down to the first floor.  The second floor south hallway is to the west."
[]

west
 second-floor-south-hallway
 
down
 first-floor-east-stairs

---Rekhi-214---
"You're in Rekhi 214.  A Concurrent Computing exam will soon be administered.  The hallway is to the east."
[professor, snack]

east
 second-floor-middle-hallway

---second-floor-south-hallway---
"You're in the second floor south hallway.  The CS Offices are to the south, a hallway is to the north, a dead end is to the west, and the second floor east stairs are to the east."
[]

south
 CS-Offices
 
east
 second-floor-east-stairs
 
north
 second-floor-middle-hallway
 
west
 second-floor-dead-end

---CS-Offices---
"You're in the CS department offices.  There is a hallway to the north."
[snack]

north
 second-floor-south-hallway

---second-floor-dead-end---
"You're at a dead end.  There is a hallway to the east."
[backpack]

east
 second-floor-south-hallway
