__includes["kretanje.nls"]

breed [mace maca]
breed [napasti napast]
breed [koluti kolut]
breed [bkoluti bkolut]

patches-own
[brojac raskrizje?]

napasti-own
[vrijeme moj-put s-naprijed s-desno
 s-lijevo zastavica-x zastavica-y i
 heuristika astar procjena-puta ziv?
 boja]

mace-own
[zivot]

globals[lista x y vrijeme1 bodovi]

to setup
  ca
  import-pcolors "labirint2.png"
  oznaci
  postavi-likove
  set lista[]
  racunaj-dijkstra
  set vrijeme1 0
end

to postavi-likove
 create-mace 1
 [
   set shape "oggy1"
   setxy 0 -5
   set heading 0
   set color cyan
   set brojac 1
   set zivot 3
 ]
 create-napasti 1
 [
   set shape "bug1"
   set color pink
   set heading 0
   setxy -1 1
   set moj-put []
   set zastavica-x []
   set zastavica-y []
   set i 1
   set ziv? true
   set boja 135
 ]
 create-napasti 1
 [
   set shape "bug2"
   set color grey
   set heading 0
   setxy 0 1
   set moj-put []
   set zastavica-x []
   set zastavica-y []
   set i 1
   set ziv? true
   set boja 5
 ]
 create-napasti 1
 [
   set shape "bug3"
   set color violet
   set heading 0
   setxy 1 1
   set moj-put []
   set zastavica-x []
   set zastavica-y []
   set i 1
   set ziv? true
   set boja 115

 ]
  create-napasti 1
 [
   set shape "jack"
   set color green
   set heading 0
   setxy 0 2
   set moj-put []
   set zastavica-x []
   set zastavica-y []
   set i 2
   set ziv? true
   set boja 55
 ]

 create-bkoluti 4
 [
   set color blue
   set shape "star"
   postavi-bkolute
 ]
 create-koluti 161
 [
   set color green
   set shape "cylinder"
   set size 0.5
   postavi-kolute
 ]

end

to oznaci
  ask patches with [pcolor != 137.1] [set plabel (pxcor * 100 + pycor)]
end

to postavi-kolute
  ask koluti [
    if (count koluti-on patch-here > 1 or ([pcolor] of patch-here != 47.9)) [
    move-to one-of patches with [(pcolor = 47.9 and pycor > 4 and brojac = 0) or
    (pcolor = 47.9 and pycor < -2 and brojac = 0) or
    (pxcor = -5 and pcolor = 47.9 and brojac = 0) or
    (pxcor = 5 and pcolor = 47.9 and brojac = 0)
    ]
   ]
  ]
end

to postavi-bkolute
   move-to one-of patches with [(pxcor = 9 and pycor = 8 and brojac = 0) or
   (pxcor = -9 and pycor = 8 and brojac = 0) or
   (pxcor = 9 and pycor = -8 and brojac = 0) or
   (pxcor = -9 and pycor = -8 and brojac = 0)]

   set brojac 1
end

to korak-pretrage-oggy
    ask mace
   [
    provjera-cilja
    provjera-napasti
    bjezi

    ifelse any? koluti-on patch-left-and-ahead 90 1 or any? bkoluti-on patch-left-and-ahead 90 1
    [
      if ([pcolor != 137.1] of patch-left-and-ahead 90 1)
      [lt 90 fd 1
       if [color] of napasti != blue [bjezi]]
    ]
    [
     ifelse any? koluti-on patch-right-and-ahead 90 1 or any? bkoluti-on patch-right-and-ahead 90 1
     [
       if ([pcolor != 137.1] of patch-right-and-ahead 90 1)
       [rt 90 fd 1 if [color] of napasti != blue [bjezi]]
     ]
     [
       ifelse any? koluti-on patch-ahead 1 or any? bkoluti-on patch-ahead 1
       [
        if [pcolor != 137.1] of patch-ahead 1
        [fd 1 if [color] of napasti != blue [bjezi]]
       ]
       [
         ifelse [pcolor != 137.1] of patch-ahead 1
         [fd 1 if [color] of napasti != blue [bjezi]]
         [
           let r random 2
           ifelse r = 0
           [
             lt 90
             if [color] of napasti != blue [bjezi]
           ]
           [
             rt 90
             if [color] of napasti != blue [bjezi]
           ]
        ]
       ]
     ]
    ]
   ]

    provjera-cilja
    provjera-napasti
    set vrijeme1 vrijeme1 + 1
    brojac-bodova
