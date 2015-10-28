globals [ conversion-rate ]
breed [humans a-human]
breed [zombies a-zombie]


to setup
  clear-all
  set-field
  set-humans ;; set human turtles up  
  set-zombies ;; set zombie turtles up
  reset-ticks
end


to go
  if not any? humans [stop]  ;;stop simulation when all humans are dead
  if not any? zombies [stop]  ;;stop simulation when all zombies are dead
  human-behavior
  zombie-behavior
  tick
end


;; procedure to set the 'dirt'
to set-field
  ask patches [set pcolor brown]
end

;; procedure to give the humans their shape and color a well as random locations
to set-humans
  set-default-shape humans "person"
  create-humans Initial-number-humans  ;;Initial number of humans is determined by the user
  [
    setxy random-xcor random-ycor
    ask humans [set color white]
   ]
end


;; procedure to give the zombies their shape and color a well as random locations
to set-zombies
  set-default-shape zombies "person"
  create-zombies Initial-number-zombies  ;;Initial number of zombies is determined by the user
  [
    setxy random-xcor random-ycor
    ask zombies [set color green]
  ]
end


to human-behavior
  ask humans 
  [
    move
    if random 100 < Human-reproduction-rate * 100 ;;user defines the reproduction rate of the humans per tick
     [                 
        hatch 1 [ rt random-float 360 fd 1 ]   ;; hatch an offspring and move it forward 1 step
     ]
    if random 100 / 100 < Human-death-rate [ die ]  ;; human's will die at a random probability given by the user
  ]
end


;; procedure for a zombies behavior for each tick
to zombie-behavior
  ask zombies 
  [
    move
    zombie-feed
    if random 100 / 100 < Zombie-death-rate [ die ]   ;; zombies's will die at a random probability given by the user
  ]
end

;; move procedure for both humans and zombies
to move
  rt random 50
  lt random 50
  fd 1
end


to zombie-feed
  let prey one-of humans-here
  if prey != nobody  ;; if there is a human available  on the same patch as the zombie, grab that human
   [ 
     ifelse random 100 / 100 < Zombie-victory-probability    ;; if zombie wins, moves on to see if the human will be converted
       [
         if random 100 / 100 < Conversion-probability    ;; if conversion probability wins then the human is converted into a zombie
         [ ask one-of humans-here 
           [ 
             set breed zombies 
             set color green 
           ] 
         ]
         [ ask prey [ die ] ]       ;; else the human dies
        ]
       [ask zombies [ die ]]
   ]
end