end

to bjezi
 ask mace
 [
   if any? napasti-on patch-left-and-ahead 90 1 = 47.9
   [
     ifelse [pcolor] of patch-ahead 1 = 47.9
      [fd 1]
      [
        ifelse [pcolor] of patch-right-and-ahead 90 1 = 47.9
         [rt 90 fd 1]
         [
           if [pcolor] of patch-ahead -1 = 47.9
            [rt 180 fd 1]
         ]
      ]
  ]

   if any? napasti-on patch-left-and-ahead 90 2
     [
     ifelse [pcolor] of patch-ahead 1 = 47.9 and [pcolor] of patch-ahead 2 = 47.9
      [fd 1]
      [
        ifelse [pcolor] of patch-right-and-ahead 90 1 = 47.9 and [pcolor] of patch-right-and-ahead 90 2 = 47.9
         [rt 90 fd 1]
         [
           if [pcolor] of patch-ahead -1 = 47.9 and [pcolor] of patch-ahead -2 = 47.9
            [rt 180 fd 1]
         ]
      ]
    ]
   if any? napasti-on patch-right-and-ahead 90 1 = 47.9
   [
     ifelse [pcolor] of patch-ahead 1 = 47.9
      [fd 1]
      [
        ifelse [pcolor] of patch-left-and-ahead 90 1 = 47.9
         [lt 90 fd 1]
         [
           if [pcolor] of patch-ahead -1 = 47.9
            [rt 180 fd 1]
         ]
      ]
  ]

   if any? napasti-on patch-right-and-ahead 90 2
     [
     ifelse [pcolor] of patch-ahead 1 = 47.9 and [pcolor] of patch-ahead 2 = 47.9
      [fd 1]
      [
        ifelse [pcolor] of patch-left-and-ahead 90 1 = 47.9 and [pcolor] of patch-right-and-ahead 90 2 = 47.9
         [lt 90 fd 1]
         [
           if [pcolor] of patch-ahead -1 = 47.9 and [pcolor] of patch-ahead -2 = 47.9
            [rt 180 fd 1]
         ]
      ]
    ]

   if any? napasti-on patch-ahead 1
   [
     ifelse [pcolor] of patch-ahead -1 = 47.9
      [lt 180 fd 1]
      [
        ifelse [pcolor] of patch-left-and-ahead 90 1 = 47.9
         [lt 90 fd 1]
         [
           if [pcolor] of patch-right-and-ahead 90 1 = 47.9
            [rt 90 fd 1]
         ]
      ]
  ]
   if any? napasti-on patch-ahead 2
     [
     ifelse [pcolor] of patch-ahead -1 = 47.9 and [pcolor] of patch-ahead -2 = 47.9
      [lt 180 fd 1]
      [
        ifelse [pcolor] of patch-left-and-ahead 90 1 = 47.9 and [pcolor] of patch-left-and-ahead 90 2 = 47.9
         [lt 90 fd 1]
         [
           if [pcolor] of patch-right-and-ahead 90 1 = 47.9 and [pcolor] of patch-right-and-ahead 90 2 = 47.9
            [rt 90 fd 1]
         ]
      ]
    ]
 ]
end

to provjera-napasti
 ask koluti [if any? mace-on patch-here [die]]
 ask bkoluti
 [
   if any? mace-on patch-here
   [
    ask napasti
    [set color blue
     set vrijeme 35]
    die
   ]
 ]
 ask napasti
 [
     if color = blue
     [set vrijeme vrijeme - 1
      if any? mace-on patch-here
      [set ziv? false stop die]]

      if vrijeme = 0
     [
       ask napasti[set color boja]
     ]
 ]
 ask mace
 [
   if any? napasti-on patch-here and [color] of napasti != blue
   [
     if zivot > 0
     [set zivot (zivot - 1)]
     if zivot = 0
      [ user-message (word "GAME OVER! BODOVI: " (96600 - (count koluti * 600)) "") zaustavi-sve die]
   ]
 ]
end

to zaustavi-sve
 ask napasti [set ziv? false die]
end

to provjera-cilja
  ask mace
  [
    if count koluti = 0 [user-message (word "OGGY POBJEĐUJE") zaustavi-sve]
  ]
end

to brojac-bodova
  set bodovi (96600 - (count koluti * 600))
end

to pretraga-po-dubini
  ask napast 2
  [
    ifelse ziv? = false [ stop ]
    [korak-pretrage]
  ]
end

to pretraga-po-sirini
 ask napast 4
 [
   ifelse ziv? = false [ stop ]
   [korak-pretrage-s]
 ]
end

to pohlepna-pretraga
 ask napast 3
 [
   ifelse ziv? = false [ stop ]
   [korak-pretrage-p]
 ]
end

to pretraga-a*
 ask napast 1
 [
   ifelse ziv? = false [ stop ]
   [a-star]
 ]
end

to pretraga
 pretraga-po-dubini
 pretraga-po-sirini
 pohlepna-pretraga
 pretraga-a*
 korak-pretrage-oggy
end

to pokreni
  ifelse not any? napasti with [ ziv? = true ] [ stop ]

 [ if pretrazi = "Mijesana" [ask napasti [pretraga]]
  if pretrazi = "Pretraga po dubini" [ask napasti[korak-pretrage] korak-pretrage-oggy]
  if pretrazi = "Pretraga po sirini" [ask napasti[korak-pretrage-s] korak-pretrage-oggy]
  if pretrazi = "Pohlepna pretraga" [ask napasti[korak-pretrage-p] korak-pretrage-oggy]
  if pretrazi = "A* pretraga" [ask napasti[a-star] korak-pretrage-oggy]
  if pretrazi = "Dijkstra" [ask napasti[dijkstra] korak-pretrage-oggy]]
end
@#$#@#$#@
GRAPHICS-WINDOW
212
11
756
576
10
10
25.43
1
10
1
1
1
0
1
1
1
-10
10
-10
10
0
0
1
ticks
30.0

BUTTON
22
15
107
48
Nova igra
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
21
109
114
154
Brojač bodova
bodovi
17
1
11

MONITOR
21
56
127
101
Život Oggya
[zivot] of maca 0
17
1
11

MONITOR
20
165
120
210
Brojač vremena
vrijeme1
17
1
11

CHOOSER
18
241
169
286
pretrazi
pretrazi
"Mijesana" "Pretraga po dubini" "Pretraga po sirini" "Pohlepna pretraga" "A* pretraga" "Dijkstra"
5

BUTTON
17
327
91
360
Pokreni
pokreni
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

ant
true
0
Polygon -7500403 true true 136 61 129 46 144 30 119 45 124 60 114 82 97 37 132 10 93 36 111 84 127 105 172 105 189 84 208 35 171 11 202 35 204 37 186 82 177 60 180 44 159 32 170 44 165 60
Polygon -7500403 true true 150 95 135 103 139 117 125 149 137 180 135 196 150 204 166 195 161 180 174 150 158 116 164 102
Polygon -7500403 true true 149 186 128 197 114 232 134 270 149 282 166 270 185 232 171 195 149 186
Polygon -7500403 true true 225 66 230 107 159 122 161 127 234 111 236 106
Polygon -7500403 true true 78 58 99 116 139 123 137 128 95 119
Polygon -7500403 true true 48 103 90 147 129 147 130 151 86 151
Polygon -7500403 true true 65 224 92 171 134 160 135 164 95 175
Polygon -7500403 true true 235 222 210 170 163 162 161 166 208 174
Polygon -7500403 true true 249 107 211 147 168 147 168 150 213 150

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug1
true
13
Circle -2064490 true true 101 157 98
Circle -2064490 true true 122 124 56
Line -16777216 false 150 100 80 30
Line -16777216 false 150 100 220 30
Polygon -2064490 true true 105 165 75 180
Circle -8630108 true false 120 70 60
Polygon -2064490 true true 105 195 120 150 165 150 180 150 195 195 105 195

bug2
true
0
Circle -7500403 true true 101 187 98
Circle -7500403 true true 122 139 56
Line -16777216 false 150 100 80 30
Line -16777216 false 150 100 220 30
Circle -10899396 true false 115 80 70
Polygon -7500403 true true 120 165 105 225 180 225 135 210 180 165 195 225

bug3
true
11
Circle -8630108 true true 79 150 142
Circle -8630108 true true 105 122 90
Line -16777216 false 150 100 80 30
Line -16777216 false 150 100 220 30
Circle -955883 true false 100 50 100

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

cat
false
0
Line -7500403 true 285 240 210 240
Line -7500403 true 195 300 165 255
Line -7500403 true 15 240 90 240
Line -7500403 true 285 285 195 240
Line -7500403 true 105 300 135 255
Line -16777216 false 150 270 150 285
Line -16777216 false 15 75 15 120
Polygon -7500403 true true 300 15 285 30 255 30 225 75 195 60 255 15
Polygon -7500403 true true 285 135 210 135 180 150 180 45 285 90
Polygon -7500403 true true 120 45 120 210 180 210 180 45
Polygon -7500403 true true 180 195 165 300 240 285 255 225 285 195
Polygon -7500403 true true 180 225 195 285 165 300 150 300 150 255 165 225
Polygon -7500403 true true 195 195 195 165 225 150 255 135 285 135 285 195
Polygon -7500403 true true 15 135 90 135 120 150 120 45 15 90
Polygon -7500403 true true 120 195 135 300 60 285 45 225 15 195
Polygon -7500403 true true 120 225 105 285 135 300 150 300 150 255 135 225
Polygon -7500403 true true 105 195 105 165 75 150 45 135 15 135 15 195
Polygon -7500403 true true 285 120 270 90 285 15 300 15
Line -7500403 true 15 285 105 240
Polygon -7500403 true true 15 120 30 90 15 15 0 15
Polygon -7500403 true true 0 15 15 30 45 30 75 75 105 60 45 15
Line -16777216 false 164 262 209 262
Line -16777216 false 223 231 208 261
Line -16777216 false 136 262 91 262
Line -16777216 false 77 231 92 261

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

jack
true
5
Circle -10899396 true true 90 146 120
Circle -10899396 true true 122 124 56
Polygon -2064490 true false 105 165 75 180
Polygon -10899396 true true 210 210 180 285 135 285 120 285 90 195 195 210
Polygon -10899396 true true 135 165 30 105 75 90 45 75 135 75 150 75 240 75 225 90 270 105 165 165
Polygon -10899396 true true 120 75 120 45 150 75 180 45 180 75
Circle -7500403 true false 115 110 70
Rectangle -16777216 true false 120 90 135 105
Rectangle -16777216 true false 165 90 180 105
Circle -2674135 true false 135 105 30

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

oggy1
true
0
Polygon -16777216 true false 105 75 105 150 195 150 195 30 150 75 105 30
Circle -11221820 true false 135 195 60
Circle -11221820 true false 103 118 94
Polygon -11221820 true false 105 165 105 105 150 135 195 90 195 165
Circle -11221820 true false 105 60 88
Polygon -11221820 true false 240 150 90 150 90 225 135 225 210 225
Circle -11221820 true false 48 138 85
Circle -11221820 true false 168 138 85
Circle -11221820 true false 78 168 85
Circle -11221820 true false 78 153 85
Circle -11221820 true false 105 195 60
Circle -11221820 true false 135 165 90
Line -16777216 false 75 180 30 165
Line -16777216 false 255 150 225 165
Line -16777216 false 75 165 45 150
Line -16777216 false 270 165 225 180
Circle -2674135 true false 118 133 62
Rectangle -1 true false 120 105 135 120
Rectangle -1 true false 165 105 180 120
Polygon -16777216 true false 150 120 120 135
Polygon -16777216 true false 105 210 150 210 195 210 150 225
Polygon -11221820 true false 105 195 105 240
Polygon -11221820 true false 165 255 225 210 150 240 150 255
Polygon -11221820 true false 135 255 90 225 150 240 150 255
Polygon -16777216 true false 120 75 150 75 105 30 120 75 150 75 195 30 180 75 120 75
Polygon -16777216 true false 120 75 150 90 180 75 165 60 150 60 135 60

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.3.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="experiment" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>Pokreni</go>
    <metric>vrijeme1</metric>
    <metric>bodovi</metric>
    <enumeratedValueSet variable="pretrazi">
      <value value="&quot;Mijesana&quot;"/>
      <value value="&quot;Pretraga po dubini&quot;"/>
      <value value="&quot;Pretraga po sirini&quot;"/>
      <value value="&quot;Pohlepna pretraga&quot;"/>
      <value value="&quot;A* pretraga&quot;"/>
      <value value="&quot;Dijkstra&quot;"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@
